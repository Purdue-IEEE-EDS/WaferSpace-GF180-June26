`default_nettype none
`timescale 1ns/1ps

// Top-level calibration E2E.
//
// Scope:
//   - Drives only dds_top pins.
//   - Uses SPI writes plus io_update to program calibration state.
//   - SPI readback is used only for DEVID and zero-on-other-address checks.
//   - Starts from power-up reset.
module tb_cal_dac_spi;

    localparam int PHASE_W        = 32;
    localparam int SINE_TRUNC_W   = 14;
    localparam int SINE_COARSE_W  = 7;
    localparam int SINE_GUARD_W   = 3;
    localparam int UNARY_BITS     = 5;
    localparam int BINARY_BITS    = 5;
    localparam int COUNT_W        = 20;
    localparam int CAL_CELLS      = 36;
    localparam int CAL_CELL_W     = 4;
    localparam int CAL_BASE       = 7'h1C;
    localparam logic [7:0] DEVID = 8'hD5;
    localparam logic [CAL_CELL_W-1:0] MID = 4'b1000;

    localparam real CLK_P  = 3.2;
    localparam real SCLK_P = 20.0;

    logic clk = 1'b0;
    logic rst_n;
    logic sclk, csn, mosi, miso;
    logic io_update, sync_in;
    logic [35:0] dac_i, dac_q;
    logic [2:0] dds_spi_clk;
    logic [PHASE_W-1:0] dds_ftw_a, dds_ftw_b, dds_ftw_step;
    logic [COUNT_W-1:0] dds_chirp_n;
    logic [1:0] dds_mode;
    logic dds_auto_restart;
    logic dds_phase_rst_on_launch;
    logic [CAL_CELLS*CAL_CELL_W-1:0] dds_cal_code;
    logic dds_direct_en;
    logic [35:0] dds_direct_i, dds_direct_q;
    logic pll_clk;
    logic [10:0] pll_config;

    int pass_n = 0;
    int fail_n = 0;

    always #(CLK_P/2) clk = ~clk;

    spi_slave #(
        .PHASE_W            (PHASE_W),
        .COUNT_W            (COUNT_W),
        .DAC_SW_W           (36),
        .CAL_DAC_N_CELLS    (CAL_CELLS),
        .CAL_DAC_CELL_W     (CAL_CELL_W)
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
        .PHASE_W         (PHASE_W),
        .SINE_TRUNC_W    (SINE_TRUNC_W),
        .SINE_COARSE_W   (SINE_COARSE_W),
        .SINE_GUARD_W    (SINE_GUARD_W),
        .UNARY_BITS      (UNARY_BITS),
        .BINARY_BITS     (BINARY_BITS),
        .COUNT_W         (COUNT_W),
        .CAL_DAC_N_CELLS (CAL_CELLS)
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
        .dac_i                   (dac_i),
        .dac_q                   (dac_q),
        .cal_clk                 (),
        .cal_data                (),
        .cal_load                ()
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

    task automatic expect_committed_code(input int idx, input logic [CAL_CELL_W-1:0] exp,
                                         input string label);
        logic [CAL_CELL_W-1:0] got;
    begin
        got = u_spi.dds_cal_code[(idx * CAL_CELL_W) +: CAL_CELL_W];
        if (got !== exp)
            fail($sformatf("%s: committed %0h exp %0h at cell %0d", label, got, exp, idx));
        else
            pass(label);
    end
    endtask

    task automatic expect_live_code(input int idx, input logic [CAL_CELL_W-1:0] exp,
                                    input string label);
        logic [CAL_CELL_W-1:0] got;
    begin
        got = dut.u_cal_dac_scan.dac_code[(idx * CAL_CELL_W) +: CAL_CELL_W];
        if (got !== exp)
            fail($sformatf("%s: live %0h exp %0h at cell %0d", label, got, exp, idx));
        else
            pass(label);
    end
    endtask

    task automatic wait_busy_seen_and_clear(input string label);
        bit saw_busy;
        int k;
    begin
        saw_busy = 1'b0;
        for (k = 0; k < 1024; k++) begin
            @(posedge dut.clk_cal);
            #1;
            if (dut.cal_busy)
                saw_busy = 1'b1;
            if (saw_busy && !dut.cal_busy) begin
                pass(label);
                return;
            end
        end
        fail($sformatf("%s: busy did not assert and clear", label));
    end
    endtask

    task automatic expect_no_busy_window(input int polls, input string label);
        int k;
    begin
        for (k = 0; k < polls; k++) begin
            @(posedge dut.clk_cal);
            #1;
            if (dut.cal_busy) begin
                fail($sformatf("%s: busy asserted unexpectedly", label));
                return;
            end
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
        sync_in    = 1'b0;

        clk_wait(4);
        rst_n = 1'b1;
        clk_wait(4);

        $display("\n=== 1. Power-up defaults ===");
        spi_read8_expect(7'h00, DEVID, "devid");
        spi_read8_expect(CAL_BASE + 0, 8'h00, "cell0 readback disabled");
        spi_read8_expect(CAL_BASE + 1, 8'h00, "cell1 readback disabled");
        spi_read8_expect(CAL_BASE + 4, 8'h00, "cell4 readback disabled");
        expect_committed_code(0, MID, "cell0 committed reset");
        expect_committed_code(1, MID, "cell1 committed reset");
        expect_committed_code(4, MID, "cell4 committed reset");
        expect_live_code(0, MID, "cell0 live reset");
        expect_live_code(1, MID, "cell1 live reset");
        expect_live_code(4, MID, "cell4 live reset");

        $display("\n=== 2. Writes stage until io_update ===");
        spi_write8(CAL_BASE + 1, 8'h03);
        spi_write8(CAL_BASE + 4, 8'h0D);
        spi_read8_expect(CAL_BASE + 1, 8'h00, "cell1 readback remains disabled");
        spi_read8_expect(CAL_BASE + 4, 8'h00, "cell4 readback remains disabled");
        expect_committed_code(1, 4'h3, "cell1 committed staged");
        expect_committed_code(4, 4'hD, "cell4 committed staged");
        expect_live_code(1, MID, "cell1 live unchanged before apply");
        expect_live_code(4, MID, "cell4 live unchanged before apply");
        expect_no_busy_window(4, "no scan before io_update");

        $display("\n=== 3. io_update launches one apply ===");
        pulse_io_update;
        wait_busy_seen_and_clear("first apply");
        expect_live_code(1, 4'h3, "cell1 live applied");
        expect_live_code(4, 4'hD, "cell4 live applied");

        $display("\n=== 4. Later nth-group update preserves prior groups ===");
        spi_write8(CAL_BASE + 2, 8'h06);
        spi_read8_expect(CAL_BASE + 2, 8'h00, "cell2 readback remains disabled");
        expect_committed_code(1, 4'h3, "cell1 committed preserved");
        expect_committed_code(2, 4'h6, "cell2 committed staged");
        expect_committed_code(4, 4'hD, "cell4 committed preserved");
        expect_live_code(1, 4'h3, "cell1 live preserved");
        expect_live_code(2, MID, "cell2 live unchanged before apply");
        expect_live_code(4, 4'hD, "cell4 live preserved");
        pulse_io_update;
        wait_busy_seen_and_clear("second apply");
        expect_live_code(2, 4'h6, "cell2 live applied");

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
