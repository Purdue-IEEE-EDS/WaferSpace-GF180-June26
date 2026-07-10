`default_nettype none
`timescale 1ns/1ps

// phase_accum_vec4 behavioral checks.
module tb_phase_accum;

    localparam PHASE_W = 32;
    localparam LANES   = 4;
    localparam CLK_P   = 3.2;

    logic                        clk, rst_n;
    logic                        phase_reset_req;
    logic                        out_enable;
    logic [PHASE_W-1:0]          ftw_now;
    logic [PHASE_W-1:0]          ftw_step_now;
    logic [3:0][PHASE_W-1:0]     phase_vec;
    logic [3:0]                  valid_vec;

    phase_accum_vec4 #(
        .PHASE_W (PHASE_W)
    ) dut (
        .clk            (clk),
        .rst_n          (rst_n),
        .out_enable     (out_enable),
        .phase_reset_req(phase_reset_req),
        .ftw_now        (ftw_now),
        .ftw_c_now      ({PHASE_W{1'b0}}),
        .ftw_step_now   (ftw_step_now),
        .phase_vec      (phase_vec),
        .valid_vec      (valid_vec)
    );

    initial clk = 0;
    always #(CLK_P/2) clk = ~clk;

    integer err_count = 0;
    integer lane;

    function automatic [PHASE_W-1:0] lane_phase(input integer idx);
    begin
        lane_phase = phase_vec[idx];
    end
    endfunction

    task automatic check_phase(input integer idx, input [PHASE_W-1:0] exp, input string msg);
        if (lane_phase(idx) !== exp) begin
            $display("FAIL [%0s]: lane%0d=%08x exp=%08x", msg, idx, lane_phase(idx), exp);
            err_count = err_count + 1;
        end
    endtask

    task automatic check_accum(input [PHASE_W-1:0] exp, input string msg);
        if (dut.phase_accum !== exp) begin
            $display("FAIL [%0s]: phase_accum=%08x exp=%08x", msg, dut.phase_accum, exp);
            err_count = err_count + 1;
        end
    endtask

    task automatic tick(input integer n = 1);
        repeat(n) @(posedge clk);
        #1;
    endtask

    initial begin
        $dumpfile("tb_phase_accum.vcd");
        $dumpvars(0, tb_phase_accum);

        ftw_now     <= 0;
        ftw_step_now <= 0;
        phase_reset_req <= 0;
        out_enable  <= 0;
        rst_n <= 0;
        tick(2);
        rst_n <= 1;
        tick(1);
        check_accum(32'd0, "post-reset accum");
        for (lane = 0; lane < LANES; lane = lane + 1)
            check_phase(lane, 32'd0, "post-reset phases");

        // Disabled: phase_base holds even if FTW inputs move. Lane outputs are
        // registered behind the timing handoff, so changed inputs are visible
        // after the second edge.
        ftw_now      <= 32'd100;
        ftw_step_now <= 32'd25;
        tick(1);
        check_accum(32'd0, "disabled hold accum");
        check_phase(0, 32'd0, "disabled handoff lane0");
        check_phase(1, 32'd0, "disabled handoff lane1");
        check_phase(2, 32'd0, "disabled handoff lane2");
        check_phase(3, 32'd0, "disabled handoff lane3");
        if (valid_vec !== 4'b0000) begin
            $display("FAIL [disabled hold valid]: valid_vec=%b exp=0000", valid_vec);
            err_count = err_count + 1;
        end
        tick(1);
        check_accum(32'd0, "disabled hold accum after tick");
        check_phase(0, 32'd0,   "disabled hold lane0");
        check_phase(1, 32'd100, "disabled hold lane1");
        check_phase(2, 32'd225, "disabled hold lane2");
        check_phase(3, 32'd375, "disabled hold lane3");

        // Constant FTW block expansion.
        out_enable   <= 1'b1;
        ftw_now      <= 32'd100;
        ftw_step_now <= 32'd0;
        tick(1);
        tick(1);
        check_phase(0, 32'd0,   "const lane0");
        check_phase(1, 32'd100, "const lane1");
        check_phase(2, 32'd200, "const lane2");
        check_phase(3, 32'd300, "const lane3");
        if (valid_vec !== 4'b1111) begin
            $display("FAIL [const valid]: valid_vec=%b exp=1111", valid_vec);
            err_count = err_count + 1;
        end
        check_accum(32'd400, "const accum advanced");
        tick(1);
        check_accum(32'd800, "const accum next");
        check_phase(0, 32'd400, "const next lane0");
        check_phase(1, 32'd500, "const next lane1");
        check_phase(2, 32'd600, "const next lane2");
        check_phase(3, 32'd700, "const next lane3");

        // Positive chirp slope.
        phase_reset_req <= 1'b1;
        tick(1);
        phase_reset_req <= 1'b0;
        ftw_now      <= 32'd10;
        ftw_step_now <= 32'd2;
        tick(1);
        tick(1);
        check_accum(32'd52, "slope reset accum");
        check_phase(0, 32'd0,  "slope lane0");
        check_phase(1, 32'd10, "slope lane1");
        check_phase(2, 32'd22, "slope lane2");
        check_phase(3, 32'd36, "slope lane3");
        tick(1);
        check_accum(32'd104, "slope accum next");
        check_phase(0, 32'd52, "slope next lane0");
        check_phase(1, 32'd62, "slope next lane1");
        check_phase(2, 32'd74, "slope next lane2");
        check_phase(3, 32'd88, "slope next lane3");

        // Negative chirp slope.
        phase_reset_req <= 1'b1;
        tick(1);
        phase_reset_req <= 1'b0;
        ftw_now      <= 32'd40;
        ftw_step_now <= -32'd5;
        tick(1);
        tick(1);
        check_phase(0, 32'd0,   "neg lane0");
        check_phase(1, 32'd40,  "neg lane1");
        check_phase(2, 32'd75,  "neg lane2");
        check_phase(3, 32'd105, "neg lane3");
        tick(1);
        check_accum(32'd260, "neg accum next");

        $display("========================================");
        if (err_count == 0) $display("ALL TESTS PASSED");
        else $display("FAILED: %0d errors", err_count);
        $display("========================================");
        $finish;
    end
endmodule
