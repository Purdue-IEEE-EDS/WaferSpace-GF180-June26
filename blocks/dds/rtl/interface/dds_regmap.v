`default_nettype none
`timescale 1ns/1ps

// DDS register map. Lives in SCLK domain.
//
// Working bank (SPI writes) -> committed bank (CSn snapshot).
// Only committed bank is exposed to CLK domain via io_update launch.
//
// rst_n:  Power-on async reset for both working and committed banks.
//         rst_n is CLK-domain but held for many microseconds at power-up —
//         safe as async reset on SCLK-domain flops.
//
// Address map (little-endian byte order):
//   0x00       DEVID        R    hardcoded
//   0x01       STATUS       R    {5'b0, cal_busy, 2'b0}
//   0x02       CTRL         R/W  {4'b0, phase_rst_on_launch, auto_restart, mode[1:0]}
//                                 mode=3 selects the fixed test-tone profile
//   0x04-0x07  FTW_A        R/W  ftw_a[31:0]
//   0x08-0x0B  FTW_B        R/W  ftw_b[31:0]
//   0x0C-0x0F  FTW_STEP     R/W  ftw_step[31:0]
//   0x10-0x12  CHIRP_N      R/W  chirp_n[COUNT_W-1:0]  (3 bytes, upper bits zero)
//                                 whole-vector segment length in fabric blocks
//   0x20...     CAL_DAC[n]   R/W  one 4-bit shadow word per cell, zero-extended

