`default_nettype none
`timescale 1ns/1ps

module tb_dds_top;

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

    localparam CLK_P  = 3.2;
    localparam SCLK_P = 20.0;

    localparam N_UNARY      = (1 << UNARY_BITS) - 1;
    localparam MIDSCALE     = 1 << (UNARY_BITS - 1);
    localparam TOTAL_WEIGHT = N_UNARY * (1 << BINARY_BITS)
                            + ((1 << BINARY_BITS) - 1);

    localparam [DAC_SW_W-1:0] MIDSCALE_SW =
        {{(N_UNARY - MIDSCALE){1'b0}}, {MIDSCALE{1'b1}}, {BINARY_BITS{1'b0}}};

    logic                 clk = 1'b0;
    logic                 rst_n;
    logic                 sclk, csn, mosi, miso;
    logic                 io_update, sync_in;
    logic [DAC_SW_W-1:0]  dac_i, dac_q;

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

    wire chirp_active = dut.u_freq.run_active;
    wire chirp_done   = dut.u_freq.segment_done;

    int err_count = 0;
    integer i;

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

    task automatic fail(input string msg);
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

    task automatic vec_wait(input int n);
    begin
        repeat (n) @(posedge dut.clk_vec);
        #1;
    end
    endtask

    task automatic spi_send_byte(input [7:0] b);
        integer j;
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
        integer j;
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

    task automatic spi_write24(input [6:0] addr, input [23:0] val);
    begin
        csn = 1'b0; #(SCLK_P/2);
        spi_send_byte({1'b0, addr});
        spi_send_byte(val[7:0]);
        spi_send_byte(val[15:8]);
        spi_send_byte(val[23:16]);
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

    task automatic do_reset;
    begin
        rst_n      = 1'b0;
        sclk       = 1'b0;
        csn        = 1'b1;
        mosi       = 1'b0;
        io_update  = 1'b0;
        sync_in    = 1'b0;
        clk_wait(4);
        rst_n = 1'b1;
        clk_wait(LANES * 3);
    end
    endtask

    task automatic expect_read8(input [6:0] addr, input [7:0] exp, input string label);
        logic [7:0] got;
    begin
        spi_read8(addr, got);
        if (got !== exp)
            fail($sformatf("%s read %02h exp %02h at %02h", label, got, exp, addr));
    end
    endtask

    task automatic wait_until_active(input int limit, output bit seen);
    begin
        seen = 1'b0;
        for (i = 0; i < limit; i = i + 1) begin
            @(posedge dut.clk_vec); #1;
            if (chirp_active) begin
                seen = 1'b1;
                i = limit;
            end
        end
    end
    endtask

    initial begin
        bit active_seen;
        bit sync_reset_seen;
        bit launch_reset_seen;
        int active_count;
        reg [PHASE_W-1:0] dp_first;
        reg [PHASE_W-1:0] dp_done;
        reg [PHASE_W-1:0] phi_after;
        reg [PHASE_W-1:0] tri_seq [0:6];
        int tri_idx;
        bit saw_motion;
        bit range_violation;
        bit dir_seen;
        int prev_i;
        int cur_i;
        int done_count;

        $dumpfile("tb_dds_top.vcd");
        $dumpvars(0, tb_dds_top);

        // Test 1: SPI readback is restricted to DEVID.
        $display("--- Test 1: SPI identity-only readback ---");
        do_reset;
        expect_read8(7'h00, DEVID, "devid");
        expect_read8(7'h01, 8'h00, "status addr reads zero");
        spi_write32(7'h04, 32'hDEAD_BEEF);
        spi_write8(7'h20, 8'h03);
        expect_read8(7'h04, 8'h00, "ftw readback disabled");
        expect_read8(7'h20, 8'h00, "cal readback disabled");

        // Test 2: CW launches on io_update and holds a steady FTW.
        $display("--- Test 2: CW io_update launch ---");
        do_reset;
        spi_write32(7'h04, 32'h1000_0000);
        spi_write8(7'h02, 8'h00);
        pulse_io_update;
        vec_wait(3);
        clk_wait(48);
        if (dut.u_freq.ftw_lane0 !== 32'h1000_0000)
            fail($sformatf("CW ftw_lane0=%08x exp=%08x", dut.u_freq.ftw_lane0, 32'h1000_0000));
        if (chirp_active !== 1'b0)
            fail("CW should not assert run_active");
        if (dac_i === MIDSCALE_SW && dac_q === MIDSCALE_SW)
            fail("CW output never left midscale");

        // Test 3: phase_rst_on_launch reduces phase epoch on relaunch.
        $display("--- Test 3: phase reset on launch ---");
        spi_write8(7'h02, 8'h08);
        launch_reset_seen = 1'b0;
        phi_after = {PHASE_W{1'b1}};
        fork
            begin
                for (i = 0; i < 24; i = i + 1) begin
                    @(posedge dut.clk_vec); #1;
                    if (dut.u_freq.phase_reset_req) begin
                        launch_reset_seen = 1'b1;
                        @(posedge dut.clk_vec); #1;
                        phi_after = dut.u_accum.phase_accum;
                        i = 24;
                    end
                end
            end
            begin
                pulse_io_update;
            end
        join
        if (!launch_reset_seen)
            fail("phase reset on launch never asserted phase_reset_req");
        if (launch_reset_seen && phi_after !== {PHASE_W{1'b0}})
            fail($sformatf("phase reset on launch failed: phi_after=%08x", phi_after));

        // Test 4: sync_in relaunches the armed profile with phase reset.
        $display("--- Test 4: sync relaunch ---");
        sync_reset_seen = 1'b0;
        fork
            begin
                for (i = 0; i < 24; i = i + 1) begin
                    @(posedge dut.clk_vec); #1;
                    if (dut.u_freq.phase_reset_req)
                        sync_reset_seen = 1'b1;
                end
            end
            begin
                vec_wait(1);
                pulse_sync;
            end
        join
        if (!sync_reset_seen)
            fail("sync relaunch never asserted phase_reset_req");

        // Test 5: SAW exact cycle count from io_update launch.
        $display("--- Test 5: SAW exact cycle count ---");
        do_reset;
        spi_write32(7'h04, 32'd1000);
        spi_write32(7'h08, 32'd9000);
        spi_write32(7'h0C, 32'd1000);
        spi_write24(7'h10, 24'd8);
        spi_write8(7'h02, 8'h01);
        active_count = 0;
        dp_first = '0;
        dp_done  = '0;
        active_seen = 1'b0;
        fork
            begin
                for (i = 0; i < 40; i = i + 1) begin
                    @(posedge dut.clk_vec); #1;
                    if (chirp_active) begin
                        active_count = active_count + 1;
                        if (!active_seen) begin
                            dp_first = dut.u_freq.ftw_lane0;
                            active_seen = 1'b1;
                        end
                    end
                    if (chirp_done)
                        dp_done = dut.u_freq.ftw_lane0;
                end
            end
            begin
                pulse_io_update;
            end
        join
        if (!active_seen)
            fail("SAW never became active");
        if (active_count !== 8)
            fail($sformatf("SAW active_count=%0d exp=8", active_count));
        if (dp_first !== 32'd1000)
            fail($sformatf("SAW first dp=%0d exp=1000", dp_first));
        if (dp_done !== 32'd9000)
            fail($sformatf("SAW done dp=%0d exp=9000", dp_done));

        // Test 6: io_update overrides an active finite run.
        $display("--- Test 6: active override ---");
        do_reset;
        spi_write32(7'h04, 32'd100);
        spi_write32(7'h08, 32'd10100);
        spi_write32(7'h0C, 32'd100);
        spi_write24(7'h10, 24'd100);
        spi_write8(7'h02, 8'h01);
        pulse_io_update;
        vec_wait(4);
        if (!chirp_active)
            fail("long SAW never became active before override");
        spi_write32(7'h04, 32'd777);
        spi_write8(7'h02, 8'h00);
        pulse_io_update;
        vec_wait(3);
        if (chirp_active)
            fail("override to CW should stop finite run");
        if (dut.u_freq.ftw_lane0 !== 32'd777)
            fail($sformatf("override ftw_lane0=%0d exp=777", dut.u_freq.ftw_lane0));

        // Test 7: TRI turnaround sequence stays exact.
        $display("--- Test 7: TRI turnaround ---");
        do_reset;
        spi_write32(7'h04, 32'd100);
        spi_write32(7'h08, 32'd400);
        spi_write32(7'h0C, 32'd25);
        spi_write24(7'h10, 24'd3);
        spi_write8(7'h02, 8'h02);
        active_seen = 1'b0;
        tri_idx = 0;
        fork
            begin
                for (i = 0; i < 32; i = i + 1) begin
                    @(posedge dut.clk_vec); #1;
                    if (!active_seen && chirp_active) begin
                        active_seen = 1'b1;
                        tri_seq[tri_idx] = dut.u_freq.ftw_lane0;
                        tri_idx = tri_idx + 1;
                    end else if (active_seen && tri_idx < 7) begin
                        tri_seq[tri_idx] = dut.u_freq.ftw_lane0;
                        tri_idx = tri_idx + 1;
                    end
                end
            end
            begin
                pulse_io_update;
            end
        join
        if (!active_seen) begin
            fail("TRI never became active");
        end else begin
            if (tri_seq[0] !== 32'd100 || tri_seq[1] !== 32'd200 ||
                tri_seq[2] !== 32'd300 || tri_seq[3] !== 32'd400 ||
                tri_seq[4] !== 32'd300 || tri_seq[5] !== 32'd200 ||
                tri_seq[6] !== 32'd100)
                fail($sformatf("TRI sequence bad: %0d %0d %0d %0d %0d %0d %0d",
                               tri_seq[0], tri_seq[1], tri_seq[2], tri_seq[3],
                               tri_seq[4], tri_seq[5], tri_seq[6]));
        end

        // Test 8: TEST mode is a steady auto-launch profile.
        $display("--- Test 8: TEST mode ---");
        do_reset;
        spi_write8(7'h02, 8'h03);
        pulse_io_update;
        vec_wait(3);
        clk_wait(40);
        if (chirp_active)
            fail("TEST mode should not assert run_active");
        if (dut.u_freq.ftw_lane0 !== TEST_TONE_FTW)
            fail($sformatf("TEST ftw_lane0=%08x exp=%08x", dut.u_freq.ftw_lane0, TEST_TONE_FTW));
        saw_motion = 1'b0;
        prev_i = sw_to_idiff(dac_i);
        for (i = 0; i < 32; i = i + 1) begin
            @(posedge clk); #1;
            cur_i = sw_to_idiff(dac_i);
            if (cur_i != prev_i)
                saw_motion = 1'b1;
            prev_i = cur_i;
        end
        if (!saw_motion)
            fail("TEST mode did not produce a live waveform");

        // Test 9: one-cycle SAW terminates cleanly and lands on FTW_B.
        $display("--- Test 9: SAW N=1 ---");
        do_reset;
        spi_write32(7'h04, 32'd500);
        spi_write32(7'h08, 32'd900);
        spi_write32(7'h0C, 32'd400);
        spi_write24(7'h10, 24'd1);
        spi_write8(7'h02, 8'h01);
        active_count = 0;
        dp_first = '0;
        dp_done  = '0;
        active_seen = 1'b0;
        fork
            begin
                for (i = 0; i < 16; i = i + 1) begin
                    @(posedge dut.clk_vec); #1;
                    if (chirp_active) begin
                        active_count = active_count + 1;
                        if (!active_seen) begin
                            dp_first = dut.u_freq.ftw_lane0;
                            active_seen = 1'b1;
                        end
                    end
                    if (chirp_done)
                        dp_done = dut.u_freq.ftw_lane0;
                end
            end
            begin
                pulse_io_update;
            end
        join
        vec_wait(1);
        if (!active_seen)
            fail("SAW N=1 never became active");
        if (active_count !== 1)
            fail($sformatf("SAW N=1 active_count=%0d exp=1", active_count));
        if (dp_first !== 32'd500)
            fail($sformatf("SAW N=1 first dp=%0d exp=500", dp_first));
        if (dp_done !== 32'd900)
            fail($sformatf("SAW N=1 done dp=%0d exp=900", dp_done));
        if (chirp_active)
            fail("SAW N=1 should be idle after completion");

        // Test 10: repeating TRI stays bounded and emits multiple done pulses.
        $display("--- Test 10: TRI repeat ---");
        do_reset;
        spi_write32(7'h04, 32'd100);
        spi_write32(7'h08, 32'd400);
        spi_write32(7'h0C, 32'd25);
        spi_write24(7'h10, 24'd3);
        spi_write8(7'h02, 8'h06);
        active_seen = 1'b0;
        range_violation = 1'b0;
        done_count = 0;
        fork
            begin
                for (i = 0; i < 40; i = i + 1) begin
                    @(posedge dut.clk_vec); #1;
                    if (chirp_active) begin
                        active_seen = 1'b1;
                        if (dut.u_freq.ftw_lane0 < 32'd100 || dut.u_freq.ftw_lane0 > 32'd400)
                            range_violation = 1'b1;
                    end
                    if (chirp_done)
                        done_count = done_count + 1;
                end
            end
            begin
                pulse_io_update;
            end
        join
        if (!active_seen)
            fail("TRI repeat never became active");
        if (range_violation)
            fail("TRI repeat drove ftw_lane0 outside [FTW_A, FTW_B]");
        if (done_count < 2)
            fail($sformatf("TRI repeat done_count=%0d exp>=2", done_count));
        if (!chirp_active)
            fail("TRI repeat unexpectedly went idle");

        // Test 11: overriding a descending TRI with TEST aborts cleanly.
        $display("--- Test 11: descending TRI override to TEST ---");
        do_reset;
        spi_write32(7'h04, 32'd100);
        spi_write32(7'h08, 32'd400);
        spi_write32(7'h0C, 32'd25);
        spi_write24(7'h10, 24'd3);
        spi_write8(7'h02, 8'h02);
        dir_seen = 1'b0;
        fork
            begin
                for (i = 0; i < 24; i = i + 1) begin
                    @(posedge dut.clk_vec); #1;
                    if (chirp_active && dut.u_freq.dir) begin
                        dir_seen = 1'b1;
                        i = 24;
                    end
                end
            end
            begin
                pulse_io_update;
            end
        join
        if (!dir_seen)
            fail("TRI never reached descending leg before override");
        spi_write8(7'h02, 8'h03);
        pulse_io_update;
        vec_wait(3);
        if (chirp_active)
            fail("override to TEST should stop finite run");
        if (dut.u_freq.ftw_lane0 !== TEST_TONE_FTW)
            fail($sformatf("TRI->TEST ftw_lane0=%08x exp=%08x", dut.u_freq.ftw_lane0, TEST_TONE_FTW));
        if (dut.u_freq.dir !== 1'b0)
            fail("override to TEST should reset TRI direction state");

        // Test 12: coincident io_update and sync launch the new profile.
        $display("--- Test 12: commit + sync precedence ---");
        do_reset;
        spi_write32(7'h04, 32'h0400_0000);
        spi_write8(7'h02, 8'h00);
        pulse_io_update;
        vec_wait(3);
        if (dut.u_freq.ftw_lane0 !== 32'h0400_0000)
            fail($sformatf("baseline CW ftw_lane0=%08x exp=%08x", dut.u_freq.ftw_lane0, 32'h0400_0000));
        spi_write32(7'h04, 32'h1800_0000);
        pulse_io_update_and_sync;
        vec_wait(3);
        if (dut.u_freq.ftw_lane0 !== 32'h1800_0000)
            fail($sformatf("commit+sync ftw_lane0=%08x exp=%08x", dut.u_freq.ftw_lane0, 32'h1800_0000));
        if (chirp_active !== 1'b0)
            fail("commit+sync on CW should remain a steady profile");
        expect_read8(7'h02, 8'h00, "ctrl readback disabled");

        if (err_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILED: %0d errors", err_count);

        $finish;
    end

endmodule

`default_nettype wire
