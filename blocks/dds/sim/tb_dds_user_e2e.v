`default_nettype none
`timescale 1ns/1ps

// User-facing E2E TB for the io_update-launched DDS top-level.
module tb_dds_user_e2e;

    localparam PHASE_W        = 32;
    localparam SINE_TRUNC_W   = 14;
    localparam SINE_COARSE_W  = 7;
    localparam SINE_GUARD_W   = 3;
    localparam UNARY_BITS     = 5;
    localparam BINARY_BITS    = 5;
    localparam COUNT_W        = 20;
    localparam LANES          = 4;
    localparam DAC_SW_W       = (1 << UNARY_BITS) - 1 + BINARY_BITS;
    localparam DEVID          = 8'hD5;
    localparam TEST_TONE_FTW = 32'h2284_DFCE;
    localparam [6:0] DIRECT_I_BASE_ADDR = 7'h44;
    localparam [6:0] DIRECT_Q_BASE_ADDR = 7'h49;
    localparam [6:0] DIRECT_CTRL_ADDR   = 7'h4E;
    localparam [DAC_SW_W-1:0] DIRECT_I_CODE = 36'h123456789;
    localparam [DAC_SW_W-1:0] DIRECT_Q_CODE = 36'h2A5A55AA5;

    localparam CLK_P        = 3.2;
    localparam SCLK_P       = 20.0;

    localparam N_UNARY      = (1 << UNARY_BITS) - 1;
    localparam MIDSCALE     = 1 << (UNARY_BITS - 1);
    localparam TOTAL_WEIGHT = N_UNARY * (1 << BINARY_BITS)
                            + ((1 << BINARY_BITS) - 1);

    localparam [DAC_SW_W-1:0] MIDSCALE_SW =
        {{(N_UNARY - MIDSCALE){1'b0}}, {MIDSCALE{1'b1}}, {BINARY_BITS{1'b0}}};

    logic                clk = 1'b0;
    logic                rst_n;
    logic                sclk, csn, mosi, miso;
    logic                io_update, sync_in;
    logic [DAC_SW_W-1:0] dac_i, dac_q;

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

    int err_count = 0;
    integer i;
    integer wave_fd;

    int cap_i [0:63];
    int cap_q [0:63];
    int cap2_i [0:63];
    int cap2_q [0:63];

    function automatic int sw_to_idiff(input logic [DAC_SW_W-1:0] sw);
        int j;
        int wp;
    begin
        wp = 0;
        for (j = BINARY_BITS; j < DAC_SW_W; j = j + 1)
            if (sw[j]) wp = wp + (1 << BINARY_BITS);
        for (j = 0; j < BINARY_BITS; j = j + 1)
            if (sw[j]) wp = wp + (1 << j);
        return 2 * wp - TOTAL_WEIGHT;
    end
    endfunction

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

    task automatic spi_recv_byte(output [7:0] b);
        int j;
    begin
        b = 8'h00;
        for (j = 7; j >= 0; j = j - 1) begin
            #(SCLK_P/2);
            sclk = 1'b1;
            b[j] = miso;
            #(SCLK_P/2);
            sclk = 1'b0;
        end
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

    task automatic expect_read8(input [6:0] addr, input [7:0] exp, input string label);
        logic [7:0] got;
    begin
        spi_read8(addr, got);
        if (got !== exp)
            fail_msg($sformatf("%s: read %02h exp %02h at %02h", label, got, exp, addr));
    end
    endtask

    task automatic pulse_io_update;
    begin
        io_update = 1'b1; #(CLK_P * (LANES * 3));
        io_update = 1'b0; #(CLK_P * (LANES * 3));
    end
    endtask

    task automatic pulse_sync;
    begin
        sync_in = 1'b1; #(CLK_P * (LANES * 3));
        sync_in = 1'b0; #(CLK_P * (LANES * 3));
    end
    endtask

    task automatic pulse_io_update_and_sync;
    begin
        io_update = 1'b1;
        sync_in   = 1'b1;
        #(CLK_P * (LANES * 3));
        io_update = 1'b0;
        sync_in   = 1'b0;
        #(CLK_P * (LANES * 3));
    end
    endtask

    task automatic do_power_cycle_reset;
    begin
        rst_n = 1'b0;
        sclk = 1'b0;
        csn = 1'b1;
        mosi = 1'b0;
        io_update = 1'b0;
        sync_in = 1'b0;
        #(CLK_P * 5);
        rst_n = 1'b1;
        clk_wait(LANES * 3);
    end
    endtask

    task automatic capture_iq(input int n, output int first_i, output int first_q);
        int j;
    begin
        first_i = 0;
        first_q = 0;
        for (j = 0; j < n; j = j + 1) begin
            @(posedge clk); #1;
            cap_i[j] = sw_to_idiff(dac_i);
            cap_q[j] = sw_to_idiff(dac_q);
            if (j == 0) begin
                first_i = cap_i[j];
                first_q = cap_q[j];
            end
        end
    end
    endtask

    task automatic capture_iq_2(input int n);
        int j;
    begin
        for (j = 0; j < n; j = j + 1) begin
            @(posedge clk); #1;
            cap2_i[j] = sw_to_idiff(dac_i);
            cap2_q[j] = sw_to_idiff(dac_q);
        end
    end
    endtask

    task automatic expect_motion(input int n, input string label);
        int prev_i;
        int prev_q;
        bit moved;
    begin
        moved = 1'b0;
        prev_i = sw_to_idiff(dac_i);
        prev_q = sw_to_idiff(dac_q);
        for (i = 0; i < n; i = i + 1) begin
            @(posedge clk); #1;
            if (sw_to_idiff(dac_i) != prev_i || sw_to_idiff(dac_q) != prev_q)
                moved = 1'b1;
            prev_i = sw_to_idiff(dac_i);
            prev_q = sw_to_idiff(dac_q);
        end
        if (!moved)
            fail_msg({label, ": waveform never moved"});
    end
    endtask

    task automatic expect_stable(input int n, input string label);
        logic [DAC_SW_W-1:0] hold_i;
        logic [DAC_SW_W-1:0] hold_q;
    begin
        hold_i = dac_i;
        hold_q = dac_q;
        for (i = 0; i < n; i = i + 1) begin
            @(posedge clk); #1;
            if (dac_i !== hold_i || dac_q !== hold_q) begin
                fail_msg({label, ": output was not stable"});
                i = n;
            end
        end
    end
    endtask

    initial begin
        wave_fd = $fopen("tb_dds_user_e2e_wave.csv", "w");
        if (wave_fd)
            $fwrite(wave_fd, "t_ns,idiff_i,idiff_q\n");
    end

    always @(posedge clk) begin
        if (wave_fd) begin
            #1;
            $fwrite(wave_fd, "%0.3f,%0d,%0d\n", $realtime, sw_to_idiff(dac_i), sw_to_idiff(dac_q));
        end
    end

    initial begin
        int first_i;
        int first_q;
        bit differs;
        bit saw_busy;

        $dumpfile("tb_dds_user_e2e.vcd");
        $dumpvars(0, tb_dds_user_e2e);

        // Test 1: power-up defaults.
        $display("--- E2E Test 1: power-up defaults ---");
        do_power_cycle_reset;
        if (dac_i !== MIDSCALE_SW || dac_q !== MIDSCALE_SW)
            fail_msg("power-up outputs should hold midscale");
        expect_read8(7'h00, DEVID, "devid");
        expect_read8(7'h01, 8'h00, "non-devid readback is zero");

        // Test 2: basic CW startup on io_update only.
        $display("--- E2E Test 2: basic CW startup ---");
        spi_write32(7'h04, 32'h1000_0000);
        spi_write8(7'h02, 8'h00);
        pulse_io_update;
        clk_wait(48);
        if (dac_i === MIDSCALE_SW && dac_q === MIDSCALE_SW)
            fail_msg("CW launch never left midscale");
        expect_motion(32, "CW launch");

        // Test 3: live frequency change while running.
        $display("--- E2E Test 3: live frequency change ---");
        capture_iq(16, first_i, first_q);
        spi_write32(7'h04, 32'h1800_0000);
        pulse_io_update;
        clk_wait(40);
        capture_iq_2(16);
        differs = 1'b0;
        for (i = 0; i < 16; i = i + 1)
            if (cap_i[i] != cap2_i[i] || cap_q[i] != cap2_q[i])
                differs = 1'b1;
        if (!differs)
            fail_msg("live io_update did not change the waveform trace");

        // Test 4: direct raw DAC override.
        $display("--- E2E Test 4: direct DAC override ---");
        spi_write36(DIRECT_I_BASE_ADDR, DIRECT_I_CODE);
        spi_write36(DIRECT_Q_BASE_ADDR, DIRECT_Q_CODE);
        spi_write8(DIRECT_CTRL_ADDR, 8'h01);
        expect_motion(16, "direct override staged");
        pulse_io_update;
        clk_wait(8);
        if (dac_i !== DIRECT_I_CODE || dac_q !== DIRECT_Q_CODE)
            fail_msg($sformatf("direct override output i=%09h q=%09h exp_i=%09h exp_q=%09h",
                               dac_i, dac_q, DIRECT_I_CODE, DIRECT_Q_CODE));
        expect_stable(16, "direct override hold");
        spi_write8(DIRECT_CTRL_ADDR, 8'h00);
        pulse_io_update;
        clk_wait(16);
        expect_motion(32, "direct override release");

        // Test 5: zero frequency edge case.
        $display("--- E2E Test 5: zero frequency ---");
        spi_write32(7'h04, 32'd0);
        pulse_io_update;
        clk_wait(48);
        expect_stable(16, "zero frequency");

        // Test 6: sync relaunch reproduces the launch epoch.
        $display("--- E2E Test 6: sync relaunch ---");
        spi_write32(7'h04, 32'h0800_0000);
        spi_write8(7'h02, 8'h08);
        pulse_io_update;
        clk_wait(48);
        capture_iq(12, first_i, first_q);
        clk_wait(48);
        pulse_sync;
        clk_wait(48);
        capture_iq_2(12);
        for (i = 0; i < 12; i = i + 1) begin
            if (cap_i[i] != cap2_i[i] || cap_q[i] != cap2_q[i]) begin
                fail_msg("sync relaunch did not reproduce the same startup window");
                i = 12;
            end
        end

        // Test 7: TEST mode auto-launch.
        $display("--- E2E Test 7: TEST mode ---");
        spi_write8(7'h02, 8'h03);
        pulse_io_update;
        clk_wait(48);
        expect_motion(32, "TEST mode");
        if (dut.u_freq.ftw_lane0 !== TEST_TONE_FTW)
            fail_msg($sformatf("TEST ftw_lane0=%08x exp=%08x", dut.u_freq.ftw_lane0, TEST_TONE_FTW));

        // Test 8: abrupt finite-to-steady takeover works via io_update alone.
        $display("--- E2E Test 8: SAW to TEST takeover ---");
        do_power_cycle_reset;
        spi_write32(7'h04, 32'd1000);
        spi_write32(7'h08, 32'd7000);
        spi_write32(7'h0C, 32'd1000);
        spi_write8(7'h02, 8'h01);
        pulse_io_update;
        clk_wait(48);
        capture_iq(12, first_i, first_q);
        spi_write8(7'h02, 8'h03);
        pulse_io_update;
        clk_wait(48);
        capture_iq_2(12);
        differs = 1'b0;
        for (i = 0; i < 12; i = i + 1)
            if (cap_i[i] != cap2_i[i] || cap_q[i] != cap2_q[i])
                differs = 1'b1;
        if (!differs)
            fail_msg("SAW to TEST takeover did not change the waveform trace");
        expect_motion(24, "SAW to TEST takeover");
        if (dut.u_freq.ftw_lane0 !== TEST_TONE_FTW)
            fail_msg($sformatf("SAW to TEST ftw_lane0=%08x exp=%08x", dut.u_freq.ftw_lane0, TEST_TONE_FTW));

        // Test 9: sync relaunch reproduces the TEST launch epoch.
        $display("--- E2E Test 9: TEST sync relaunch ---");
        do_power_cycle_reset;
        spi_write8(7'h02, 8'h03);
        pulse_io_update;
        clk_wait(48);
        capture_iq(12, first_i, first_q);
        clk_wait(48);
        pulse_sync;
        clk_wait(48);
        capture_iq_2(12);
        for (i = 0; i < 12; i = i + 1) begin
            if (cap_i[i] != cap2_i[i] || cap_q[i] != cap2_q[i]) begin
                fail_msg("TEST sync relaunch did not reproduce the same startup window");
                i = 12;
            end
        end
        if (dut.u_freq.ftw_lane0 !== TEST_TONE_FTW)
            fail_msg($sformatf("TEST sync ftw_lane0=%08x exp=%08x", dut.u_freq.ftw_lane0, TEST_TONE_FTW));

        // Test 10: coincident io_update + sync prefer the newly committed profile.
        $display("--- E2E Test 10: io_update + sync precedence ---");
        do_power_cycle_reset;
        spi_write32(7'h04, 32'h0400_0000);
        spi_write8(7'h02, 8'h00);
        pulse_io_update;
        clk_wait(48);
        capture_iq(12, first_i, first_q);
        spi_write32(7'h04, 32'h1800_0000);
        pulse_io_update_and_sync;
        clk_wait(48);
        capture_iq_2(12);
        differs = 1'b0;
        for (i = 0; i < 12; i = i + 1)
            if (cap_i[i] != cap2_i[i] || cap_q[i] != cap2_q[i])
                differs = 1'b1;
        if (!differs)
            fail_msg("io_update + sync overlap did not launch the new CW trace");
        if (dut.u_freq.ftw_lane0 !== 32'h1800_0000)
            fail_msg($sformatf("io_update + sync ftw_lane0=%08x exp=%08x", dut.u_freq.ftw_lane0, 32'h1800_0000));
        expect_motion(24, "io_update + sync overlap");

        // Test 11: only DEVID reads back; calibration still launches on io_update.
        $display("--- E2E Test 11: identity-only readback + cal apply ---");
        expect_read8(7'h02, 8'h00, "ctrl readback disabled");
        spi_write8(7'h20, 8'h03);
        expect_read8(7'h20, 8'h00, "cal readback disabled");
        if (dut.u_cal_dac_scan.dac_code[3:0] !== 4'h8)
            fail_msg($sformatf("pre-apply cal code=%0h exp 8", dut.u_cal_dac_scan.dac_code[3:0]));
        pulse_io_update;
        saw_busy = 1'b0;
        for (i = 0; i < 1024; i = i + 1) begin
            @(posedge dut.clk_cal); #1;
            if (dut.cal_busy)
                saw_busy = 1'b1;
            if (saw_busy && !dut.cal_busy)
                i = 1024;
        end
        if (!saw_busy)
            fail_msg("calibration busy never asserted");
        if (dut.u_cal_dac_scan.dac_code[3:0] !== 4'h3)
            fail_msg($sformatf("post-apply cal code=%0h exp 3", dut.u_cal_dac_scan.dac_code[3:0]));

        if (err_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILED: %0d errors", err_count);

        $finish;
    end

endmodule

`default_nettype wire
