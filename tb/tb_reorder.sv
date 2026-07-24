`timescale 1 ns / 1ps 
module tb_reorder();

    logic clk, rst;
    logic signed [5:0] din_re0, din_re1, din_re2, din_re3;
    logic signed [5:0] din_im0, din_im1, din_im2, din_im3;
    logic valid_in;

    logic signed [5:0] din_re0_r, din_re1_r, din_re2_r, din_re3_r;
    logic signed [5:0] din_im0_r, din_im1_r, din_im2_r, din_im3_r; 
    logic valid_out;

    reorder 
    DUT (
        .clk, .rst,
        .din_re0, .din_re1, .din_re2, .din_re3,
        .din_im0, .din_im1, .din_im2, .din_im3,
        .valid_in,

        .din_re0_r, .din_re1_r, .din_re2_r, .din_re3_r,
        .din_im0_r, .din_im1_r, .din_im2_r, .din_im3_r, 
        .valid_out
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
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
    end
    endtask

    initial begin
	    $dumpfile("testbench.vcd");
    	$dumpvars(0,DUT);

        reset_dut;
   
        valid_in = '0; 
        repeat (2) @(negedge clk);

        valid_in = 1'b1; 

        for (int i=0; i < 16; i ++) begin 
            din_re0=4*i;
            din_re1=4*i+1;
            din_re2=4*i+2;
            din_re3=4*i+3; 

            din_im0=i;
            din_im1=i+1;
            din_im2=i+2;
            din_im3=i+3;
            @(negedge clk);
        end

        for (int i=0; i < 16; i ++) begin 
            din_re0=4*i+3;
            din_re1=4*i+2;
            din_re2=4*i+1;
            din_re3=4*i; 

            din_im0=i+3;
            din_im1=i+2;
            din_im2=i+1;
            din_im3=i;
            @(negedge clk);
        end

        valid_in = 1'b0; 

        repeat (64) @(negedge clk);

        $display("Reached end at time %0t", $time);
        $finish;
	end

endmodule