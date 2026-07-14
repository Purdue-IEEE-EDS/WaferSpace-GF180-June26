`default_nettype none
`timescale 1ns/1ps

module tb_freq_ctrl;

    localparam PHASE_W = 32;
    localparam COUNT_W = 20;
    localparam CLK_P   = 3.2;

    localparam [1:0] SHAPE_STEADY = 2'd0,
                     SHAPE_RAMP   = 2'd1,
                     SHAPE_TRI    = 2'd2;

    logic               clk = 1'b0;
    logic               rst_n;
    logic               commit;
    logic               sync;
    logic [1:0]         next_shape;
    logic               next_loop_en;
    logic               next_phase_reset_on_launch;
    logic [PHASE_W-1:0] next_ftw_start;
    logic [PHASE_W-1:0] next_ftw_end;
    logic [PHASE_W-1:0] next_ftw_step_sample_pos;
    logic [PHASE_W-1:0] next_ftw_step_sample_neg;
    logic [COUNT_W-1:0] next_seg_blocks;

    logic               out_enable;
    logic               phase_reset_req;
    logic [PHASE_W-1:0] dp_s;
    logic [PHASE_W-1:0] dp_c;
    logic [PHASE_W-1:0] ftw_lane0;
    logic [PHASE_W-1:0] ftw_step_now;

    always #(CLK_P/2) clk = ~clk;

    freq_runner #(
        .PHASE_W (PHASE_W),
        .COUNT_W (COUNT_W),
        .LANES   (1)
    ) dut (
        .clk                       (clk),
        .rst_n                     (rst_n),
        .commit                    (commit),
        .sync                      (sync),
        .next_shape                (next_shape),
        .next_loop_en              (next_loop_en),
        .next_phase_reset_on_launch(next_phase_reset_on_launch),
        .next_ftw_start            (next_ftw_start),
        .next_ftw_end              (next_ftw_end),
        .next_ftw_step_sample_pos  (next_ftw_step_sample_pos),
        .next_ftw_step_sample_neg  (next_ftw_step_sample_neg),
        .next_seg_blocks           (next_seg_blocks),
        .out_enable                (out_enable),
        .phase_reset_req           (phase_reset_req),
        .dp_s                      (dp_s),
        .dp_c                      (dp_c),
        .ftw_lane0                 (ftw_lane0),
        .ftw_step_now              (ftw_step_now)
    );

    int err_count = 0;

    task automatic fail(input string msg);
    begin
        $display("FAIL: %s", msg);
        err_count++;
    end
    endtask

    task automatic tick(input int n = 1);
    begin
        repeat (n) @(posedge clk);
        #1;
    end
    endtask

    task automatic expect_state(
        input [PHASE_W-1:0] exp_dp,
        input [PHASE_W-1:0] exp_step,
        input bit           exp_enable,
        input bit           exp_active,
        input bit           exp_done,
        input string        label
    );
    begin
        if (ftw_lane0 !== exp_dp)
            fail($sformatf("%s ftw_lane0=%08x exp=%08x", label, ftw_lane0, exp_dp));
        if (ftw_step_now !== exp_step)
            fail($sformatf("%s ftw_step_now=%08x exp=%08x", label, ftw_step_now, exp_step));
        if (out_enable !== exp_enable)
            fail($sformatf("%s out_enable=%b exp=%b", label, out_enable, exp_enable));
        if (dut.run_active !== exp_active)
            fail($sformatf("%s run_active=%b exp=%b", label, dut.run_active, exp_active));
        if (dut.segment_done !== exp_done)
            fail($sformatf("%s segment_done=%b exp=%b", label, dut.segment_done, exp_done));
    end
    endtask

    task automatic load_profile(
        input [1:0]         shape,
        input bit           loop_en,
        input bit           phase_reset_on_launch,
        input [PHASE_W-1:0] ftw_start,
        input [PHASE_W-1:0] ftw_end,
        input [PHASE_W-1:0] ftw_step_sample,
        input [COUNT_W-1:0] seg_blocks
    );
    begin
        next_shape                 = shape;
        next_loop_en               = loop_en;
        next_phase_reset_on_launch = phase_reset_on_launch;
        next_ftw_start             = ftw_start;
        next_ftw_end               = ftw_end;
        next_ftw_step_sample_pos   = ftw_step_sample;
        next_ftw_step_sample_neg   = -ftw_step_sample;
        next_seg_blocks            = seg_blocks;
    end
    endtask

    task automatic pulse_commit;
    begin
        @(negedge clk);
        commit = 1'b1;
        @(posedge clk);
        #1;
        if (!phase_reset_req && next_phase_reset_on_launch)
            fail("phase_reset_req did not assert during commit launch");
        commit = 1'b0;
        @(posedge clk);
        #1;
    end
    endtask

    task automatic pulse_commit_with_sync;
    begin
        @(negedge clk);
        commit = 1'b1;
        sync   = 1'b1;
        @(posedge clk);
        #1;
        if (!phase_reset_req)
            fail("commit+sync should force phase_reset_req");
        commit = 1'b0;
        sync   = 1'b0;
        @(posedge clk);
        #1;
    end
    endtask

    task automatic pulse_sync;
    begin
        @(negedge clk);
        sync = 1'b1;
        @(posedge clk);
        #1;
        if (dut.profile_valid && !phase_reset_req)
            fail("sync relaunch should assert phase_reset_req");
        sync = 1'b0;
        @(posedge clk);
        #1;
    end
    endtask

    task automatic reset_dut;
    begin
        rst_n                      = 1'b0;
        commit                     = 1'b0;
        sync                       = 1'b0;
        next_shape                 = SHAPE_STEADY;
        next_loop_en               = 1'b0;
        next_phase_reset_on_launch = 1'b0;
        next_ftw_start             = '0;
        next_ftw_end               = '0;
        next_ftw_step_sample_pos   = '0;
        next_ftw_step_sample_neg   = '0;
        next_seg_blocks            = '0;
        tick(2);
        rst_n = 1'b1;
        tick(1);
    end
    endtask

    initial begin
        $dumpfile("tb_freq_ctrl.vcd");
        $dumpvars(0, tb_freq_ctrl);

        // Reset baseline.
        reset_dut;
        expect_state(32'd0, 32'd0, 0, 0, 0, "reset");

        // Test 1: steady launch on commit.
        load_profile(SHAPE_STEADY, 0, 0, 32'd1000, 32'd0, 32'd0, 20'd0);
        pulse_commit;
        expect_state(32'd1000, 32'd0, 1, 0, 0, "steady commit");
        tick(4);
        expect_state(32'd1000, 32'd0, 1, 0, 0, "steady hold");

        // Test 2: one-shot ramp.
        reset_dut;
        load_profile(SHAPE_RAMP, 0, 1, 32'd100, 32'd500, 32'd100, 20'd4);
        pulse_commit;
        expect_state(32'd100, 32'd100, 1, 1, 0, "ramp start");
        tick(1); expect_state(32'd200, 32'd100, 1, 1, 0, "ramp c1");
        tick(1); expect_state(32'd300, 32'd100, 1, 1, 0, "ramp c2");
        tick(1); expect_state(32'd400, 32'd100, 1, 1, 0, "ramp c3");
        tick(1); expect_state(32'd500, 32'd0, 1, 0, 1, "ramp done");
        tick(1); expect_state(32'd500, 32'd0, 1, 0, 0, "ramp idle");

        // Test 3: repeating ramp.
        reset_dut;
        load_profile(SHAPE_RAMP, 1, 0, 32'd10, 32'd30, 32'd10, 20'd2);
        pulse_commit;
        expect_state(32'd10, 32'd10, 1, 1, 0, "repeat ramp start");
        tick(1); expect_state(32'd20, 32'd10, 1, 1, 0, "repeat ramp c1");
        tick(1); expect_state(32'd10, 32'd10, 1, 1, 1, "repeat ramp restart");
        tick(1); expect_state(32'd20, 32'd10, 1, 1, 0, "repeat ramp c1 again");

        // Test 4: triangle.
        reset_dut;
        load_profile(SHAPE_TRI, 0, 1, 32'd100, 32'd400, 32'd100, 20'd3);
        pulse_commit;
        expect_state(32'd100, 32'd100, 1, 1, 0, "tri start");
        tick(1); expect_state(32'd200, 32'd100, 1, 1, 0, "tri up1");
        tick(1); expect_state(32'd300, 32'd100, 1, 1, 0, "tri up2");
        tick(1); expect_state(32'd400, -32'd100, 1, 1, 0, "tri apex");
        tick(1); expect_state(32'd300, -32'd100, 1, 1, 0, "tri down1");
        tick(1); expect_state(32'd200, -32'd100, 1, 1, 0, "tri down2");
        tick(1); expect_state(32'd100, 32'd0, 1, 0, 1, "tri done");

        // Test 5: sync relaunches armed ramp instead of idling it.
        reset_dut;
        load_profile(SHAPE_RAMP, 0, 0, 32'd50, 32'd250, 32'd50, 20'd5);
        pulse_commit;
        tick(2);
        expect_state(32'd150, 32'd50, 1, 1, 0, "sync pre");
        pulse_sync;
        expect_state(32'd50, 32'd50, 1, 1, 0, "sync relaunch");
        tick(1); expect_state(32'd100, 32'd50, 1, 1, 0, "sync c1");

        // Test 6: commit overrides an active ramp immediately.
        reset_dut;
        load_profile(SHAPE_RAMP, 0, 0, 32'd0, 32'd1000, 32'd100, 20'd10);
        pulse_commit;
        tick(2);
        expect_state(32'd200, 32'd100, 1, 1, 0, "override pre");
        load_profile(SHAPE_STEADY, 0, 0, 32'd777, 32'd0, 32'd0, 20'd0);
        pulse_commit;
        expect_state(32'd777, 32'd0, 1, 0, 0, "override steady");

        // Test 7: zero-block finite profile is ignored.
        reset_dut;
        load_profile(SHAPE_RAMP, 0, 0, 32'd123, 32'd999, 32'd1, 20'd0);
        pulse_commit;
        expect_state(32'd0, 32'd0, 0, 0, 0, "zero-block ramp ignored");

        // Test 8: commit+sync uses the next profile and forces phase reset.
        reset_dut;
        load_profile(SHAPE_STEADY, 0, 0, 32'd321, 32'd0, 32'd0, 20'd0);
        pulse_commit_with_sync;
        expect_state(32'd321, 32'd0, 1, 0, 0, "commit+sync");

        if (err_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILED: %0d errors", err_count);

        $finish;
    end

endmodule

`default_nettype wire
