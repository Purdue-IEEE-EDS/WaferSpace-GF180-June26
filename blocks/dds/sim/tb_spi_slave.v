`default_nettype none
`timescale 1ns/1ps

module tb_spi_slave;

    localparam HP = 50;   // SCLK half-period (10 MHz)

    // ----------------------------------------------------------------
    //  DUT signals
    // ----------------------------------------------------------------

    reg        sclk, csn, mosi;
    wire       miso;
    wire       wr_en, rd_en;
    wire [6:0] addr;
    wire [7:0] wdata;
    reg  [7:0] rdata;

    spi_slave dut (
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

    // ----------------------------------------------------------------
    //  simple register file (TB-side stand-in)
    // ----------------------------------------------------------------

    reg [7:0] mem [0:127];
    integer k;

    always @(*) rdata = mem[addr];

    always @(posedge sclk)
        if (wr_en) mem[addr] <= wdata;

    // ----------------------------------------------------------------
    //  pass / fail tracking
    // ----------------------------------------------------------------

    integer pass_n, fail_n;
    integer i;

    task check(input [255:0] label, input integer got, input integer exp);
    begin
        if (got === exp) begin
            $display("  PASS: %0s", label);
            pass_n = pass_n + 1;
        end else begin
            $display("  FAIL: %0s — got %0d (0x%0h), expected %0d (0x%0h)",
                     label, got, got, exp, exp);
            fail_n = fail_n + 1;
        end
    end
    endtask

    // ----------------------------------------------------------------
    //  SPI master model
    // ----------------------------------------------------------------

    reg [7:0] rx_byte;

    task send_byte(input [7:0] val);
        integer b;
    begin
        for (b = 7; b >= 0; b = b - 1) begin
            mosi = val[b];
            #HP; sclk = 1;
            #HP; sclk = 0;
        end
    end
    endtask

    task recv_byte;
        integer b;
    begin
        rx_byte = 8'd0;
        for (b = 7; b >= 0; b = b - 1) begin
            mosi = 1'b0;
            #HP; sclk = 1;
            #1;  rx_byte[b] = miso;
            #(HP-1); sclk = 0;
        end
    end
    endtask

    task spi_write(input [6:0] a, input [7:0] d);
    begin
        csn = 0; #HP;
        send_byte({1'b0, a});
        send_byte(d);
        #HP; csn = 1; #HP;
    end
    endtask

    task spi_read(input [6:0] a);
    begin
        csn = 0; #HP;
        send_byte({1'b1, a});
        recv_byte;
        #HP; csn = 1; #HP;
    end
    endtask

    // burst write: sends n bytes from tx_buf starting at address a
    reg [7:0] tx_buf [0:15];

    task spi_write_burst(input [6:0] a, input integer n);
        integer j;
    begin
        csn = 0; #HP;
        send_byte({1'b0, a});
        for (j = 0; j < n; j = j + 1)
            send_byte(tx_buf[j]);
        #HP; csn = 1; #HP;
    end
    endtask

    // burst read: receives n bytes into rx_buf starting at address a
    reg [7:0] rx_buf [0:15];

    task spi_read_burst(input [6:0] a, input integer n);
        integer j;
    begin
        csn = 0; #HP;
        send_byte({1'b1, a});
        for (j = 0; j < n; j = j + 1) begin
            recv_byte;
            rx_buf[j] = rx_byte;
        end
        #HP; csn = 1; #HP;
    end
    endtask

    // ----------------------------------------------------------------
    //  test sequence
    // ----------------------------------------------------------------

    initial begin
        $dumpfile("tb_spi_slave.vcd");
        $dumpvars(0, tb_spi_slave);
        pass_n = 0; fail_n = 0;

        sclk = 0; csn = 1; mosi = 0;
        for (k = 0; k < 128; k = k + 1) mem[k] = 8'd0;
        #(HP*4);

        // ========================================================
        //  1. Single byte write
        // ========================================================
        begin
            $display("\n=== 1. Single byte write ===");
            spi_write(7'h10, 8'hA5);
            check("mem[0x10] == 0xA5", mem[8'h10], 8'hA5);
        end

        // ========================================================
        //  2. Single byte read
        // ========================================================
        begin
            $display("\n=== 2. Single byte read ===");
            mem[8'h20] = 8'h5A;
            spi_read(7'h20);
            check("read 0x20 == 0x5A", rx_byte, 8'h5A);
        end

        // ========================================================
        //  3. Write-read roundtrip
        // ========================================================
        begin
            $display("\n=== 3. Write-read roundtrip ===");
            spi_write(7'h04, 8'hDE);
            spi_read(7'h04);
            check("roundtrip 0x04 == 0xDE", rx_byte, 8'hDE);
        end

        // ========================================================
        //  4. Burst write 4 bytes (simulates FTW_INIT)
        // ========================================================
        begin
            $display("\n=== 4. Burst write 4 bytes ===");
            tx_buf[0] = 8'h12; tx_buf[1] = 8'h34;
            tx_buf[2] = 8'h56; tx_buf[3] = 8'h78;
            spi_write_burst(7'h04, 4);
            check("mem[0x04] == 0x12", mem[8'h04], 8'h12);
            check("mem[0x05] == 0x34", mem[8'h05], 8'h34);
            check("mem[0x06] == 0x56", mem[8'h06], 8'h56);
            check("mem[0x07] == 0x78", mem[8'h07], 8'h78);
        end

        // ========================================================
        //  5. Burst read 4 bytes
        // ========================================================
        begin
            $display("\n=== 5. Burst read 4 bytes ===");
            mem[8'h08] = 8'hAA; mem[8'h09] = 8'hBB;
            mem[8'h0A] = 8'hCC; mem[8'h0B] = 8'hDD;
            spi_read_burst(7'h08, 4);
            check("read[0] == 0xAA", rx_buf[0], 8'hAA);
            check("read[1] == 0xBB", rx_buf[1], 8'hBB);
            check("read[2] == 0xCC", rx_buf[2], 8'hCC);
            check("read[3] == 0xDD", rx_buf[3], 8'hDD);
        end

        // ========================================================
        //  6. Back-to-back transactions (CSn reset between)
        // ========================================================
        begin
            $display("\n=== 6. Back-to-back transactions ===");
            spi_write(7'h30, 8'h11);
            spi_write(7'h31, 8'h22);
            check("mem[0x30] == 0x11", mem[8'h30], 8'h11);
            check("mem[0x31] == 0x22", mem[8'h31], 8'h22);
        end

        // ========================================================
        //  7. Max address (0x7F)
        // ========================================================
        begin
            $display("\n=== 7. Max address 0x7F ===");
            spi_write(7'h7F, 8'hFF);
            check("mem[0x7F] == 0xFF", mem[8'h7F], 8'hFF);
            spi_read(7'h7F);
            check("read 0x7F == 0xFF", rx_byte, 8'hFF);
        end

        // ========================================================
        //  8. Read-only DEVID simulation
        // ========================================================
        begin
            $display("\n=== 8. DEVID read (mem[0x00] pre-loaded) ===");
            mem[8'h00] = 8'hD5;
            spi_read(7'h00);
            check("read 0x00 == 0xD5", rx_byte, 8'hD5);
        end

        // ========================================================
        //  9. Write does not corrupt adjacent bytes
        // ========================================================
        begin
            $display("\n=== 9. Write isolation ===");
            for (k = 0; k < 128; k = k + 1) mem[k] = 8'd0;
            spi_write(7'h40, 8'hBE);
            check("mem[0x3F] == 0x00", mem[8'h3F], 8'h00);
            check("mem[0x40] == 0xBE", mem[8'h40], 8'hBE);
            check("mem[0x41] == 0x00", mem[8'h41], 8'h00);
        end

        // ========================================================
        //  10. Burst write then burst read-back
        // ========================================================
        begin
            $display("\n=== 10. Burst write + read-back ===");
            tx_buf[0] = 8'hCA; tx_buf[1] = 8'hFE;
            tx_buf[2] = 8'hBA; tx_buf[3] = 8'hBE;
            spi_write_burst(7'h50, 4);
            spi_read_burst(7'h50, 4);
            check("roundtrip[0] == 0xCA", rx_buf[0], 8'hCA);
            check("roundtrip[1] == 0xFE", rx_buf[1], 8'hFE);
            check("roundtrip[2] == 0xBA", rx_buf[2], 8'hBA);
            check("roundtrip[3] == 0xBE", rx_buf[3], 8'hBE);
        end

        // ========================================================
        //  11. All-zeros and all-ones data
        // ========================================================
        begin
            $display("\n=== 11. All-zeros and all-ones ===");
            spi_write(7'h60, 8'h00);
            spi_read(7'h60);
            check("read 0x00 data", rx_byte, 8'h00);
            spi_write(7'h61, 8'hFF);
            spi_read(7'h61);
            check("read 0xFF data", rx_byte, 8'hFF);
        end

        // ========================================================
        //  12. Address auto-increment wraps (burst across 0x7F)
        // ========================================================
        begin
            $display("\n=== 12. Address wrap on burst ===");
            tx_buf[0] = 8'hAA; tx_buf[1] = 8'hBB;
            spi_write_burst(7'h7F, 2);
            check("mem[0x7F] == 0xAA", mem[8'h7F], 8'hAA);
            // addr wraps to 0x00 (7-bit)
            check("mem[0x00] after wrap == 0xBB", mem[8'h00], 8'hBB);
        end

        // ========================================================
        //  summary
        // ========================================================

        $display("\n============================================");
        $display("  %0d passed, %0d failed", pass_n, fail_n);
        $display("============================================\n");
        if (fail_n == 0)
            $display("  ALL TESTS PASSED\n");
        else
            $display("  *** FAILURES DETECTED ***\n");
        $finish;
    end

endmodule