module dds_regmap #(
    parameter PHASE_W       = 32,
    parameter COUNT_W       = 20,
    parameter DEVID         = 8'hD5,
    parameter CAL_DAC_N_CELLS = 36,
    parameter CAL_DAC_CELL_W  = 4,
    parameter [CAL_DAC_CELL_W-1:0] CAL_DAC_RESET_CODE = {1'b1, {(CAL_DAC_CELL_W-1){1'b0}}}
)(
    input  logic        sclk,
    input  logic        csn,
    input  logic        rst_n,

    // SPI LBUS
    input  logic        wr_en,
    input  logic [6:0]  addr,
    input  logic [7:0]  wdata,
    output logic [7:0]  rdata,

    // status inputs (CLK domain — synchronised here for readback)
    input  logic        cal_busy,

    // register outputs (committed bank)
    output logic [PHASE_W-1:0]  ftw_a,
    output logic [PHASE_W-1:0]  ftw_b,
    output logic [PHASE_W-1:0]  ftw_step,
    output logic [COUNT_W-1:0]  chirp_n,
    output logic [1:0]          mode,
    output logic                auto_restart,
    output logic                phase_rst_on_launch,
    output logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] cal_code
);

    localparam logic [6:0] CAL_DAC_BASE_ADDR = 7'h20;

    //  status synchronizer (CLK -> SCLK, 2-FF)
    logic [1:0] cb_sync;

    always_ff @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            cb_sync <= 2'b0;
        end else begin
            cb_sync <= {cb_sync[0], cal_busy};
        end
    end

    logic cal_busy_s;
    assign cal_busy_s = cb_sync[1];

    // ----------------------------------------------------------------
    //  working bank — SPI byte writes (posedge sclk, async rst_n)
    // ----------------------------------------------------------------
    logic [PHASE_W-1:0] w_ftw_a, w_ftw_b, w_ftw_step;
    logic [COUNT_W-1:0] w_chirp_n;
    logic [1:0]         w_mode;
    logic               w_auto_restart;
    logic               w_phase_rst_on_launch;
    logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] w_cal_code;
    integer idx;

    always_ff @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            w_ftw_a              <= {PHASE_W{1'b0}};
            w_ftw_b              <= {PHASE_W{1'b0}};
            w_ftw_step           <= {PHASE_W{1'b0}};
            w_chirp_n            <= {COUNT_W{1'b0}};
            w_mode               <= 2'd0;
            w_auto_restart       <= 1'b0;
            w_phase_rst_on_launch <= 1'b0;
            for (idx = 0; idx < CAL_DAC_N_CELLS; idx = idx + 1)
                w_cal_code[(idx*CAL_DAC_CELL_W) +: CAL_DAC_CELL_W] <= CAL_DAC_RESET_CODE;
        end else if (wr_en) begin
            if (addr >= CAL_DAC_BASE_ADDR && addr < CAL_DAC_BASE_ADDR + CAL_DAC_N_CELLS) begin
                w_cal_code[((addr - CAL_DAC_BASE_ADDR) * CAL_DAC_CELL_W) +: CAL_DAC_CELL_W] <=
                    wdata[CAL_DAC_CELL_W-1:0];
            end else begin
                case (addr)
                    7'h02: begin
                        w_mode               <= wdata[1:0];
                        w_auto_restart       <= wdata[2];
                        w_phase_rst_on_launch <= wdata[3];
                    end
                    7'h04: w_ftw_a[ 7: 0] <= wdata;
                    7'h05: w_ftw_a[15: 8] <= wdata;
                    7'h06: w_ftw_a[23:16] <= wdata;
                    7'h07: w_ftw_a[31:24] <= wdata;
                    7'h08: w_ftw_b[ 7: 0] <= wdata;
                    7'h09: w_ftw_b[15: 8] <= wdata;
                    7'h0A: w_ftw_b[23:16] <= wdata;
                    7'h0B: w_ftw_b[31:24] <= wdata;
                    7'h0C: w_ftw_step[ 7: 0] <= wdata;
                    7'h0D: w_ftw_step[15: 8] <= wdata;
                    7'h0E: w_ftw_step[23:16] <= wdata;
                    7'h0F: w_ftw_step[31:24] <= wdata;
                    7'h10: w_chirp_n[ 7: 0] <= wdata;
                    7'h11: w_chirp_n[15: 8] <= wdata;
                    7'h12: w_chirp_n[COUNT_W-1:16] <= wdata[COUNT_W-1-16:0];
                    default: ;
                endcase
            end
        end
    end

    // ----------------------------------------------------------------
    //  committed bank — snapshot on CSn rising (async rst_n)
    // ----------------------------------------------------------------
    always_ff @(posedge csn or negedge rst_n) begin
        if (!rst_n) begin
            ftw_a              <= {PHASE_W{1'b0}};
            ftw_b              <= {PHASE_W{1'b0}};
            ftw_step           <= {PHASE_W{1'b0}};
            chirp_n            <= {COUNT_W{1'b0}};
            mode               <= 2'd0;
            auto_restart       <= 1'b0;
            phase_rst_on_launch <= 1'b0;
            for (idx = 0; idx < CAL_DAC_N_CELLS; idx = idx + 1)
                cal_code[(idx*CAL_DAC_CELL_W) +: CAL_DAC_CELL_W] <= CAL_DAC_RESET_CODE;
        end else begin
            ftw_a              <= w_ftw_a;
            ftw_b              <= w_ftw_b;
            ftw_step           <= w_ftw_step;
            chirp_n            <= w_chirp_n;
            mode               <= w_mode;
            auto_restart       <= w_auto_restart;
            phase_rst_on_launch <= w_phase_rst_on_launch;
            cal_code           <= w_cal_code;
        end
    end

    // ----------------------------------------------------------------
    //  read mux (SPI read-back)
    // ----------------------------------------------------------------
    function [7:0] read_mux;
        input [6:0] a;
        integer cal_idx;
    begin
        if (a >= CAL_DAC_BASE_ADDR && a < CAL_DAC_BASE_ADDR + CAL_DAC_N_CELLS) begin
            cal_idx = a - CAL_DAC_BASE_ADDR;
            read_mux = {{(8-CAL_DAC_CELL_W){1'b0}},
                        w_cal_code[(cal_idx*CAL_DAC_CELL_W) +: CAL_DAC_CELL_W]};
        end else begin
            case (a)
                7'h00: read_mux = DEVID[7:0];
                7'h01: read_mux = {5'b0, cal_busy_s, 2'b00};
                7'h02: read_mux = {4'b0, w_phase_rst_on_launch, w_auto_restart, w_mode};
                7'h04: read_mux = w_ftw_a[ 7: 0];
                7'h05: read_mux = w_ftw_a[15: 8];
                7'h06: read_mux = w_ftw_a[23:16];
                7'h07: read_mux = w_ftw_a[31:24];
                7'h08: read_mux = w_ftw_b[ 7: 0];
                7'h09: read_mux = w_ftw_b[15: 8];
                7'h0A: read_mux = w_ftw_b[23:16];
                7'h0B: read_mux = w_ftw_b[31:24];
                7'h0C: read_mux = w_ftw_step[ 7: 0];
                7'h0D: read_mux = w_ftw_step[15: 8];
                7'h0E: read_mux = w_ftw_step[23:16];
                7'h0F: read_mux = w_ftw_step[31:24];
                7'h10: read_mux = w_chirp_n[ 7: 0];
                7'h11: read_mux = w_chirp_n[15: 8];
                7'h12: read_mux = {{(24-COUNT_W){1'b0}}, w_chirp_n[COUNT_W-1:16]};
                default: read_mux = 8'h00;
            endcase
        end
    end
    endfunction

    assign rdata = read_mux(addr);

endmodule

`default_nettype wire
