`timescale 1 ns / 1ps 
module tb_mdc_stage();

    localparam BITS = 16;
    logic clk, rst;
    logic in_valid, out_valid; 
    logic signed [BITS-1:0] din_re0, din_re1, din_re2, din_re3;
    logic signed [BITS-1:0] din_im0, din_im1, din_im2, din_im3;

    logic signed [BITS-1:0] dout_re0, dout_re1, dout_re2, dout_re3;   
    logic signed [BITS-1:0] dout_im0, dout_im1, dout_im2, dout_im3;

    mdc_stage #(.BITS(16), .STAGES(8), .CURR_STAGE(0))
    DUT ( 
        .clk, .rst,
        .in_valid, 
        .din_re0, .din_re1, .din_re2, .din_re3,
        .din_im0, .din_im1, .din_im2, .din_im3,

        .dout_re0, .dout_re1, .dout_re2, .dout_re3,   
        .dout_im0, .dout_im1, .dout_im2, .dout_im3, 
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

        din_re0 = 16'h1; 
        din_re1 = 16'h2; 
        din_re2 = 16'h3; 
        din_re3 = 16'h4;
        din_im0 = 16'h1; 
        din_im1 = 16'h2;
        din_im2 = 16'h3; 
        din_im3 = 16'h4; 
        in_valid = 1'b1; 

        reset_dut; 

        repeat (3) @(negedge clk);
        
        $finish; 
    end
endmodule