`default_nettype none
`timescale 1ns/1ps

// DDS top-level.
//
// CONFIG comes from the chip-level SPI bundle and launches on io_update.
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

    // DDS config bundle from the chip-level SPI block. These signals are
    // committed in the SPI SCLK domain and synchronized locally below.
    input  logic [2:0]            dds_spi_clk,
    input  logic [PHASE_W-1:0]    dds_ftw_a,
    input  logic [PHASE_W-1:0]    dds_ftw_b,
    input  logic [PHASE_W-1:0]    dds_ftw_step,
    input  logic [COUNT_W-1:0]    dds_chirp_n,
    input  logic [1:0]            dds_mode,
    input  logic                  dds_auto_restart,
    input  logic                  dds_phase_rst_on_launch,
    input  logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] dds_cal_code,
    input  logic                  dds_direct_en,
    input  logic [DAC_SW_W-1:0]   dds_direct_i,
    input  logic [DAC_SW_W-1:0]   dds_direct_q,

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
    //  SPI config bundle synchronization into DDS clock domains.
    // ================================================================
    logic [2:0]         dds_spi_clk_vec_meta, dds_spi_clk_vec;
    logic [PHASE_W-1:0] dds_ftw_a_vec_meta, dds_ftw_a_vec;
    logic [PHASE_W-1:0] dds_ftw_b_vec_meta, dds_ftw_b_vec;
    logic [PHASE_W-1:0] dds_ftw_step_vec_meta, dds_ftw_step_vec;
    logic [COUNT_W-1:0] dds_chirp_n_vec_meta, dds_chirp_n_vec;
    logic [1:0]         dds_mode_vec_meta, dds_mode_vec;
    logic               dds_auto_restart_vec_meta, dds_auto_restart_vec;
    logic               dds_phase_rst_on_launch_vec_meta, dds_phase_rst_on_launch_vec;
    logic               dds_direct_en_vec_meta, dds_direct_en_vec;
    logic [DAC_SW_W-1:0] dds_direct_i_vec_meta, dds_direct_i_vec;
    logic [DAC_SW_W-1:0] dds_direct_q_vec_meta, dds_direct_q_vec;

    logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] dds_cal_code_cal_meta;
    logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] dds_cal_code_cal;

    always_ff @(posedge clk_vec or negedge core_rst_n_vec) begin
        if (!core_rst_n_vec) begin
            dds_spi_clk_vec_meta             <= 3'b000;
            dds_spi_clk_vec                  <= 3'b000;
            dds_ftw_a_vec_meta               <= {PHASE_W{1'b0}};
            dds_ftw_a_vec                    <= {PHASE_W{1'b0}};
            dds_ftw_b_vec_meta               <= {PHASE_W{1'b0}};
            dds_ftw_b_vec                    <= {PHASE_W{1'b0}};
            dds_ftw_step_vec_meta            <= {PHASE_W{1'b0}};
            dds_ftw_step_vec                 <= {PHASE_W{1'b0}};
            dds_chirp_n_vec_meta             <= {COUNT_W{1'b0}};
            dds_chirp_n_vec                  <= {COUNT_W{1'b0}};
            dds_mode_vec_meta                <= 2'b00;
            dds_mode_vec                     <= 2'b00;
            dds_auto_restart_vec_meta        <= 1'b0;
            dds_auto_restart_vec             <= 1'b0;
            dds_phase_rst_on_launch_vec_meta <= 1'b0;
            dds_phase_rst_on_launch_vec      <= 1'b0;
            dds_direct_en_vec_meta           <= 1'b0;
            dds_direct_en_vec                <= 1'b0;
            dds_direct_i_vec_meta            <= {DAC_SW_W{1'b0}};
            dds_direct_i_vec                 <= {DAC_SW_W{1'b0}};
            dds_direct_q_vec_meta            <= {DAC_SW_W{1'b0}};
            dds_direct_q_vec                 <= {DAC_SW_W{1'b0}};
        end else begin
            dds_spi_clk_vec_meta             <= dds_spi_clk;
            dds_spi_clk_vec                  <= dds_spi_clk_vec_meta;
            dds_ftw_a_vec_meta               <= dds_ftw_a;
            dds_ftw_a_vec                    <= dds_ftw_a_vec_meta;
            dds_ftw_b_vec_meta               <= dds_ftw_b;
            dds_ftw_b_vec                    <= dds_ftw_b_vec_meta;
            dds_ftw_step_vec_meta            <= dds_ftw_step;
            dds_ftw_step_vec                 <= dds_ftw_step_vec_meta;
            dds_chirp_n_vec_meta             <= dds_chirp_n;
            dds_chirp_n_vec                  <= dds_chirp_n_vec_meta;
            dds_mode_vec_meta                <= dds_mode;
            dds_mode_vec                     <= dds_mode_vec_meta;
            dds_auto_restart_vec_meta        <= dds_auto_restart;
            dds_auto_restart_vec             <= dds_auto_restart_vec_meta;
            dds_phase_rst_on_launch_vec_meta <= dds_phase_rst_on_launch;
            dds_phase_rst_on_launch_vec      <= dds_phase_rst_on_launch_vec_meta;
            dds_direct_en_vec_meta           <= dds_direct_en;
            dds_direct_en_vec                <= dds_direct_en_vec_meta;
            dds_direct_i_vec_meta            <= dds_direct_i;
            dds_direct_i_vec                 <= dds_direct_i_vec_meta;
            dds_direct_q_vec_meta            <= dds_direct_q;
            dds_direct_q_vec                 <= dds_direct_q_vec_meta;
        end
    end

    always_ff @(posedge clk_cal or negedge core_rst_n_cal) begin
        if (!core_rst_n_cal) begin
            dds_cal_code_cal_meta <= {CAL_DAC_N_CELLS*CAL_DAC_CELL_W{1'b0}};
            dds_cal_code_cal      <= {CAL_DAC_N_CELLS*CAL_DAC_CELL_W{1'b0}};
        end else begin
            dds_cal_code_cal_meta <= dds_cal_code;
            dds_cal_code_cal      <= dds_cal_code_cal_meta;
        end
    end

    logic               cal_busy;

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
        .ftw_a                     (dds_ftw_a_vec),
        .ftw_b                     (dds_ftw_b_vec),
        .ftw_step                  (dds_ftw_step_vec),
        .chirp_n                   (dds_chirp_n_vec),
        .mode                      (dds_mode_vec),
        .auto_restart              (dds_auto_restart_vec),
        .phase_rst_on_launch       (dds_phase_rst_on_launch_vec),
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
            direct_en_active <= dds_direct_en_vec;
            direct_i_active  <= dds_direct_i_vec;
            direct_q_active  <= dds_direct_q_vec;
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

    assign cal_dirty = (dds_cal_code_cal != cal_dac_code_live);
    assign cal_apply = io_upd_cal && !cal_busy && cal_dirty;

    cal_dac_scan #(
        .N_CELLS      (CAL_DAC_N_CELLS),
        .CELL_W       (CAL_DAC_CELL_W),
        .SHIFT_CYCLES (CAL_DAC_SHIFT_CYCLES)
    ) u_cal_dac_scan (
        .clk        (clk_cal),
        .rst_n      (core_rst_n_cal),
        .start      (cal_apply),
        .frame_data (dds_cal_code_cal),
        .busy       (cal_busy),
        .cal_clk    (cal_clk),
        .cal_data   (cal_data),
        .cal_load   (cal_load),
        .dac_code   (cal_dac_code_live)
    );

endmodule

`default_nettype wire
