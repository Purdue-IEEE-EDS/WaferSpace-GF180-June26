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
//   0x02       CTRL         W    {4'b0, phase_rst_on_launch, auto_restart, mode[1:0]}
//                                 mode=3 selects the fixed test-tone profile
//   0x04-0x07  FTW_A        W    ftw_a[31:0]
//   0x08-0x0B  FTW_B        W    ftw_b[31:0]
//   0x0C-0x0F  FTW_STEP     W    ftw_step[31:0]
//   0x10-0x12  CHIRP_N      W    chirp_n[COUNT_W-1:0]  (3 bytes, upper bits zero)
//                                 whole-vector segment length in fabric blocks
//   0x20...     CAL_DAC[n]   W    one 4-bit shadow word per cell, low nibble only
//                                 address = 0x20 + n, so with 36 cells:
//                                 0x20 -> cell 0, ... 0x43 -> cell 35
//   0x44-0x48  DIRECT_I      W    raw DAC I switch word [35:0], LSB-first bytes
//   0x49-0x4D  DIRECT_Q      W    raw DAC Q switch word [35:0], LSB-first bytes
//   0x4E       DIRECT_CTRL   W    bit[0]=direct_en
//
// SPI front-end format from spi_slave:
//   command byte = {R/W, ADDR[6:0]}
//   write byte   = DATA[7:0]
//
// Example calibration write:
//   command 0x24, data 0x0D  -> write trim code 4'hD into cell 4
//
// SPI readback is intentionally restricted to DEVID. All non-DEVID
// addresses return 0x00.

module dds_regmap #(
    parameter PHASE_W       = 32,
    parameter COUNT_W       = 20,
    parameter DEVID         = 8'hD5,
    parameter DAC_SW_W      = 36,
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

    // register outputs (committed bank)
    output logic [PHASE_W-1:0]  ftw_a,
    output logic [PHASE_W-1:0]  ftw_b,
    output logic [PHASE_W-1:0]  ftw_step,
    output logic [COUNT_W-1:0]  chirp_n,
    output logic [1:0]          mode,
    output logic                auto_restart,
    output logic                phase_rst_on_launch,
    output logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] cal_code,
    output logic                direct_en,
    output logic [DAC_SW_W-1:0] direct_i,
    output logic [DAC_SW_W-1:0] direct_q
);

    localparam logic [6:0] CAL_DAC_BASE_ADDR = 7'h20;
    localparam logic [6:0] DIRECT_I_BASE_ADDR = 7'h44;
    localparam logic [6:0] DIRECT_Q_BASE_ADDR = 7'h49;
    localparam logic [6:0] DIRECT_CTRL_ADDR   = 7'h4E;
    localparam integer DIRECT_TOP_W = DAC_SW_W - 32;

    initial begin
        if (DAC_SW_W < 33 || DAC_SW_W > 40)
            $error("dds_regmap direct DAC register packing assumes 33-40 switch bits, got %0d",
                   DAC_SW_W);
    end

    // ----------------------------------------------------------------
    //  working bank — SPI byte writes (posedge sclk, async rst_n)
    //   - CAL_DAC writes stage one 4-bit word per cell at 0x20 + cell_idx
    //   - only wdata[3:0] is consumed for CAL_DAC writes
    //   - CSn rising snapshots the whole staged frame into cal_code
    //   - io_update later launches that committed frame into the scan chain
    // ----------------------------------------------------------------
    logic [PHASE_W-1:0] w_ftw_a, w_ftw_b, w_ftw_step;
    logic [COUNT_W-1:0] w_chirp_n;
    logic [1:0]         w_mode;
    logic               w_auto_restart;
    logic               w_phase_rst_on_launch;
    logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] w_cal_code;
    logic               w_direct_en;
    logic [DAC_SW_W-1:0] w_direct_i;
    logic [DAC_SW_W-1:0] w_direct_q;
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
            w_direct_en          <= 1'b0;
            w_direct_i           <= {DAC_SW_W{1'b0}};
            w_direct_q           <= {DAC_SW_W{1'b0}};
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
                    DIRECT_I_BASE_ADDR + 7'd0: w_direct_i[7:0]   <= wdata;
                    DIRECT_I_BASE_ADDR + 7'd1: w_direct_i[15:8]  <= wdata;
                    DIRECT_I_BASE_ADDR + 7'd2: w_direct_i[23:16] <= wdata;
                    DIRECT_I_BASE_ADDR + 7'd3: w_direct_i[31:24] <= wdata;
                    DIRECT_I_BASE_ADDR + 7'd4: w_direct_i[DAC_SW_W-1:32] <= wdata[DIRECT_TOP_W-1:0];
                    DIRECT_Q_BASE_ADDR + 7'd0: w_direct_q[7:0]   <= wdata;
                    DIRECT_Q_BASE_ADDR + 7'd1: w_direct_q[15:8]  <= wdata;
                    DIRECT_Q_BASE_ADDR + 7'd2: w_direct_q[23:16] <= wdata;
                    DIRECT_Q_BASE_ADDR + 7'd3: w_direct_q[31:24] <= wdata;
                    DIRECT_Q_BASE_ADDR + 7'd4: w_direct_q[DAC_SW_W-1:32] <= wdata[DIRECT_TOP_W-1:0];
                    DIRECT_CTRL_ADDR: w_direct_en <= wdata[0];
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
            direct_en          <= 1'b0;
            direct_i           <= {DAC_SW_W{1'b0}};
            direct_q           <= {DAC_SW_W{1'b0}};
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
            direct_en          <= w_direct_en;
            direct_i           <= w_direct_i;
            direct_q           <= w_direct_q;
        end
    end

    assign rdata = (addr == 7'h00) ? DEVID[7:0] : 8'h00;

endmodule

`default_nettype wire
