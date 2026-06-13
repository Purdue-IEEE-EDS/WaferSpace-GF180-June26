`timescale 1 ns / 1ps 
module tb_fft();	

	logic clk, rst;
    
    localparam BITS = 16;

    logic signed [5:0] din_re0, din_re1, din_re2, din_re3;
    logic signed [5:0] din_im0, din_im1, din_im2, din_im3; 

    logic signed [BITS-1:0] dout_re0, dout_re1, dout_re2, dout_re3;  
    logic signed [BITS-1:0] dout_im0, dout_im1, dout_im2, dout_im3;

    logic in_valid, out_valid;
    logic [15:0][15:0] vals;

    reg [31:0] wave [0:511];
    initial begin
        $readmemh("data.mem", wave);
        // = '{16'h1234, 16'hfe34, 16'h4589, 16'hc090, 16'h1823, 16'hd451, 16'haabc, 16'h7034, 16'h9076, 16'hb439, 16'h0743, 16'hbdfc, 16'h2349, 16'h8490, 16'hcbfe, 16'h3028};
    end

    fft
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
        @(posedge clk);
        @(posedge clk);
        @(negedge clk);
    end
    endtask

	initial begin
	    $dumpfile("testbench.vcd");
    	$dumpvars(0,DUT);
        
        din_re0 = 16'h0;
        din_re1 = 16'h0; 
        din_re2 = 16'h0; 
        din_re3 = 16'h0; 
        din_im0 = 16'h0;
        din_im1 = 16'h0;
        din_im2 = 16'h0;
        din_im3 = 16'h0; 
        in_valid = '0; 

        reset_dut;

        in_valid = 1'b1;

        for (int i = 0; i < 16; i++) begin
            // din_re0 = 1<<5; 
            // din_re1 = 1<<5; 
            // din_re2 = 1<<5; 
            // din_re3 = 1<<5; 
            // din_im0 = 1'b0;
            // din_im1 = 1'b0;
            // din_im2 = 1'b0;
            // din_im3 = 1'b0; 

            // din_re0 = wave[i]; 
            // din_re1 = wave[i+128]; 
            // din_re2 = wave[i+64]; 
            // din_re3 = wave[i+192]; 
            // din_im0 = 1'b0;
            // din_im1 = 1'b0;
            // din_im2 = 1'b0;
            // din_im3 = 1'b0; 

            if(i == 1) din_re0 = 6'h10; 
            else din_re0 = 6'h0; 
            din_re1 = '0; 
            din_re2 = '0; 
            din_re3 = '0; 
            din_im0 = 1'b0;
            din_im1 = 1'b0;
            din_im2 = 1'b0;
            din_im3 = 1'b0;
            @(negedge clk);
        end
        
        in_valid = '0; 

        din_re0 = 1'b0; 
        din_re1 = 1'b0; 
        din_re2 = 1'b0; 
        din_re3 = 1'b0; 
        din_im0 = 1'b0;
        din_im1 = 1'b0;
        din_im2 = 1'b0;
        din_im3 = 1'b0; 
        // for (int i = 0; i < 512; i++) begin
        //     in_real = wave[i];
        //     @(negedge clk);
        // end

        repeat (256) @(negedge clk);

        $display("Reached end at time %0t", $time);
        $finish;
	end
endmodule 