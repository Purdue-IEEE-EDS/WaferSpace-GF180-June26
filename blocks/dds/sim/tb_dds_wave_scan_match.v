`default_nettype none
`timescale 1ns/1ps

module tb_dds_wave_scan_match;

    localparam PHASE_W        = 32;
    localparam TRUNC_W        = 12;
    localparam UNARY_BITS     = 5;
    localparam BINARY_BITS    = 5;
    localparam COUNT_W        = 20;
    localparam LANES          = 4;
    localparam DAC_SW_W       = (1 << UNARY_BITS) - 1 + BINARY_BITS;
    localparam MAG_W          = UNARY_BITS + BINARY_BITS - 1;
    localparam ADDR_W         = TRUNC_W - 2;
    localparam ROM_DEPTH      = 1 << ADDR_W;
    localparam PIPE_LATENCY   = 11;
    localparam PHASE_BLOCKS   = 16;
    localparam CODE_WARMUP    = 0;
    localparam CODE_SAMPLES   = 1024;

    localparam CLK_P          = 2.0;
    localparam SCLK_P         = 20.0;

    localparam N_UNARY        = (1 << UNARY_BITS) - 1;
    localparam MIDSCALE       = 1 << (UNARY_BITS - 1);
    localparam [DAC_SW_W-1:0] MIDSCALE_SW =
        {{(N_UNARY - MIDSCALE){1'b0}}, {MIDSCALE{1'b1}}, {BINARY_BITS{1'b0}}};

    localparam [PHASE_W-1:0] FTW_CW_LO              = 32'h0800_0000; // 15.625 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_HI              = 32'h1800_0000; // 46.875 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_FRAC_5MHZ       = 32'h028F_5C29; // 5.000000005 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_FRAC_37MHZ      = 32'h12F1_A9FC; // 37.000000011 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_FRAC_67P42MHZ   = 32'h2284_DFCE; // 67.419999978 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_75MHZ           = 32'h2666_6666; // 74.999999953 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_100MHZ          = 32'h3333_3333; // 99.999999977 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_FRAC_123P456789 = 32'h3F35_BA6E; // 123.456788948 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_175MHZ          = 32'h5999_999A; // 175.000000047 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_FRAC_211P75MHZ  = 32'h6C6A_7EFA; // 211.750000017 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_FRAC_237P125MHZ = 32'h7968_72B0; // 237.124999985 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_240MHZ          = 32'h7AE1_47AE; // 239.999999991 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_245MHZ          = 32'h7D70_A3D7; // 244.999999995 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_FRAC_248P75MHZ  = 32'h7F5C_28F6; // 248.750000028 MHz @ 500 MS/s
    localparam [PHASE_W-1:0] FTW_CW_FRAC_249P9MHZ   = 32'h7FF2_E48F; // 249.900000053 MHz @ 500 MS/s

    logic                clk = 1'b0;
    logic                rst_n;
    logic                sclk, csn, mosi, miso;
    logic                io_update, sync_in;
    logic [DAC_SW_W-1:0] dac_i, dac_q;

    logic [PHASE_W-1:0] scenario_ftw;
    logic [PHASE_W-1:0] scenario_step;

    logic [MAG_W-1:0] rom [0:ROM_DEPTH-1];

    logic [PHASE_W-1:0] exp_phase_base;
    logic [PHASE_W-1:0] exp_ftw_x2, exp_ftw_x3, exp_ftw_x4;
    logic [PHASE_W-1:0] exp_step_x3, exp_step_x6;
    logic [LANES-1:0][PHASE_W-1:0] exp_phase_vec_cur;

    logic [LANES-1:0][PHASE_W-1:0] phase_pipe [0:PIPE_LATENCY-1];
    logic [LANES-1:0][DAC_SW_W-1:0] code_i_pipe [0:PIPE_LATENCY-1];
    logic [LANES-1:0][DAC_SW_W-1:0] code_q_pipe [0:PIPE_LATENCY-1];

    logic [1:0] gold_ser_lane;
    logic       gold_load_dout;
    logic       gold_load_sh1;
    logic       gold_load_sh2;
    logic       gold_load_sh3;

    logic [DAC_SW_W-1:0] gold_ser_i;
    logic [DAC_SW_W-1:0] gold_ser_q;
    logic [DAC_SW_W-1:0] gold_sh1_i, gold_sh2_i, gold_sh3_i;
    logic [DAC_SW_W-1:0] gold_sh1_q, gold_sh2_q, gold_sh3_q;
    logic [PHASE_W-1:0]  gold_ser_phase;
    logic [PHASE_W-1:0]  gold_sh1_phase, gold_sh2_phase, gold_sh3_phase;

    integer err_count = 0;
    integer cmp_fd;
    integer lane_idx;
    integer stage_idx;

    always #(CLK_P/2) clk = ~clk;

    dds_top #(
        .PHASE_W(PHASE_W),
        .TRUNC_W(TRUNC_W),
        .UNARY_BITS(UNARY_BITS),
        .BINARY_BITS(BINARY_BITS),
        .COUNT_W(COUNT_W)
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

    initial begin
    `include "./rtl/datapath/sine_lut_init.v"
    end

    assign exp_ftw_x2  = scenario_ftw << 1;
    assign exp_ftw_x3  = (scenario_ftw << 1) + scenario_ftw;
    assign exp_ftw_x4  = scenario_ftw << 2;
    assign exp_step_x3 = (scenario_step << 1) + scenario_step;
    assign exp_step_x6 = (scenario_step << 2) + (scenario_step << 1);

    always_comb begin
        exp_phase_vec_cur[0] = exp_phase_base;
        exp_phase_vec_cur[1] = exp_phase_base + scenario_ftw;
        exp_phase_vec_cur[2] = exp_phase_base + exp_ftw_x2 + scenario_step;
        exp_phase_vec_cur[3] = exp_phase_base + exp_ftw_x3 + exp_step_x3;
    end

    function automatic [DAC_SW_W-1:0] mag_to_sw(input logic [MAG_W-1:0] mag);
        logic [N_UNARY-1:0] unary;
        integer g;
    begin
        for (g = 0; g < N_UNARY; g = g + 1) begin
            if (g < MIDSCALE)
                unary[g] = 1'b1;
            else
                unary[g] = (mag[MAG_W-1:BINARY_BITS] > (g - MIDSCALE));
        end
        mag_to_sw = {unary, mag[BINARY_BITS-1:0]};
    end
    endfunction

    function automatic [DAC_SW_W-1:0] phase_to_dac_code(
        input logic [PHASE_W-1:0] phase,
        input logic               q_sel
    );
        logic [TRUNC_W-1:0] trunc;
        logic               sign_i;
        logic               fold;
        logic [ADDR_W-1:0]  raw_addr;
        logic [ADDR_W-1:0]  addr;
        logic               sign;
        logic [MAG_W-1:0]   mag;
        logic [DAC_SW_W-1:0] sw_pos;
    begin
        trunc    = phase[PHASE_W-1:PHASE_W-TRUNC_W];
        sign_i   = trunc[TRUNC_W-1];
        fold     = trunc[TRUNC_W-2];
        raw_addr = trunc[ADDR_W-1:0];

        if (!q_sel) begin
            addr = fold ? ~raw_addr : raw_addr;
            sign = sign_i;
        end else begin
            addr = fold ? raw_addr : ~raw_addr;
            sign = sign_i ^ fold;
        end

        mag     = rom[addr];
        sw_pos  = mag_to_sw(mag);
        phase_to_dac_code = sw_pos ^ {DAC_SW_W{sign}};
    end
    endfunction

    task automatic fail_msg(input string msg);
    begin
        $display("FAIL: %s", msg);
        err_count = err_count + 1;
    end
    endtask

    task automatic clk_wait(input integer n);
    begin
        repeat (n) @(posedge clk);
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

    task automatic pulse_io_update;
    begin
        io_update = 1'b1; #(CLK_P * (LANES * 3));
        io_update = 1'b0; #(CLK_P * (LANES * 3));
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
        clk_wait(6);
        rst_n = 1'b1;
        clk_wait(LANES * 4);
    end
    endtask

    task automatic wait_for_wave_enable(output bit seen);
        integer tries;
    begin
        seen = 1'b0;
        for (tries = 0; tries < 12; tries = tries + 1) begin
            @(posedge dut.clk_vec); #1;
            if (dut.wave_en) begin
                seen = 1'b1;
                tries = 12;
            end
        end
    end
    endtask

    task automatic check_phase_block(input string label, input integer block_idx);
        integer lane;
    begin
        if (!dut.wave_en)
            fail_msg($sformatf("%s block %0d: wave_en dropped", label, block_idx));

        if (dut.ftw_lane0 !== scenario_ftw)
            fail_msg($sformatf("%s block %0d: ftw_lane0=%08h exp=%08h",
                               label, block_idx, dut.ftw_lane0, scenario_ftw));

        if (dut.ftw_step_now !== scenario_step)
            fail_msg($sformatf("%s block %0d: ftw_step_now=%08h exp=%08h",
                               label, block_idx, dut.ftw_step_now, scenario_step));

        for (lane = 0; lane < LANES; lane = lane + 1) begin
            if (dut.phase_vec[lane] !== exp_phase_vec_cur[lane]) begin
                fail_msg($sformatf(
                    "%s block %0d lane %0d: phase=%08h exp=%08h",
                    label, block_idx, lane, dut.phase_vec[lane], exp_phase_vec_cur[lane]
                ));
            end
        end
    end
    endtask

    task automatic check_vector_block(input string label, input integer block_idx);
        integer lane;
    begin
        for (lane = 0; lane < LANES; lane = lane + 1) begin
            if (dut.dac_i_vec[lane] !== code_i_pipe[PIPE_LATENCY-1][lane]) begin
                fail_msg($sformatf(
                    "%s vec block %0d lane %0d: dac_i_vec=%09h exp=%09h phase=%08h",
                    label,
                    block_idx,
                    lane,
                    dut.dac_i_vec[lane],
                    code_i_pipe[PIPE_LATENCY-1][lane],
                    phase_pipe[PIPE_LATENCY-1][lane]
                ));
            end

            if (dut.dac_q_vec[lane] !== code_q_pipe[PIPE_LATENCY-1][lane]) begin
                fail_msg($sformatf(
                    "%s vec block %0d lane %0d: dac_q_vec=%09h exp=%09h phase=%08h",
                    label,
                    block_idx,
                    lane,
                    dut.dac_q_vec[lane],
                    code_q_pipe[PIPE_LATENCY-1][lane],
                    phase_pipe[PIPE_LATENCY-1][lane]
                ));
            end
        end
    end
    endtask

    task automatic check_code_sample(input string label, input integer sample_idx);
    begin
        if (cmp_fd) begin
            $fwrite(
                cmp_fd,
                "%s,%0d,%08h,%09h,%09h,%09h,%09h\n",
                label,
                sample_idx,
                gold_ser_phase,
                gold_ser_i,
                dac_i,
                gold_ser_q,
                dac_q
            );
        end

        if (dac_i !== gold_ser_i) begin
            fail_msg($sformatf(
                "%s sample %0d: dac_i=%09h exp=%09h phase=%08h",
                label, sample_idx, dac_i, gold_ser_i, gold_ser_phase
            ));
        end

        if (dac_q !== gold_ser_q) begin
            fail_msg($sformatf(
                "%s sample %0d: dac_q=%09h exp=%09h phase=%08h",
                label, sample_idx, dac_q, gold_ser_q, gold_ser_phase
            ));
        end
    end
    endtask

    task automatic run_cw_case(input [PHASE_W-1:0] ftw, input string label);
        bit wave_seen;
        integer block_idx;
        integer vec_idx;
        integer sample_idx;
    begin
        $display("--- Wave Match: %s ---", label);

        scenario_ftw  = ftw;
        scenario_step = {PHASE_W{1'b0}};

        do_reset;
        spi_write32(7'h04, ftw);
        spi_write8(7'h02, 8'h08); // CW + phase reset on launch
        pulse_io_update;

        wait_for_wave_enable(wave_seen);
        if (!wave_seen) begin
            fail_msg({label, ": wave_en never asserted"});
        end else begin
            check_phase_block(label, 0);
            for (block_idx = 1; block_idx < PHASE_BLOCKS; block_idx = block_idx + 1) begin
                @(posedge dut.clk_vec); #1;
                check_phase_block(label, block_idx);
            end

            check_vector_block(label, 0);
            for (vec_idx = 1; vec_idx < 8; vec_idx = vec_idx + 1) begin
                @(posedge dut.clk_vec); #1;
                check_vector_block(label, vec_idx);
            end

            repeat (CODE_WARMUP) @(posedge clk);
            #1;

            for (sample_idx = 0; sample_idx < CODE_SAMPLES; sample_idx = sample_idx + 1) begin
                @(posedge clk); #1;
                check_code_sample(label, sample_idx);
            end
        end
    end
    endtask

    always_ff @(posedge dut.clk_vec or negedge dut.core_rst_n_vec) begin
        if (!dut.core_rst_n_vec) begin
            exp_phase_base <= {PHASE_W{1'b0}};
            for (stage_idx = 0; stage_idx < PIPE_LATENCY; stage_idx = stage_idx + 1) begin
                for (lane_idx = 0; lane_idx < LANES; lane_idx = lane_idx + 1) begin
                    phase_pipe[stage_idx][lane_idx] <= {PHASE_W{1'b0}};
                    code_i_pipe[stage_idx][lane_idx] <= MIDSCALE_SW;
                    code_q_pipe[stage_idx][lane_idx] <= MIDSCALE_SW;
                end
            end
        end else begin
            for (lane_idx = 0; lane_idx < LANES; lane_idx = lane_idx + 1) begin
                phase_pipe[0][lane_idx] <= exp_phase_vec_cur[lane_idx];
                if (dut.phase_valid_vec[0]) begin
                    code_i_pipe[0][lane_idx] <= phase_to_dac_code(exp_phase_vec_cur[lane_idx], 1'b0);
                    code_q_pipe[0][lane_idx] <= phase_to_dac_code(exp_phase_vec_cur[lane_idx], 1'b1);
                end else begin
                    code_i_pipe[0][lane_idx] <= MIDSCALE_SW;
                    code_q_pipe[0][lane_idx] <= MIDSCALE_SW;
                end
            end

            for (stage_idx = 1; stage_idx < PIPE_LATENCY; stage_idx = stage_idx + 1) begin
                for (lane_idx = 0; lane_idx < LANES; lane_idx = lane_idx + 1) begin
                    phase_pipe[stage_idx][lane_idx] <= phase_pipe[stage_idx-1][lane_idx];
                    code_i_pipe[stage_idx][lane_idx] <= code_i_pipe[stage_idx-1][lane_idx];
                    code_q_pipe[stage_idx][lane_idx] <= code_q_pipe[stage_idx-1][lane_idx];
                end
            end

            if (dut.phase_reset_req)
                exp_phase_base <= {PHASE_W{1'b0}};
            else if (dut.wave_en)
                exp_phase_base <= exp_phase_base + exp_ftw_x4 + exp_step_x6;
        end
    end

    always_ff @(posedge clk or negedge dut.core_rst_n_ser) begin
        if (!dut.core_rst_n_ser) begin
            gold_ser_lane   <= 2'd0;
            gold_load_dout  <= 1'b0;
            gold_load_sh1   <= 1'b0;
            gold_load_sh2   <= 1'b0;
            gold_load_sh3   <= 1'b0;

            gold_ser_i      <= MIDSCALE_SW;
            gold_ser_q      <= MIDSCALE_SW;
            gold_sh1_i      <= MIDSCALE_SW;
            gold_sh2_i      <= MIDSCALE_SW;
            gold_sh3_i      <= MIDSCALE_SW;
            gold_sh1_q      <= MIDSCALE_SW;
            gold_sh2_q      <= MIDSCALE_SW;
            gold_sh3_q      <= MIDSCALE_SW;

            gold_ser_phase  <= {PHASE_W{1'b0}};
            gold_sh1_phase  <= {PHASE_W{1'b0}};
            gold_sh2_phase  <= {PHASE_W{1'b0}};
            gold_sh3_phase  <= {PHASE_W{1'b0}};
        end else begin
            gold_ser_lane  <= gold_ser_lane + 2'd1;
            gold_load_dout <= (gold_ser_lane == 2'd3);
            gold_load_sh1  <= (gold_ser_lane == 2'd3);
            gold_load_sh2  <= (gold_ser_lane == 2'd3);
            gold_load_sh3  <= (gold_ser_lane == 2'd3);

            gold_ser_i <= gold_load_dout ? code_i_pipe[PIPE_LATENCY-1][0] : gold_sh1_i;
            gold_sh1_i <= gold_load_sh1  ? code_i_pipe[PIPE_LATENCY-1][1] : gold_sh2_i;
            gold_sh2_i <= gold_load_sh2  ? code_i_pipe[PIPE_LATENCY-1][2] : gold_sh3_i;
            gold_sh3_i <= gold_load_sh3  ? code_i_pipe[PIPE_LATENCY-1][3] : {DAC_SW_W{1'b0}};

            gold_ser_q <= gold_load_dout ? code_q_pipe[PIPE_LATENCY-1][0] : gold_sh1_q;
            gold_sh1_q <= gold_load_sh1  ? code_q_pipe[PIPE_LATENCY-1][1] : gold_sh2_q;
            gold_sh2_q <= gold_load_sh2  ? code_q_pipe[PIPE_LATENCY-1][2] : gold_sh3_q;
            gold_sh3_q <= gold_load_sh3  ? code_q_pipe[PIPE_LATENCY-1][3] : {DAC_SW_W{1'b0}};

            gold_ser_phase <= gold_load_dout ? phase_pipe[PIPE_LATENCY-1][0] : gold_sh1_phase;
            gold_sh1_phase <= gold_load_sh1  ? phase_pipe[PIPE_LATENCY-1][1] : gold_sh2_phase;
            gold_sh2_phase <= gold_load_sh2  ? phase_pipe[PIPE_LATENCY-1][2] : gold_sh3_phase;
            gold_sh3_phase <= gold_load_sh3  ? phase_pipe[PIPE_LATENCY-1][3] : {PHASE_W{1'b0}};
        end
    end

    initial begin
        cmp_fd = $fopen("tb_dds_wave_scan_match.csv", "w");
        if (cmp_fd)
            $fwrite(cmp_fd, "scenario,sample_idx,exp_phase,exp_dac_i,act_dac_i,exp_dac_q,act_dac_q\n");
    end

    initial begin
        $dumpfile("tb_dds_wave_scan_match.vcd");
        $dumpvars(0, tb_dds_wave_scan_match);

        scenario_ftw  = {PHASE_W{1'b0}};
        scenario_step = {PHASE_W{1'b0}};

        run_cw_case(FTW_CW_FRAC_5MHZ,       "cw_frac_5mhz");
        run_cw_case(FTW_CW_LO,              "cw_15p625mhz");
        run_cw_case(FTW_CW_FRAC_37MHZ,      "cw_frac_37mhz");
        run_cw_case(FTW_CW_HI,              "cw_46p875mhz");
        run_cw_case(FTW_CW_FRAC_67P42MHZ,   "cw_frac_67p42mhz");
        run_cw_case(FTW_CW_75MHZ,           "cw_75mhz");
        run_cw_case(FTW_CW_100MHZ,          "cw_100mhz");
        run_cw_case(FTW_CW_FRAC_123P456789, "cw_frac_123p456789mhz");
        run_cw_case(FTW_CW_175MHZ,          "cw_175mhz");
        run_cw_case(FTW_CW_FRAC_211P75MHZ,  "cw_frac_211p75mhz");
        run_cw_case(FTW_CW_FRAC_237P125MHZ, "cw_frac_237p125mhz");
        run_cw_case(FTW_CW_240MHZ,          "cw_240mhz");
        run_cw_case(FTW_CW_245MHZ,          "cw_245mhz");
        run_cw_case(FTW_CW_FRAC_248P75MHZ,  "cw_frac_248p75mhz");
        run_cw_case(FTW_CW_FRAC_249P9MHZ,   "cw_frac_249p9mhz");

        if (cmp_fd)
            $fclose(cmp_fd);

        if (err_count == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILED: %0d errors", err_count);

        $finish;
    end

endmodule

`default_nettype wire
