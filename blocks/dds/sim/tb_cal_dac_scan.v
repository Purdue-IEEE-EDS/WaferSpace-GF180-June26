`default_nettype none
`timescale 1ns/1ps

module tb_cal_dac_scan;

    localparam int N_CELLS      = 4;
    localparam int CELL_W       = 4;
    localparam int TOTAL_W      = N_CELLS * CELL_W;
    localparam int SHIFT_CYCLES = 2;
    localparam logic [CELL_W-1:0] MID = 4'b1000;

    localparam logic [TOTAL_W-1:0] MID_FRAME = {N_CELLS{MID}};
    localparam logic [TOTAL_W-1:0] FRAME_A   = {4'h2, 4'hC, 4'h5, 4'h9};
    localparam logic [TOTAL_W-1:0] FRAME_B   = {4'h7, 4'h1, 4'hE, 4'h4};
    localparam logic [TOTAL_W-1:0] FRAME_C   = {4'hD, 4'h3, 4'h0, 4'hA};

    logic clk = 1'b0;
    logic rst_n;
    logic start;
    logic [TOTAL_W-1:0] frame_data;
    logic busy;
    logic [TOTAL_W-1:0] dac_code;

    int pass_n = 0;
    int fail_n = 0;

    always #5 clk = ~clk;

    cal_dac_scan #(
        .N_CELLS      (N_CELLS),
        .CELL_W       (CELL_W),
        .SHIFT_CYCLES (SHIFT_CYCLES),
        .RESET_CODE   (MID)
    ) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (start),
        .frame_data(frame_data),
        .busy      (busy),
        .cal_clk   (),
        .cal_data  (),
        .cal_load  (),
        .dac_code  (dac_code)
    );

    task automatic fail(input string msg);
    begin
        $display("  FAIL: %s", msg);
        fail_n++;
    end
    endtask

    task automatic pass(input string msg);
    begin
        $display("  PASS: %s", msg);
        pass_n++;
    end
    endtask

    task automatic clk_wait(input int n);
    begin
        repeat (n) @(posedge clk);
        #1;
    end
    endtask

    task automatic pulse_start;
    begin
        start = 1'b1;
        @(posedge clk);
        #1;
        start = 1'b0;
    end
    endtask

    task automatic expect_frame(input logic [TOTAL_W-1:0] exp, input string label);
    begin
        if (dac_code !== exp)
            fail($sformatf("%s: got %0h exp %0h", label, dac_code, exp));
        else
            pass(label);
    end
    endtask

    task automatic wait_busy_high(input int max_cycles, input string label);
        int k;
    begin
        for (k = 0; k < max_cycles; k++) begin
            @(posedge clk);
            #1;
            if (busy)
                return;
        end
        fail($sformatf("%s: busy never asserted", label));
    end
    endtask

    task automatic wait_busy_low(input int max_cycles, input string label);
        int k;
    begin
        for (k = 0; k < max_cycles; k++) begin
            @(posedge clk);
            #1;
            if (!busy)
                return;
        end
        fail($sformatf("%s: busy never cleared", label));
    end
    endtask

    task automatic expect_stable_while_busy(
        input logic [TOTAL_W-1:0] exp,
        input string label
    );
        int saw_busy;
    begin
        saw_busy = 0;
        while (busy) begin
            saw_busy = 1;
            if (!dut.cal_load && dac_code !== exp)
                fail($sformatf("%s: live code changed before load to %0h", label, dac_code));
            @(posedge clk);
            #1;
        end
        if (saw_busy)
            pass(label);
    end
    endtask

    task automatic expect_load_gap_and_width(
        input int exp_shift_pulses,
        input int exp_gap_cycles,
        input int exp_high_cycles,
        input string label
    );
        int shift_pulses;
        int gap_cycles;
        int high_cycles;
    begin
        shift_pulses = 0;
        while (shift_pulses < exp_shift_pulses) begin
            @(posedge clk);
            #1;
            if (dut.cal_clk)
                shift_pulses++;
        end

        gap_cycles = 0;
        while (!dut.cal_load && gap_cycles < (exp_gap_cycles + 8)) begin
            @(posedge clk);
            #1;
            if (!dut.cal_load)
                gap_cycles++;
        end
        if (!dut.cal_load) begin
            fail($sformatf("%s: load never asserted", label));
            return;
        end

        high_cycles = 0;
        while (dut.cal_load && high_cycles < (exp_high_cycles + 8)) begin
            high_cycles++;
            @(posedge clk);
            #1;
        end

        if (gap_cycles != exp_gap_cycles)
            fail($sformatf("%s: gap got %0d exp %0d", label, gap_cycles, exp_gap_cycles));
        else
            pass({label, " gap"});

        if (high_cycles != exp_high_cycles)
            fail($sformatf("%s: width got %0d exp %0d", label, high_cycles, exp_high_cycles));
        else
            pass({label, " width"});
    end
    endtask

    task automatic expect_data_stable_on_shift_pulses(
        input int exp_shift_pulses,
        input string label
    );
        int shift_pulses;
        int saw_violation;
        logic prev_data;
        logic prev_cal_clk;
    begin
        shift_pulses   = 0;
        saw_violation  = 0;
        prev_data      = dut.cal_data;
        prev_cal_clk   = 1'b0;

        while (shift_pulses < exp_shift_pulses) begin
            @(posedge clk);
            #1;
            if (dut.cal_clk) begin
                if (dut.cal_data !== prev_data) begin
                    fail($sformatf("%s: data changed on cal_clk pulse (%0b -> %0b)",
                                   label, prev_data, dut.cal_data));
                    saw_violation = 1;
                end
                shift_pulses++;
            end
            if (prev_cal_clk && dut.cal_data !== prev_data) begin
                fail($sformatf("%s: data changed too soon after cal_clk pulse (%0b -> %0b)",
                               label, prev_data, dut.cal_data));
                saw_violation = 1;
            end
            prev_cal_clk = dut.cal_clk;
            prev_data = dut.cal_data;
        end

        if (!saw_violation)
            pass(label);
    end
    endtask

    initial begin
        $dumpfile("tb_cal_dac_scan.vcd");
        $dumpvars(0, tb_cal_dac_scan);

        rst_n      = 1'b0;
        start      = 1'b0;
        frame_data = MID_FRAME;

        clk_wait(3);
        rst_n = 1'b1;
        clk_wait(2);

        $display("\n=== 1. Reset comes up at midscale ===");
        expect_frame(MID_FRAME, "reset frame");
        if (busy)
            fail("busy high after reset");
        else
            pass("busy low after reset");

        $display("\n=== 2. Apply is atomic ===");
        frame_data = FRAME_A;
        pulse_start;
        fork
            expect_load_gap_and_width(TOTAL_W, 2, 2, "FRAME_A load timing");
            expect_data_stable_on_shift_pulses(TOTAL_W, "FRAME_A data stable at shift edge");
            begin
                wait_busy_high(20, "start FRAME_A");
                expect_stable_while_busy(MID_FRAME, "FRAME_A held off until commit");
            end
        join
        expect_frame(FRAME_A, "FRAME_A applied");

        $display("\n=== 3. Input changes during busy do not corrupt active scan ===");
        frame_data = FRAME_B;
        pulse_start;
        wait_busy_high(20, "start FRAME_B");
        clk_wait(3);
        frame_data = FRAME_C;
        pulse_start;
        expect_stable_while_busy(FRAME_A, "FRAME_B scan kept prior live frame");
        expect_frame(FRAME_B, "FRAME_B applied");

        $display("\n=== 4. New start after idle applies latest frame ===");
        pulse_start;
        wait_busy_high(20, "start FRAME_C");
        expect_stable_while_busy(FRAME_B, "FRAME_C held off until commit");
        expect_frame(FRAME_C, "FRAME_C applied");

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
