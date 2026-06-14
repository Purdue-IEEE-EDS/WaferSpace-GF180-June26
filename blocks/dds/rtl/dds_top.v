`default_nettype none
`timescale 1ns/1ps

// DDS top-level.
//
// CONFIG comes over SPI and launches on io_update.
// sync_in relaunches the armed profile with a forced phase reset.
//
// Clocking for the 4:1 DDS build:
//   - clk     = external fast 4x serializer / DAC output clock
//               intended nominal rate: 500 MHz
//   - clk_cal = internal divide-by-2 calibration clock
//               intended nominal rate: 250 MHz
//   - clk_vec = internal divide-by-4 vector clock
//               intended nominal rate: 125 MHz
//
// Work split:
//   - clk_vec domain: profile execution, phase generation, 4 parallel DDS lanes
//   - clk_cal domain: calibration DAC scan engine
//   - clk_4x domain:  output serialization and DAC pin drive
//
// Steady-state timing in the default 4:1 build:
//   - phase_accum_vec4 produces one 4-sample phase block per clk_vec edge.
//   - dds_datapath_vec adds 8 registered clk_vec stages:
//       phase_vec sampled on edge N -> dac_{i,q}_vec just after edge N+7
//       (7 full clk_vec intervals, 56 ns at 125 MHz).
//   - clk_vec posedges occur on the serializer 3 -> 0 wrap edge, so a ready
//     vector block is loaded one clk_4x edge later and emitted as lane 0/1/2/3
//     on the next 4 clk_4x edges.
//   - End-to-end from phase_vec capture to DAC pins at 500/125 MHz:
//       lane0 = 58 ns, lane1 = 60 ns, lane2 = 62 ns, lane3 = 64 ns nominal.
module dds_top #(
    parameter int PHASE_W               = 32,
    parameter int SINE_TRUNC_W          = 14,
    parameter int SINE_COARSE_W         = 7,
    parameter int SINE_GUARD_W          = 3,
    parameter int UNARY_BITS            = 5,
    parameter int BINARY_BITS           = 5,
    parameter int COUNT_W               = 20,
    parameter int LANES                 = 4,
    parameter int DAC_SW_W              = (1 << UNARY_BITS) - 1 + BINARY_BITS,
    parameter int CAL_DAC_N_CELLS       = DAC_SW_W,
    parameter int CAL_DAC_CELL_W        = 4,
    parameter int CAL_DAC_SHIFT_CYCLES  = 3,
    parameter integer CLK_DIV1_FREQ_HZ = 500_000_000,
    parameter integer CAL_CLK_MAX_HZ   = 500_000_000,
    parameter DEVID       = 8'hD5,
    parameter [PHASE_W-1:0] TEST_TONE_FTW = 32'h2284_DFCE // MY CHIP MY RULES
)(
    // Fast serializer clock. Internally aliased as clk_4x.
    // Intended nominal rate: 500 MHz.
    input  logic                  clk,
    input  logic                  rst_n,

    // SPI pins (SCLK domain)
    input  logic                  sclk,
    input  logic                  csn,
    input  logic                  mosi,
    output logic                  miso,

    // External control pins. Internally synchronized into clk_cal/clk_vec.
    input  logic                  io_update,
    input  logic                  sync_in,

    // DAC outputs
    output logic [DAC_SW_W-1:0]   dac_i,
    output logic [DAC_SW_W-1:0]   dac_q,

    // Calibration DAC outputs
    output logic                  cal_clk,
    output logic                  cal_data,
    output logic                  cal_load
);

    localparam integer CLK_CAL_FREQ_HZ = CLK_DIV1_FREQ_HZ / 2;

    initial begin
        if (LANES != 4)
            $error("dds_top currently targets the 4-lane serializer build");

        if (CLK_CAL_FREQ_HZ > CAL_CLK_MAX_HZ)
            $error("dds_top cal clock %0d Hz exceeds analog max %0d Hz",
                   CLK_CAL_FREQ_HZ, CAL_CLK_MAX_HZ);
    end

    // ================================================================
    //  Explicit 4x -> {1x, 1/2x, 1/4x} clock split for the 4:1 serializer
    //  build.
    // ================================================================
    logic clk_div1;
    logic clk_div2;
    logic clk_div4;
    logic clk_4x;
    logic clk_cal;
    logic clk_vec;

    clock_divider_4x u_clk_div4 (
        .clk_in   (clk),
        .rst_n    (rst_n),
        .clk_div1 (clk_div1),
        .clk_div2 (clk_div2),
        .clk_div4 (clk_div4)
    );

    assign clk_4x  = clk_div1;
    assign clk_cal = clk_div2;
    assign clk_vec = clk_div4;

    // ================================================================
    //  Reset synchronizers
    //   - core_rst_n_ser: fast 500 MHz serializer domain
    //   - core_rst_n_cal: half-rate 250 MHz calibration domain
    //   - core_rst_n_vec: slow 125 MHz vector domain
    // ================================================================
    logic core_rst_n_ser;
    logic core_rst_n_cal;
    logic core_rst_n_vec;

    reset_sync u_ser_rst_sync (
        .clk    (clk_4x),
        .arst_n (rst_n),
        .srst_n (core_rst_n_ser)
    );

    reset_sync u_cal_rst_sync (
        .clk    (clk_cal),
        .arst_n (rst_n),
        .srst_n (core_rst_n_cal)
    );

    reset_sync u_vec_rst_sync (
        .clk    (clk_vec),
        .arst_n (rst_n),
        .srst_n (core_rst_n_vec)
    );

    // ================================================================
    //  SPI slave (SCLK domain)
    // ================================================================
    logic        spi_wr_en, spi_rd_en;
    logic [6:0]  spi_addr;
    logic [7:0]  spi_wdata, spi_rdata;

    spi_slave u_spi (
        .sclk  (sclk),
        .csn   (csn),
        .mosi  (mosi),
        .miso  (miso),
        .wr_en (spi_wr_en),
        .rd_en (spi_rd_en),
        .addr  (spi_addr),
        .wdata (spi_wdata),
        .rdata (spi_rdata)
    );

    // ================================================================
    //  Register map (SCLK domain)
    // ================================================================
    logic [PHASE_W-1:0] rf_ftw_a, rf_ftw_b, rf_ftw_step;
    logic [COUNT_W-1:0] rf_chirp_n;
    logic [1:0]         rf_mode;
    logic               rf_auto_restart;
    logic               rf_phase_rst_on_launch;
    logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] rf_cal_code;
    logic               rf_direct_en;
    logic [DAC_SW_W-1:0] rf_direct_i;
    logic [DAC_SW_W-1:0] rf_direct_q;

    logic               cal_busy;

    dds_regmap #(
        .PHASE_W            (PHASE_W),
        .COUNT_W            (COUNT_W),
        .DEVID              (DEVID),
        .DAC_SW_W           (DAC_SW_W),
        .CAL_DAC_N_CELLS    (CAL_DAC_N_CELLS),
        .CAL_DAC_CELL_W     (CAL_DAC_CELL_W)
    ) u_regmap (
        .sclk                (sclk),
        .csn                 (csn),
        .rst_n               (rst_n),
        .wr_en               (spi_wr_en),
        .addr                (spi_addr),
        .wdata               (spi_wdata),
        .rdata               (spi_rdata),
        .ftw_a               (rf_ftw_a),
        .ftw_b               (rf_ftw_b),
        .ftw_step            (rf_ftw_step),
        .chirp_n             (rf_chirp_n),
        .mode                (rf_mode),
        .auto_restart        (rf_auto_restart),
        .phase_rst_on_launch (rf_phase_rst_on_launch),
        .cal_code            (rf_cal_code),
        .direct_en           (rf_direct_en),
        .direct_i            (rf_direct_i),
        .direct_q            (rf_direct_q)
    );

    // ================================================================
    //  Control-pin synchronizers.
    // io_update is used in both:
    //   - clk_cal domain for calibration apply
    //   - clk_vec domain for DDS profile launch
    // ================================================================
    logic io_upd_cal;
    logic io_upd_vec;
    logic sync_vec;

    sync_edge u_sync_ioup_cal (
        .clk  (clk_cal),
        .rst_n(core_rst_n_cal),
        .d    (io_update),
        .rise (io_upd_cal)
    );

    sync_edge u_sync_ioup_vec (
        .clk  (clk_vec),
        .rst_n(core_rst_n_vec),
        .d    (io_update),
        .rise (io_upd_vec)
    );

    sync_edge u_sync_sync_vec (
        .clk  (clk_vec),
        .rst_n(core_rst_n_vec),
        .d    (sync_in),
        .rise (sync_vec)
    );

    // ================================================================
    //  FTW control (clk_vec / 125 MHz block-rate domain)
    //   - profile normalization
    //   - normalized profile execution
    // ================================================================
    logic [PHASE_W-1:0] ftw_lane0;
    logic [PHASE_W-1:0] ftw_step_now;
    logic               wave_en;
    logic               phase_reset_req;

    ftw_ctrl #(
        .PHASE_W       (PHASE_W),
        .COUNT_W       (COUNT_W),
        .LANES         (LANES),
        .TEST_TONE_FTW (TEST_TONE_FTW)
    ) u_freq (
        .clk                       (clk_vec),
        .rst_n                     (core_rst_n_vec),
        .commit                    (io_upd_vec),
        .sync                      (sync_vec),
        .ftw_a                     (rf_ftw_a),
        .ftw_b                     (rf_ftw_b),
        .ftw_step                  (rf_ftw_step),
        .chirp_n                   (rf_chirp_n),
        .mode                      (rf_mode),
        .auto_restart              (rf_auto_restart),
        .phase_rst_on_launch       (rf_phase_rst_on_launch),
        .out_enable                (wave_en),
        .phase_reset_req           (phase_reset_req),
        .ftw_lane0                 (ftw_lane0),
        .ftw_step_now              (ftw_step_now)
    );

    // ================================================================
    //  Phase vector generation (clk_vec / 125 MHz block-rate domain)
    // ================================================================
    logic [3:0][PHASE_W-1:0] phase_vec;
    logic [3:0]              phase_valid_vec;

    phase_accum_vec4 #(
        .PHASE_W (PHASE_W)
    ) u_accum (
        .clk            (clk_vec),
        .rst_n          (core_rst_n_vec),
        .out_enable     (wave_en),
        .phase_reset_req(phase_reset_req),
        .ftw_now        (ftw_lane0),
        .ftw_step_now   (ftw_step_now),
        .phase_vec      (phase_vec),
        .valid_vec      (phase_valid_vec)
    );

    // ================================================================
    //  Parallel DDS datapath (clk_vec / 125 MHz block-rate domain)
    // ================================================================
    logic [LANES-1:0][DAC_SW_W-1:0] dac_i_vec;
    logic [LANES-1:0][DAC_SW_W-1:0] dac_q_vec;
    logic [LANES-1:0][DAC_SW_W-1:0] ser_i_vec;
    logic [LANES-1:0][DAC_SW_W-1:0] ser_q_vec;
    logic                           direct_en_active;
    logic [DAC_SW_W-1:0]            direct_i_active;
    logic [DAC_SW_W-1:0]            direct_q_active;

    dds_datapath_vec #(
        .PHASE_W       (PHASE_W),
        .SINE_TRUNC_W  (SINE_TRUNC_W),
        .SINE_COARSE_W (SINE_COARSE_W),
        .SINE_GUARD_W  (SINE_GUARD_W),
        .UNARY_BITS    (UNARY_BITS),
        .BINARY_BITS   (BINARY_BITS),
        .LANES         (LANES)
    ) u_dp (
        .clk        (clk_vec),
        .rst_n      (core_rst_n_vec),
        .phase_vec  (phase_vec),
        .out_enable (phase_valid_vec[0]),
        .dac_i_vec  (dac_i_vec),
        .dac_q_vec  (dac_q_vec)
    );

    always_ff @(posedge clk_vec or negedge core_rst_n_vec) begin
        if (!core_rst_n_vec) begin
            direct_en_active <= 1'b0;
            direct_i_active  <= {DAC_SW_W{1'b0}};
            direct_q_active  <= {DAC_SW_W{1'b0}};
        end else if (io_upd_vec) begin
            direct_en_active <= rf_direct_en;
            direct_i_active  <= rf_direct_i;
            direct_q_active  <= rf_direct_q;
        end
    end

    genvar lane_idx;
    generate
        for (lane_idx = 0; lane_idx < LANES; lane_idx = lane_idx + 1) begin : g_direct_override
            assign ser_i_vec[lane_idx] = direct_en_active ? direct_i_active : dac_i_vec[lane_idx];
            assign ser_q_vec[lane_idx] = direct_en_active ? direct_q_active : dac_q_vec[lane_idx];
        end
    endgenerate

    // ================================================================
    //  Output serialization (clk / 500 MHz fast serial domain)
    // ================================================================
    serializer_4to1 #(
        .WORD_W (DAC_SW_W)
    ) u_ser_i (
        .clk_ser (clk_4x),
        .rst_n   (core_rst_n_ser),
        .din_vec (ser_i_vec[3:0]),
        .dout    (dac_i)
    );

    serializer_4to1 #(
        .WORD_W (DAC_SW_W)
    ) u_ser_q (
        .clk_ser (clk_4x),
        .rst_n   (core_rst_n_ser),
        .din_vec (ser_q_vec[3:0]),
        .dout    (dac_q)
    );

    // ================================================================
    //  Calibration path
    // ================================================================
    // Default sizing is one 4-bit trim word per 36-bit DAC switch route.
    // The physical interface remains serial (`cal_clk`, `cal_data`,
    // `cal_load`); the 36*4-bit buses below are just staged/live state.
    logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] cal_dac_code_live;
    logic cal_dirty, cal_apply;

    assign cal_dirty = (rf_cal_code != cal_dac_code_live);
    assign cal_apply = io_upd_cal && !cal_busy && cal_dirty;

    cal_dac_scan #(
        .N_CELLS      (CAL_DAC_N_CELLS),
        .CELL_W       (CAL_DAC_CELL_W),
        .SHIFT_CYCLES (CAL_DAC_SHIFT_CYCLES)
    ) u_cal_dac_scan (
        .clk        (clk_cal),
        .rst_n      (core_rst_n_cal),
        .start      (cal_apply),
        .frame_data (rf_cal_code),
        .busy       (cal_busy),
        .cal_clk    (cal_clk),
        .cal_data   (cal_data),
        .cal_load   (cal_load),
        .dac_code   (cal_dac_code_live)
    );

endmodule

`default_nettype wire
