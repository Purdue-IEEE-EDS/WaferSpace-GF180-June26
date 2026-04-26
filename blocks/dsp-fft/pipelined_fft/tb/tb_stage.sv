`timescale 1 ns / 1ps 
module tb_stage();
	
	logic clk, rst;
    logic signed [63:0] in, out;
    logic [6:0] count;
    logic signed [31:0] in_real, in_imag, out_real, out_imag;

    stage #(.BITS(32), .DECIMAL(12), .STAGES(9), .CURR_STAGE(9))
    DUT (
        .clk, .rst,
        .in_real, .in_imag, 
        .out_real, .out_imag,
        .count(count)
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
	    // $dumpfile("testbench.vcd");
    	// $dumpvars(0,DUT);
        count = '0;
        in_real = '0;
        in_imag = '0;
        reset_dut;
        //@(posedge clk);
        for (int i = 0; i < 64; i++) begin 
            //in = {i[4:3], i[0], i[1], i[2]};
            in_real = (i+1) << (32 + 12);
            @(posedge clk);
            count = count + 1;
            @(negedge clk);
        end
        $finish;
	end
endmodule 
