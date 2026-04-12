`default_nettype none
`timescale 1ns/1ps

module tb_dds_top;

    localparam PHASE_W     = 32;
    localparam TRUNC_W     = 12;
    localparam UNARY_BITS  = 5;
    localparam BINARY_BITS = 5;
    localparam COUNT_W     = 20;
    localparam SYM_W       = 2;
    localparam DAC_SW_W    = (1 << UNARY_BITS) - 1 + BINARY_BITS;

    localparam CLK_P  = 3.2;
    localparam SCLK_P = 20.0;

    // ---- DUT signals ----
    logic                  clk, rst_n;
    logic                  sclk, csn, mosi, miso;
    logic                  io_update, start_pin, sync_in;
    logic                  freq_trigger_pin, amp_trigger_pin;
    logic [SYM_W-1:0]     amp_idx;
    logic [SYM_W-1:0]     pow_sel;
    logic                  freq_sel;
    logic [DAC_SW_W-1:0]  dac_i, dac_q;
    logic                  chirp_active, chirp_done;

    dds_top #(
        .PHASE_W(PHASE_W), .TRUNC_W(TRUNC_W),
        .UNARY_BITS(UNARY_BITS), .BINARY_BITS(BINARY_BITS),
        .COUNT_W(COUNT_W), .SYM_W(SYM_W)
    ) dut (
        .clk(clk), .rst_n(rst_n),
        .sclk(sclk), .csn(csn), .mosi(mosi), .miso(miso),
        .io_update(io_update), .start(start_pin),
        .sync_in(sync_in),
        .freq_trigger(freq_trigger_pin), .amp_trigger(amp_trigger_pin),
        .amp_idx(amp_idx), .pow_sel(pow_sel), .freq_sel(freq_sel),
        .dac_i(dac_i), .dac_q(dac_q),
        .chirp_active(chirp_active), .chirp_done(chirp_done)
    );

    initial clk = 0;
    always #(CLK_P/2) clk = ~clk;

    integer err_count = 0;
    integer i;

    // ---- shared temp variables ----
    reg [7:0] rd_byte;
    reg [DAC_SW_W-1:0] snap_i, snap_q;
    reg [PHASE_W-1:0] dp_log [0:9];
    reg [PHASE_W-1:0] theta_cap;

    // ---- DAC midscale constant for amplitude tests ----
    localparam N_UNARY_TB  = (1 << UNARY_BITS) - 1;
    localparam MIDSCALE_TB = 1 << (UNARY_BITS - 1);
    localparam [DAC_SW_W-1:0] MIDSCALE_SW =
        {{(N_UNARY_TB - MIDSCALE_TB){1'b0}}, {MIDSCALE_TB{1'b1}}, {BINARY_BITS{1'b0}}};

    // ---- additional constants for waveform quality tests ----
    localparam ADDR_W      = TRUNC_W - 2;
    localparam MAG_W       = UNARY_BITS + BINARY_BITS - 1;  // 9
    localparam PEAK        = (1 << MAG_W) - 1;              // 511
    localparam TOTAL_WEIGHT = N_UNARY_TB * (1 << BINARY_BITS)
                             + ((1 << BINARY_BITS) - 1);    // 1023

    // ---- convert DAC switch pattern to signed differential ----
    function integer sw_to_idiff;
        input [DAC_SW_W-1:0] sw;
        integer j, wp;
    begin
        wp = 0;
        for (j = BINARY_BITS; j < DAC_SW_W; j = j + 1)
            if (sw[j]) wp = wp + (1 << BINARY_BITS);
        for (j = 0; j < BINARY_BITS; j = j + 1)
            if (sw[j]) wp = wp + (1 << j);
        sw_to_idiff = 2 * wp - TOTAL_WEIGHT;
    end
    endfunction

    // ---- continuous I_diff for waveform viewing ----
    integer idiff_i, idiff_q;
    always @(*) begin
        idiff_i = sw_to_idiff(dac_i);
        idiff_q = sw_to_idiff(dac_q);
    end

    // ---- capture buffers ----
    integer cap_i [0:255];
    integer cap_q [0:255];

    task capture;
        input integer n;
        integer ci;
    begin
        for (ci = 0; ci < n; ci = ci + 1) begin
            @(posedge clk); #1;
            cap_i[ci] = sw_to_idiff(dac_i);
            cap_q[ci] = sw_to_idiff(dac_q);
        end
    end
    endtask

    // ---- standalone mag_to_sw decoder for exhaustive test ----
    logic [MAG_W-1:0]    t71_mag;
    logic [DAC_SW_W-1:0] t71_sw;
    mag_to_sw #(.UNARY_BITS(UNARY_BITS), .BINARY_BITS(BINARY_BITS)) t71_dec (
        .mag (t71_mag), .sw (t71_sw)
    );

    // ================================================================
    //  SPI primitives
    // ================================================================
    task spi_send_byte;
        input [7:0] b;
        integer j;
    begin
        for (j = 7; j >= 0; j = j - 1) begin
            mosi = b[j];
            #(SCLK_P/2);
            sclk = 1;
            #(SCLK_P/2);
            sclk = 0;
        end
    end
    endtask

    task spi_recv_byte;
        output [7:0] b;
        integer j;
    begin
        b = 8'd0;
        for (j = 7; j >= 0; j = j - 1) begin
            #(SCLK_P/2);
            sclk = 1;
            b[j] = miso;
            #(SCLK_P/2);
            sclk = 0;
        end
    end
    endtask

    task spi_write32;
        input [6:0] addr;
        input [31:0] val;
    begin
        csn = 0; #(SCLK_P/2);
        spi_send_byte({1'b0, addr});
        spi_send_byte(val[ 7: 0]);
        spi_send_byte(val[15: 8]);
        spi_send_byte(val[23:16]);
        spi_send_byte(val[31:24]);
        #(SCLK_P/2); csn = 1; #(SCLK_P);
    end
    endtask

    task spi_write24;
        input [6:0] addr;
        input [23:0] val;
    begin
        csn = 0; #(SCLK_P/2);
        spi_send_byte({1'b0, addr});
        spi_send_byte(val[ 7: 0]);
        spi_send_byte(val[15: 8]);
        spi_send_byte(val[23:16]);
        #(SCLK_P/2); csn = 1; #(SCLK_P);
    end
    endtask

    task spi_write8;
        input [6:0] addr;
        input [7:0] val;
    begin
        csn = 0; #(SCLK_P/2);
        spi_send_byte({1'b0, addr});
        spi_send_byte(val);
        #(SCLK_P/2); csn = 1; #(SCLK_P);
    end
    endtask

    task spi_write16;
        input [6:0] addr;
        input [15:0] val;
    begin
        csn = 0; #(SCLK_P/2);
        spi_send_byte({1'b0, addr});
        spi_send_byte(val[ 7:0]);
        spi_send_byte(val[15:8]);
        #(SCLK_P/2); csn = 1; #(SCLK_P);
    end
    endtask

    task spi_read8;
        input  [6:0] addr;
        output [7:0] val;
    begin
        csn = 0; #(SCLK_P/2);
        spi_send_byte({1'b1, addr});
        spi_recv_byte(val);
        #(SCLK_P/2); csn = 1; #(SCLK_P);
    end
    endtask

    task pulse_io_update;
    begin
        io_update = 1; #(CLK_P * 5);
        io_update = 0; #(CLK_P * 5);
    end
    endtask

    task pulse_start;
    begin
        start_pin = 1; #(CLK_P * 5);
        start_pin = 0; #(CLK_P * 5);
    end
    endtask

    task pulse_freq_trigger;
    begin
        freq_trigger_pin = 1; #(CLK_P * 5);
        freq_trigger_pin = 0; #(CLK_P * 5);
    end
    endtask

    task pulse_amp_trigger;
    begin
        amp_trigger_pin = 1; #(CLK_P * 5);
        amp_trigger_pin = 0; #(CLK_P * 5);
    end
    endtask

    task clk_wait;
        input integer n;
    begin
        repeat(n) @(posedge clk);
        #1;
    end
    endtask

    task do_reset;
    begin
        rst_n = 0; #(CLK_P * 5);
        rst_n = 1; #(CLK_P * 5);
    end
    endtask

    // ================================================================
    //  Tests
    // ================================================================
    initial begin
        $dumpfile("tb_dds_top.vcd");
        $dumpvars(0, tb_dds_top);

        sclk = 0; csn = 1; mosi = 0;
        io_update = 0; start_pin = 0; sync_in = 0;
        freq_trigger_pin = 0; amp_trigger_pin = 0;
        amp_idx = 0; pow_sel = 0; freq_sel = 0;
        rst_n = 0;
        #(CLK_P * 10);
        rst_n = 1;
        #(CLK_P * 5);

        // ============================================================
        //  Test 1: SPI DEVID
        // ============================================================
        $display("--- Test 1: SPI DEVID ---");
        spi_read8(7'h00, rd_byte);
        if (rd_byte !== 8'hD5) begin
            $display("FAIL: DEVID=%02x exp=D5", rd_byte);
            err_count = err_count + 1;
        end

        // ============================================================
        //  Test 2: SPI write/readback FTW_A
        // ============================================================
        $display("--- Test 2: SPI write/read ---");
        spi_write32(7'h04, 32'hDEAD_BEEF);
        spi_read8(7'h04, rd_byte);
        if (rd_byte !== 8'hEF) begin
            $display("FAIL: FTW_A[7:0]=%02x exp=EF", rd_byte);
            err_count = err_count + 1;
        end
        spi_read8(7'h07, rd_byte);
        if (rd_byte !== 8'hDE) begin
            $display("FAIL: FTW_A[31:24]=%02x exp=DE", rd_byte);
            err_count = err_count + 1;
        end

        // ============================================================
        //  Test 3: CW mode — DAC not stuck
        // ============================================================
        $display("--- Test 3: CW mode ---");
        do_reset;
        spi_write32(7'h04, 32'h1000_0000);  // FTW_A
        spi_write8(7'h02, 8'h00);           // CW
        pulse_io_update;
        pulse_start;
        clk_wait(20);

        @(posedge clk); #1;
        snap_i = dac_i;
        snap_q = dac_q;
        clk_wait(8);
        if (dac_i === snap_i && dac_q === snap_q) begin
            $display("FAIL: DAC stuck in CW mode");
            err_count = err_count + 1;
        end
        if (chirp_active !== 1'b0) begin
            $display("FAIL: chirp_active!=0 in CW");
            err_count = err_count + 1;
        end

        // ============================================================
        //  Test 4: SAW chirp — active and done
        // ============================================================
        $display("--- Test 4: SAW chirp ---");
        begin
            integer saw_done_seen, active_seen;
            do_reset;
            spi_write32(7'h04, 32'd100);
            spi_write32(7'h08, 32'd3100);
            spi_write32(7'h0C, 32'd100);
            spi_write24(7'h10, 24'd30);     // N=30, long enough to observe
            spi_write8(7'h02, 8'h01);       // SAW
            pulse_io_update;
            pulse_start;

            saw_done_seen = 0;
            active_seen   = 0;
            for (i = 0; i < 80; i = i + 1) begin
                @(posedge clk); #1;
                if (chirp_active) active_seen = 1;
                if (chirp_done)   saw_done_seen = 1;
            end
            if (!active_seen) begin
                $display("FAIL: chirp_active never asserted in SAW");
                err_count = err_count + 1;
            end
            if (!saw_done_seen) begin
                $display("FAIL: chirp_done never pulsed in SAW");
                err_count = err_count + 1;
            end
            if (chirp_active !== 1'b0) begin
                $display("FAIL: chirp_active not 0 after SAW done");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 5: SAW delta_phase ramp (internal probe)
        // ============================================================
        $display("--- Test 5: SAW ramp values ---");
        begin
            integer ramp_ok;
            do_reset;
            spi_write32(7'h04, 32'd1000);
            spi_write32(7'h08, 32'd31000);
            spi_write32(7'h0C, 32'd1000);
            spi_write24(7'h10, 24'd30);     // N=30
            spi_write8(7'h02, 8'h01);
            pulse_io_update;
            pulse_start;
            clk_wait(5);

            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clk); #1;
                dp_log[i] = dut.u_freq.delta_phase;
            end

            // verify we see consecutive steps of 1000 somewhere in the log
            ramp_ok = 0;
            for (i = 0; i < 9; i = i + 1) begin
                if (dp_log[i+1] == dp_log[i] + 32'd1000 &&
                    dp_log[i] >= 32'd1000 && dp_log[i] != 32'd0)
                    ramp_ok = 1;
            end
            if (!ramp_ok) begin
                $display("FAIL: SAW ramp not found");
                $display("  log: %0d %0d %0d %0d %0d %0d %0d %0d %0d %0d",
                    dp_log[0], dp_log[1], dp_log[2], dp_log[3], dp_log[4],
                    dp_log[5], dp_log[6], dp_log[7], dp_log[8], dp_log[9]);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 6: HOP mode
        // ============================================================
        $display("--- Test 6: HOP mode ---");
        begin
            reg [PHASE_W-1:0] dp_val;
            do_reset;
            spi_write32(7'h04, 32'd1000);
            spi_write32(7'h08, 32'd9000);
            spi_write8(7'h02, 8'h03);       // HOP
            pulse_io_update;
            pulse_start;
            clk_wait(15);

            dp_val = dut.u_freq.delta_phase;
            if (dp_val !== 32'd1000) begin
                $display("FAIL: HOP init dp=%0d exp=1000", dp_val);
                err_count = err_count + 1;
            end

            freq_sel = 1;
            pulse_freq_trigger;
            clk_wait(10);
            dp_val = dut.u_freq.delta_phase;
            if (dp_val !== 32'd9000) begin
                $display("FAIL: HOP→B dp=%0d exp=9000", dp_val);
                err_count = err_count + 1;
            end

            freq_sel = 0;
            pulse_freq_trigger;
            clk_wait(10);
            dp_val = dut.u_freq.delta_phase;
            if (dp_val !== 32'd1000) begin
                $display("FAIL: HOP→A dp=%0d exp=1000", dp_val);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 7: QPSK — phase offset mux
        // ============================================================
        $display("--- Test 7: QPSK ---");
        begin
            reg [TRUNC_W-1:0] po_0, po_1, po_2, po_3;
            do_reset;
            spi_write32(7'h04, 32'h0800_0000);  // FTW_A
            spi_write16(7'h20, 16'h0000);  // POW[0]
            spi_write16(7'h22, 16'h4000);  // POW[1]
            spi_write16(7'h24, 16'h8000);  // POW[2]
            spi_write16(7'h26, 16'hC000);  // POW[3]
            spi_write8(7'h02, 8'h00);           // CW
            pulse_io_update;
            pulse_start;
            clk_wait(15);

            pow_sel = 2'd0; clk_wait(10);
            po_0 = dut.u_dp.pow_off;

            pow_sel = 2'd1; clk_wait(10);
            po_1 = dut.u_dp.pow_off;

            pow_sel = 2'd2; clk_wait(10);
            po_2 = dut.u_dp.pow_off;

            pow_sel = 2'd3; clk_wait(10);
            po_3 = dut.u_dp.pow_off;

            if (po_0 !== 12'h000) begin
                $display("FAIL: POW[0]=%03x exp=000", po_0);
                err_count = err_count + 1;
            end
            if (po_1 !== 12'h400) begin
                $display("FAIL: POW[1]=%03x exp=400", po_1);
                err_count = err_count + 1;
            end
            if (po_2 !== 12'h800) begin
                $display("FAIL: POW[2]=%03x exp=800", po_2);
                err_count = err_count + 1;
            end
            if (po_3 !== 12'hC00) begin
                $display("FAIL: POW[3]=%03x exp=C00", po_3);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 8: TRI chirp
        // ============================================================
        $display("--- Test 8: TRI chirp ---");
        begin
            integer done_count, active_seen;
            do_reset;
            spi_write32(7'h04, 32'd100);
            spi_write32(7'h08, 32'd2100);
            spi_write32(7'h0C, 32'd100);
            spi_write24(7'h10, 24'd20);     // N=20
            spi_write8(7'h02, 8'h02);       // TRI
            pulse_io_update;
            pulse_start;

            done_count  = 0;
            active_seen = 0;
            for (i = 0; i < 100; i = i + 1) begin
                @(posedge clk); #1;
                if (chirp_active) active_seen = 1;
                if (chirp_done)   done_count = done_count + 1;
            end
            if (!active_seen) begin
                $display("FAIL: TRI chirp_active never asserted");
                err_count = err_count + 1;
            end
            if (done_count !== 1) begin
                $display("FAIL: TRI done_count=%0d exp=1", done_count);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 9: SAW auto-restart — multiple done pulses
        // ============================================================
        $display("--- Test 9: SAW auto-restart ---");
        begin
            integer done_count;
            do_reset;
            spi_write32(7'h04, 32'd0);
            spi_write32(7'h08, 32'd2000);
            spi_write32(7'h0C, 32'd100);
            spi_write24(7'h10, 24'd20);     // N=20
            spi_write8(7'h02, 8'h05);       // SAW + auto_restart
            pulse_io_update;
            pulse_start;

            done_count = 0;
            for (i = 0; i < 120; i = i + 1) begin
                @(posedge clk); #1;
                if (chirp_done) done_count = done_count + 1;
            end
            if (done_count < 2) begin
                $display("FAIL: auto-restart done_count=%0d exp>=2", done_count);
                err_count = err_count + 1;
            end
            if (chirp_active !== 1'b1) begin
                $display("FAIL: chirp_active not held high with auto_restart");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 10: SAW with N=0 — should NOT enter RUN
        // ============================================================
        $display("--- Test 10: SAW N=0 guard ---");
        begin
            integer active_seen;
            do_reset;
            spi_write32(7'h04, 32'd100);
            spi_write32(7'h08, 32'd500);
            spi_write32(7'h0C, 32'd100);
            spi_write24(7'h10, 24'd0);      // N=0
            spi_write8(7'h02, 8'h01);       // SAW
            pulse_io_update;
            pulse_start;

            active_seen = 0;
            for (i = 0; i < 30; i = i + 1) begin
                @(posedge clk); #1;
                if (chirp_active) active_seen = 1;
            end
            if (active_seen) begin
                $display("FAIL: chirp_active asserted with N=0");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 11: io_update blocked during active chirp
        // ============================================================
        $display("--- Test 11: gated io_update ---");
        begin
            reg [PHASE_W-1:0] step_before, step_after;
            do_reset;
            // configure a long chirp
            spi_write32(7'h04, 32'd100);
            spi_write32(7'h08, 32'd10100);
            spi_write32(7'h0C, 32'd100);    // step=100
            spi_write24(7'h10, 24'd100);    // N=100 — long ramp
            spi_write8(7'h02, 8'h01);       // SAW
            pulse_io_update;
            pulse_start;
            clk_wait(15);

            // chirp should be active now — capture current step
            step_before = dut.u_freq.step_reg;

            // write a different step via SPI and io_update while chirp runs
            spi_write32(7'h0C, 32'd999);   // new step
            pulse_io_update;
            clk_wait(10);

            // step should NOT have changed — io_update was gated
            step_after = dut.u_freq.step_reg;
            if (step_after !== step_before) begin
                $display("FAIL: step changed during chirp: %0d → %0d",
                         step_before, step_after);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 12: POW updates during active chirp (NOT gated)
        // ============================================================
        $display("--- Test 12: POW update during chirp ---");
        begin
            reg [15:0] pow_before, pow_after;
            do_reset;
            spi_write32(7'h04, 32'd100);
            spi_write32(7'h08, 32'd10100);
            spi_write32(7'h0C, 32'd100);
            spi_write24(7'h10, 24'd100);
            spi_write16(7'h20, 16'hAAAA);  // POW[0] initial
            spi_write8(7'h02, 8'h01);
            pulse_io_update;
            pulse_start;
            clk_wait(15);

            // chirp should be active — capture POW[0] in active domain
            pow_before = dut.act_pow_0;

            // write new POW[0] and io_update while chirp runs
            spi_write16(7'h20, 16'h5555);
            pulse_io_update;
            clk_wait(10);

            pow_after = dut.act_pow_0;
            if (pow_after === pow_before) begin
                $display("FAIL: POW did not update during chirp");
                err_count = err_count + 1;
            end
            if (pow_after !== 16'h5555) begin
                $display("FAIL: POW=%04x exp=5555", pow_after);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 13: phase_rst_on_start
        // ============================================================
        $display("--- Test 13: phase_rst_on_start ---");
        begin
            reg [PHASE_W-1:0] phi_before, phi_after;
            do_reset;
            // CW mode with moderate FTW (avoid wrap during re-accumulation)
            spi_write32(7'h04, 32'h0100_0000);
            spi_write8(7'h02, 8'h00);       // CW, no phase_rst
            pulse_io_update;
            pulse_start;
            clk_wait(50);

            // phase should be non-zero
            phi_before = dut.u_dp.phi_binary;
            if (phi_before === 32'd0) begin
                $display("FAIL: phi should be non-zero before reset test");
                err_count = err_count + 1;
            end

            // enable phase_rst_on_start (CTRL bit 3)
            spi_write8(7'h02, 8'h08);       // CW + phase_rst_on_start
            pulse_io_update;
            pulse_start;
            clk_wait(10);

            // phase should have been reset to 0 on start, then re-accumulated
            // a few cycles.  With FTW=0x0100_0000 and ~15 cycles:
            // phi_after ~ 15 * 0x0100_0000 = 0x0F00_0000 << phi_before
            phi_after = dut.u_dp.phi_binary;
            if (phi_after >= phi_before) begin
                $display("FAIL: phase_rst_on_start did not reset: before=%08x after=%08x",
                         phi_before, phi_after);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 14: sync_in resets phase accumulator
        // ============================================================
        $display("--- Test 14: sync_in ---");
        begin
            reg [PHASE_W-1:0] phi_val;
            do_reset;
            spi_write32(7'h04, 32'h1000_0000);
            spi_write8(7'h02, 8'h00);       // CW
            pulse_io_update;
            pulse_start;
            clk_wait(30);

            phi_val = dut.u_dp.phi_binary;
            if (phi_val === 32'd0) begin
                $display("FAIL: phi should be non-zero before sync");
                err_count = err_count + 1;
            end

            // fire sync_in
            sync_in = 1; #(CLK_P * 5);
            sync_in = 0; #(CLK_P * 5);
            clk_wait(2);

            // phi should have been zeroed by sync, then re-accumulated a few cycles.
            // Capture and verify it's much less than what we had before sync.
            phi_val = dut.u_dp.phi_binary;
            // after sync_edge (3 cycles) + reset (1 cycle) + ~2 clocks of re-accumulation
            // phi ~ few * 0x10000000.  Before sync it was ~35 clocks worth.
            // Use 15 clocks as generous upper bound.
            if (phi_val > (32'h1000_0000 * 15)) begin
                $display("FAIL: sync_in did not reset phi: %08x", phi_val);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 15: Negative-step SAW (down-chirp)
        //  ftw_a > ftw_b, step is two's complement negative.
        //  Verifies unsigned addition wraps correctly for down-ramps.
        // ============================================================
        $display("--- Test 15: Negative SAW (down-chirp) ---");
        begin
            reg [PHASE_W-1:0] dp_first, dp_mid;
            integer done_seen;
            do_reset;
            // ftw_a = 50000, ftw_b = 10000, step = -1000 = 0xFFFFFC18
            // N=40: 40 steps of -1000 covers 40000 of the 40000 range
            spi_write32(7'h04, 32'd50000);       // FTW_A (high)
            spi_write32(7'h08, 32'd10000);       // FTW_B (low)
            spi_write32(7'h0C, 32'hFFFF_FC18);   // CHIRP_STEP = -1000 two's complement
            spi_write24(7'h10, 24'd40);          // N=40
            spi_write8(7'h02, 8'h01);            // SAW
            pulse_io_update;
            pulse_start;

            // wait for ramp to start (sync_edge 3 + start_d 1 + freq_ctrl 1 = ~5 cycles)
            // plus pulse_start overhead (~10 CLK). Total ~15 from pulse_start call.
            clk_wait(8);

            // capture first — should be near ftw_a or just started ramping down
            dp_first = dut.u_freq.delta_phase;

            // let it ramp more
            clk_wait(15);
            dp_mid = dut.u_freq.delta_phase;

            // dp should be decreasing
            if (dp_mid >= dp_first) begin
                $display("FAIL: down-chirp not decreasing: first=%0d mid=%0d", dp_first, dp_mid);
                err_count = err_count + 1;
            end

            // wait for completion
            done_seen = 0;
            for (i = 0; i < 80; i = i + 1) begin
                @(posedge clk); #1;
                if (chirp_done) done_seen = 1;
            end

            if (!done_seen) begin
                $display("FAIL: down-chirp done never fired");
                err_count = err_count + 1;
            end
            // final should be ftw_b = 10000 (force-load at terminal)
            if (dut.u_freq.delta_phase !== 32'd10000) begin
                $display("FAIL: down-chirp terminal dp=%0d exp=10000", dut.u_freq.delta_phase);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 16: Simultaneous freq_trigger + pow_sel change
        //  Both happen on same edge.  Verify both take effect.
        // ============================================================
        $display("--- Test 16: Simultaneous freq + pow_sel ---");
        begin
            reg [PHASE_W-1:0] dp_val;
            reg [TRUNC_W-1:0] po_val;
            do_reset;
            spi_write32(7'h04, 32'd1000);       // FTW_A
            spi_write32(7'h08, 32'd9000);       // FTW_B
            spi_write16(7'h20, 16'h0000);  // POW[0]
            spi_write16(7'h22, 16'h8000);  // POW[1] = pi
            spi_write8(7'h02, 8'h03);           // HOP
            pulse_io_update;
            pulse_start;
            clk_wait(15);

            // initial state: dp=ftw_a=1000, offset=0 (pow_sel=0)
            dp_val = dut.u_freq.delta_phase;
            if (dp_val !== 32'd1000) begin
                $display("FAIL: T16 init dp=%0d exp=1000", dp_val);
                err_count = err_count + 1;
            end

            // fire freq_trigger and change pow_sel simultaneously
            freq_sel = 1;
            pow_sel = 2'd1;
            freq_trigger_pin = 1;
            #(CLK_P * 5);
            freq_trigger_pin = 0;
            clk_wait(15);

            // freq should have hopped to ftw_b
            dp_val = dut.u_freq.delta_phase;
            if (dp_val !== 32'd9000) begin
                $display("FAIL: T16 freq hop dp=%0d exp=9000", dp_val);
                err_count = err_count + 1;
            end
            // phase offset should be POW[1] (top 12 bits of 0x8000_0000 = 0x800)
            po_val = dut.u_dp.pow_off;
            if (po_val !== 12'h800) begin
                $display("FAIL: T16 pow offset=%03x exp=800", po_val);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 17: POW change affects DAC output
        //  Verify new POW value propagates through pipeline to DAC.
        // ============================================================
        $display("--- Test 17: POW affects DAC ---");
        begin
            reg [DAC_SW_W-1:0] dac_i_a, dac_i_b;
            do_reset;
            // CW carrier with known FTW
            spi_write32(7'h04, 32'h0800_0000);  // FTW_A = Fclk/8
            spi_write16(7'h20, 16'h0000);  // POW[0] = 0
            spi_write16(7'h22, 16'h8000);  // POW[1] = pi (inverts sine)
            spi_write8(7'h02, 8'h00);           // CW
            pulse_io_update;
            pulse_start;

            // select POW[0] via pow_sel
            pow_sel = 2'd0;
            clk_wait(30);

            // capture DAC output with offset = 0
            @(posedge clk); #1;
            dac_i_a = dac_i;

            // switch to POW[1] = pi via pow_sel
            pow_sel = 2'd1;
            // wait for CDC + pipeline flush (2 CDC + 4 stages)
            clk_wait(10);

            // capture DAC output with offset = pi
            @(posedge clk); #1;
            dac_i_b = dac_i;

            // the two captures must differ — pi offset inverts the sine
            if (dac_i_a === dac_i_b) begin
                $display("FAIL: POW change did not affect DAC: both=%036b", dac_i_a);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 18: Mode change in RUN via SPI (system-level)
        //  Enter HOP, change mode to CW via SPI+io_update, verify
        //  FSM returns to IDLE.
        // ============================================================
        $display("--- Test 18: Mode change in RUN (system) ---");
        begin
            do_reset;
            spi_write32(7'h04, 32'd1000);
            spi_write32(7'h08, 32'd5000);
            spi_write8(7'h02, 8'h03);           // HOP
            pulse_io_update;
            pulse_start;
            clk_wait(15);

            // should be in RUN (HOP)
            if (dut.u_freq.state !== 1'b1) begin
                $display("FAIL: T18 not in RUN after HOP start");
                err_count = err_count + 1;
            end

            // change mode to CW via SPI + io_update
            spi_write8(7'h02, 8'h00);           // CW
            pulse_io_update;
            clk_wait(10);

            // FSM should have detected mode != run_mode → IDLE
            if (dut.u_freq.state !== 1'b0) begin
                $display("FAIL: T18 FSM not IDLE after mode change, state=%b",
                         dut.u_freq.state);
                err_count = err_count + 1;
            end

            // can start CW cleanly
            pulse_start;
            clk_wait(10);
            if (dut.u_freq.delta_phase !== 32'd1000) begin
                $display("FAIL: T18 CW start dp=%0d exp=1000", dut.u_freq.delta_phase);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  AMPLITUDE TESTS
        //
        //  Expected behavior:
        //    AMP[k] is a 16-bit unsigned amplitude word per symbol.
        //    AMP = 0xFFFF → unity gain (output same as without multiply).
        //    AMP = 0x0000 → mute (DAC = MIDSCALE_SW, constant).
        //    AMP = 0x8000 → half scale (oscillation at ~50% swing).
        //    AMP registers at addresses 0x30-0x37, little-endian 16-bit.
        //    AMP[amp_idx] latched on amp_trigger.
        //    Default after reset: 0xFFFF (unity) — existing tests unaffected.
        //
        //  These tests are RTL-independent: they observe DAC pin behavior
        //  only.  No internal probes.
        // ============================================================

        // ============================================================
        //  Test 19: AMP = 0xFFFF (unity) — DAC oscillates normally
        // ============================================================
        $display("--- Test 19: AMP unity passthrough ---");
        begin
            integer stuck;
            do_reset;
            spi_write32(7'h04, 32'h0800_0000);  // FTW_A = Fclk/8 (fast osc)
            spi_write16(7'h20, 16'h0000);  // POW[0] = 0
            spi_write16(7'h30, 16'hFFFF);        // AMP[0] = unity
            spi_write8(7'h02, 8'h00);            // CW
            pulse_io_update;
            pulse_start;

            // load symbol 0
            pow_sel = 2'd0;
            amp_idx = 2'd0;
            pulse_amp_trigger;
            clk_wait(30);

            // verify oscillation — snapshot, wait, compare
            @(posedge clk); #1;
            snap_i = dac_i;
            clk_wait(4);
            stuck = (dac_i === snap_i);
            if (stuck) begin
                $display("FAIL: T19 DAC stuck at unity AMP");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 20: AMP = 0x0000 (mute) — DAC locked to midscale
        // ============================================================
        $display("--- Test 20: AMP mute ---");
        begin
            integer is_midscale;
            do_reset;
            spi_write32(7'h04, 32'h0800_0000);  // FTW_A (fast tone)
            spi_write16(7'h20, 16'h0000);  // POW[0] = 0
            spi_write16(7'h30, 16'h0000);        // AMP[0] = mute
            spi_write8(7'h02, 8'h00);            // CW
            pulse_io_update;
            pulse_start;

            pow_sel = 2'd0;
            amp_idx = 2'd0;
            pulse_amp_trigger;
            clk_wait(30);

            // DAC should be constant at MIDSCALE_SW for several consecutive cycles
            is_midscale = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk); #1;
                if (dac_i !== MIDSCALE_SW || dac_q !== MIDSCALE_SW)
                    is_midscale = 0;
            end
            if (!is_midscale) begin
                $display("FAIL: T20 DAC not midscale at AMP=0 (dac_i=%036b, exp=%036b)",
                         dac_i, MIDSCALE_SW);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 21: AMP half-scale — reduced swing vs unity
        //
        //  Capture the maximum deviation of dac_i from MIDSCALE_SW
        //  over 32 cycles at full amplitude, then at half amplitude.
        //  The half-amplitude deviation must be strictly less.
        // ============================================================
        $display("--- Test 21: AMP half-scale swing ---");
        begin
            reg [DAC_SW_W-1:0] max_dev_full, max_dev_half, dev;
            do_reset;
            spi_write32(7'h04, 32'h0800_0000);  // FTW_A
            spi_write16(7'h20, 16'h0000);  // POW[0]
            spi_write16(7'h30, 16'hFFFF);        // AMP[0] = unity
            spi_write16(7'h32, 16'h8000);        // AMP[1] = half
            spi_write8(7'h02, 8'h00);            // CW
            pulse_io_update;
            pulse_start;

            // measure full amplitude: load AMP[0] via amp_idx=0
            pow_sel = 2'd0;
            amp_idx = 2'd0;
            pulse_amp_trigger;
            clk_wait(30);

            max_dev_full = 0;
            for (i = 0; i < 32; i = i + 1) begin
                @(posedge clk); #1;
                dev = (dac_i > MIDSCALE_SW) ? (dac_i - MIDSCALE_SW)
                                            : (MIDSCALE_SW - dac_i);
                if (dev > max_dev_full)
                    max_dev_full = dev;
            end

            // switch to half amplitude: load AMP[1] via amp_idx=1
            pow_sel = 2'd0;
            amp_idx = 2'd1;
            pulse_amp_trigger;
            clk_wait(30);

            max_dev_half = 0;
            for (i = 0; i < 32; i = i + 1) begin
                @(posedge clk); #1;
                dev = (dac_i > MIDSCALE_SW) ? (dac_i - MIDSCALE_SW)
                                            : (MIDSCALE_SW - dac_i);
                if (dev > max_dev_half)
                    max_dev_half = dev;
            end

            if (max_dev_full == 0) begin
                $display("FAIL: T21 no swing at full amplitude");
                err_count = err_count + 1;
            end else if (max_dev_half >= max_dev_full) begin
                $display("FAIL: T21 half swing (%0d) >= full swing (%0d)",
                         max_dev_half, max_dev_full);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 22: Per-symbol amplitude — two symbols, same phase,
        //  different AMP → different DAC swing.
        // ============================================================
        $display("--- Test 22: Per-symbol amplitude ---");
        begin
            reg [DAC_SW_W-1:0] max_dev_0, max_dev_1, dev;
            do_reset;
            spi_write32(7'h04, 32'h0800_0000);  // FTW_A
            spi_write16(7'h20, 16'h0000);  // POW[0] = 0
            spi_write16(7'h22, 16'h0000);  // POW[1] = 0 (same phase)
            spi_write16(7'h30, 16'hFFFF);        // AMP[0] = full
            spi_write16(7'h32, 16'h4000);        // AMP[1] = quarter
            spi_write8(7'h02, 8'h00);            // CW
            pulse_io_update;
            pulse_start;

            // symbol 0
            pow_sel = 2'd0;
            amp_idx = 2'd0;
            pulse_amp_trigger;
            clk_wait(30);
            max_dev_0 = 0;
            for (i = 0; i < 32; i = i + 1) begin
                @(posedge clk); #1;
                dev = (dac_i > MIDSCALE_SW) ? (dac_i - MIDSCALE_SW)
                                            : (MIDSCALE_SW - dac_i);
                if (dev > max_dev_0) max_dev_0 = dev;
            end

            // symbol 1
            pow_sel = 2'd0;
            amp_idx = 2'd1;
            pulse_amp_trigger;
            clk_wait(30);
            max_dev_1 = 0;
            for (i = 0; i < 32; i = i + 1) begin
                @(posedge clk); #1;
                dev = (dac_i > MIDSCALE_SW) ? (dac_i - MIDSCALE_SW)
                                            : (MIDSCALE_SW - dac_i);
                if (dev > max_dev_1) max_dev_1 = dev;
            end

            if (max_dev_0 == 0) begin
                $display("FAIL: T22 no swing for symbol 0");
                err_count = err_count + 1;
            end else if (max_dev_1 >= max_dev_0) begin
                $display("FAIL: T22 quarter AMP (%0d) >= full AMP (%0d)",
                         max_dev_1, max_dev_0);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 23: QAM-style — different (POW, AMP) per symbol
        //  Two symbols with different phase AND amplitude.
        //  Verify DAC output differs between them.
        // ============================================================
        $display("--- Test 23: QAM POW+AMP ---");
        begin
            reg [DAC_SW_W-1:0] cap_i_0, cap_q_0, cap_i_1, cap_q_1;
            integer same;
            do_reset;
            spi_write32(7'h04, 32'h0800_0000);  // FTW_A
            spi_write16(7'h20, 16'h0000);  // POW[0] = 0
            spi_write16(7'h22, 16'h4000);  // POW[1] = pi/2
            spi_write16(7'h30, 16'hFFFF);        // AMP[0] = full
            spi_write16(7'h32, 16'h8000);        // AMP[1] = half
            spi_write8(7'h02, 8'h00);            // CW
            pulse_io_update;
            pulse_start;

            // capture output for symbol 0
            pow_sel = 2'd0;
            amp_idx = 2'd0;
            pulse_amp_trigger;
            clk_wait(30);
            // wait for a specific phase point (multiple of 8 cycles for Fclk/8)
            clk_wait(8);
            @(posedge clk); #1;
            cap_i_0 = dac_i;
            cap_q_0 = dac_q;

            // capture output for symbol 1 at same relative phase
            pow_sel = 2'd1;
            amp_idx = 2'd1;
            pulse_amp_trigger;
            clk_wait(30);
            clk_wait(8);
            @(posedge clk); #1;
            cap_i_1 = dac_i;
            cap_q_1 = dac_q;

            // both I AND Q must differ (different phase + different amplitude)
            same = (cap_i_0 === cap_i_1) && (cap_q_0 === cap_q_1);
            if (same) begin
                $display("FAIL: T23 QAM symbols identical: I0=%036b Q0=%036b",
                         cap_i_0, cap_q_0);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  WAVEFORM QUALITY TESTS (ported from tb_dds)
        //
        //  These test signal integrity, I/Q correctness, DAC encoding,
        //  and pipeline behaviour using the system-level SPI interface.
        // ============================================================

        // ============================================================
        //  Test 24: CW full swing I and Q
        // ============================================================
        $display("--- Test 24: CW full swing ---");
        begin
            integer mx_i, mn_i, mx_q, mn_q;
            do_reset;
            spi_write32(7'h04, 32'h1000_0000);  // FTW = fclk/16
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(20);

            mx_i = 0; mn_i = 0; mx_q = 0; mn_q = 0;
            for (i = 0; i < 64; i = i + 1) begin
                @(posedge clk); #1;
                if (idiff_i >  800) mx_i = 1;
                if (idiff_i < -800) mn_i = 1;
                if (idiff_q >  800) mx_q = 1;
                if (idiff_q < -800) mn_q = 1;
            end
            if (!(mx_i && mn_i)) begin
                $display("FAIL: T24 I not full swing");
                err_count = err_count + 1;
            end
            if (!(mx_q && mn_q)) begin
                $display("FAIL: T24 Q not full swing");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 25: CW zero crossings — 16 in 64 samples at fclk/8
        // ============================================================
        $display("--- Test 25: CW zero crossings ---");
        begin
            integer zc;
            do_reset;
            spi_write32(7'h04, 32'h2000_0000);  // FTW = fclk/8
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(20);
            capture(64);

            zc = 0;
            for (i = 1; i < 64; i = i + 1)
                if ((cap_i[i] >= 0 && cap_i[i-1] < 0) ||
                    (cap_i[i] < 0  && cap_i[i-1] >= 0))
                    zc = zc + 1;
            if (zc !== 16) begin
                $display("FAIL: T25 zero crossings=%0d exp=16", zc);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 26: Half-wave symmetry — I[n] = -I[n + N/2]
        // ============================================================
        $display("--- Test 26: Half-wave symmetry ---");
        begin
            integer ok_i, ok_q;
            do_reset;
            spi_write32(7'h04, 32'h1000_0000);  // fclk/16
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(20);
            capture(16);

            ok_i = 1; ok_q = 1;
            for (i = 0; i < 8; i = i + 1) begin
                if (cap_i[i] + cap_i[i+8] != 0) ok_i = 0;
                if (cap_q[i] + cap_q[i+8] != 0) ok_q = 0;
            end
            if (!ok_i) begin
                $display("FAIL: T26 I half-wave symmetry broken");
                err_count = err_count + 1;
            end
            if (!ok_q) begin
                $display("FAIL: T26 Q half-wave symmetry broken");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 27: I/Q orthogonality — dot(I,Q) = 0 over one period
        // ============================================================
        $display("--- Test 27: I/Q orthogonality ---");
        begin
            integer dot;
            do_reset;
            spi_write32(7'h04, 32'h1000_0000);  // fclk/16
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(20);
            capture(16);

            dot = 0;
            for (i = 0; i < 16; i = i + 1)
                dot = dot + cap_i[i] * cap_q[i];
            if (dot !== 0) begin
                $display("FAIL: T27 dot(I,Q)=%0d exp=0", dot);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 28: I/Q quadrature — Q near zero when I peaks
        // ============================================================
        $display("--- Test 28: I/Q quadrature ---");
        begin
            integer idx, qval;
            do_reset;
            spi_write32(7'h04, 32'h1000_0000);
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(20);
            capture(16);

            idx = 0;
            for (i = 1; i < 16; i = i + 1)
                if (cap_i[i] > cap_i[idx]) idx = i;
            qval = cap_q[idx];
            if (!(qval > -20 && qval < 20)) begin
                $display("FAIL: T28 Q=%0d at I peak (exp near 0)", qval);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 29: ROM spot-check — sin(0)=0, sin(~90)=PEAK
        // ============================================================
        $display("--- Test 29: ROM spot-check ---");
        begin
            if (dut.u_dp.u_rom.rom[0] !== 0) begin
                $display("FAIL: T29 ROM[0]=%0d exp=0", dut.u_dp.u_rom.rom[0]);
                err_count = err_count + 1;
            end
            if (dut.u_dp.u_rom.rom[(1<<ADDR_W)-1] !== PEAK) begin
                $display("FAIL: T29 ROM[max]=%0d exp=%0d", dut.u_dp.u_rom.rom[(1<<ADDR_W)-1], PEAK);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 30: Output range — |I_diff|, |Q_diff| <= TOTAL_WEIGHT
        // ============================================================
        $display("--- Test 30: Output range ---");
        begin
            integer range_ok;
            do_reset;
            spi_write32(7'h04, 32'h1000_0000);
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(20);

            range_ok = 1;
            for (i = 0; i < 128; i = i + 1) begin
                @(posedge clk); #1;
                if (idiff_i > TOTAL_WEIGHT || idiff_i < -TOTAL_WEIGHT) range_ok = 0;
                if (idiff_q > TOTAL_WEIGHT || idiff_q < -TOTAL_WEIGHT) range_ok = 0;
            end
            if (!range_ok) begin
                $display("FAIL: T30 output exceeds [-1023,+1023]");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 31: Phase accumulator monotonic (small FTW, no wrap)
        // ============================================================
        $display("--- Test 31: Phase accum monotonic ---");
        begin
            reg [PHASE_W-1:0] prev_ph;
            integer mono_ok;
            do_reset;
            spi_write32(7'h04, 32'h0010_0000);  // small FTW
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            clk_wait(15);

            @(posedge clk); #1;
            prev_ph = dut.u_dp.phi_binary;
            mono_ok = 1;
            for (i = 0; i < 64; i = i + 1) begin
                @(posedge clk); #1;
                if (dut.u_dp.phi_binary <= prev_ph) mono_ok = 0;
                prev_ph = dut.u_dp.phi_binary;
            end
            if (!mono_ok) begin
                $display("FAIL: T31 phase accumulator not monotonic");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 32: Q = cos(0) — Q near +PEAK when phase ~ 0
        // ============================================================
        $display("--- Test 32: Q = cos at phase zero ---");
        begin
            do_reset;
            spi_write32(7'h04, 32'h0001_0000);  // very small FTW
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            // wait for phase reset + CDC + pipeline (generous)
            clk_wait(20);

            @(posedge clk); #1;
            if (!(idiff_i > -40 && idiff_i < 40)) begin
                $display("FAIL: T32 I=%0d at start (exp near 0)", idiff_i);
                err_count = err_count + 1;
            end
            if (!(idiff_q > 900)) begin
                $display("FAIL: T32 Q=%0d at start (exp near +PEAK)", idiff_q);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 33: chirp_done is a single-cycle pulse
        // ============================================================
        $display("--- Test 33: chirp_done pulse width ---");
        begin
            integer consecutive, ok;
            do_reset;
            spi_write32(7'h04, 32'h0800_0000);  // FTW_A
            spi_write32(7'h08, 32'h1800_0000);  // FTW_B
            spi_write32(7'h0C, 32'h0010_0000);  // CHIRP_STEP
            spi_write24(7'h10, 24'd16);          // N=16
            spi_write8(7'h02, 8'h05);            // SAW + auto_restart
            pulse_io_update; pulse_start;

            consecutive = 0; ok = 1;
            for (i = 0; i < 512; i = i + 1) begin
                @(posedge clk); #1;
                if (chirp_done) begin
                    consecutive = consecutive + 1;
                    if (consecutive > 1) ok = 0;
                end else begin
                    consecutive = 0;
                end
            end
            if (!ok) begin
                $display("FAIL: T33 chirp_done high for >1 consecutive cycle");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 34: Exact differential symmetry
        //  I_diff(n) = -I_diff(n + N/2) — XOR sign gives exact negation
        // ============================================================
        $display("--- Test 34: Exact differential symmetry ---");
        begin
            integer sym_ok_i, sym_ok_q;
            do_reset;
            spi_write32(7'h04, 32'h1000_0000);  // fclk/16
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(20);
            capture(16);

            sym_ok_i = 1; sym_ok_q = 1;
            for (i = 0; i < 8; i = i + 1) begin
                if (cap_i[i] + cap_i[i+8] != 0) sym_ok_i = 0;
                if (cap_q[i] + cap_q[i+8] != 0) sym_ok_q = 0;
            end
            if (!sym_ok_i) begin
                $display("FAIL: T34 I differential symmetry broken");
                err_count = err_count + 1;
            end
            if (!sym_ok_q) begin
                $display("FAIL: T34 Q differential symmetry broken");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 35: Thermometer code validity — every output must
        //  have contiguous 1s in the thermo field (no DNL spike)
        // ============================================================
        $display("--- Test 35: Thermometer code validity ---");
        begin
            integer bad_cnt, transitions, b;
            reg [N_UNARY_TB-1:0] th;
            do_reset;
            spi_write32(7'h04, 32'h0040_0000);  // slow CW
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(20);

            bad_cnt = 0;
            for (i = 0; i < 256; i = i + 1) begin
                @(posedge clk); #1;
                // I channel
                th = dac_i[DAC_SW_W-1:BINARY_BITS];
                transitions = 0;
                for (b = 1; b < N_UNARY_TB; b = b + 1)
                    if (th[b] != th[b-1]) transitions = transitions + 1;
                if (transitions > 1) bad_cnt = bad_cnt + 1;
                // Q channel
                th = dac_q[DAC_SW_W-1:BINARY_BITS];
                transitions = 0;
                for (b = 1; b < N_UNARY_TB; b = b + 1)
                    if (th[b] != th[b-1]) transitions = transitions + 1;
                if (transitions > 1) bad_cnt = bad_cnt + 1;
            end
            if (bad_cnt != 0) begin
                $display("FAIL: T35 %0d invalid thermo codes", bad_cnt);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 36: Golden-model bitwise check (I channel)
        //  Independently compute expected switch pattern from ROM
        //  contents + quadrant logic + sign XOR, compare bit-for-bit.
        //  Pipeline latency: 4 cycles from phi to dac_i.
        // ============================================================
        $display("--- Test 36: Golden-model bitwise ---");
        begin
            reg [PHASE_W-1:0] ph;
            reg [TRUNC_W-1:0] tr;
            reg               s, f;
            reg [ADDR_W-1:0]  ra, a;
            reg [MAG_W-1:0]   m;
            reg [N_UNARY_TB-1:0] exp_thermo;
            reg [DAC_SW_W-1:0] exp_sw;
            integer mismatch_cnt, b;
            localparam [PHASE_W-1:0] FTW_GM = 32'h0100_0000;  // fclk/256
            do_reset;
            spi_write32(7'h04, FTW_GM);
            spi_write16(7'h20, 16'h0);
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            // skip pipeline fill + CDC
            clk_wait(20);

            mismatch_cnt = 0;
            for (i = 0; i < 256; i = i + 1) begin
                @(posedge clk); #1;
                // dac_i now reflects phi from 4 cycles ago
                ph = dut.u_dp.phi_binary - 4 * FTW_GM;
                tr = ph[PHASE_W-1 -: TRUNC_W];
                s  = tr[TRUNC_W-1];
                f  = tr[TRUNC_W-2];
                ra = tr[ADDR_W-1:0];
                a  = f ? ~ra : ra;
                m  = dut.u_dp.u_rom.rom[a];

                // build expected thermo
                for (b = 0; b < N_UNARY_TB; b = b + 1) begin
                    if (b < MIDSCALE_TB)
                        exp_thermo[b] = 1'b1;
                    else
                        exp_thermo[b] = (m[MAG_W-1:BINARY_BITS] > b - MIDSCALE_TB);
                end

                exp_sw = {exp_thermo, m[BINARY_BITS-1:0]} ^ {DAC_SW_W{s}};

                if (dac_i !== exp_sw) begin
                    mismatch_cnt = mismatch_cnt + 1;
                    if (mismatch_cnt <= 3)
                        $display("    MISMATCH i=%0d ph=%08h: got %09h exp %09h",
                                 i, ph, dac_i, exp_sw);
                end
            end
            if (mismatch_cnt != 0) begin
                $display("FAIL: T36 %0d golden-model mismatches", mismatch_cnt);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 37: Q = I shifted exactly N/4
        //  For fclk/16: Q[n] == I[(n+4) % 16] for every sample.
        // ============================================================
        $display("--- Test 37: Q = I shifted N/4 ---");
        begin
            integer mismatch;
            do_reset;
            spi_write32(7'h04, 32'h1000_0000);  // fclk/16
            spi_write16(7'h20, 16'h0);
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(20);
            capture(16);

            mismatch = 0;
            for (i = 0; i < 16; i = i + 1) begin
                if (cap_q[i] !== cap_i[(i + 4) % 16]) begin
                    mismatch = mismatch + 1;
                    if (mismatch <= 3)
                        $display("    Q[%0d]=%0d != I[%0d]=%0d",
                                 i, cap_q[i], (i+4)%16, cap_i[(i+4)%16]);
                end
            end
            if (mismatch != 0) begin
                $display("FAIL: T37 %0d Q/I shift mismatches", mismatch);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 38: Monotonicity in first quadrant
        //  As phase 0 → π/2, I_diff must never decrease.
        //  Sync phase after starting tone, then capture Q1.
        // ============================================================
        $display("--- Test 38: Q1 monotonicity ---");
        begin
            integer prev_val, curr_val, mono_ok, nsamples, lat_to;
            do_reset;
            // fclk/1024: 256 samples per quadrant
            spi_write32(7'h04, 32'h0040_0000);
            spi_write16(7'h20, 16'h0);
            spi_write8(7'h02, 8'h00);  // CW (no phase_rst_on_start)
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(10);

            // fire sync_in to reset phase to 0 NOW
            sync_in = 1; #(CLK_P * 3);
            sync_in = 0;
            // poll for phi=0
            lat_to = 0;
            while ((dut.u_accum.phi_s !== 0 || dut.u_accum.phi_c !== 0) && lat_to < 30) begin
                @(posedge clk); #1; lat_to = lat_to + 1;
            end
            // 5 posedges so dac_i reflects phi=0 (CSA + 4 datapath stages)
            repeat(5) @(posedge clk);
            #1;

            prev_val = idiff_i;
            mono_ok = 1; nsamples = 0;
            // 240 samples stays well within Q1 (240*4 = 960 < 1024)
            for (i = 0; i < 240; i = i + 1) begin
                @(posedge clk); #1;
                curr_val = idiff_i;
                if (curr_val < prev_val) begin
                    if (mono_ok)
                        $display("    FIRST VIOLATION i=%0d prev=%0d curr=%0d", i, prev_val, curr_val);
                    mono_ok = 0;
                end
                prev_val = curr_val;
                nsamples = nsamples + 1;
            end
            if (!mono_ok) begin
                $display("FAIL: T38 I not monotonic in Q1 (%0d samples)", nsamples);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 39: Exact boundary values
        //  Sync phase to 0 after start.  At fclk/4 (90°/cycle):
        //  sin(0)=+1, sin(90)=+peak, sin(180)=-1, sin(270)=-peak
        // ============================================================
        $display("--- Test 39: Exact boundary values ---");
        begin
            integer boundary_ok, lat_to;
            do_reset;
            spi_write32(7'h04, 32'h4000_0000);  // fclk/4
            spi_write16(7'h20, 16'h0);
            spi_write8(7'h02, 8'h00);  // CW
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(10);

            // fire sync_in to reset phase to 0
            sync_in = 1; #(CLK_P * 3);
            sync_in = 0;
            // poll for phi=0
            lat_to = 0;
            while ((dut.u_accum.phi_s !== 0 || dut.u_accum.phi_c !== 0) && lat_to < 30) begin
                @(posedge clk); #1; lat_to = lat_to + 1;
            end
            // 4 posedges here + capture's first @posedge = 5 = pipeline depth
            repeat(4) @(posedge clk);
            #1;
            capture(4);

            boundary_ok = 1;
            // sin(0): mag=0, sign=0 → I_diff=+1
            if (cap_i[0] != 1) boundary_ok = 0;
            // sin(90): mag=PEAK, sign=0 → I_diff=+1023
            if (!(cap_i[1] > 1010)) boundary_ok = 0;
            // sin(180): mag=0, sign=1, XOR flips → I_diff=-1
            if (cap_i[2] != -1) boundary_ok = 0;
            // sin(270): mag=PEAK, sign=1 → I_diff=-1023
            if (!(cap_i[3] < -1010)) boundary_ok = 0;
            if (!boundary_ok) begin
                $display("FAIL: T39 boundary vals I: %0d %0d %0d %0d",
                         cap_i[0], cap_i[1], cap_i[2], cap_i[3]);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 40: Pipeline latency measurement
        //  Sync resets phi to 0.  Output should reflect phase=0
        //  exactly 4 cycles after phi=0 is registered (4-stage pipe).
        // ============================================================
        $display("--- Test 40: Pipeline latency ---");
        begin
            integer lat_timeout, val_at_0;
            do_reset;
            spi_write32(7'h04, 32'h1000_0000);
            spi_write16(7'h20, 16'h0);
            spi_write8(7'h02, 8'h00);
            pulse_io_update; pulse_start;
            pow_sel = 2'd0;
            clk_wait(30);

            // fire sync to reset phase
            sync_in = 1; #(CLK_P * 5);
            sync_in = 0;
            // wait for phi to hit 0
            lat_timeout = 0;
            while ((dut.u_accum.phi_s !== 0 || dut.u_accum.phi_c !== 0) && lat_timeout < 30) begin
                @(posedge clk); #1; lat_timeout = lat_timeout + 1;
            end
            // phi=0 detected. 4 pipeline stages to output.
            repeat(4) @(posedge clk);  // S0 (CPA) + stages 1-3
            @(posedge clk); #1;         // stage 4 output reg updated
            val_at_0 = idiff_i;
            if (val_at_0 !== 1) begin
                $display("FAIL: T40 I_diff=%0d at phase=0 (exp 1, midscale)", val_at_0);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 41: Exhaustive mag_to_sw decoder
        //  All 512 magnitudes: valid thermo, correct binary,
        //  correct popcount.
        // ============================================================
        $display("--- Test 41: Exhaustive mag_to_sw ---");
        begin
            integer m, b, bad, transitions, ucount;
            reg [N_UNARY_TB-1:0] dec_unary;

            bad = 0;
            for (m = 0; m < (1 << MAG_W); m = m + 1) begin
                t71_mag = m;
                #1;
                dec_unary = t71_sw[DAC_SW_W-1:BINARY_BITS];

                // valid thermometer: at most 1 transition
                transitions = 0;
                for (b = 1; b < N_UNARY_TB; b = b + 1)
                    if (dec_unary[b] != dec_unary[b-1]) transitions = transitions + 1;
                if (transitions > 1) bad = bad + 1;

                // binary passthrough
                if (t71_sw[BINARY_BITS-1:0] !== m[BINARY_BITS-1:0]) bad = bad + 1;

                // popcount(unary) = MIDSCALE + mag[8:5]
                ucount = 0;
                for (b = 0; b < N_UNARY_TB; b = b + 1)
                    if (dec_unary[b]) ucount = ucount + 1;
                if (ucount !== MIDSCALE_TB + m[MAG_W-1:BINARY_BITS]) bad = bad + 1;
            end
            if (bad != 0) begin
                $display("FAIL: T41 %0d decoder errors across 512 magnitudes", bad);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  REFACTOR-SAFETY TESTS
        //
        //  These close the coverage gap for freq_ctrl structural
        //  changes.  They verify cycle-exact behavior that existing
        //  tests only check approximately.
        // ============================================================

        // ============================================================
        //  Test 42: SAW exact cycle count
        //  Count cycles where chirp_active == 1.  Verify == N.
        //  First active delta_phase == ftw_a.
        //  delta_phase at chirp_done == ftw_b.
        // ============================================================
        $display("--- Test 42: SAW exact cycle count ---");
        begin
            localparam [PHASE_W-1:0] T42_FTW_A = 32'd1000;
            localparam [PHASE_W-1:0] T42_FTW_B = 32'd11000;
            localparam [PHASE_W-1:0] T42_STEP  = 32'd1000;
            localparam integer       T42_N     = 10;
            integer active_count, done_seen;
            reg [PHASE_W-1:0] dp_first, dp_at_done;
            reg got_first;
            do_reset;
            spi_write32(7'h04, T42_FTW_A);
            spi_write32(7'h08, T42_FTW_B);
            spi_write32(7'h0C, T42_STEP);
            spi_write24(7'h10, T42_N);
            spi_write8(7'h02, 8'h01);           // SAW, no restart
            pulse_io_update;

            // drive start manually and monitor from the beginning
            active_count = 0;
            done_seen = 0;
            got_first = 0;
            dp_first = 0;
            dp_at_done = 0;
            start_pin = 1;
            for (i = 0; i < 60; i = i + 1) begin
                @(posedge clk); #1;
                if (i == 5) start_pin = 0;
                if (dut.u_freq.chirp_active) begin
                    active_count = active_count + 1;
                    if (!got_first) begin
                        dp_first = dut.u_freq.delta_phase;
                        got_first = 1;
                    end
                end
                if (dut.u_freq.chirp_done) begin
                    done_seen = 1;
                    dp_at_done = dut.u_freq.delta_phase;
                end
            end
            start_pin = 0;
            if (!done_seen) begin
                $display("FAIL: T42 chirp_done never fired");
                err_count = err_count + 1;
            end
            if (active_count !== T42_N) begin
                $display("FAIL: T42 active cycles=%0d exp=%0d", active_count, T42_N);
                err_count = err_count + 1;
            end
            if (dp_first !== T42_FTW_A) begin
                $display("FAIL: T42 first dp=%0d exp=%0d", dp_first, T42_FTW_A);
                err_count = err_count + 1;
            end
            if (dp_at_done !== T42_FTW_B) begin
                $display("FAIL: T42 dp at done=%0d exp=%0d", dp_at_done, T42_FTW_B);
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 43: Hold stability after SAW completion
        //  After SAW finishes (no restart), delta_phase must hold
        //  at ftw_b with zero drift.  Catches "one extra add" bugs
        //  where step_reg isn't cleared on exit.
        // ============================================================
        $display("--- Test 43: Hold stability after SAW ---");
        begin
            localparam [PHASE_W-1:0] T43_FTW_A = 32'd2000;
            localparam [PHASE_W-1:0] T43_FTW_B = 32'd12000;
            localparam [PHASE_W-1:0] T43_STEP  = 32'd500;
            localparam integer       T43_N     = 20;
            reg [PHASE_W-1:0] dp_hold;
            integer hold_ok;
            do_reset;
            spi_write32(7'h04, T43_FTW_A);
            spi_write32(7'h08, T43_FTW_B);
            spi_write32(7'h0C, T43_STEP);
            spi_write24(7'h10, T43_N);
            spi_write8(7'h02, 8'h01);           // SAW, no restart
            pulse_io_update;
            pulse_start;

            // wait for chirp_done
            for (i = 0; i < 100; i = i + 1) begin
                @(posedge clk); #1;
                if (dut.u_freq.chirp_done) i = 100;
            end

            // delta_phase should be ftw_b and HOLD for 30 cycles
            @(posedge clk); #1;
            dp_hold = dut.u_freq.delta_phase;
            hold_ok = 1;
            for (i = 0; i < 30; i = i + 1) begin
                @(posedge clk); #1;
                if (dut.u_freq.delta_phase !== dp_hold) begin
                    if (hold_ok)
                        $display("    DRIFT at cycle %0d: %0d -> %0d",
                                 i, dp_hold, dut.u_freq.delta_phase);
                    hold_ok = 0;
                end
            end
            if (dp_hold !== T43_FTW_B) begin
                $display("FAIL: T43 hold value=%0d exp=%0d", dp_hold, T43_FTW_B);
                err_count = err_count + 1;
            end
            if (!hold_ok) begin
                $display("FAIL: T43 delta_phase drifted after SAW completion");
                err_count = err_count + 1;
            end
        end

        // ============================================================
        //  Test 44: TRI turnaround probe
        //  Capture delta_phase across the top turnaround boundary.
        //  Verify exact 4-sample window:
        //    N-2: ftw_a + (N-2)*step   (pre-apex - 1)
        //    N-1: ftw_a + (N-1)*step   (pre-apex)
        //    N:   ftw_b                (force-loaded apex)
        //    N+1: ftw_b - step         (first reversal)
        //  Verify step consistency: each pair differs by exactly step.
        // ============================================================
        $display("--- Test 44: TRI turnaround probe ---");
        begin
            localparam [PHASE_W-1:0] T44_FTW_A2 = 32'd1000;
            localparam [PHASE_W-1:0] T44_FTW_B2 = 32'd11000;
            localparam [PHASE_W-1:0] T44_STEP2  = 32'd1000;
            localparam integer       T44_N2     = 10;
            localparam [PHASE_W-1:0] T44_EXP_0 = 32'd9000;   // N-2
            localparam [PHASE_W-1:0] T44_EXP_1 = 32'd10000;  // N-1
            localparam [PHASE_W-1:0] T44_EXP_2 = 32'd11000;  // apex
            localparam [PHASE_W-1:0] T44_EXP_3 = 32'd10000;  // reversal
            reg [PHASE_W-1:0] trail_0, trail_1, trail_2, trail_3;
            integer found;
            do_reset;
            spi_write32(7'h04, T44_FTW_A2);
            spi_write32(7'h08, T44_FTW_B2);
            spi_write32(7'h0C, T44_STEP2);
            spi_write24(7'h10, T44_N2);
            spi_write8(7'h02, 8'h02);           // TRI, no restart
            pulse_io_update;

            // drive start manually and monitor from the beginning
            found = 0;
            trail_0 = 0; trail_1 = 0; trail_2 = 0; trail_3 = 0;
            start_pin = 1;
            for (i = 0; i < 60 && !found; i = i + 1) begin
                @(posedge clk); #1;
                if (i == 5) start_pin = 0;
                trail_0 = trail_1;
                trail_1 = trail_2;
                trail_2 = trail_3;
                trail_3 = dut.u_freq.delta_phase;

                // when trail_2 = apex, trail_3 already has post-apex
                if (trail_2 == T44_FTW_B2 && i > 8)
                    found = 1;
            end

            start_pin = 0;
            if (!found) begin
                $display("FAIL: T44 apex never detected");
                err_count = err_count + 1;
            end else begin
                // trail_0 = 2 before apex, trail_1 = 1 before apex,
                // trail_2 = apex, trail_3 = 1 after apex
                if (trail_0 !== T44_EXP_0) begin
                    $display("FAIL: T44 win[N-2]=%0d exp=%0d", trail_0, T44_EXP_0);
                    err_count = err_count + 1;
                end
                if (trail_1 !== T44_EXP_1) begin
                    $display("FAIL: T44 win[N-1]=%0d exp=%0d", trail_1, T44_EXP_1);
                    err_count = err_count + 1;
                end
                if (trail_2 !== T44_EXP_2) begin
                    $display("FAIL: T44 apex=%0d exp=%0d", trail_2, T44_EXP_2);
                    err_count = err_count + 1;
                end
                if (trail_3 !== T44_EXP_3) begin
                    $display("FAIL: T44 reversal=%0d exp=%0d", trail_3, T44_EXP_3);
                    err_count = err_count + 1;
                end
                // verify step consistency: each pair differs by exactly step
                // except apex load (trail_1 → trail_2 jumps by step to ftw_b)
                if (trail_1 - trail_0 !== T44_STEP2) begin
                    $display("FAIL: T44 step before apex: %0d", trail_1 - trail_0);
                    err_count = err_count + 1;
                end
                if (trail_2 - trail_1 !== T44_STEP2) begin
                    $display("FAIL: T44 step into apex: %0d", trail_2 - trail_1);
                    err_count = err_count + 1;
                end
                if (trail_2 - trail_3 !== T44_STEP2) begin
                    $display("FAIL: T44 step out of apex: %0d", trail_2 - trail_3);
                    err_count = err_count + 1;
                end
            end
        end

        // ============================================================
        //  Summary
        // ============================================================
        #(CLK_P * 10);
        $display("========================================");
        if (err_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILED: %0d errors", err_count);
        $display("========================================");
        $finish;
    end

endmodule
