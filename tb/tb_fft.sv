module tb_fft(); 

    logic adc_clk, rst;
    logic valid_in;

    logic signed [5:0] din_re, din_im;
    logic signed [15:0] dout_re, dout_im; 

    logic valid_out;

    initial begin
        adc_clk = 1'b0;
        forever #5 adc_clk = ~adc_clk;
  	end

	task reset_dut;
    begin
        rst = 0;
        @(posedge adc_clk);
        repeat (16) @(posedge adc_clk);
        @(negedge adc_clk);
        rst = 1;
        @(posedge adc_clk);
        @(posedge adc_clk);
        @(negedge adc_clk);
    end
    endtask

    fft
    DUT (
        .adc_clk, .rst,

        .din_re, .din_im,
        .dout_re, .dout_im, 

        .valid_out
    ); 

    logic [5:0] k;

    initial begin
	    $dumpfile("testbench.vcd");
    	$dumpvars(0,DUT);
        
        valid_in = 1'b1; 
        din_re = 6'd20; 
        din_im = 6'h20; 

        reset_dut; 

        repeat (1) @(negedge adc_clk);
        valid_in = 1'b1; 

        for (int i = 0; i < 128; i++) begin 
            din_re = 6'h1; 
            repeat (8) @(negedge adc_clk);
            din_re = 6'h3f; 
            repeat (8) @(negedge adc_clk);
        end
         
        repeat (400) @(negedge adc_clk);

        $display("Reached end at time %0t", $time);
        $finish;
	end
endmodule