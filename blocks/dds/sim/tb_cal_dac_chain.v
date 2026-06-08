`default_nettype none
`timescale 1ns/1ps

module tb_cal_dac_chain;

    localparam integer N_CELLS    = 3;
    localparam integer CELL_W     = 4;
    localparam [CELL_W-1:0] MID   = 4'b1000;
    localparam integer TOTAL_BITS = N_CELLS * CELL_W;

    reg  rst_n;
    reg  cal_clk;
    reg  load;
    reg  serial_in;
    wire serial_out;
    wire [TOTAL_BITS-1:0] dac_code;

    integer pass_n;
    integer fail_n;

    cal_dac_chain #(
        .N_CELLS    (N_CELLS),
        .CELL_W     (CELL_W),
        .RESET_CODE (MID)
    ) dut (
        .rst_n      (rst_n),
        .cal_clk    (cal_clk),
        .load       (load),
        .serial_in  (serial_in),
        .serial_out (serial_out),
        .dac_code   (dac_code)
    );

    task check_code(input [255:0] label, input integer cell_idx, input [CELL_W-1:0] exp);
        reg [CELL_W-1:0] got;
    begin
        got = dac_code[(cell_idx*CELL_W) +: CELL_W];
        if (got === exp) begin
            $display("  PASS: %0s", label);
            pass_n = pass_n + 1;
        end else begin
            $display("  FAIL: %0s -- got 0x%0h, expected 0x%0h", label, got, exp);
            fail_n = fail_n + 1;
        end
    end
    endtask

    task pulse_cal_clk(input bit din);
    begin
        serial_in = din;
        #5;
        cal_clk = 1'b1;
        #5;
        cal_clk = 1'b0;
    end
    endtask

    task pulse_load;
    begin
        #5;
        load = 1'b1;
        #5;
        load = 1'b0;
    end
    endtask

    task shift_word_lsb_first(input [CELL_W-1:0] word);
        integer b;
    begin
        for (b = 0; b < CELL_W; b = b + 1)
            pulse_cal_clk(word[b]);
    end
    endtask

    initial begin
        $dumpfile("tb_cal_dac_chain.vcd");
        $dumpvars(0, tb_cal_dac_chain);

        rst_n     = 1'b0;
        cal_clk   = 1'b0;
        load      = 1'b0;
        serial_in = 1'b0;
        pass_n    = 0;
        fail_n    = 0;

        #20;
        rst_n = 1'b1;
        #5;

        $display("\n=== 1. Reset to midscale ===");
        check_code("cell0 reset code", 0, MID);
        check_code("cell1 reset code", 1, MID);
        check_code("cell2 reset code", 2, MID);

        $display("\n=== 2. Shift alone does not update DAC storage ===");
        shift_word_lsb_first(4'b0110);
        #5;
        check_code("cell0 unchanged before load", 0, MID);
        check_code("cell1 unchanged before load", 1, MID);
        check_code("cell2 unchanged before load", 2, MID);

        $display("\n=== 3. Single-word load updates nearest cell ===");
        pulse_load;
        #5;
        check_code("cell0 loaded word", 0, 4'b0110);
        check_code("cell1 still midscale", 1, MID);
        check_code("cell2 still midscale", 2, MID);

        $display("\n=== 4. Full-frame daisy-chain ordering ===");
        // Shift farthest-to-nearest so load maps to:
        //   cell2 = 4'b0011
        //   cell1 = 4'b0101
        //   cell0 = 4'b1110
        shift_word_lsb_first(4'b0011);
        shift_word_lsb_first(4'b0101);
        shift_word_lsb_first(4'b1110);
        pulse_load;
        #5;
        check_code("cell0 frame load", 0, 4'b1110);
        check_code("cell1 frame load", 1, 4'b0101);
        check_code("cell2 frame load", 2, 4'b0011);

        $display("\n=== 5. serial_out exposes scan-chain tail ===");
        // The last cell in the chain now holds 4'b0011, so serial_out
        // exposes its LSB until the next scan clock.
        if (serial_out === 1'b1) begin
            $display("  PASS: serial_out tail bit observed");
            pass_n = pass_n + 1;
        end else begin
            $display("  FAIL: serial_out tail bit wrong -- got %0b, expected 1", serial_out);
            fail_n = fail_n + 1;
        end

        $display("\n========================================");
        if (fail_n == 0) begin
            $display("ALL TESTS PASSED (%0d checks)", pass_n);
        end else begin
            $display("FAILED: %0d error(s), %0d pass(es)", fail_n, pass_n);
        end
        $display("========================================");

        $finish;
    end

endmodule

`default_nettype wire
