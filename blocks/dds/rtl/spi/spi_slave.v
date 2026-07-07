`default_nettype none
`timescale 1ns/1ps

// Adapted from charkster/spi_slave_verilog (BSD-2-Clause).
// SPI byte engine plus chip register map wrapper.
//
// SPI Mode 0 (CPOL=0, CPHA=0). All logic in SCLK domain.
// CSn high = async reset (slave deselected).
//
// Protocol: command byte {R/W, ADDR[6:0]}, then N data bytes.
// Address auto-increments after each data byte.
// Write: R/W=0. Read: R/W=1, MISO returns rdata MSB-first.
//
// spi_slave is the chip-facing block: SPI pins in, decoded register
// bundles out. spi_slave_core is the protocol-only byte-addressed local
// bus engine kept separate so the shifter/addressing behavior stays easy
// to test.

module spi_slave #(
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
    input  logic        mosi,
    output logic        miso,

    // DDS bundle from the SPI register map.
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

    // PLL bundle from the SPI register map.
    output logic                pll_clk,
    output logic [10:0]         pll_config
);

    logic        wr_en;
    logic        rd_en;
    logic [6:0]  addr;
    logic [7:0]  wdata;
    logic [7:0]  rdata;

    spi_slave_core u_core (
        .sclk  (sclk),
        .csn   (csn),
        .mosi  (mosi),
        .miso  (miso),
        .wr_en (wr_en),
        .rd_en (rd_en),
        .addr  (addr),
        .wdata (wdata),
        .rdata (rdata)
    );

    dds_regmap #(
        .PHASE_W            (PHASE_W),
        .COUNT_W            (COUNT_W),
        .DEVID              (DEVID),
        .DAC_SW_W           (DAC_SW_W),
        .CAL_DAC_N_CELLS    (CAL_DAC_N_CELLS),
        .CAL_DAC_CELL_W     (CAL_DAC_CELL_W),
        .CAL_DAC_RESET_CODE (CAL_DAC_RESET_CODE)
    ) u_regmap (
        .sclk                (sclk),
        .csn                 (csn),
        .rst_n               (rst_n),
        .wr_en               (wr_en),
        .addr                (addr),
        .wdata               (wdata),
        .rdata               (rdata),
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

endmodule

// wr_en and wdata are combinational — the external register file
// must sample them on posedge sclk. addr is registered and holds
// the correct (pre-increment) value when wr_en is high.
module spi_slave_core (
    input  logic       sclk,
    input  logic       csn,
    input  logic       mosi,
    output logic       miso,

    output logic       wr_en,
    output logic       rd_en,
    output logic [6:0] addr,
    output logic [7:0] wdata,
    input  logic [7:0] rdata
);

    logic [6:0] mosi_buf;
    logic [2:0] bit_cnt;
    logic       cmd_done;
    logic       read_cycle;
    logic       write_cycle;
    logic       miso_shift;

    // ----------------------------------------------------------------
    //  MOSI shift register (last 7 bits)
    // ----------------------------------------------------------------

    always_ff @(posedge sclk or posedge csn) begin
        if (csn) mosi_buf <= 7'd0;
        else     mosi_buf <= {mosi_buf[5:0], mosi};
    end

    // ----------------------------------------------------------------
    //  bit counter — free-running 0-7
    // ----------------------------------------------------------------

    always_ff @(posedge sclk or posedge csn) begin
        if (csn) bit_cnt <= 3'd0;
        else     bit_cnt <= bit_cnt + 3'd1;
    end

    // ----------------------------------------------------------------
    //  command phase detection
    // ----------------------------------------------------------------

    always_ff @(posedge sclk or posedge csn) begin
        if (csn)                                cmd_done <= 1'b0;
        else if (bit_cnt == 3'd7 && !cmd_done)  cmd_done <= 1'b1;
    end

    // R/W decode: mosi_buf[6] = MSB of command byte = R/W bit
    always_ff @(posedge sclk or posedge csn) begin
        if (csn)                                               read_cycle <= 1'b0;
        else if (bit_cnt == 3'd7 && !cmd_done && mosi_buf[6])  read_cycle <= 1'b1;
    end

    always_ff @(posedge sclk or posedge csn) begin
        if (csn)                                                write_cycle <= 1'b0;
        else if (bit_cnt == 3'd7 && !cmd_done && !mosi_buf[6]) write_cycle <= 1'b1;
    end

    // ----------------------------------------------------------------
    //  address register
    // ----------------------------------------------------------------
    //  Latch from command byte on first byte boundary.
    //  Auto-increment on subsequent byte boundaries (both R and W).
    //  Increment is nonblocking — reg_file sees pre-increment addr
    //  on the same posedge where combinational wr_en is high.

    always_ff @(posedge sclk or posedge csn) begin
        if (csn)
            addr <= 7'd0;
        else if (bit_cnt == 3'd7) begin
            if (!cmd_done)
                addr <= {mosi_buf[5:0], mosi};
            else
                addr <= addr + 7'd1;
        end
    end

    // ----------------------------------------------------------------
    //  write enable + write data (combinational)
    // ----------------------------------------------------------------

    assign wr_en = write_cycle & cmd_done & (bit_cnt == 3'd7);
    assign wdata = {mosi_buf[6:0], mosi};

    // ----------------------------------------------------------------
    //  read enable
    // ----------------------------------------------------------------

    assign rd_en = read_cycle;

    // ----------------------------------------------------------------
    //  MISO — driven on negedge, MSB first
    // ----------------------------------------------------------------

    always_ff @(negedge sclk or posedge csn) begin
        if (csn)             miso_shift <= 1'b0;
        else if (read_cycle) miso_shift <= rdata[7 - bit_cnt];
        else                 miso_shift <= 1'b0;
    end

    assign miso = miso_shift;

endmodule
