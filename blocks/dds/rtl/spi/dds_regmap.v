`default_nettype none
`timescale 1ns/1ps

// Shared SPI register map. Lives in the SCLK domain.
//
// Working bank (SPI writes) -> committed bank (CSn snapshot).
// Only committed outputs are exposed to the rest of the chip.
//
// rst_n:  Power-on async reset for both working and committed banks.
//         rst_n is CLK-domain but held for many microseconds at power-up,
//         so it is safe as an async reset on SCLK-domain flops.
//
// Address map (little-endian byte order):
//   0x00       DEVID          R    hardcoded
//   0x01       CTRL           W    {4'b0, dds_phase_rst_on_launch,
//                                      dds_auto_restart, dds_mode[1:0]}
//   0x02-0x05  FTW_A          W    dds_ftw_a[31:0]
//   0x06-0x09  FTW_B          W    dds_ftw_b[31:0]
//   0x0A-0x0D  FTW_STEP       W    dds_ftw_step[31:0]
//   0x0E-0x10  CHIRP_N        W    dds_chirp_n[COUNT_W-1:0] (3-byte window)
//   0x11-0x15  DIRECT_I       W    raw DAC I switch word, LSB-first bytes
//   0x16-0x1A  DIRECT_Q       W    raw DAC Q switch word, LSB-first bytes
//   0x1B       DIRECT_CTRL    W    bit[0]=dds_direct_en
//   0x1C...    CAL_DAC[n]     W    one 4-bit shadow word per cell
//                                   address = 0x1C + n, low nibble only
//   0x40-0x41  PLL_CFG        W    packed PLL config:
//                                   [2:0]   dds_spi_clk
//                                   [5:3]   pll_config[5:3]  (FFT clock select)
//                                   [8:6]   pll_config[8:6]  (ADC clock select)
//                                   [9]     pll_clk
//                                   [10]    pll_config[10]   (FFT data source)
//                                   [15:11] reserved
//
// SPI front-end format from spi_slave:
//   command byte = {R/W, ADDR[6:0]}
//   write byte   = DATA[7:0]
//
// SPI readback is intentionally restricted to DEVID. All non-DEVID
// addresses return 0x00.

