`default_nettype none
`timescale 1ns/1ps

// Focused E2E test for the raw direct DAC bypass path.
//
// Intent:
//   - validate the user-visible protocol, not internal implementation details
//   - prove shadow writes do nothing until io_update
//   - prove direct mode dominates waveform updates while enabled
//   - prove I/Q words update atomically on io_update with no mixed pairs
//   - prove direct disable returns cleanly to the background DDS stream
module tb_dds_direct_bypass;

    localparam PHASE_W        = 32;
    localparam SINE_TRUNC_W   = 14;
    localparam SINE_COARSE_W  = 7;
    localparam SINE_GUARD_W   = 3;
    localparam UNARY_BITS     = 5;
    localparam BINARY_BITS    = 5;
    localparam COUNT_W        = 20;
    localparam LANES          = 4;
    localparam DAC_SW_W       = (1 << UNARY_BITS) - 1 + BINARY_BITS;

    localparam [6:0] CTRL_ADDR          = 7'h02;
    localparam [6:0] FTW_A_ADDR         = 7'h04;
    localparam [6:0] DIRECT_I_BASE_ADDR = 7'h44;
    localparam [6:0] DIRECT_Q_BASE_ADDR = 7'h49;
    localparam [6:0] DIRECT_CTRL_ADDR   = 7'h4E;

    localparam [31:0] FTW_BG_A = 32'h1000_0000;
    localparam [31:0] FTW_BG_B = 32'h1800_0000;

    localparam [DAC_SW_W-1:0] DIRECT_A_I = 36'h123456789;
    localparam [DAC_SW_W-1:0] DIRECT_A_Q = 36'h2A5A55AA5;
    localparam [DAC_SW_W-1:0] DIRECT_B_I = 36'h31C0FFEE1;
    localparam [DAC_SW_W-1:0] DIRECT_B_Q = 36'h0DEADBEEF;
    localparam [DAC_SW_W-1:0] DIRECT_C_I = 36'h3C3C3C3C3;
    localparam [DAC_SW_W-1:0] DIRECT_C_Q = 36'h055AA33CC;
    localparam [DAC_SW_W-1:0] DIRECT_SWEEP_Q = {DAC_SW_W{1'b0}};

    localparam real CLK_P  = 3.2;
    localparam real SCLK_P = 20.0;

    localparam int N_UNARY = (1 << UNARY_BITS) - 1;
    localparam int MIDSCALE = 1 << (UNARY_BITS - 1);
    localparam [DAC_SW_W-1:0] MIDSCALE_SW =
        {{(N_UNARY - MIDSCALE){1'b0}}, {MIDSCALE{1'b1}}, {BINARY_BITS{1'b0}}};

    logic clk = 1'b0;
    logic rst_n;
    logic sclk, csn, mosi, miso;
    logic io_update, sync_in;
    logic [DAC_SW_W-1:0] dac_i, dac_q;

    int err_count = 0;

    always #(CLK_P/2) clk = ~clk;

    dds_top #(
        .PHASE_W       (PHASE_W),
        .SINE_TRUNC_W  (SINE_TRUNC_W),
        .SINE_COARSE_W (SINE_COARSE_W),
        .SINE_GUARD_W  (SINE_GUARD_W),
        .UNARY_BITS    (UNARY_BITS),
        .BINARY_BITS   (BINARY_BITS),
        .COUNT_W       (COUNT_W)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .sclk(sclk),
        .csn(csn),
        .mosi(mosi),
        .miso(miso),
        .io_update(io_update),
        .sync_in(sync_in),
        .dac_i(dac_i),
        .dac_q(dac_q),
        .cal_clk(),
        .cal_data(),
        .cal_load()
    );

    task automatic fail_msg(input string msg);
    begin
        $display("FAIL: %s", msg);
        err_count++;
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
        for (j = 7; j >= 0; j = j - 1) begin
            mosi = b[j];
            #(SCLK_P/2);
            sclk = 1'b1;
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

    task automatic spi_write32(input [6:0] addr, input [31:0] val);
    begin
        csn = 1'b0; #(SCLK_P/2);
        spi_send_byte({1'b0, addr});
        spi_send_byte(val[7:0]);
        spi_send_byte(val[15:8]);
        spi_send_byte(val[23:16]);
        spi_send_byte(val[31:24]);
        #(SCLK_P/2);
        csn = 1'b1;
        #(SCLK_P);
    end
    endtask

    task automatic spi_write36(input [6:0] addr, input [DAC_SW_W-1:0] val);
    begin
        csn = 1'b0; #(SCLK_P/2);
        spi_send_byte({1'b0, addr});
        spi_send_byte(val[7:0]);
        spi_send_byte(val[15:8]);
        spi_send_byte(val[23:16]);
        spi_send_byte(val[31:24]);
        spi_send_byte({4'h0, val[35:32]});
        #(SCLK_P/2);
        csn = 1'b1;
        #(SCLK_P);
    end
    endtask

    task automatic pulse_io_update;
    begin
        io_update = 1'b1;
        #(CLK_P * (LANES * 3));
        io_update = 1'b0;
        #(CLK_P * (LANES * 3));
    end
    endtask

    task automatic pulse_sync;
    begin
        sync_in = 1'b1;
        #(CLK_P * (LANES * 3));
        sync_in = 1'b0;
        #(CLK_P * (LANES * 3));
    end
    endtask

    task automatic do_reset;
    begin
        rst_n      = 1'b0;
        sclk       = 1'b0;
        csn        = 1'b1;
        mosi       = 1'b0;
        io_update  = 1'b0;
        sync_in    = 1'b0;
        #(CLK_P * 5);
        rst_n = 1'b1;
        clk_wait(LANES * 3);
    end
    endtask

    task automatic expect_motion(input int n, input string label);
        logic [DAC_SW_W-1:0] prev_i;
        logic [DAC_SW_W-1:0] prev_q;
        bit moved;
        int j;
    begin
        moved = 1'b0;
        prev_i = dac_i;
        prev_q = dac_q;
        for (j = 0; j < n; j = j + 1) begin
            @(posedge clk); #1;
            if (dac_i !== prev_i || dac_q !== prev_q)
                moved = 1'b1;
            prev_i = dac_i;
            prev_q = dac_q;
        end
        if (!moved)
            fail_msg({label, ": output never moved"});
    end
    endtask

    task automatic expect_pair_stable(
        input logic [DAC_SW_W-1:0] exp_i,
        input logic [DAC_SW_W-1:0] exp_q,
        input int n,
        input string label
    );
        int j;
    begin
        for (j = 0; j < n; j = j + 1) begin
            @(posedge clk); #1;
            if (dac_i !== exp_i || dac_q !== exp_q) begin
                fail_msg($sformatf("%s: saw i=%09h q=%09h exp_i=%09h exp_q=%09h",
                                   label, dac_i, dac_q, exp_i, exp_q));
                j = n;
            end
        end
    end
    endtask

    task automatic expect_never_pair(
        input logic [DAC_SW_W-1:0] exp_i,
        input logic [DAC_SW_W-1:0] exp_q,
        input int n,
        input string label
    );
        int j;
    begin
        for (j = 0; j < n; j = j + 1) begin
            @(posedge clk); #1;
            if (dac_i === exp_i && dac_q === exp_q) begin
                fail_msg({label, ": pair appeared unexpectedly"});
                j = n;
            end
        end
    end
    endtask

    task automatic wait_for_pair_atomic(
        input logic [DAC_SW_W-1:0] exp_i,
        input logic [DAC_SW_W-1:0] exp_q,
        input int max_cycles,
        input string label
    );
        bit seen;
        int j;
    begin
        seen = 1'b0;
        for (j = 0; j < max_cycles; j = j + 1) begin
            @(posedge clk); #1;
            if ((dac_i === exp_i) ^ (dac_q === exp_q)) begin
                fail_msg({label, ": I/Q changed non-atomically"});
                return;
            end
            if (dac_i === exp_i && dac_q === exp_q) begin
                seen = 1'b1;
                j = max_cycles;
            end
        end
        if (!seen)
            fail_msg({label, ": expected pair never appeared"});
    end
    endtask

    task automatic wait_for_pair_transition(
        input logic [DAC_SW_W-1:0] old_i,
        input logic [DAC_SW_W-1:0] old_q,
        input logic [DAC_SW_W-1:0] new_i,
        input logic [DAC_SW_W-1:0] new_q,
        input int max_cycles,
        input string label
    );
        bit seen_new;
        int j;
    begin
        seen_new = 1'b0;
        for (j = 0; j < max_cycles; j = j + 1) begin
            @(posedge clk); #1;
            if ((dac_i === new_i) ^ (dac_q === new_q)) begin
                fail_msg({label, ": I/Q changed non-atomically"});
                return;
            end
            if (!((dac_i === old_i && dac_q === old_q) ||
                  (dac_i === new_i && dac_q === new_q))) begin
                fail_msg($sformatf("%s: saw unexpected intermediate i=%09h q=%09h",
                                   label, dac_i, dac_q));
                return;
            end
            if (dac_i === new_i && dac_q === new_q) begin
                seen_new = 1'b1;
                j = max_cycles;
            end
        end
        if (!seen_new)
            fail_msg({label, ": new pair never appeared"});
    end
    endtask

    task automatic wait_until_not_pair(
        input logic [DAC_SW_W-1:0] exp_i,
        input logic [DAC_SW_W-1:0] exp_q,
        input int max_cycles,
        input string label
    );
        bit changed;
        int j;
    begin
        changed = 1'b0;
        for (j = 0; j < max_cycles; j = j + 1) begin
            @(posedge clk); #1;
            if (dac_i !== exp_i || dac_q !== exp_q) begin
                changed = 1'b1;
                j = max_cycles;
            end
        end
        if (!changed)
            fail_msg({label, ": pair never released"});
    end
    endtask

    task automatic run_direct_i_one_hot_sweep;
        logic [DAC_SW_W-1:0] prev_i;
        logic [DAC_SW_W-1:0] sweep_i;
        int bit_idx;
        string label;
    begin
        // First pin Q to a fixed reference so the sweep isolates I behavior.
        spi_write36(DIRECT_Q_BASE_ADDR, DIRECT_SWEEP_Q);
        pulse_io_update;
        wait_for_pair_transition(
            DIRECT_C_I, DIRECT_C_Q,
            DIRECT_C_I, DIRECT_SWEEP_Q,
            128,
            "prep one-hot sweep q baseline"
        );
        expect_pair_stable(DIRECT_C_I, DIRECT_SWEEP_Q, 32, "prep one-hot sweep hold");

        prev_i = DIRECT_C_I;
        for (bit_idx = 0; bit_idx < DAC_SW_W; bit_idx = bit_idx + 1) begin
            sweep_i = {DAC_SW_W{1'b0}};
            sweep_i[bit_idx] = 1'b1;

            spi_write36(DIRECT_I_BASE_ADDR, sweep_i);
            label = $sformatf("direct one-hot sweep bit %0d staged", bit_idx);
            expect_pair_stable(prev_i, DIRECT_SWEEP_Q, 8, label);

            pulse_io_update;
            label = $sformatf("direct one-hot sweep bit %0d apply", bit_idx);
            wait_for_pair_transition(
                prev_i, DIRECT_SWEEP_Q,
                sweep_i, DIRECT_SWEEP_Q,
                128,
                label
            );

            label = $sformatf("direct one-hot sweep bit %0d hold", bit_idx);
            expect_pair_stable(sweep_i, DIRECT_SWEEP_Q, 16, label);
            if (bit_idx == 3 && (dac_i !== 36'h000000008 || dac_q !== DIRECT_SWEEP_Q))
                fail_msg($sformatf("one-hot sweep 0000001000 step saw i=%09h q=%09h",
                                   dac_i, dac_q));
            prev_i = sweep_i;
        end
    end
    endtask

    initial begin
        $dumpfile("tb_dds_direct_bypass.vcd");
        $dumpvars(0, tb_dds_direct_bypass);

        do_reset;

        if (dac_i !== MIDSCALE_SW || dac_q !== MIDSCALE_SW)
            fail_msg("power-up outputs should hold midscale");

        // Bring up a moving background waveform.
        spi_write32(FTW_A_ADDR, FTW_BG_A);
        spi_write8(CTRL_ADDR, 8'h00);
        pulse_io_update;
        clk_wait(48);
        expect_motion(32, "background CW start");

        // Stage direct mode, but verify nothing changes before io_update.
        spi_write36(DIRECT_I_BASE_ADDR, DIRECT_A_I);
        spi_write36(DIRECT_Q_BASE_ADDR, DIRECT_A_Q);
        spi_write8(DIRECT_CTRL_ADDR, 8'h01);
        expect_never_pair(DIRECT_A_I, DIRECT_A_Q, 32, "direct A staged");
        expect_motion(32, "wave continues before direct A apply");

        // Apply direct mode and require an exact atomic transition.
        pulse_io_update;
        wait_for_pair_atomic(DIRECT_A_I, DIRECT_A_Q, 128, "direct A apply");
        expect_pair_stable(DIRECT_A_I, DIRECT_A_Q, 64, "direct A hold");

        // External sync must not perturb the raw override.
        pulse_sync;
        expect_pair_stable(DIRECT_A_I, DIRECT_A_Q, 64, "sync ignored in direct mode");

        // Normal waveform reconfiguration while direct mode is active must stay masked.
        spi_write32(FTW_A_ADDR, FTW_BG_B);
        spi_write8(CTRL_ADDR, 8'h00);
        pulse_io_update;
        expect_pair_stable(DIRECT_A_I, DIRECT_A_Q, 64, "wave update masked by direct");

        // Staging a new direct pair must not leak through early.
        spi_write36(DIRECT_I_BASE_ADDR, DIRECT_B_I);
        spi_write36(DIRECT_Q_BASE_ADDR, DIRECT_B_Q);
        expect_pair_stable(DIRECT_A_I, DIRECT_A_Q, 64, "direct B staged");

        // Applying the new direct pair must be a clean old->new transition.
        pulse_io_update;
        wait_for_pair_transition(
            DIRECT_A_I, DIRECT_A_Q,
            DIRECT_B_I, DIRECT_B_Q,
            128,
            "direct A to B"
        );
        expect_pair_stable(DIRECT_B_I, DIRECT_B_Q, 64, "direct B hold");

        // I-only update should produce the exact new I with the old Q.
        spi_write36(DIRECT_I_BASE_ADDR, DIRECT_C_I);
        pulse_io_update;
        wait_for_pair_transition(
            DIRECT_B_I, DIRECT_B_Q,
            DIRECT_C_I, DIRECT_B_Q,
            128,
            "direct I-only update"
        );
        expect_pair_stable(DIRECT_C_I, DIRECT_B_Q, 64, "direct I-only hold");

        // Q-only update should produce the exact new Q with the current I.
        spi_write36(DIRECT_Q_BASE_ADDR, DIRECT_C_Q);
        pulse_io_update;
        wait_for_pair_transition(
            DIRECT_C_I, DIRECT_B_Q,
            DIRECT_C_I, DIRECT_C_Q,
            128,
            "direct Q-only update"
        );
        expect_pair_stable(DIRECT_C_I, DIRECT_C_Q, 64, "direct Q-only hold");

        // Staging disable must do nothing until io_update.
        spi_write8(DIRECT_CTRL_ADDR, 8'h00);
        expect_pair_stable(DIRECT_C_I, DIRECT_C_Q, 64, "direct disable staged");

        // Release back to the background waveform.
        pulse_io_update;
        wait_until_not_pair(DIRECT_C_I, DIRECT_C_Q, 128, "direct disable release");
        expect_motion(64, "wave resumes after direct disable");

        // Re-enable direct mode and ensure it can retake control cleanly.
        spi_write8(DIRECT_CTRL_ADDR, 8'h01);
        pulse_io_update;
        wait_for_pair_atomic(DIRECT_C_I, DIRECT_C_Q, 128, "direct re-enable");
        expect_pair_stable(DIRECT_C_I, DIRECT_C_Q, 64, "direct re-entry hold");

        // Calibration-style raw direct sweep: 000...0001, 000...0010, 000...0100,
        // 000...1000, etc., checking the exact commanded word at every step.
        run_direct_i_one_hot_sweep;

        if (err_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILED: %0d errors", err_count);

        $finish;
    end

endmodule

`default_nettype wire
