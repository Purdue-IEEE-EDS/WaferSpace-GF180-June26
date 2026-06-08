`default_nettype none
`timescale 1ns/1ps

module tb_main_dac_ams;

    localparam int UNARY_BITS   = 5;
    localparam int BINARY_BITS  = 5;
    localparam int DAC_SW_W     = (1 << UNARY_BITS) - 1 + BINARY_BITS;
    localparam int N_UNARY      = (1 << UNARY_BITS) - 1;
    localparam int MIDSCALE     = 1 << (UNARY_BITS - 1);
    localparam int TOTAL_WEIGHT = N_UNARY * (1 << BINARY_BITS)
                                + ((1 << BINARY_BITS) - 1);
    localparam int STARTUP_TIMEOUT = 1024;
    localparam int STARTUP_TARGET  = 256;

    localparam logic [DAC_SW_W-1:0] MIDSCALE_SW =
        {{(N_UNARY - MIDSCALE){1'b0}}, {MIDSCALE{1'b1}}, {BINARY_BITS{1'b0}}};

    logic clk = 1'b0;
    logic [DAC_SW_W-1:0] dac_i_p;
    logic [DAC_SW_W-1:0] dac_i_n;
    logic [DAC_SW_W-1:0] dac_q_p;
    logic [DAC_SW_W-1:0] dac_q_n;
    int errors = 0;

    always #4 clk = ~clk;

    main_dac_codegen dut (
        .clk         (clk),
        .dac_i_p     (dac_i_p),
        .dac_i_n     (dac_i_n),
        .dac_q_p     (dac_q_p),
        .dac_q_n     (dac_q_n)
    );

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
        errors++;
    end
    endtask

    initial begin
        int j;
        int prev_i;
        int prev_q;
        int cur_i;
        int cur_q;
        int first_i_live;
        int first_q_live;
        bit saw_non_midscale;
        bit saw_motion;
        bit bad_i_pair;
        bit bad_q_pair;

        $dumpfile("tb_main_dac_ams.vcd");
        $dumpvars(0, tb_main_dac_ams);

        first_i_live = -1;
        first_q_live = -1;
        bad_i_pair   = 1'b0;
        bad_q_pair   = 1'b0;
        for (j = 0; j < STARTUP_TIMEOUT; j = j + 1) begin
            @(posedge clk);
            #1;
            if (first_i_live < 0 && (^dac_i_p !== 1'bx) && dac_i_p != MIDSCALE_SW)
                first_i_live = j + 1;
            if (first_q_live < 0 && (^dac_q_p !== 1'bx) && dac_q_p != MIDSCALE_SW)
                first_q_live = j + 1;
            if (!bad_i_pair && (^dac_i_p !== 1'bx) && (^dac_i_n !== 1'bx) &&
                dac_i_n !== ~dac_i_p) begin
                fail("main DAC I negative leg is not the inverse of the positive leg");
                bad_i_pair = 1'b1;
            end
            if (!bad_q_pair && (^dac_q_p !== 1'bx) && (^dac_q_n !== 1'bx) &&
                dac_q_n !== ~dac_q_p) begin
                fail("main DAC Q negative leg is not the inverse of the positive leg");
                bad_q_pair = 1'b1;
            end
        end

        $display("startup: dac_q left midscale at cycle %0d, dac_i at cycle %0d",
                 first_q_live, first_i_live);

        if (first_i_live < 0)
            fail("main DAC I path never left midscale before timeout");
        if (first_q_live < 0)
            fail("main DAC Q path never left midscale before timeout");
        if (first_i_live >= STARTUP_TARGET || first_q_live >= STARTUP_TARGET)
            fail($sformatf("main DAC startup too slow: I=%0d Q=%0d target<%0d",
                           first_i_live, first_q_live, STARTUP_TARGET));

        saw_non_midscale = 1'b0;
        saw_motion       = 1'b0;
        prev_i           = sw_to_idiff(dac_i_p);
        prev_q           = sw_to_idiff(dac_q_p);

        for (j = 0; j < 64; j = j + 1) begin
            @(posedge clk);
            #1;
            cur_i = sw_to_idiff(dac_i_p);
            cur_q = sw_to_idiff(dac_q_p);
            if (dac_i_p !== MIDSCALE_SW || dac_q_p !== MIDSCALE_SW)
                saw_non_midscale = 1'b1;
            if (cur_i != prev_i || cur_q != prev_q)
                saw_motion = 1'b1;
            if (!bad_i_pair && dac_i_n !== ~dac_i_p) begin
                fail("main DAC I negative leg lost inversion tracking");
                bad_i_pair = 1'b1;
            end
            if (!bad_q_pair && dac_q_n !== ~dac_q_p) begin
                fail("main DAC Q negative leg lost inversion tracking");
                bad_q_pair = 1'b1;
            end
            prev_i = cur_i;
            prev_q = cur_q;
        end

        if (!saw_non_midscale)
            fail("main DAC never left midscale after self-start");
        if (!saw_motion)
            fail("CW wrapper did not generate a changing waveform");

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("FAILED: %0d errors", errors);

        $finish;
    end

endmodule

`default_nettype wire
