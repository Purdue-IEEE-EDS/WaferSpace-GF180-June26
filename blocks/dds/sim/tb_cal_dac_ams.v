`default_nettype none
`timescale 1ns/1ps

// Top-level calibration DAC smoke test.
//
// Uses the user-facing path:
//   SPI write -> committed config -> io_update -> cal_busy / pin activity
// and checks that the top-level calibration outputs emit the expected scan
// activity without generating sidecar stimulus files.
module tb_cal_dac_ams;

    localparam int PHASE_W        = 32;
    localparam int SINE_TRUNC_W   = 14;
    localparam int SINE_COARSE_W  = 7;
    localparam int SINE_GUARD_W   = 3;
    localparam int UNARY_BITS     = 5;
    localparam int BINARY_BITS    = 5;
    localparam int COUNT_W        = 20;
    localparam int CAL_CELLS      = 1;
    localparam int CAL_CELL_W     = 4;
    localparam int CAL_BASE       = 7'h20;
    localparam logic [7:0] DEVID = 8'hD5;
    localparam logic [CAL_CELL_W-1:0] MID = 4'b1000;
    localparam logic [CAL_CELL_W-1:0] USER_CODE_A = 4'h3;
    localparam logic [CAL_CELL_W-1:0] USER_CODE_B = 4'hD;

    localparam real CLK_PERIOD_NS     = 2.0;   // 500 MHz top-level clock
    localparam real SCLK_PERIOD_NS    = 20.0;  // 50 MHz SPI clock
    localparam int RESET_IDLE_CYCLES  = 4;
    localparam int HOLD_CYCLES        = 8;
    localparam int EXP_SHIFT_PULSES      = CAL_CELLS * CAL_CELL_W;
    localparam int EXP_LOAD_HIGH_CYCLES  = 2;

    logic clk = 1'b0;
    logic rst_n;
    logic sclk;
    logic csn;
    logic mosi;
    logic miso;
    logic io_update;
    logic sync_in;
    logic [35:0] dac_i;
    logic [35:0] dac_q;
    logic cal_clk;
    logic cal_data;
    logic cal_load;

    int cal_shift_pulses;
    int cal_load_high_cycles;

    always #(CLK_PERIOD_NS / 2.0) clk = ~clk;

    dds_top #(
        .PHASE_W              (PHASE_W),
        .SINE_TRUNC_W         (SINE_TRUNC_W),
        .SINE_COARSE_W        (SINE_COARSE_W),
        .SINE_GUARD_W         (SINE_GUARD_W),
        .UNARY_BITS           (UNARY_BITS),
        .BINARY_BITS          (BINARY_BITS),
        .COUNT_W              (COUNT_W),
        .CAL_DAC_N_CELLS      (CAL_CELLS),
        .CAL_DAC_CELL_W       (CAL_CELL_W),
        .CAL_DAC_SHIFT_CYCLES (2)
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
        .cal_clk      (cal_clk),
        .cal_data     (cal_data),
        .cal_load     (cal_load)
    );

    task automatic expect_committed_code(
        input logic [CAL_CELL_W-1:0] exp,
        input string label
    );
        logic [CAL_CELL_W-1:0] got;
    begin
        got = dut.rf_cal_code[CAL_CELL_W-1:0];
        if (got !== exp)
            $fatal(1, "%s: committed %0h exp %0h", label, got, exp);
    end
    endtask

    task automatic expect_live_code(
        input logic [CAL_CELL_W-1:0] exp,
        input string label
    );
        logic [CAL_CELL_W-1:0] got;
    begin
        got = dut.u_cal_dac_scan.dac_code[CAL_CELL_W-1:0];
        if (got !== exp)
            $fatal(1, "%s: live %0h exp %0h", label, got, exp);
    end
    endtask

    task automatic reset_cal_pin_counters;
    begin
        cal_shift_pulses    = 0;
        cal_load_high_cycles = 0;
    end
    endtask

    task automatic expect_cal_pin_activity(input string label);
    begin
        if (cal_shift_pulses !== EXP_SHIFT_PULSES) begin
            $fatal(1, "%s: cal_clk pulses %0d exp %0d",
                   label, cal_shift_pulses, EXP_SHIFT_PULSES);
        end
        if (cal_load_high_cycles !== EXP_LOAD_HIGH_CYCLES) begin
            $fatal(1, "%s: cal_load high cycles %0d exp %0d",
                   label, cal_load_high_cycles, EXP_LOAD_HIGH_CYCLES);
        end
    end
    endtask

    task automatic expect_no_cal_pin_activity(input string label);
    begin
        if (cal_shift_pulses !== 0 || cal_load_high_cycles !== 0) begin
            $fatal(1, "%s: unexpected pin activity clk=%0d load=%0d",
                   label, cal_shift_pulses, cal_load_high_cycles);
        end
    end
    endtask

    task automatic clk_wait(input int n);
    begin
        repeat (n) @(posedge clk);
        #1;
    end
    endtask

    task automatic cal_wait(input int n);
    begin
        repeat (n) @(posedge dut.clk_cal);
        #1;
    end
    endtask

    task automatic spi_send_byte(input [7:0] b);
        int j;
    begin
        for (j = 7; j >= 0; j--) begin
            mosi = b[j];
            #(SCLK_PERIOD_NS / 2.0);
            sclk = 1'b1;
            #(SCLK_PERIOD_NS / 2.0);
            sclk = 1'b0;
        end
    end
    endtask

    task automatic spi_recv_byte(output [7:0] b);
        int j;
    begin
        b = 8'h00;
        for (j = 7; j >= 0; j--) begin
            #(SCLK_PERIOD_NS / 2.0);
            sclk = 1'b1;
            b[j] = miso;
            #(SCLK_PERIOD_NS / 2.0);
            sclk = 1'b0;
        end
    end
    endtask

    task automatic spi_write8(input [6:0] addr, input [7:0] val);
    begin
        csn = 1'b0;
        #(SCLK_PERIOD_NS / 2.0);
        spi_send_byte({1'b0, addr});
        spi_send_byte(val);
        #(SCLK_PERIOD_NS / 2.0);
        csn = 1'b1;
        #(SCLK_PERIOD_NS);
    end
    endtask

    task automatic spi_read8(input [6:0] addr, output [7:0] val);
    begin
        csn = 1'b0;
        #(SCLK_PERIOD_NS / 2.0);
        spi_send_byte({1'b1, addr});
        spi_recv_byte(val);
        #(SCLK_PERIOD_NS / 2.0);
        csn = 1'b1;
        #(SCLK_PERIOD_NS);
    end
    endtask

    task automatic spi_read8_expect(
        input [6:0] addr,
        input [7:0] exp,
        input string label
    );
        logic [7:0] got;
    begin
        spi_read8(addr, got);
        if (got !== exp)
            $fatal(1, "%s: read %02h exp %02h at %02h", label, got, exp, addr);
    end
    endtask

    task automatic pulse_io_update;
    begin
        io_update = 1'b1;
        #(CLK_PERIOD_NS * 5.0);
        io_update = 1'b0;
        #(CLK_PERIOD_NS * 5.0);
    end
    endtask

    task automatic wait_cal_busy_cycle(input string label);
        bit saw_busy;
        int k;
    begin
        saw_busy = 1'b0;
        for (k = 0; k < 32; k++) begin
            @(posedge dut.clk_cal);
            #1;
            if (cal_clk)
                cal_shift_pulses = cal_shift_pulses + 1;
            if (cal_load)
                cal_load_high_cycles = cal_load_high_cycles + 1;
            if (dut.cal_busy)
                saw_busy = 1'b1;
            if (saw_busy && !dut.cal_busy)
                return;
        end
        $fatal(1, "%s: busy did not assert and clear", label);
    end
    endtask

    task automatic expect_no_cal_busy_window(input int cycles, input string label);
        int k;
    begin
        for (k = 0; k < cycles; k++) begin
            @(posedge dut.clk_cal);
            #1;
            if (dut.cal_busy)
                $fatal(1, "%s: busy asserted unexpectedly", label);
        end
    end
    endtask

    task automatic apply_cal_code(
        input logic [CAL_CELL_W-1:0] next_code,
        input string label
    );
        logic [CAL_CELL_W-1:0] prev_code;
    begin
        prev_code = dut.u_cal_dac_scan.dac_code[CAL_CELL_W-1:0];
        reset_cal_pin_counters();
        spi_write8(CAL_BASE, {4'h0, next_code});
        spi_read8_expect(CAL_BASE, 8'h00, {label, " readback disabled"});
        expect_committed_code(next_code, {label, " committed"});
        expect_live_code(prev_code, {label, " live unchanged before apply"});
        pulse_io_update;
        wait_cal_busy_cycle({label, " apply"});
        expect_cal_pin_activity({label, " pin activity"});
        expect_live_code(next_code, {label, " live applied"});
    end
    endtask

    initial begin
        $dumpfile("tb_cal_dac_ams.vcd");
        $dumpvars(0, tb_cal_dac_ams);

        rst_n            = 1'b0;
        sclk             = 1'b0;
        csn              = 1'b1;
        mosi             = 1'b0;
        io_update        = 1'b0;
        sync_in          = 1'b0;
        cal_shift_pulses     = 0;
        cal_load_high_cycles = 0;

        clk_wait(4);
        rst_n = 1'b1;
        clk_wait(RESET_IDLE_CYCLES);

        spi_read8_expect(7'h00, DEVID, "devid");
        spi_read8_expect(CAL_BASE, 8'h00, "cal readback disabled");
        expect_committed_code(MID, "power-up committed");
        expect_live_code(MID, "power-up live");
        if (cal_clk !== 1'b0 || cal_load !== 1'b0)
            $fatal(1, "power-up cal pins should be idle");

        apply_cal_code(USER_CODE_A, "first trim");
        cal_wait(HOLD_CYCLES);

        apply_cal_code(USER_CODE_B, "trim adjust");
        cal_wait(HOLD_CYCLES);

        reset_cal_pin_counters();
        pulse_io_update;
        expect_no_cal_busy_window(HOLD_CYCLES, "no-op io_update");
        expect_no_cal_pin_activity("no-op io_update");
        cal_wait(HOLD_CYCLES);

        apply_cal_code(MID, "return to midscale");
        cal_wait(HOLD_CYCLES);

        if (cal_data !== MID[CAL_CELL_W-1])
            $fatal(1, "final cal_data=%0b exp %0b", cal_data, MID[CAL_CELL_W-1]);

        $display("ALL TESTS PASSED");
        $finish;
    end

endmodule

`default_nettype wire
