`default_nettype none
`timescale 1ns/1ps

// ============================================================
//  tb_freq_ctrl — behavioral specification as testbench
// ============================================================
//
//  Expected behavior (the spec):
//
//  Modes: CW=0, SAW=1, TRI=2, HOP=3
//
//  CW:  On start, delta_phase = ftw_a.  Hold forever.
//       chirp_active=0, chirp_done=0.  State stays IDLE.
//
//  SAW: On start, load ftw_a, count=N, step_reg=S.  → RUN.
//       Per cycle in RUN: delta_phase += step_reg, count -= 1.
//       When count==1 (terminal): delta_phase = ftw_b (force-load).
//         chirp_done=1 (one-cycle pulse).
//         If auto_restart: reload ftw_a, count=N, stay RUN.
//         Else: → IDLE.
//       Ramp produces N-1 increments + 1 force-load = N cycles in RUN.
//       Output sequence: ftw_a, ftw_a+S, ..., ftw_a+(N-1)*S, ftw_b.
//
//  TRI: Same as SAW for up-ramp (dir=0).  At top terminal:
//         delta_phase = ftw_b, step_reg = -step_reg, dir=1, count=N.
//       Down-ramp: same mechanics.  At bottom terminal:
//         delta_phase = ftw_a, chirp_done=1.
//         auto_restart or IDLE.
//       Output: ftw_a, ..., ftw_b, ..., ftw_a.  2N cycles in RUN.
//
//  HOP: On start, delta_phase = ftw_a.  → RUN.
//       On trigger: delta_phase = ftw[freq_sel].
//       No per-cycle increment, no counter.
//
//  chirp_active: 1 when state==RUN, 0 when IDLE.
//       Exception: CW never enters RUN, so chirp_active=0.
//
module tb_freq_ctrl;

    localparam PHASE_W  = 32;
    localparam COUNT_W  = 20;
    localparam CLK_P    = 3.2;  // ~312 MHz

    logic                  clk, rst_n;
    logic [PHASE_W-1:0]   ftw_a, ftw_b, chirp_step;
    logic [COUNT_W-1:0]   chirp_n;
    logic [1:0]            mode;
    logic                  auto_restart;
    logic                  start, trigger, freq_sel;
    logic                  sync_reset;

    logic [PHASE_W-1:0]   delta_phase;
    logic                  chirp_active, chirp_done;

    wire [PHASE_W-1:0] neg_chirp_step = -chirp_step;
    wire               chirp_n_valid  = (chirp_n != {COUNT_W{1'b0}});

    freq_ctrl #(
        .PHASE_W (PHASE_W),
        .COUNT_W (COUNT_W)
    ) dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .ftw_a        (ftw_a),
        .ftw_b        (ftw_b),
        .chirp_step   (chirp_step),
        .neg_chirp_step(neg_chirp_step),
        .chirp_n      (chirp_n),
        .chirp_n_valid(chirp_n_valid),
        .mode         (mode),
        .auto_restart (auto_restart),
        .start        (start),
        .trigger      (trigger),
        .freq_sel     (freq_sel),
        .sync_reset   (sync_reset),
        .delta_phase  (delta_phase),
        .chirp_active (chirp_active),
        .chirp_done   (chirp_done)
    );

    // ---- clock ----
    initial clk = 0;
    always #(CLK_P/2) clk = ~clk;

    // ---- helpers ----
    integer err_count = 0;
    integer test_num  = 0;

    task automatic check(
        input [PHASE_W-1:0] exp_dp,
        input                exp_active,
        input                exp_done,
        input string         msg
    );
        if (delta_phase !== exp_dp || chirp_active !== exp_active || chirp_done !== exp_done) begin
            $display("FAIL [%0s]: dp=%0d exp=%0d | active=%b exp=%b | done=%b exp=%b",
                     msg, delta_phase, exp_dp, chirp_active, exp_active, chirp_done, exp_done);
            err_count = err_count + 1;
        end
    endtask

    task automatic tick(input integer n = 1);
        repeat(n) @(posedge clk);
        #1;  // settle after edge
    endtask

    task automatic pulse_start;
        @(posedge clk);
        start <= 1;
        @(posedge clk);
        start <= 0;
        #1;
    endtask

    task automatic pulse_trigger;
        @(posedge clk);
        trigger <= 1;
        @(posedge clk);
        trigger <= 0;
        #1;
    endtask

    task automatic reset_dut;
        rst_n <= 0;
        start <= 0;
        trigger <= 0;
        freq_sel <= 0;
        sync_reset <= 0;
        tick(2);
        rst_n <= 1;
        tick(1);
    endtask

    task automatic pulse_sync;
        @(posedge clk);
        sync_reset <= 1;
        @(posedge clk);
        sync_reset <= 0;
        #1;
    endtask

    // ================================================================
    //  Tests
    // ================================================================
    initial begin
        $dumpfile("tb_freq_ctrl.vcd");
        $dumpvars(0, tb_freq_ctrl);

        // ============================================================
        //  Test 1: CW mode — load and hold
        // ============================================================
        test_num = 1;
        $display("--- Test %0d: CW load and hold ---", test_num);

        ftw_a       <= 32'd1000;
        ftw_b       <= 32'd5000;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd10;
        mode        <= 2'd0;  // CW
        auto_restart <= 0;

        reset_dut;

        // Before start: delta_phase should be 0 (reset value)
        check(0, 0, 0, "T1 pre-start");

        // Fire start
        pulse_start;

        // After start: delta_phase = ftw_a, stays IDLE
        check(32'd1000, 0, 0, "T1 post-start");

        // Hold for several cycles — nothing should change
        tick(5);
        check(32'd1000, 0, 0, "T1 hold");

        // ============================================================
        //  Test 2: SAW ramp, no restart
        // ============================================================
        test_num = 2;
        $display("--- Test %0d: SAW ramp ---", test_num);

        ftw_a       <= 32'd100;
        ftw_b       <= 32'd500;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd4;
        mode        <= 2'd1;  // SAW
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        // start edge: delta_phase = ftw_a = 100, now in RUN
        check(32'd100, 1, 0, "T2 start");

        // cycle 1 (count=4→3): dp = 100+100 = 200
        tick(1);
        check(32'd200, 1, 0, "T2 c1");

        // cycle 2 (count=3→2): dp = 300
        tick(1);
        check(32'd300, 1, 0, "T2 c2");

        // cycle 3 (count=2→1): dp = 400
        tick(1);
        check(32'd400, 1, 0, "T2 c3");

        // cycle 4 (count=1, terminal): dp = ftw_b = 500, done pulse
        tick(1);
        check(32'd500, 0, 1, "T2 terminal");

        // cycle 5: IDLE, done clears
        tick(1);
        check(32'd500, 0, 0, "T2 idle");

        // holds
        tick(3);
        check(32'd500, 0, 0, "T2 hold");

        // ============================================================
        //  Test 3: SAW with residual — force-load absorbs error
        // ============================================================
        test_num = 3;
        $display("--- Test %0d: SAW residual ---", test_num);

        ftw_a       <= 32'd0;
        ftw_b       <= 32'd1000;
        chirp_step  <= 32'd300;   // 3 steps of 300 = 900, not 1000
        chirp_n     <= 20'd3;
        mode        <= 2'd1;  // SAW
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        check(32'd0, 1, 0, "T3 start");
        tick(1);
        check(32'd300, 1, 0, "T3 c1");
        tick(1);
        check(32'd600, 1, 0, "T3 c2");
        // terminal: should be 1000 (ftw_b), NOT 900
        tick(1);
        check(32'd1000, 0, 1, "T3 terminal");

        // ============================================================
        //  Test 4: SAW with auto_restart
        // ============================================================
        test_num = 4;
        $display("--- Test %0d: SAW auto-restart ---", test_num);

        ftw_a       <= 32'd100;
        ftw_b       <= 32'd400;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd3;
        mode        <= 2'd1;  // SAW
        auto_restart <= 1;

        reset_dut;
        pulse_start;

        // first ramp: 100, 200, 300, then terminal restarts to 100
        check(32'd100, 1, 0, "T4 s0");
        tick(1); check(32'd200, 1, 0, "T4 s1");
        tick(1); check(32'd300, 1, 0, "T4 s2");
        tick(1); check(32'd100, 1, 1, "T4 term+restart");
        // NOTE: on restart, delta_phase reloads to ftw_a, not ftw_b.
        // chirp_done is a pulse with the restart.

        // second ramp starts immediately
        tick(1); check(32'd200, 1, 0, "T4 r2 c1");
        tick(1); check(32'd300, 1, 0, "T4 r2 c2");
        tick(1); check(32'd100, 1, 1, "T4 r2 term");

        // ============================================================
        //  Test 5: TRI mode
        // ============================================================
        test_num = 5;
        $display("--- Test %0d: TRI mode ---", test_num);

        ftw_a       <= 32'd100;
        ftw_b       <= 32'd400;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd3;
        mode        <= 2'd2;  // TRI
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        // up ramp: 100, 200, 300, 400(top)
        check(32'd100, 1, 0, "T5 u0");
        tick(1); check(32'd200, 1, 0, "T5 u1");
        tick(1); check(32'd300, 1, 0, "T5 u2");
        tick(1); check(32'd400, 1, 0, "T5 top");
        // top: force-load ftw_b, step negates, dir flips.  No chirp_done yet.

        // down ramp: 300, 200, 100(bottom, done)
        tick(1); check(32'd300, 1, 0, "T5 d1");
        tick(1); check(32'd200, 1, 0, "T5 d2");
        tick(1); check(32'd100, 0, 1, "T5 bottom");

        // IDLE
        tick(1); check(32'd100, 0, 0, "T5 idle");

        // ============================================================
        //  Test 6: TRI with auto_restart
        // ============================================================
        test_num = 6;
        $display("--- Test %0d: TRI auto-restart ---", test_num);

        ftw_a       <= 32'd0;
        ftw_b       <= 32'd200;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd2;
        mode        <= 2'd2;  // TRI
        auto_restart <= 1;

        reset_dut;
        pulse_start;

        // up: 0, 100, 200(top)
        check(32'd0,   1, 0, "T6 u0");
        tick(1); check(32'd100, 1, 0, "T6 u1");
        tick(1); check(32'd200, 1, 0, "T6 top");

        // down: 100, 0(bottom, done+restart)
        tick(1); check(32'd100, 1, 0, "T6 d1");
        tick(1); check(32'd0,   1, 1, "T6 bottom+restart");

        // second triangle starts immediately (up)
        tick(1); check(32'd100, 1, 0, "T6 r2 u1");
        tick(1); check(32'd200, 1, 0, "T6 r2 top");
        tick(1); check(32'd100, 1, 0, "T6 r2 d1");
        tick(1); check(32'd0,   1, 1, "T6 r2 bottom");

        // ============================================================
        //  Test 7: HOP mode
        // ============================================================
        test_num = 7;
        $display("--- Test %0d: HOP mode ---", test_num);

        ftw_a       <= 32'd1000;
        ftw_b       <= 32'd5000;
        chirp_step  <= 32'd0;
        chirp_n     <= 20'd0;
        mode        <= 2'd3;  // HOP
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        // start: load ftw_a
        check(32'd1000, 0, 0, "T7 start");

        // hold several cycles
        tick(3);
        check(32'd1000, 0, 0, "T7 hold");

        // trigger with freq_sel=1 → ftw_b
        freq_sel <= 1;
        pulse_trigger;
        check(32'd5000, 0, 0, "T7 hop to b");

        // hold
        tick(3);
        check(32'd5000, 0, 0, "T7 hold b");

        // trigger with freq_sel=0 → ftw_a
        freq_sel <= 0;
        pulse_trigger;
        check(32'd1000, 0, 0, "T7 hop to a");

        // ============================================================
        //  Test 8: SAW N=1 edge case — immediate terminal
        // ============================================================
        test_num = 8;
        $display("--- Test %0d: SAW N=1 ---", test_num);

        ftw_a       <= 32'd0;
        ftw_b       <= 32'd999;
        chirp_step  <= 32'd500;
        chirp_n     <= 20'd1;
        mode        <= 2'd1;
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        // start: dp = ftw_a = 0
        check(32'd0, 1, 0, "T8 start");

        // count=1 immediately → terminal, force-load ftw_b
        tick(1);
        check(32'd999, 0, 1, "T8 terminal");

        tick(1);
        check(32'd999, 0, 0, "T8 idle");

        // ============================================================
        //  Test 9: chirp_done is single-cycle pulse
        // ============================================================
        test_num = 9;
        $display("--- Test %0d: done pulse width ---", test_num);

        ftw_a       <= 32'd0;
        ftw_b       <= 32'd200;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd2;
        mode        <= 2'd1;
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        check(32'd0, 1, 0, "T9 start");
        tick(1); check(32'd100, 1, 0, "T9 c1");
        tick(1); check(32'd200, 0, 1, "T9 done=1");
        tick(1); check(32'd200, 0, 0, "T9 done=0");
        tick(1); check(32'd200, 0, 0, "T9 still 0");

        // ============================================================
        //  Test 10: Reset during ramp
        // ============================================================
        test_num = 10;
        $display("--- Test %0d: Reset during ramp ---", test_num);

        ftw_a       <= 32'd100;
        ftw_b       <= 32'd500;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd4;
        mode        <= 2'd1;
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        check(32'd100, 1, 0, "T10 start");
        tick(1); check(32'd200, 1, 0, "T10 c1");

        // hard reset mid-ramp
        rst_n <= 0;
        tick(2);
        rst_n <= 1;
        tick(1);

        check(0, 0, 0, "T10 post-reset");

        // ============================================================
        //  Test 11: SAW with N=0 — should NOT enter RUN
        // ============================================================
        test_num = 11;
        $display("--- Test %0d: SAW N=0 guard ---", test_num);

        ftw_a       <= 32'd100;
        ftw_b       <= 32'd500;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd0;    // N=0 — illegal
        mode        <= 2'd1;     // SAW
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        // should load ftw_a but stay IDLE
        check(32'd100, 0, 0, "T11 post-start");

        // hold — nothing should change
        tick(5);
        check(32'd100, 0, 0, "T11 hold");

        // ============================================================
        //  Test 12: TRI with N=0 — should NOT enter RUN
        // ============================================================
        test_num = 12;
        $display("--- Test %0d: TRI N=0 guard ---", test_num);

        ftw_a       <= 32'd100;
        ftw_b       <= 32'd500;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd0;
        mode        <= 2'd2;     // TRI
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        check(32'd100, 0, 0, "T12 post-start");
        tick(5);
        check(32'd100, 0, 0, "T12 hold");

        // ============================================================
        //  Test 13: Back-to-back start during active SAW
        // ============================================================
        test_num = 13;
        $display("--- Test %0d: Start during active ramp ---", test_num);

        ftw_a       <= 32'd0;
        ftw_b       <= 32'd1000;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd10;
        mode        <= 2'd1;
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        check(32'd0, 1, 0, "T13 first start");
        tick(1); check(32'd100, 1, 0, "T13 c1");
        tick(1); check(32'd200, 1, 0, "T13 c2");

        // fire start again mid-ramp — FSM is in RUN, start is
        // only checked in IDLE, so it should be ignored
        pulse_start;
        // should continue ramping from where we were, not restart
        // (we lost some cycles to pulse_start timing, just check still active)
        if (!chirp_active) begin
            $display("FAIL [T13]: chirp_active dropped on mid-ramp start");
            err_count = err_count + 1;
        end

        // ============================================================
        //  Test 14: HOP exit via mode change
        // ============================================================
        test_num = 14;
        $display("--- Test %0d: HOP exit via mode change ---", test_num);

        ftw_a       <= 32'd1000;
        ftw_b       <= 32'd5000;
        chirp_step  <= 32'd0;
        chirp_n     <= 20'd0;
        mode        <= 2'd3;  // HOP
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        // in HOP, chirp_active=0
        check(32'd1000, 0, 0, "T14 in HOP");

        tick(3);

        // change mode to CW externally (simulates io_update latching new mode)
        mode <= 2'd0;
        tick(1);

        // FSM detects mode != run_mode → goes to IDLE
        tick(1);
        if (dut.state !== 1'b0) begin
            $display("FAIL [T14]: FSM did not return to IDLE on mode change, state=%b", dut.state);
            err_count = err_count + 1;
        end

        // ============================================================
        //  Test 15: Mode change during SAW ramp → safe IDLE return
        // ============================================================
        test_num = 15;
        $display("--- Test %0d: Mode change during SAW → IDLE ---", test_num);

        ftw_a       <= 32'd0;
        ftw_b       <= 32'd1000;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd10;
        mode        <= 2'd1;  // SAW
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        check(32'd0, 1, 0, "T15 SAW start");
        tick(2);
        // ramp is running (chirp_active=1)
        if (!chirp_active) begin
            $display("FAIL [T15]: chirp_active not set during SAW");
            err_count = err_count + 1;
        end

        // change mode to HOP mid-ramp
        mode <= 2'd3;
        tick(1);

        // FSM detects mode != run_mode → goes to IDLE
        tick(1);
        if (dut.state !== 1'b0) begin
            $display("FAIL [T15]: FSM did not return to IDLE on mode change, state=%b", dut.state);
            err_count = err_count + 1;
        end
        // chirp_active should be 0 now
        if (chirp_active !== 1'b0) begin
            $display("FAIL [T15]: chirp_active not cleared after mode change");
            err_count = err_count + 1;
        end

        // ============================================================
        //  Test 16: sync_reset during SAW ramp — full epoch reset
        // ============================================================
        test_num = 16;
        $display("--- Test %0d: sync_reset during SAW ---", test_num);

        ftw_a       <= 32'd100;
        ftw_b       <= 32'd1100;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd10;
        mode        <= 2'd1;  // SAW
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        // ramp running
        check(32'd100, 1, 0, "T16 start");
        tick(1); check(32'd200, 1, 0, "T16 c1");
        tick(1); check(32'd300, 1, 0, "T16 c2");

        // fire sync_reset mid-ramp
        pulse_sync;

        // expected: IDLE, delta_phase = ftw_a, chirp_active = 0
        check(32'd100, 0, 0, "T16 post-sync");

        // should hold at ftw_a
        tick(3);
        check(32'd100, 0, 0, "T16 hold");

        // start again — should begin a fresh ramp
        pulse_start;
        check(32'd100, 1, 0, "T16 restart");
        tick(1); check(32'd200, 1, 0, "T16 restart c1");

        // ============================================================
        //  Test 17: sync_reset during TRI down-ramp
        // ============================================================
        test_num = 17;
        $display("--- Test %0d: sync_reset during TRI ---", test_num);

        ftw_a       <= 32'd100;
        ftw_b       <= 32'd400;
        chirp_step  <= 32'd100;
        chirp_n     <= 20'd3;
        mode        <= 2'd2;  // TRI
        auto_restart <= 0;

        reset_dut;
        pulse_start;

        // up ramp: 100, 200, 300, 400(top)
        check(32'd100, 1, 0, "T17 u0");
        tick(1); check(32'd200, 1, 0, "T17 u1");
        tick(1); check(32'd300, 1, 0, "T17 u2");
        tick(1); check(32'd400, 1, 0, "T17 top");
        // down ramp: 300
        tick(1); check(32'd300, 1, 0, "T17 d1");

        // sync mid-down-ramp
        pulse_sync;

        // expected: IDLE, delta_phase = ftw_a = 100
        check(32'd100, 0, 0, "T17 post-sync");

        // ============================================================
        //  Test 18: sync_reset during HOP — returns to IDLE
        // ============================================================
        test_num = 18;
        $display("--- Test %0d: sync_reset during HOP ---", test_num);

        ftw_a       <= 32'd1000;
        ftw_b       <= 32'd5000;
        mode        <= 2'd3;  // HOP
        auto_restart <= 0;

        reset_dut;
        pulse_start;
        check(32'd1000, 0, 0, "T18 HOP start");

        // hop to ftw_b
        freq_sel <= 1;
        pulse_trigger;
        check(32'd5000, 0, 0, "T18 hopped");

        // sync_reset while in HOP
        pulse_sync;
        check(32'd1000, 0, 0, "T18 post-sync");

        // FSM should be in IDLE now
        if (dut.state !== 1'b0) begin
            $display("FAIL [T18]: state not IDLE after sync_reset in HOP");
            err_count = err_count + 1;
        end

        // ============================================================
        //  Summary
        // ============================================================
        $display("========================================");
        if (err_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILED: %0d errors", err_count);
        $display("========================================");

        $finish;
    end

endmodule
