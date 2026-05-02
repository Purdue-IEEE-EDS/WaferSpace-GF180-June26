`timescale 1 ns / 1ps 
module tb_r4();

    localparam BITS = 16;
    logic clk, rst;
    logic signed [BITS-1:0] din_re0, din_re1, din_re2, din_re3;
    logic signed [BITS-1:0] din_im0, din_im1, din_im2, din_im3;

    logic signed [BITS-1:0] dout_re0, dout_re1, dout_re2, dout_re3;   
    logic signed [BITS-1:0] dout_im0, dout_im1, dout_im2, dout_im3;

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
  	end

    r4 #(.BITS(16))
        DUT (
            .clk, .rst,
            .din_re0, .din_re1, .din_re2, .din_re3,
            .din_im0, .din_im1, .din_im2, .din_im3, 

            .dout_re0, .dout_re1, .dout_re2, .dout_re3,   
            .dout_im0, .dout_im1, .dout_im2, .dout_im3
        );

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

        repeat (3) @(negedge clk);
        
        $finish; 

        reset_dut; 
        repeat (3) @(negedge clk);
        
        $finish; 
    end
endmodule