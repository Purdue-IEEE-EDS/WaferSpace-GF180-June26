`timescale 1 ns / 1ps 
module tb_stage();
	
	logic clk, rst;
    logic in_valid, out_valid;
    logic signed [15:0] in_real, in_imag, out_real, out_imag;

    int count; 
    mdc_stage #(.BITS(16), .STAGES(8), .CURR_STAGE(8))
    DUT (
        .clk, .rst,
        .in_valid, 
        .in_real, .in_imag, 
        .out_real, .out_imag, 
        .out_valid
    );

	initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
  	end

	task reset_dut;
    begin
        rst = 0;
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
        rst = 1;
    end
    endtask

	initial begin
	    $dumpfile("testbench.vcd");
    	$dumpvars(0,DUT);
        count = '0;
        in_real = '0;
        in_imag = '0;
        in_valid = '0; 
        reset_dut;
        in_valid = 1'b1; 
        for (int i = 0; i < 256; i++) begin 
            //in = {i[4:3], i[0], i[1], i[2]};
            in_real = (i+1);
            @(posedge clk);
            @(negedge clk);
        end
        $finish;
	end
endmodule 