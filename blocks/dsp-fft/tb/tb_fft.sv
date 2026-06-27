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
        .valid_in, 

        .din_re, .din_im,
        .dout_re, .dout_im, 

        .valid_out
    ); 

    initial begin
	    $dumpfile("testbench.vcd");
    	$dumpvars(0,DUT);
        
        valid_in = 1'b0; 
        din_re = 6'd0; 
        din_im = 6'd32; 

        reset_dut; 

        valid_in = 1'b1; 

        for (int i = 0; i < 64; i++) begin 
            din_re = 5'd0; 
            @(negedge adc_clk);
        end
        //repeat (64) @(negedge adc_clk);

        valid_in = 1'b0; 

        repeat (1024) @(negedge adc_clk);

        $display("Reached end at time %0t", $time);
        $finish;
	end
endmodule