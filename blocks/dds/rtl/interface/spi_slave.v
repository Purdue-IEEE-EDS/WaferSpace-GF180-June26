`default_nettype none
`timescale 1ns/1ps

// Adapted from charkster/spi_slave_verilog (BSD-2-Clause).
// SPI slave with byte-addressable local bus.
//
// SPI Mode 0 (CPOL=0, CPHA=0). All logic in SCLK domain.
// CSn high = async reset (slave deselected).
//
// Protocol: command byte {R/W, ADDR[6:0]}, then N data bytes.
// Address auto-increments after each data byte.
// Write: R/W=0. Read: R/W=1, MISO returns rdata MSB-first.
//
// wr_en and wdata are combinational — the external register file
// must sample them on posedge sclk. addr is registered and holds
// the correct (pre-increment) value when wr_en is high.
module spi_slave (
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
