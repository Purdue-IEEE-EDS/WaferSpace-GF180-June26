`default_nettype none
`timescale 1ns/1ps

// Top-level black-box calibration E2E.
//
// Scope:
//   - Drives only dds_top pins.
//   - Uses SPI readback and STATUS polling only.
//   - Starts from power-up reset.
module tb_cal_dac_spi;

    localparam int PHASE_W      = 32;
    localparam int TRUNC_W      = 12;
    localparam int UNARY_BITS   = 5;
    localparam int BINARY_BITS  = 5;
    localparam int COUNT_W      = 20;
    localparam int CAL_CELLS    = 36;
    localparam int CAL_CELL_W   = 4;
    localparam int CAL_BASE     = 7'h20;
    localparam int STATUS_ADDR  = 7'h01;
    localparam logic [CAL_CELL_W-1:0] MID = 4'b1000;

    localparam real CLK_P  = 3.2;
    localparam real SCLK_P = 20.0;

    logic clk = 1'b0;
    logic rst_n;
    logic sclk, csn, mosi, miso;
    logic io_update, start_pin, sync_in;
    logic [35:0] dac_i, dac_q;

    int pass_n = 0;
    int fail_n = 0;

    always #(CLK_P/2) clk = ~clk;

    dds_top #(
        .PHASE_W         (PHASE_W),
        .TRUNC_W         (TRUNC_W),
        .UNARY_BITS      (UNARY_BITS),
        .BINARY_BITS     (BINARY_BITS),
        .COUNT_W         (COUNT_W),
        .CAL_DAC_N_CELLS (CAL_CELLS)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .sclk         (sclk),
        .csn          (csn),
        .mosi         (mosi),
        .miso         (miso),
        .io_update    (io_update),
        .sync_in      (sync_in),
        .dac_i        (dac_i),
        .dac_q        (dac_q),
        .cal_clk      (),
        .cal_data     (),
        .cal_load     ()
    );

    task automatic pass(input string msg);
    begin
        $display("  PASS: %s", msg);
        pass_n++;
    end
    endtask

    task automatic fail(input string msg);
    begin
        $display("  FAIL: %s", msg);
        fail_n++;
    end
    endtask

    task automatic clk_wait(input int n);
    begin
        repeat (n) @(posedge clk);
        #1;
    end
    endtask

    task automatic spi_send_byte(input [7:0] b);
        int j;
    begin
        for (j = 7; j >= 0; j--) begin
            mosi = b[j];
            #(SCLK_P/2);
            sclk = 1'b1;
            #(SCLK_P/2);
            sclk = 1'b0;
        end
    end
    endtask

    task automatic spi_recv_byte(output [7:0] b);
        int j;
    begin
        b = 8'h00;
        for (j = 7; j >= 0; j--) begin
            #(SCLK_P/2);
            sclk = 1'b1;
            b[j] = miso;
            #(SCLK_P/2);
            sclk = 1'b0;
        end
    end
    endtask

    task automatic spi_write8(input [6:0] addr, input [7:0] val);
    begin
        csn = 1'b0; #(SCLK_P/2);
        spi_send_byte({1'b0, addr});
        spi_send_byte(val);
        #(SCLK_P/2);
        csn = 1'b1;
        #(SCLK_P);
    end
    endtask

    task automatic spi_read8(input [6:0] addr, output [7:0] val);
    begin
        csn = 1'b0; #(SCLK_P/2);
        spi_send_byte({1'b1, addr});
        spi_recv_byte(val);
        #(SCLK_P/2);
        csn = 1'b1;
        #(SCLK_P);
    end
    endtask

    task automatic spi_read8_expect(input [6:0] addr, input [7:0] exp, input string label);
        logic [7:0] got;
    begin
        spi_read8(addr, got);
        if (got !== exp)
            fail($sformatf("%s: read %02h exp %02h at %02h", label, got, exp, addr));
        else
            pass(label);
    end
    endtask

    task automatic pulse_io_update;
    begin
        io_update = 1'b1;
        #(CLK_P * 5);
        io_update = 1'b0;
        #(CLK_P * 5);
    end
    endtask

    function automatic bit status_busy(input [7:0] status);
    begin
        return status[2];
    end
    endfunction

    task automatic wait_busy_seen_and_clear(input string label);
        logic [7:0] status;
        bit saw_busy;
        int k;
    begin
        saw_busy = 1'b0;
        for (k = 0; k < 20; k++) begin
            spi_read8(STATUS_ADDR, status);
            if (status_busy(status))
                saw_busy = 1'b1;
            if (saw_busy && !status_busy(status)) begin
                pass(label);
                return;
            end
            clk_wait(4);
        end
        fail($sformatf("%s: busy did not assert and clear", label));
    end
    endtask

    task automatic expect_no_busy_window(input int polls, input string label);
        logic [7:0] status;
        int k;
    begin
        for (k = 0; k < polls; k++) begin
            spi_read8(STATUS_ADDR, status);
            if (status_busy(status)) begin
                fail($sformatf("%s: busy asserted unexpectedly", label));
                return;
            end
            clk_wait(6);
        end
        pass(label);
    end
    endtask

    initial begin
        $dumpfile("tb_cal_dac_spi.vcd");
        $dumpvars(0, tb_cal_dac_spi);

        rst_n      = 1'b0;
        sclk       = 1'b0;
        csn        = 1'b1;
        mosi       = 1'b0;
        io_update  = 1'b0;
        start_pin  = 1'b0;
        sync_in    = 1'b0;

        clk_wait(4);
        rst_n = 1'b1;
        clk_wait(4);

        $display("\n=== 1. Power-up defaults ===");
        spi_read8_expect(STATUS_ADDR, 8'h00, "status reset");
        spi_read8_expect(CAL_BASE + 0, {4'h0, MID}, "cell0 reset shadow");
        spi_read8_expect(CAL_BASE + 1, {4'h0, MID}, "cell1 reset shadow");
        spi_read8_expect(CAL_BASE + 4, {4'h0, MID}, "cell4 reset shadow");

        $display("\n=== 2. Writes stage until io_update ===");
        spi_write8(CAL_BASE + 1, 8'h03);
        spi_write8(CAL_BASE + 4, 8'h0D);
        spi_read8_expect(CAL_BASE + 1, 8'h03, "cell1 staged readback");
        spi_read8_expect(CAL_BASE + 4, 8'h0D, "cell4 staged readback");
        expect_no_busy_window(4, "no scan before io_update");

        $display("\n=== 3. io_update launches one apply ===");
        pulse_io_update;
        wait_busy_seen_and_clear("first apply");
        spi_read8_expect(CAL_BASE + 1, 8'h03, "cell1 retained after apply");
        spi_read8_expect(CAL_BASE + 4, 8'h0D, "cell4 retained after apply");

        $display("\n=== 4. Later nth-group update preserves prior groups ===");
        spi_write8(CAL_BASE + 2, 8'h06);
        spi_read8_expect(CAL_BASE + 1, 8'h03, "cell1 shadow preserved");
        spi_read8_expect(CAL_BASE + 2, 8'h06, "cell2 staged readback");
        spi_read8_expect(CAL_BASE + 4, 8'h0D, "cell4 shadow preserved");
        pulse_io_update;
        wait_busy_seen_and_clear("second apply");

        $display("\n=== 5. io_update with no calibration change does not rescan ===");
        pulse_io_update;
        expect_no_busy_window(8, "no redundant rescan");

        $display("\n========================================");
        if (fail_n == 0)
            $display("ALL TESTS PASSED (%0d checks)", pass_n);
        else
            $display("FAILED: %0d error(s), %0d pass(es)", fail_n, pass_n);
        $display("========================================");
        $finish;
    end

endmodule

`default_nettype wire
