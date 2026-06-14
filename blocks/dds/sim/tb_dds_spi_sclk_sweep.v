`default_nettype none
`timescale 1ns/1ps

module tb_dds_spi_sclk_sweep;

    localparam int PHASE_W        = 32;
    localparam int SINE_TRUNC_W   = 14;
    localparam int SINE_COARSE_W  = 7;
    localparam int SINE_GUARD_W   = 3;
    localparam int UNARY_BITS     = 5;
    localparam int BINARY_BITS    = 5;
    localparam int COUNT_W        = 20;
    localparam int LANES          = 4;
    localparam int DAC_SW_W       = (1 << UNARY_BITS) - 1 + BINARY_BITS;
    localparam logic [7:0] DEVID = 8'hD5;
    localparam logic [31:0] TEST_TONE_FTW = 32'h2284_DFCE;

    localparam real CLK_P = 3.2;

    localparam int NUM_CASES = 6;
    localparam int BURST_BYTES = 17;

    logic                 clk = 1'b0;
    logic                 rst_n;
    logic                 sclk;
    logic                 csn;
    logic                 mosi;
    logic                 miso;
    logic                 io_update;
    logic                 sync_in;
    logic [DAC_SW_W-1:0]  dac_i;
    logic [DAC_SW_W-1:0]  dac_q;

    real sclk_p;

    reg [7:0] tx_buf [0:31];

    int pass_n = 0;
    int fail_n = 0;

    always #(CLK_P/2.0) clk = ~clk;

    dds_top #(
        .PHASE_W       (PHASE_W),
        .SINE_TRUNC_W  (SINE_TRUNC_W),
        .SINE_COARSE_W (SINE_COARSE_W),
        .SINE_GUARD_W  (SINE_GUARD_W),
        .UNARY_BITS    (UNARY_BITS),
        .BINARY_BITS   (BINARY_BITS),
        .COUNT_W       (COUNT_W)
    ) dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .sclk     (sclk),
        .csn      (csn),
        .mosi     (mosi),
        .miso     (miso),
        .io_update(io_update),
        .sync_in  (sync_in),
        .dac_i    (dac_i),
        .dac_q    (dac_q),
        .cal_clk  (),
        .cal_data (),
        .cal_load ()
    );

    function automatic real case_sclk_period(input int idx);
    begin
        case (idx)
            0: case_sclk_period = 1.7;
            1: case_sclk_period = 3.2;
            2: case_sclk_period = 6.9;
            3: case_sclk_period = 17.3;
            4: case_sclk_period = 53.0;
            default: case_sclk_period = 141.1;
        endcase
    end
    endfunction

    function automatic real case_burst_skew(input int idx);
    begin
        case (idx)
            0: case_burst_skew = 0.4;
            1: case_burst_skew = 1.1;
            2: case_burst_skew = 2.7;
            3: case_burst_skew = 0.9;
            4: case_burst_skew = 4.3;
            default: case_burst_skew = 7.6;
        endcase
    end
    endfunction

    function automatic real case_update_skew(input int idx);
    begin
        case (idx)
            0: case_update_skew = 0.8;
            1: case_update_skew = 2.5;
            2: case_update_skew = 5.1;
            3: case_update_skew = 1.4;
            4: case_update_skew = 8.7;
            default: case_update_skew = 3.3;
        endcase
    end
    endfunction

    function automatic logic [1:0] profile_shape(input logic [1:0] mode);
    begin
        case (mode)
            2'd1: profile_shape = 2'd1;
            2'd2: profile_shape = 2'd2;
            default: profile_shape = 2'd0;
        endcase
    end
    endfunction

    function automatic logic profile_loop(input logic [1:0] mode, input logic auto_restart);
    begin
        profile_loop = ((mode == 2'd1) || (mode == 2'd2)) ? auto_restart : 1'b0;
    end
    endfunction

    function automatic logic profile_phase_reset_norm(input logic [1:0] mode,
                                                      input logic phase_rst_on_launch);
    begin
        profile_phase_reset_norm = (mode == 2'd3) ? 1'b1 : phase_rst_on_launch;
    end
    endfunction

    function automatic logic [31:0] profile_ftw_start_norm(input logic [1:0] mode,
                                                            input logic [31:0] ftw_a);
    begin
        profile_ftw_start_norm = (mode == 2'd3) ? TEST_TONE_FTW : ftw_a;
    end
    endfunction

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

    task automatic vec_wait(input int n);
    begin
        repeat (n) @(posedge dut.clk_vec);
        #1;
    end
    endtask

    task automatic expect1(input logic got, input logic exp, input string label);
    begin
        if (got !== exp)
            fail($sformatf("%s got %0b exp %0b", label, got, exp));
        else
            pass(label);
    end
    endtask

    task automatic expect2(input logic [1:0] got, input logic [1:0] exp, input string label);
    begin
        if (got !== exp)
            fail($sformatf("%s got %0h exp %0h", label, got, exp));
        else
            pass(label);
    end
    endtask

    task automatic expect20(input logic [COUNT_W-1:0] got,
                            input logic [COUNT_W-1:0] exp,
                            input string label);
    begin
        if (got !== exp)
            fail($sformatf("%s got %05h exp %05h", label, got, exp));
        else
            pass(label);
    end
    endtask

    task automatic expect32(input logic [31:0] got,
                            input logic [31:0] exp,
                            input string label);
    begin
        if (got !== exp)
            fail($sformatf("%s got %08h exp %08h", label, got, exp));
        else
            pass(label);
    end
    endtask

    task automatic spi_send_byte(input logic [7:0] b);
        int j;
    begin
        for (j = 7; j >= 0; j--) begin
            mosi = b[j];
            #(sclk_p/2.0);
            sclk = 1'b1;
            #(sclk_p/2.0);
            sclk = 1'b0;
        end
    end
    endtask

    task automatic spi_recv_byte(output logic [7:0] b);
        int j;
    begin
        b = 8'h00;
        for (j = 7; j >= 0; j--) begin
            #(sclk_p/2.0);
            sclk = 1'b1;
            b[j] = miso;
            #(sclk_p/2.0);
            sclk = 1'b0;
        end
    end
    endtask

    task automatic spi_write_burst(input logic [6:0] addr, input int nbytes);
        int j;
    begin
        csn = 1'b0;
        #(sclk_p/2.0);
        spi_send_byte({1'b0, addr});
        for (j = 0; j < nbytes; j++)
            spi_send_byte(tx_buf[j]);
        #(sclk_p/2.0);
        csn = 1'b1;
        #(sclk_p);
    end
    endtask

    task automatic spi_write_burst_with_mid_update(input logic [6:0] addr,
                                                   input int nbytes,
                                                   input int update_after_byte_idx);
        int j;
    begin
        csn = 1'b0;
        #(sclk_p/2.0);
        spi_send_byte({1'b0, addr});
        for (j = 0; j < nbytes; j++) begin
            spi_send_byte(tx_buf[j]);
            if (j == update_after_byte_idx)
                pulse_io_update();
        end
        #(sclk_p/2.0);
        csn = 1'b1;
        #(sclk_p);
    end
    endtask

    task automatic spi_read8(input logic [6:0] addr, output logic [7:0] val);
    begin
        csn = 1'b0;
        #(sclk_p/2.0);
        spi_send_byte({1'b1, addr});
        spi_recv_byte(val);
        #(sclk_p/2.0);
        csn = 1'b1;
        #(sclk_p);
    end
    endtask

    task automatic pulse_io_update;
    begin
        io_update = 1'b1;
        #(CLK_P * 8.0);
        io_update = 1'b0;
        #(CLK_P * 8.0);
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
        sclk_p     = 20.0;
        clk_wait(6);
        rst_n = 1'b1;
        clk_wait(16);
        vec_wait(4);
    end
    endtask

    task automatic load_profile_payload(input logic [7:0] ctrl,
                                        input logic [31:0] ftw_a,
                                        input logic [31:0] ftw_b,
                                        input logic [31:0] ftw_step,
                                        input logic [COUNT_W-1:0] chirp_n);
    begin
        tx_buf[0]  = ctrl;
        tx_buf[1]  = 8'h5A;
        tx_buf[2]  = ftw_a[7:0];
        tx_buf[3]  = ftw_a[15:8];
        tx_buf[4]  = ftw_a[23:16];
        tx_buf[5]  = ftw_a[31:24];
        tx_buf[6]  = ftw_b[7:0];
        tx_buf[7]  = ftw_b[15:8];
        tx_buf[8]  = ftw_b[23:16];
        tx_buf[9]  = ftw_b[31:24];
        tx_buf[10] = ftw_step[7:0];
        tx_buf[11] = ftw_step[15:8];
        tx_buf[12] = ftw_step[23:16];
        tx_buf[13] = ftw_step[31:24];
        tx_buf[14] = chirp_n[7:0];
        tx_buf[15] = chirp_n[15:8];
        tx_buf[16] = {4'hA, chirp_n[19:16]};
    end
    endtask

    task automatic expect_committed_profile(input string tag,
                                            input logic [1:0] mode_exp,
                                            input logic auto_restart_exp,
                                            input logic phase_rst_exp,
                                            input logic [31:0] ftw_a_exp,
                                            input logic [31:0] ftw_b_exp,
                                            input logic [31:0] ftw_step_exp,
                                            input logic [COUNT_W-1:0] chirp_n_exp);
    begin
        expect2(dut.rf_mode, mode_exp, $sformatf("%s committed mode", tag));
        expect1(dut.rf_auto_restart, auto_restart_exp, $sformatf("%s committed auto_restart", tag));
        expect1(dut.rf_phase_rst_on_launch, phase_rst_exp, $sformatf("%s committed phase_rst", tag));
        expect32(dut.rf_ftw_a, ftw_a_exp, $sformatf("%s committed ftw_a", tag));
        expect32(dut.rf_ftw_b, ftw_b_exp, $sformatf("%s committed ftw_b", tag));
        expect32(dut.rf_ftw_step, ftw_step_exp, $sformatf("%s committed ftw_step", tag));
        expect20(dut.rf_chirp_n, chirp_n_exp, $sformatf("%s committed chirp_n", tag));
    end
    endtask

    task automatic expect_active_profile(input string tag,
                                         input logic [1:0] shape_exp,
                                         input logic loop_exp,
                                         input logic [31:0] ftw_start_exp,
                                         input logic [31:0] ftw_end_exp,
                                         input logic [31:0] ftw_step_exp,
                                         input logic [COUNT_W-1:0] chirp_n_exp);
    begin
        expect1(dut.u_freq.u_run.profile_valid, 1'b1, $sformatf("%s profile valid", tag));
        expect2(dut.u_freq.u_run.act_shape, shape_exp, $sformatf("%s active shape", tag));
        expect1(dut.u_freq.u_run.act_loop_en, loop_exp, $sformatf("%s active loop", tag));
        expect32(dut.u_freq.u_run.act_ftw_start, ftw_start_exp, $sformatf("%s active ftw_start", tag));
        expect32(dut.u_freq.u_run.act_ftw_end, ftw_end_exp, $sformatf("%s active ftw_end", tag));
        expect32(dut.u_freq.u_run.act_ftw_step_sample_pos, ftw_step_exp,
                 $sformatf("%s active ftw_step", tag));
        expect20(dut.u_freq.u_run.act_seg_blocks, chirp_n_exp,
                 $sformatf("%s active chirp_n", tag));
    end
    endtask

    task automatic run_case(input int idx);
        logic [31:0] ftw_a_exp;
        logic [31:0] ftw_b_exp;
        logic [31:0] ftw_step_exp;
        logic [COUNT_W-1:0] chirp_n_exp;
        logic [7:0] ctrl_exp;
        logic [1:0] mode_exp;
        logic       auto_restart_exp;
        logic       phase_rst_exp;
        logic [1:0] shape_exp;
        logic       loop_exp;
        logic       phase_reset_norm_exp;
        logic [31:0] ftw_start_norm_exp;
        logic [7:0] devid;
    begin
        do_reset();

        sclk_p = case_sclk_period(idx);
        #(case_burst_skew(idx));

        ftw_a_exp          = 32'h1020_3040 ^ (32'h0101_0110 * idx);
        ftw_b_exp          = 32'h89AB_CDEF ^ (32'h0011_2203 * idx);
        ftw_step_exp       = 32'h1357_9BDF ^ (32'h0102_0408 * idx);
        chirp_n_exp        = (20'h12345 + (idx * 20'h1111)) & 20'hFFFFF;
        mode_exp           = idx[1:0];
        auto_restart_exp   = idx[2];
        phase_rst_exp      = ~idx[0];
        ctrl_exp           = {4'b0, phase_rst_exp, auto_restart_exp, mode_exp};
        shape_exp          = profile_shape(mode_exp);
        loop_exp           = profile_loop(mode_exp, auto_restart_exp);
        phase_reset_norm_exp = profile_phase_reset_norm(mode_exp, phase_rst_exp);
        ftw_start_norm_exp = profile_ftw_start_norm(mode_exp, ftw_a_exp);

        load_profile_payload(ctrl_exp, ftw_a_exp, ftw_b_exp, ftw_step_exp, chirp_n_exp);

        $display("\n=== Sweep case %0d: SCLK period = %0.1f ns ===", idx, sclk_p);

        spi_read8(7'h00, devid);
        expect32({24'h0, devid}, {24'h0, DEVID}, $sformatf("case %0d devid read", idx));

        spi_write_burst(7'h02, BURST_BYTES);

        expect_committed_profile($sformatf("case %0d", idx), mode_exp, auto_restart_exp,
                                 phase_rst_exp, ftw_a_exp, ftw_b_exp, ftw_step_exp, chirp_n_exp);

        expect2(dut.u_freq.norm_shape, shape_exp, $sformatf("case %0d normalized shape", idx));
        expect1(dut.u_freq.norm_loop_en, loop_exp, $sformatf("case %0d normalized loop", idx));
        expect1(dut.u_freq.norm_phase_reset_on_launch, phase_reset_norm_exp,
                $sformatf("case %0d normalized phase reset", idx));
        expect32(dut.u_freq.norm_ftw_start, ftw_start_norm_exp,
                 $sformatf("case %0d normalized ftw_start", idx));
        expect32(dut.u_freq.norm_ftw_end, ftw_b_exp, $sformatf("case %0d normalized ftw_end", idx));
        expect32(dut.u_freq.norm_ftw_step_sample_pos, ftw_step_exp,
                 $sformatf("case %0d normalized ftw_step", idx));
        expect20(dut.u_freq.norm_seg_blocks, chirp_n_exp,
                 $sformatf("case %0d normalized chirp_n", idx));

        #(case_update_skew(idx));
        pulse_io_update();
        vec_wait(4);

        expect_active_profile($sformatf("case %0d", idx), shape_exp, loop_exp,
                              ftw_start_norm_exp, ftw_b_exp, ftw_step_exp, chirp_n_exp);
    end
    endtask

    task automatic run_midburst_update_case;
        logic [1:0] old_mode;
        logic       old_auto_restart;
        logic       old_phase_rst;
        logic [7:0] old_ctrl;
        logic [31:0] old_ftw_a;
        logic [31:0] old_ftw_b;
        logic [31:0] old_ftw_step;
        logic [COUNT_W-1:0] old_chirp_n;
        logic [1:0] new_mode;
        logic       new_auto_restart;
        logic       new_phase_rst;
        logic [7:0] new_ctrl;
        logic [31:0] new_ftw_a;
        logic [31:0] new_ftw_b;
        logic [31:0] new_ftw_step;
        logic [COUNT_W-1:0] new_chirp_n;
    begin
        do_reset();
        sclk_p = 17.3;

        old_mode         = 2'd1;
        old_auto_restart = 1'b1;
        old_phase_rst    = 1'b1;
        old_ctrl         = {4'b0, old_phase_rst, old_auto_restart, old_mode};
        old_ftw_a        = 32'h0102_0304;
        old_ftw_b        = 32'h1112_1314;
        old_ftw_step     = 32'h0000_0021;
        old_chirp_n      = 20'h00055;

        new_mode         = 2'd2;
        new_auto_restart = 1'b0;
        new_phase_rst    = 1'b0;
        new_ctrl         = {4'b0, new_phase_rst, new_auto_restart, new_mode};
        new_ftw_a        = 32'hA1A2_A3A4;
        new_ftw_b        = 32'hB1B2_B3B4;
        new_ftw_step     = 32'h0000_0043;
        new_chirp_n      = 20'h00333;

        $display("\n=== Negative case 1: io_update before csn rise ===");

        load_profile_payload(old_ctrl, old_ftw_a, old_ftw_b, old_ftw_step, old_chirp_n);
        spi_write_burst(7'h02, BURST_BYTES);
        pulse_io_update();
        vec_wait(4);

        expect_active_profile("midburst setup old",
                              profile_shape(old_mode),
                              profile_loop(old_mode, old_auto_restart),
                              profile_ftw_start_norm(old_mode, old_ftw_a),
                              old_ftw_b,
                              old_ftw_step,
                              old_chirp_n);

        load_profile_payload(new_ctrl, new_ftw_a, new_ftw_b, new_ftw_step, new_chirp_n);
        spi_write_burst_with_mid_update(7'h02, BURST_BYTES, 5);
        vec_wait(4);

        expect_committed_profile("midburst committed new", new_mode, new_auto_restart,
                                 new_phase_rst, new_ftw_a, new_ftw_b, new_ftw_step, new_chirp_n);
        expect_active_profile("midburst active still old",
                              profile_shape(old_mode),
                              profile_loop(old_mode, old_auto_restart),
                              profile_ftw_start_norm(old_mode, old_ftw_a),
                              old_ftw_b,
                              old_ftw_step,
                              old_chirp_n);

        pulse_io_update();
        vec_wait(4);

        expect_active_profile("midburst active after update",
                              profile_shape(new_mode),
                              profile_loop(new_mode, new_auto_restart),
                              profile_ftw_start_norm(new_mode, new_ftw_a),
                              new_ftw_b,
                              new_ftw_step,
                              new_chirp_n);
    end
    endtask

    task automatic run_split_transaction_partial_commit_case;
        logic [1:0] old_mode;
        logic       old_auto_restart;
        logic       old_phase_rst;
        logic [7:0] old_ctrl;
        logic [31:0] old_ftw_a;
        logic [31:0] old_ftw_b;
        logic [31:0] old_ftw_step;
        logic [COUNT_W-1:0] old_chirp_n;
        logic [1:0] new_mode;
        logic       new_auto_restart;
        logic       new_phase_rst;
        logic [31:0] new_ftw_a;
        logic [31:0] new_ftw_b;
        logic [31:0] new_ftw_step;
        logic [COUNT_W-1:0] new_chirp_n;
    begin
        do_reset();
        sclk_p = 53.0;

        old_mode         = 2'd1;
        old_auto_restart = 1'b0;
        old_phase_rst    = 1'b1;
        old_ctrl         = {4'b0, old_phase_rst, old_auto_restart, old_mode};
        old_ftw_a        = 32'h2222_0001;
        old_ftw_b        = 32'h3333_0002;
        old_ftw_step     = 32'h0000_0007;
        old_chirp_n      = 20'h00120;

        new_mode         = old_mode;
        new_auto_restart = old_auto_restart;
        new_phase_rst    = old_phase_rst;
        new_ftw_a        = 32'h4444_1001;
        new_ftw_b        = 32'h5555_2002;
        new_ftw_step     = 32'h0000_0019;
        new_chirp_n      = 20'h00420;

        $display("\n=== Negative case 2: split transactions can launch partial bank ===");

        load_profile_payload(old_ctrl, old_ftw_a, old_ftw_b, old_ftw_step, old_chirp_n);
        spi_write_burst(7'h02, BURST_BYTES);
        pulse_io_update();
        vec_wait(4);

        expect_active_profile("split setup old",
                              profile_shape(old_mode),
                              profile_loop(old_mode, old_auto_restart),
                              profile_ftw_start_norm(old_mode, old_ftw_a),
                              old_ftw_b,
                              old_ftw_step,
                              old_chirp_n);

        tx_buf[0] = new_ftw_a[7:0];
        tx_buf[1] = new_ftw_a[15:8];
        tx_buf[2] = new_ftw_a[23:16];
        tx_buf[3] = new_ftw_a[31:24];
        spi_write_burst(7'h04, 4);

        expect_committed_profile("split committed mixed", old_mode, old_auto_restart,
                                 old_phase_rst, new_ftw_a, old_ftw_b, old_ftw_step, old_chirp_n);

        pulse_io_update();
        vec_wait(4);

        expect_active_profile("split active mixed",
                              profile_shape(old_mode),
                              profile_loop(old_mode, old_auto_restart),
                              profile_ftw_start_norm(old_mode, new_ftw_a),
                              old_ftw_b,
                              old_ftw_step,
                              old_chirp_n);

        tx_buf[0] = new_ftw_b[7:0];
        tx_buf[1] = new_ftw_b[15:8];
        tx_buf[2] = new_ftw_b[23:16];
        tx_buf[3] = new_ftw_b[31:24];
        spi_write_burst(7'h08, 4);

        tx_buf[0] = new_ftw_step[7:0];
        tx_buf[1] = new_ftw_step[15:8];
        tx_buf[2] = new_ftw_step[23:16];
        tx_buf[3] = new_ftw_step[31:24];
        spi_write_burst(7'h0C, 4);

        tx_buf[0] = new_chirp_n[7:0];
        tx_buf[1] = new_chirp_n[15:8];
        tx_buf[2] = {4'hA, new_chirp_n[19:16]};
        spi_write_burst(7'h10, 3);

        expect_committed_profile("split committed full", new_mode, new_auto_restart,
                                 new_phase_rst, new_ftw_a, new_ftw_b, new_ftw_step, new_chirp_n);

        pulse_io_update();
        vec_wait(4);

        expect_active_profile("split active full",
                              profile_shape(new_mode),
                              profile_loop(new_mode, new_auto_restart),
                              profile_ftw_start_norm(new_mode, new_ftw_a),
                              new_ftw_b,
                              new_ftw_step,
                              new_chirp_n);
    end
    endtask

    initial begin
        int idx;

        $dumpfile("tb_dds_spi_sclk_sweep.vcd");
        $dumpvars(0, tb_dds_spi_sclk_sweep);

        for (idx = 0; idx < NUM_CASES; idx++)
            run_case(idx);
        run_midburst_update_case();
        run_split_transaction_partial_commit_case();

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
