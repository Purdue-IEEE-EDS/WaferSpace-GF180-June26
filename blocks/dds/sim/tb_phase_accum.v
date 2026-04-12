`default_nettype none
`timescale 1ns/1ps

// ============================================================
//  tb_phase_accum — behavioral spec:
//
//  Every cycle:  phi <= phi + dp_s + dp_c  (4:2 CSA internally)
//  On reset:     phi = 0
//  On phase_reset: phi = 0
//  Overflow wraps naturally (mod 2^32).
//
//  TB drives dp_s = delta_phase, dp_c = 0 (binary input).
//  Checks use phi_s + phi_c (resolved binary) for comparison.
// ============================================================
module tb_phase_accum;

    localparam PHASE_W = 32;
    localparam CLK_P   = 3.2;

    logic                clk, rst_n;
    logic [PHASE_W-1:0] dp_s, dp_c;
    logic                phase_reset;
    logic [PHASE_W-1:0] phi_s, phi_c;

    phase_accum #(.PHASE_W(PHASE_W)) dut (
        .clk         (clk),
        .rst_n       (rst_n),
        .dp_s        (dp_s),
        .dp_c        (dp_c),
        .phase_reset (phase_reset),
        .phi_s       (phi_s),
        .phi_c       (phi_c)
    );

    // resolved binary for checking
    wire [PHASE_W-1:0] phi = phi_s + phi_c;

    initial clk = 0;
    always #(CLK_P/2) clk = ~clk;

    integer err_count = 0;

    task automatic check(input [PHASE_W-1:0] exp, input string msg);
        if (phi !== exp) begin
            $display("FAIL [%0s]: phi=%0d exp=%0d", msg, phi, exp);
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

        dp_s <= 0;
        dp_c <= 0;
        phase_reset <= 0;
        rst_n <= 0;
        tick(2);
        rst_n <= 1;
        tick(1);
        check(0, "post-reset");

        // constant delta_phase — linear ramp (dp_s = value, dp_c = 0)
        dp_s <= 32'd1000;
        dp_c <= 32'd0;
        tick(1); check(32'd1000, "c1");
        tick(1); check(32'd2000, "c2");
        tick(1); check(32'd3000, "c3");

        // overflow wrap
        dp_s <= 32'hFFFF_FF00;
        dp_c <= 32'd0;
        tick(1); check(32'd3000 + 32'hFFFF_FF00, "pre-wrap");
        tick(1); check(32'd3000 + 2 * 64'hFFFF_FF00, "wrap");

        // phase_reset
        phase_reset <= 1;
        tick(1); check(32'd0, "phase_reset");
        phase_reset <= 0;
        dp_s <= 32'd500;
        dp_c <= 32'd0;
        tick(1); check(32'd500, "post-phase-reset");

        // test with split dp_s/dp_c (non-zero carry)
        dp_s <= 32'd300;
        dp_c <= 32'd200;
        tick(1); check(32'd500 + 32'd500, "split dp 1");
        tick(1); check(32'd500 + 2 * 32'd500, "split dp 2");

        $display("========================================");
        if (err_count == 0) $display("ALL TESTS PASSED");
        else $display("FAILED: %0d errors", err_count);
        $display("========================================");
        $finish;
    end
endmodule
