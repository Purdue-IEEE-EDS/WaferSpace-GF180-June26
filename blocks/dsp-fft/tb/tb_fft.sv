`timescale 1 ns / 1ps 
module tb_fft();
	
	logic clk, rst;
    logic signed [15:0] in_real, in_imag, out_real, out_imag;
    logic in_valid, out_valid;

    reg [31:0] wave [0:511];
    // initial begin
    //     $readmemh("data.mem", wave);
    // end

    fft
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
        
        in_real = '0;
        in_imag = '0;
        in_valid = '0; 
        reset_dut;

        in_valid = 1'b1;
        for (int i = 0; i < (1 << 10); i++) begin
            in_real = ~i;
            in_imag = i; 
            @(negedge clk);
        end
        
        // for (int i = 0; i < 512; i++) begin
        //     in_real = wave[i];
        //     @(negedge clk);
        // end

        in_real = '0;
        repeat (20) @(negedge clk);

        $display("Reached end at time %0t", $time);
        $finish;
	end
endmodule 