`default_nettype none
`timescale 1ns/1ps

/* verilator lint_off WIDTHEXPAND */
`include "rtl/common/carry_out.v"
`include "rtl/common/clock_divider_4x.v"
`include "rtl/common/reset_sync.v"
`include "rtl/common/sync_edge.v"
`include "rtl/ftw/dp_half.v"
`include "rtl/ftw/step_half.v"
`include "rtl/ftw/seg_timer.v"
`include "rtl/ftw/profile_normalizer.v"
`include "rtl/ftw/freq_runner.v"
`include "rtl/ftw/ftw_ctrl.v"
`include "rtl/phase/phase_accum_vec4.v"
`include "rtl/cal_dac/cal_dac_chain.v"
`include "rtl/cal_dac/cal_dac_scan.v"
`include "rtl/datapath/dac_encoder.v"
`include "rtl/datapath/phase_to_sincos_interp.v"
`include "rtl/datapath/sincos_interp_rom.v"
`include "rtl/datapath/sincos_interp_mag.v"
`include "rtl/datapath/dds_datapath.v"
`include "rtl/datapath/dds_datapath_vec.v"
`include "rtl/serializer/serializer_4to1.v"
`include "rtl/spi/spi_slave.v"
`include "rtl/spi/dds_regmap.v"
/* verilator lint_off PINMISSING */
`include "rtl/dds_top.v"
/* verilator lint_on PINMISSING */
/* verilator lint_on WIDTHEXPAND */

// AMS wrapper for the main DDS DAC path.
//
// The wrapper self-programs the chip-level SPI block:
//   - writes only CTRL over SPI
//   - selects TEST mode
//   - pulses io_update only; dds_top launches TEST mode internally
//
// This keeps the AMS view aligned with the user-facing DDS interface
// instead of bypassing the top-level control plane. The startup path is
// intentionally minimal so AMS runs reach a live waveform quickly.
module main_dac_codegen #(
    parameter integer PHASE_W      = 32,
    parameter integer SINE_TRUNC_W = 14,
    parameter integer SINE_COARSE_W = 7,
    parameter integer SINE_GUARD_W = 3,
    parameter integer UNARY_BITS   = 5,
    parameter integer BINARY_BITS  = 5,
    parameter integer COUNT_W      = 20,
    parameter integer DAC_SW_W     = (1 << UNARY_BITS) - 1 + BINARY_BITS,
    parameter integer RESET_LOW_CYCLES    = 2,
    parameter integer RESET_IDLE_CYCLES   = 2,
    parameter integer SPI_HALF_CYCLES     = 1,
    parameter integer IO_UPDATE_CYCLES    = 1,
    parameter logic [1:0] DDS_MODE        = 2'd3,
    parameter logic       AUTO_RESTART    = 1'b0,
    parameter logic       PHASE_RST_ON_LAUNCH = 1'b1,
    parameter logic [PHASE_W-1:0] FTW_A   = 32'h1000_0000,
    parameter logic [PHASE_W-1:0] FTW_B   = 32'h3000_0000,
    parameter logic [PHASE_W-1:0] CHIRP_STEP = 32'h0010_0000,
    parameter logic [COUNT_W-1:0] CHIRP_N = 20'd512
) (
    input  wire                clk,
    output wire [DAC_SW_W-1:0] dac_i_p,
    output wire [DAC_SW_W-1:0] dac_i_n,
    output wire [DAC_SW_W-1:0] dac_q_p,
    output wire [DAC_SW_W-1:0] dac_q_n
);

    // The SPI slave powers up uninitialized until it sees a CSn rising edge.
    // Issue the same CTRL write twice so the first transaction primes reset
    // and the second applies TEST mode deterministically.
    localparam integer CFG_WRITES = 2;
    localparam integer RESET_LOW_W   = (RESET_LOW_CYCLES   <= 1) ? 1 : $clog2(RESET_LOW_CYCLES   + 1);
    localparam integer RESET_IDLE_W  = (RESET_IDLE_CYCLES  <= 1) ? 1 : $clog2(RESET_IDLE_CYCLES  + 1);
    localparam integer SPI_HALF_W    = (SPI_HALF_CYCLES    <= 1) ? 1 : $clog2(SPI_HALF_CYCLES    + 1);
    localparam integer IO_UPDATE_W   = (IO_UPDATE_CYCLES   <= 1) ? 1 : $clog2(IO_UPDATE_CYCLES   + 1);
    localparam integer CFG_IDX_W     = (CFG_WRITES         <= 1) ? 1 : $clog2(CFG_WRITES);
    localparam logic [7:0] CTRL_DATA = {4'b0000, PHASE_RST_ON_LAUNCH, AUTO_RESTART, DDS_MODE};

    function automatic logic [6:0] cfg_addr(input logic [CFG_IDX_W-1:0] idx);
        begin
            cfg_addr = 7'h01;
        end
    endfunction

    function automatic logic [7:0] cfg_data(input logic [CFG_IDX_W-1:0] idx);
        begin
            cfg_data = CTRL_DATA;
        end
    endfunction

    typedef enum logic [3:0] {
        ST_RESET_LOW,
        ST_RESET_IDLE,
        ST_SPI_LOAD,
        ST_SPI_DRIVE,
        ST_SPI_SCLK_HIGH,
        ST_SPI_SCLK_LOW,
        ST_SPI_GAP,
        ST_IO_UPDATE_HIGH,
        ST_IO_UPDATE_LOW,
        ST_DONE
    } runner_state_t;

    logic rst_n = 1'b1;
    logic sclk = 1'b0;
    logic csn = 1'b1;
    logic mosi = 1'b0;
    logic miso;
    logic io_update = 1'b0;
    logic sync_in = 1'b0;

    runner_state_t runner_state = ST_RESET_LOW;
    logic [RESET_LOW_W-1:0]  reset_low_count = '0;
    logic [RESET_IDLE_W-1:0] reset_idle_count = '0;
    logic [SPI_HALF_W-1:0]   spi_half_count = '0;
    logic [IO_UPDATE_W-1:0]  io_update_count = '0;
    logic [CFG_IDX_W-1:0]    cfg_idx = '0;
    logic [15:0]             spi_shift = 16'h0000;
    logic [3:0]              bit_idx = 4'd0;
    wire  [DAC_SW_W-1:0]     dac_i_sw;
    wire  [DAC_SW_W-1:0]     dac_q_sw;
    logic cal_clk, cal_data, cal_load;
    logic [2:0] dds_spi_clk;
    logic [PHASE_W-1:0] dds_ftw_a, dds_ftw_b, dds_ftw_step;
    logic [COUNT_W-1:0] dds_chirp_n;
    logic [1:0] dds_mode;
    logic dds_auto_restart;
    logic dds_phase_rst_on_launch;
    logic [DAC_SW_W*4-1:0] dds_cal_code;
    logic dds_direct_en;
    logic [DAC_SW_W-1:0] dds_direct_i, dds_direct_q;
    logic pll_clk;
    logic [10:0] pll_config;

    assign dac_i_p = dac_i_sw;
    assign dac_i_n = ~dac_i_sw;
    assign dac_q_p = dac_q_sw;
    assign dac_q_n = ~dac_q_sw;

    spi_slave #(
        .PHASE_W            (PHASE_W),
        .COUNT_W            (COUNT_W),
        .DAC_SW_W           (DAC_SW_W),
        .CAL_DAC_N_CELLS    (DAC_SW_W),
        .CAL_DAC_CELL_W     (4)
    ) u_spi (
        .sclk                    (sclk),
        .csn                     (csn),
        .rst_n                   (rst_n),
        .mosi                    (mosi),
        .miso                    (miso),
        .dds_spi_clk             (dds_spi_clk),
        .dds_ftw_a               (dds_ftw_a),
        .dds_ftw_b               (dds_ftw_b),
        .dds_ftw_step            (dds_ftw_step),
        .dds_chirp_n             (dds_chirp_n),
        .dds_mode                (dds_mode),
        .dds_auto_restart        (dds_auto_restart),
        .dds_phase_rst_on_launch (dds_phase_rst_on_launch),
        .dds_cal_code            (dds_cal_code),
        .dds_direct_en           (dds_direct_en),
        .dds_direct_i            (dds_direct_i),
        .dds_direct_q            (dds_direct_q),
        .pll_clk                 (pll_clk),
        .pll_config              (pll_config)
    );

    dds_top #(
        .PHASE_W       (PHASE_W),
        .SINE_TRUNC_W  (SINE_TRUNC_W),
        .SINE_COARSE_W (SINE_COARSE_W),
        .SINE_GUARD_W  (SINE_GUARD_W),
        .UNARY_BITS    (UNARY_BITS),
        .BINARY_BITS   (BINARY_BITS),
        .COUNT_W       (COUNT_W)
    ) dut (
        .clk                     (clk),
        .rst_n                   (rst_n),
        .dds_spi_clk             (dds_spi_clk),
        .dds_ftw_a               (dds_ftw_a),
        .dds_ftw_b               (dds_ftw_b),
        .dds_ftw_step            (dds_ftw_step),
        .dds_chirp_n             (dds_chirp_n),
        .dds_mode                (dds_mode),
        .dds_auto_restart        (dds_auto_restart),
        .dds_phase_rst_on_launch (dds_phase_rst_on_launch),
        .dds_cal_code            (dds_cal_code),
        .dds_direct_en           (dds_direct_en),
        .dds_direct_i            (dds_direct_i),
        .dds_direct_q            (dds_direct_q),
        .io_update               (io_update),
        .sync_in                 (sync_in),
        .dac_i                   (dac_i_sw),
        .dac_q                   (dac_q_sw),
        .cal_clk                 (cal_clk),
        .cal_data                (cal_data),
        .cal_load                (cal_load)
    );

    always_ff @(negedge clk) begin
        io_update <= 1'b0;

        case (runner_state)
            ST_RESET_LOW: begin
                rst_n             <= 1'b0;
                sclk              <= 1'b0;
                csn               <= 1'b1;
                mosi              <= 1'b0;
                cfg_idx           <= '0;
                spi_shift         <= 16'h0000;
                bit_idx           <= 4'd0;
                spi_half_count    <= '0;
                io_update_count   <= '0;
                reset_idle_count  <= '0;
                if (reset_low_count == RESET_LOW_W'(RESET_LOW_CYCLES - 1)) begin
                    reset_low_count <= '0;
                    rst_n           <= 1'b1;
                    runner_state    <= ST_RESET_IDLE;
                end else begin
                    reset_low_count <= reset_low_count + RESET_LOW_W'(1);
                end
            end

            ST_RESET_IDLE: begin
                if (reset_idle_count == RESET_IDLE_W'(RESET_IDLE_CYCLES - 1)) begin
                    reset_idle_count <= '0;
                    cfg_idx          <= '0;
                    runner_state     <= ST_SPI_LOAD;
                end else begin
                    reset_idle_count <= reset_idle_count + RESET_IDLE_W'(1);
                end
            end

            ST_SPI_LOAD: begin
                csn            <= 1'b0;
                sclk           <= 1'b0;
                spi_half_count <= '0;
                spi_shift      <= {1'b0, cfg_addr(cfg_idx), cfg_data(cfg_idx)};
                bit_idx        <= 4'd15;
                runner_state   <= ST_SPI_DRIVE;
            end

            ST_SPI_DRIVE: begin
                mosi <= spi_shift[15];
                if (spi_half_count == SPI_HALF_W'(SPI_HALF_CYCLES - 1)) begin
                    spi_half_count <= '0;
                    runner_state   <= ST_SPI_SCLK_HIGH;
                end else begin
                    spi_half_count <= spi_half_count + SPI_HALF_W'(1);
                end
            end

            ST_SPI_SCLK_HIGH: begin
                sclk <= 1'b1;
                if (spi_half_count == SPI_HALF_W'(SPI_HALF_CYCLES - 1)) begin
                    spi_half_count <= '0;
                    runner_state   <= ST_SPI_SCLK_LOW;
                end else begin
                    spi_half_count <= spi_half_count + SPI_HALF_W'(1);
                end
            end

            ST_SPI_SCLK_LOW: begin
                sclk <= 1'b0;
                if (spi_half_count == SPI_HALF_W'(SPI_HALF_CYCLES - 1)) begin
                    spi_half_count <= '0;
                    if (bit_idx == 4'd0) begin
                        csn          <= 1'b1;
                        runner_state <= ST_SPI_GAP;
                    end else begin
                        bit_idx      <= bit_idx - 4'd1;
                        spi_shift    <= {spi_shift[14:0], 1'b0};
                        runner_state <= ST_SPI_DRIVE;
                    end
                end else begin
                    spi_half_count <= spi_half_count + SPI_HALF_W'(1);
                end
            end

            ST_SPI_GAP: begin
                if (cfg_idx == CFG_IDX_W'(CFG_WRITES - 1)) begin
                    io_update_count <= '0;
                    runner_state    <= ST_IO_UPDATE_HIGH;
                end else begin
                    cfg_idx      <= cfg_idx + CFG_IDX_W'(1);
                    runner_state <= ST_SPI_LOAD;
                end
            end

            ST_IO_UPDATE_HIGH: begin
                io_update <= 1'b1;
                if (io_update_count == IO_UPDATE_W'(IO_UPDATE_CYCLES - 1)) begin
                    io_update_count <= '0;
                    runner_state    <= ST_IO_UPDATE_LOW;
                end else begin
                    io_update_count <= io_update_count + IO_UPDATE_W'(1);
                end
            end

            ST_IO_UPDATE_LOW: begin
                if (io_update_count == IO_UPDATE_W'(IO_UPDATE_CYCLES - 1)) begin
                    io_update_count <= '0;
                    runner_state    <= ST_DONE;
                end else begin
                    io_update_count <= io_update_count + IO_UPDATE_W'(1);
                end
            end

            default: begin
                runner_state <= ST_DONE;
            end
        endcase
    end

endmodule

`default_nettype wire
