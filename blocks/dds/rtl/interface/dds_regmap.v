`default_nettype none
`timescale 1ns/1ps

// DDS register map. Lives in SCLK domain. SPI slave drives the LBUS side.
//
// Working bank (SPI writes) → committed bank (CSn snapshot).
// Only committed bank exposed to CLK domain via io_update latch.
//
// rst_n:  Power-on async reset for both working and committed banks.
//         rst_n is CLK-domain but held for many microseconds at power-up —
//         safe as async reset on SCLK-domain flops.
//
// Address map (little-endian byte order):
//   0x00       DEVID        R    hardcoded
//   0x01       STATUS       R    {6'b0, chirp_done_sticky, chirp_active}
//   0x02       CTRL         R/W  {4'b0, phase_rst_on_start, auto_restart, mode[1:0]}
//   0x04-0x07  FTW_A        R/W  ftw_a[31:0]
//   0x08-0x0B  FTW_B        R/W  ftw_b[31:0]
//   0x0C-0x0F  CHIRP_STEP   R/W  chirp_step[31:0]
//   0x10-0x12  CHIRP_N      R/W  chirp_n[COUNT_W-1:0] (3 bytes, upper bits zero)
//   0x20-0x21  POW[0]       R/W  pow_0[15:0]  (phase offset, top TRUNC_W bits used)
//   0x22-0x23  POW[1]       R/W  pow_1[15:0]
//   0x24-0x25  POW[2]       R/W  pow_2[15:0]
//   0x26-0x27  POW[3]       R/W  pow_3[15:0]
//   0x30-0x31  AMP[0]       R/W  amp_0[15:0]   (reset: 0xFFFF = unity)
//   0x32-0x33  AMP[1]       R/W  amp_1[15:0]   (reset: 0xFFFF = unity)
//   0x34-0x35  AMP[2]       R/W  amp_2[15:0]   (reset: 0xFFFF = unity)
//   0x36-0x37  AMP[3]       R/W  amp_3[15:0]   (reset: 0xFFFF = unity)
module dds_regmap #(
    parameter PHASE_W  = 32,
    parameter COUNT_W  = 20,
    parameter DEVID    = 8'hD5
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
    input  logic        chirp_active,
    input  logic        chirp_done_sticky,

    // register outputs (committed bank)
    output logic [PHASE_W-1:0]  ftw_a,
    output logic [PHASE_W-1:0]  ftw_b,
    output logic [PHASE_W-1:0]  chirp_step,
    output logic [COUNT_W-1:0]  chirp_n,
    output logic [1:0]          mode,
    output logic                auto_restart,
    output logic                phase_rst_on_start,
    output logic [15:0]         pow_0,
    output logic [15:0]         pow_1,
    output logic [15:0]         pow_2,
    output logic [15:0]         pow_3,
    output logic [15:0]         amp_0,
    output logic [15:0]         amp_1,
    output logic [15:0]         amp_2,
    output logic [15:0]         amp_3
);

    //  status synchronizers (CLK -> SCLK, 2-FF)
    logic [1:0] ca_sync, cd_sync;

    always_ff @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            ca_sync <= 2'b0;
            cd_sync <= 2'b0;
        end else begin
            ca_sync <= {ca_sync[0], chirp_active};
            cd_sync <= {cd_sync[0], chirp_done_sticky};
        end
    end

    logic chirp_active_s, chirp_done_s;
    assign chirp_active_s = ca_sync[1];
    assign chirp_done_s   = cd_sync[1];

    // ----------------------------------------------------------------
    //  working bank — SPI byte writes (posedge sclk, async rst_n)
    // ----------------------------------------------------------------
    logic [PHASE_W-1:0] w_ftw_a, w_ftw_b, w_chirp_step;
    logic [COUNT_W-1:0] w_chirp_n;
    logic [1:0]         w_mode;
    logic               w_auto_restart;
    logic               w_phase_rst_on_start;
    logic [15:0]        w_pow [0:3];
    logic [15:0]        w_amp [0:3];

    always_ff @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            w_ftw_a              <= {PHASE_W{1'b0}};
            w_ftw_b              <= {PHASE_W{1'b0}};
            w_chirp_step         <= {PHASE_W{1'b0}};
            w_chirp_n            <= {COUNT_W{1'b0}};
            w_mode               <= 2'd0;
            w_auto_restart       <= 1'b0;
            w_phase_rst_on_start <= 1'b0;
            w_pow[0] <= 16'h0;
            w_pow[1] <= 16'h0;
            w_pow[2] <= 16'h0;
            w_pow[3] <= 16'h0;
            w_amp[0] <= 16'hFFFF;
            w_amp[1] <= 16'hFFFF;
            w_amp[2] <= 16'hFFFF;
            w_amp[3] <= 16'hFFFF;
        end else if (wr_en) begin
            case (addr)
                // CTRL 0x02
                7'h02: begin
                    w_mode               <= wdata[1:0];
                    w_auto_restart       <= wdata[2];
                    w_phase_rst_on_start <= wdata[3];
                end
                // FTW_A 0x04-0x07
                7'h04: w_ftw_a[ 7: 0] <= wdata;
                7'h05: w_ftw_a[15: 8] <= wdata;
                7'h06: w_ftw_a[23:16] <= wdata;
                7'h07: w_ftw_a[31:24] <= wdata;
                // FTW_B 0x08-0x0B
                7'h08: w_ftw_b[ 7: 0] <= wdata;
                7'h09: w_ftw_b[15: 8] <= wdata;
                7'h0A: w_ftw_b[23:16] <= wdata;
                7'h0B: w_ftw_b[31:24] <= wdata;
                // CHIRP_STEP 0x0C-0x0F
                7'h0C: w_chirp_step[ 7: 0] <= wdata;
                7'h0D: w_chirp_step[15: 8] <= wdata;
                7'h0E: w_chirp_step[23:16] <= wdata;
                7'h0F: w_chirp_step[31:24] <= wdata;
                // CHIRP_N 0x10-0x12
                7'h10: w_chirp_n[ 7: 0] <= wdata;
                7'h11: w_chirp_n[15: 8] <= wdata;
                7'h12: w_chirp_n[COUNT_W-1:16] <= wdata[COUNT_W-1-16:0];
                // POW[0] 0x20-0x21
                7'h20: w_pow[0][ 7:0] <= wdata;
                7'h21: w_pow[0][15:8] <= wdata;
                // POW[1] 0x22-0x23
                7'h22: w_pow[1][ 7:0] <= wdata;
                7'h23: w_pow[1][15:8] <= wdata;
                // POW[2] 0x24-0x25
                7'h24: w_pow[2][ 7:0] <= wdata;
                7'h25: w_pow[2][15:8] <= wdata;
                // POW[3] 0x26-0x27
                7'h26: w_pow[3][ 7:0] <= wdata;
                7'h27: w_pow[3][15:8] <= wdata;
                // AMP[0] 0x30-0x31
                7'h30: w_amp[0][ 7:0] <= wdata;
                7'h31: w_amp[0][15:8] <= wdata;
                // AMP[1] 0x32-0x33
                7'h32: w_amp[1][ 7:0] <= wdata;
                7'h33: w_amp[1][15:8] <= wdata;
                // AMP[2] 0x34-0x35
                7'h34: w_amp[2][ 7:0] <= wdata;
                7'h35: w_amp[2][15:8] <= wdata;
                // AMP[3] 0x36-0x37
                7'h36: w_amp[3][ 7:0] <= wdata;
                7'h37: w_amp[3][15:8] <= wdata;
                default: ;
            endcase
        end
    end

    // ----------------------------------------------------------------
    //  committed bank — snapshot on CSn rising (async rst_n)
    // ----------------------------------------------------------------
    always_ff @(posedge csn or negedge rst_n) begin
        if (!rst_n) begin
            ftw_a              <= {PHASE_W{1'b0}};
            ftw_b              <= {PHASE_W{1'b0}};
            chirp_step         <= {PHASE_W{1'b0}};
            chirp_n            <= {COUNT_W{1'b0}};
            mode               <= 2'd0;
            auto_restart       <= 1'b0;
            phase_rst_on_start <= 1'b0;
            pow_0              <= 16'h0;
            pow_1              <= 16'h0;
            pow_2              <= 16'h0;
            pow_3              <= 16'h0;
            amp_0              <= 16'hFFFF;
            amp_1              <= 16'hFFFF;
            amp_2              <= 16'hFFFF;
            amp_3              <= 16'hFFFF;
        end else begin
            ftw_a              <= w_ftw_a;
            ftw_b              <= w_ftw_b;
            chirp_step         <= w_chirp_step;
            chirp_n            <= w_chirp_n;
            mode               <= w_mode;
            auto_restart       <= w_auto_restart;
            phase_rst_on_start <= w_phase_rst_on_start;
            pow_0              <= w_pow[0];
            pow_1              <= w_pow[1];
            pow_2              <= w_pow[2];
            pow_3              <= w_pow[3];
            amp_0              <= w_amp[0];
            amp_1              <= w_amp[1];
            amp_2              <= w_amp[2];
            amp_3              <= w_amp[3];
        end
    end

    // ----------------------------------------------------------------
    //  read mux (SPI read-back)
    // ----------------------------------------------------------------
    function [7:0] read_mux;
        input [6:0] a;
    begin
        case (a)
            7'h00: read_mux = DEVID[7:0];
            7'h01: read_mux = {6'b0, chirp_done_s, chirp_active_s};
            7'h02: read_mux = {4'b0, w_phase_rst_on_start, w_auto_restart, w_mode};
            // FTW_A
            7'h04: read_mux = w_ftw_a[ 7: 0];
            7'h05: read_mux = w_ftw_a[15: 8];
            7'h06: read_mux = w_ftw_a[23:16];
            7'h07: read_mux = w_ftw_a[31:24];
            // FTW_B
            7'h08: read_mux = w_ftw_b[ 7: 0];
            7'h09: read_mux = w_ftw_b[15: 8];
            7'h0A: read_mux = w_ftw_b[23:16];
            7'h0B: read_mux = w_ftw_b[31:24];
            // CHIRP_STEP
            7'h0C: read_mux = w_chirp_step[ 7: 0];
            7'h0D: read_mux = w_chirp_step[15: 8];
            7'h0E: read_mux = w_chirp_step[23:16];
            7'h0F: read_mux = w_chirp_step[31:24];
            // CHIRP_N
            7'h10: read_mux = w_chirp_n[ 7: 0];
            7'h11: read_mux = w_chirp_n[15: 8];
            7'h12: read_mux = {{(24-COUNT_W){1'b0}}, w_chirp_n[COUNT_W-1:16]};
            // POW[0]
            7'h20: read_mux = w_pow[0][ 7:0];
            7'h21: read_mux = w_pow[0][15:8];
            // POW[1]
            7'h22: read_mux = w_pow[1][ 7:0];
            7'h23: read_mux = w_pow[1][15:8];
            // POW[2]
            7'h24: read_mux = w_pow[2][ 7:0];
            7'h25: read_mux = w_pow[2][15:8];
            // POW[3]
            7'h26: read_mux = w_pow[3][ 7:0];
            7'h27: read_mux = w_pow[3][15:8];
            // AMP[0]
            7'h30: read_mux = w_amp[0][ 7:0];
            7'h31: read_mux = w_amp[0][15:8];
            // AMP[1]
            7'h32: read_mux = w_amp[1][ 7:0];
            7'h33: read_mux = w_amp[1][15:8];
            // AMP[2]
            7'h34: read_mux = w_amp[2][ 7:0];
            7'h35: read_mux = w_amp[2][15:8];
            // AMP[3]
            7'h36: read_mux = w_amp[3][ 7:0];
            7'h37: read_mux = w_amp[3][15:8];
            default: read_mux = 8'h00;
        endcase
    end
    endfunction

    assign rdata = read_mux(addr);

endmodule