module dds_regmap #(
    parameter PHASE_W         = 32,
    parameter COUNT_W         = 20,
    parameter DEVID           = 8'hD5,
    parameter DAC_SW_W        = 36,
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

    // DDS outputs (committed bank)
    output logic [2:0]          dds_spi_clk,
    output logic [PHASE_W-1:0]  dds_ftw_a,
    output logic [PHASE_W-1:0]  dds_ftw_b,
    output logic [PHASE_W-1:0]  dds_ftw_step,
    output logic [COUNT_W-1:0]  dds_chirp_n,
    output logic [1:0]          dds_mode,
    output logic                dds_auto_restart,
    output logic                dds_phase_rst_on_launch,
    output logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] dds_cal_code,
    output logic                dds_direct_en,
    output logic [DAC_SW_W-1:0] dds_direct_i,
    output logic [DAC_SW_W-1:0] dds_direct_q,

    // PLL/config outputs decoded from PLL_CFG.
    output logic                pll_clk,
    output logic [10:0]         pll_config
);

    // ----------------------------------------------------------------
    // Address constants. Keep this block aligned with REGMAP.md.
    //
    // Fixed registers get one constant per byte so the write decode below
    // reads directly as "address -> field bits".
    // ----------------------------------------------------------------
    localparam logic [6:0] ADDR_DEVID          = 7'h00;

    localparam logic [6:0] ADDR_CTRL           = 7'h01; // CTRL[3:0]

    localparam logic [6:0] ADDR_FTW_A_0        = 7'h02; // dds_ftw_a[7:0]
    localparam logic [6:0] ADDR_FTW_A_1        = 7'h03; // dds_ftw_a[15:8]
    localparam logic [6:0] ADDR_FTW_A_2        = 7'h04; // dds_ftw_a[23:16]
    localparam logic [6:0] ADDR_FTW_A_3        = 7'h05; // dds_ftw_a[31:24]

    localparam logic [6:0] ADDR_FTW_B_0        = 7'h06; // dds_ftw_b[7:0]
    localparam logic [6:0] ADDR_FTW_B_1        = 7'h07; // dds_ftw_b[15:8]
    localparam logic [6:0] ADDR_FTW_B_2        = 7'h08; // dds_ftw_b[23:16]
    localparam logic [6:0] ADDR_FTW_B_3        = 7'h09; // dds_ftw_b[31:24]

    localparam logic [6:0] ADDR_FTW_STEP_0     = 7'h0A; // dds_ftw_step[7:0]
    localparam logic [6:0] ADDR_FTW_STEP_1     = 7'h0B; // dds_ftw_step[15:8]
    localparam logic [6:0] ADDR_FTW_STEP_2     = 7'h0C; // dds_ftw_step[23:16]
    localparam logic [6:0] ADDR_FTW_STEP_3     = 7'h0D; // dds_ftw_step[31:24]

    localparam logic [6:0] ADDR_CHIRP_N_0      = 7'h0E; // dds_chirp_n[7:0]
    localparam logic [6:0] ADDR_CHIRP_N_1      = 7'h0F; // dds_chirp_n[15:8]
    localparam logic [6:0] ADDR_CHIRP_N_2      = 7'h10; // dds_chirp_n[COUNT_W-1:16]

    localparam logic [6:0] ADDR_DIRECT_I_0     = 7'h11; // dds_direct_i[7:0]
    localparam logic [6:0] ADDR_DIRECT_I_1     = 7'h12; // dds_direct_i[15:8]
    localparam logic [6:0] ADDR_DIRECT_I_2     = 7'h13; // dds_direct_i[23:16]
    localparam logic [6:0] ADDR_DIRECT_I_3     = 7'h14; // dds_direct_i[31:24]
    localparam logic [6:0] ADDR_DIRECT_I_4     = 7'h15; // dds_direct_i[DAC_SW_W-1:32]

    localparam logic [6:0] ADDR_DIRECT_Q_0     = 7'h16; // dds_direct_q[7:0]
    localparam logic [6:0] ADDR_DIRECT_Q_1     = 7'h17; // dds_direct_q[15:8]
    localparam logic [6:0] ADDR_DIRECT_Q_2     = 7'h18; // dds_direct_q[23:16]
    localparam logic [6:0] ADDR_DIRECT_Q_3     = 7'h19; // dds_direct_q[31:24]
    localparam logic [6:0] ADDR_DIRECT_Q_4     = 7'h1A; // dds_direct_q[DAC_SW_W-1:32]

    localparam logic [6:0] ADDR_DIRECT_CTRL    = 7'h1B; // dds_direct_en

    localparam logic [6:0] ADDR_CAL_DAC_BASE   = 7'h1C; // CAL_DAC[0]
    localparam logic [6:0] ADDR_CAL_DAC_LAST   = 7'h3F; // CAL_DAC[35]

    localparam logic [6:0] ADDR_PLL_CFG_0      = 7'h40; // DDS/FFT select, ADC select low bits
    localparam logic [6:0] ADDR_PLL_CFG_1      = 7'h41; // ADC select msb, clock/data source

    localparam integer DIRECT_TOP_W  = DAC_SW_W - 32;
    localparam integer CHIRP_N_TOP_W = COUNT_W - 16;
    localparam logic [7:0]  CTRL_RESET        = 8'h00;
    localparam logic [7:0]  DIRECT_CTRL_RESET = 8'h00;
    localparam logic [15:0] PLL_CFG_RESET     = 16'h0400; // pll_config[10] reset = 1

    initial begin
        if (PHASE_W != 32)
            $error("dds_regmap v2 address map assumes 32-bit FTW registers, got PHASE_W=%0d",
                   PHASE_W);

        if (COUNT_W < 17 || COUNT_W > 24)
            $error("dds_regmap v2 CHIRP_N packing assumes 17-24 bits, got COUNT_W=%0d",
                   COUNT_W);

        if (DAC_SW_W < 33 || DAC_SW_W > 40)
            $error("dds_regmap direct DAC packing assumes 33-40 switch bits, got DAC_SW_W=%0d",
                   DAC_SW_W);

        if (CAL_DAC_CELL_W != 4)
            $error("dds_regmap CAL_DAC map assumes 4-bit cells, got CAL_DAC_CELL_W=%0d",
                   CAL_DAC_CELL_W);

        if (CAL_DAC_N_CELLS > 36)
            $error("dds_regmap CAL_DAC window 0x1C-0x3F fits at most 36 cells, got %0d",
                   CAL_DAC_N_CELLS);
    end

    // ----------------------------------------------------------------
    // Working bank: byte writes from SPI land here immediately.
    // Packed control registers are kept packed internally, then decoded
    // into named committed ports below.
    // ----------------------------------------------------------------
    logic [PHASE_W-1:0]  w_ftw_a, w_ftw_b, w_ftw_step;
    logic [COUNT_W-1:0]  w_chirp_n;
    logic [7:0]          w_ctrl;
    logic [CAL_DAC_N_CELLS*CAL_DAC_CELL_W-1:0] w_cal_code;
    logic [7:0]          w_direct_ctrl;
    logic [DAC_SW_W-1:0] w_direct_i;
    logic [DAC_SW_W-1:0] w_direct_q;
    logic [15:0]         w_pll_cfg;
    integer              idx;

    always_ff @(posedge sclk or negedge rst_n) begin
        if (!rst_n) begin
            w_ftw_a        <= {PHASE_W{1'b0}};
            w_ftw_b        <= {PHASE_W{1'b0}};
            w_ftw_step     <= {PHASE_W{1'b0}};
            w_chirp_n      <= {COUNT_W{1'b0}};
            w_ctrl         <= CTRL_RESET;
            w_direct_ctrl  <= DIRECT_CTRL_RESET;
            w_direct_i     <= {DAC_SW_W{1'b0}};
            w_direct_q     <= {DAC_SW_W{1'b0}};
            w_pll_cfg      <= PLL_CFG_RESET;

            for (idx = 0; idx < CAL_DAC_N_CELLS; idx = idx + 1)
                w_cal_code[(idx*CAL_DAC_CELL_W) +: CAL_DAC_CELL_W] <= CAL_DAC_RESET_CODE;
        end else if (wr_en) begin
            case (addr)
                // ----------------------------------------------------
                // DDS profile/control registers
                // ----------------------------------------------------
                ADDR_CTRL: begin
                    w_ctrl <= {4'b0000, wdata[3:0]};
                end

                ADDR_FTW_A_0:    w_ftw_a[ 7: 0] <= wdata;
                ADDR_FTW_A_1:    w_ftw_a[15: 8] <= wdata;
                ADDR_FTW_A_2:    w_ftw_a[23:16] <= wdata;
                ADDR_FTW_A_3:    w_ftw_a[31:24] <= wdata;

                ADDR_FTW_B_0:    w_ftw_b[ 7: 0] <= wdata;
                ADDR_FTW_B_1:    w_ftw_b[15: 8] <= wdata;
                ADDR_FTW_B_2:    w_ftw_b[23:16] <= wdata;
                ADDR_FTW_B_3:    w_ftw_b[31:24] <= wdata;

                ADDR_FTW_STEP_0: w_ftw_step[ 7: 0] <= wdata;
                ADDR_FTW_STEP_1: w_ftw_step[15: 8] <= wdata;
                ADDR_FTW_STEP_2: w_ftw_step[23:16] <= wdata;
                ADDR_FTW_STEP_3: w_ftw_step[31:24] <= wdata;

                ADDR_CHIRP_N_0:  w_chirp_n[ 7: 0] <= wdata;
                ADDR_CHIRP_N_1:  w_chirp_n[15: 8] <= wdata;
                ADDR_CHIRP_N_2:  w_chirp_n[COUNT_W-1:16] <= wdata[CHIRP_N_TOP_W-1:0];

                // ----------------------------------------------------
                // Direct DAC bypass registers
                // ----------------------------------------------------
                ADDR_DIRECT_I_0:  w_direct_i[ 7: 0] <= wdata;
                ADDR_DIRECT_I_1:  w_direct_i[15: 8] <= wdata;
                ADDR_DIRECT_I_2:  w_direct_i[23:16] <= wdata;
                ADDR_DIRECT_I_3:  w_direct_i[31:24] <= wdata;
                ADDR_DIRECT_I_4:  w_direct_i[DAC_SW_W-1:32] <= wdata[DIRECT_TOP_W-1:0];

                ADDR_DIRECT_Q_0:  w_direct_q[ 7: 0] <= wdata;
                ADDR_DIRECT_Q_1:  w_direct_q[15: 8] <= wdata;
                ADDR_DIRECT_Q_2:  w_direct_q[23:16] <= wdata;
                ADDR_DIRECT_Q_3:  w_direct_q[31:24] <= wdata;
                ADDR_DIRECT_Q_4:  w_direct_q[DAC_SW_W-1:32] <= wdata[DIRECT_TOP_W-1:0];

                ADDR_DIRECT_CTRL: w_direct_ctrl <= {7'b0000000, wdata[0]};

                // ----------------------------------------------------
                // PLL window. PLL_CFG is one packed register, but each
                // field still exits this module as a named port.
                // ----------------------------------------------------
                // 0x40:
                //   wdata[2:0] = dds_spi_clk
                //   wdata[5:3] = pll_config[5:3]
                //   wdata[7:6] = pll_config[7:6]
                ADDR_PLL_CFG_0: begin
                    w_pll_cfg[7:0] <= wdata;
                end

                // 0x41:
                //   wdata[0] = pll_config[8]
                //   wdata[1] = pll_clk / pll_config[9]
                //   wdata[2] = pll_config[10]
                //   wdata[7:3] ignored/reserved
                ADDR_PLL_CFG_1: begin
                    w_pll_cfg[15:8] <= {5'b00000, wdata[2:0]};
                end

                default: begin
                    if (addr >= ADDR_CAL_DAC_BASE &&
                        addr <= ADDR_CAL_DAC_LAST &&
                        addr <  ADDR_CAL_DAC_BASE + CAL_DAC_N_CELLS) begin
                        w_cal_code[((addr - ADDR_CAL_DAC_BASE) * CAL_DAC_CELL_W) +: CAL_DAC_CELL_W] <=
                            wdata[CAL_DAC_CELL_W-1:0];
                    end
                end
            endcase
        end
    end

    // ----------------------------------------------------------------
    // Committed bank: CSn rising snapshots a complete SPI frame.
    // ----------------------------------------------------------------
    logic [7:0]  ctrl_q;
    logic [7:0]  direct_ctrl_q;
    logic [15:0] pll_cfg_q;

    always_ff @(posedge csn or negedge rst_n) begin
        if (!rst_n) begin
            dds_ftw_a     <= {PHASE_W{1'b0}};
            dds_ftw_b     <= {PHASE_W{1'b0}};
            dds_ftw_step  <= {PHASE_W{1'b0}};
            dds_chirp_n   <= {COUNT_W{1'b0}};
            ctrl_q        <= CTRL_RESET;
            direct_ctrl_q <= DIRECT_CTRL_RESET;
            dds_direct_i  <= {DAC_SW_W{1'b0}};
            dds_direct_q  <= {DAC_SW_W{1'b0}};
            pll_cfg_q     <= PLL_CFG_RESET;

            for (idx = 0; idx < CAL_DAC_N_CELLS; idx = idx + 1)
                dds_cal_code[(idx*CAL_DAC_CELL_W) +: CAL_DAC_CELL_W] <= CAL_DAC_RESET_CODE;
        end else begin
            dds_ftw_a     <= w_ftw_a;
            dds_ftw_b     <= w_ftw_b;
            dds_ftw_step  <= w_ftw_step;
            dds_chirp_n   <= w_chirp_n;
            ctrl_q        <= w_ctrl;
            dds_cal_code  <= w_cal_code;
            direct_ctrl_q <= w_direct_ctrl;
            dds_direct_i  <= w_direct_i;
            dds_direct_q  <= w_direct_q;
            pll_cfg_q     <= w_pll_cfg;
        end
    end

    // ----------------------------------------------------------------
    // Named field decode from committed packed registers.
    // ----------------------------------------------------------------
    assign dds_mode                = ctrl_q[1:0];
    assign dds_auto_restart        = ctrl_q[2];
    assign dds_phase_rst_on_launch = ctrl_q[3];

    assign dds_direct_en = direct_ctrl_q[0];

    assign dds_spi_clk = pll_cfg_q[2:0];
    assign pll_clk     = pll_cfg_q[9];
    assign pll_config = pll_cfg_q[10:0];

    assign rdata = (addr == ADDR_DEVID) ? DEVID[7:0] : 8'h00;

endmodule

`default_nettype wire
