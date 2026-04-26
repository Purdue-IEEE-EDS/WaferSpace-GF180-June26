`timescale 1 ns / 1ps 
module tb_fft();
	
	logic clk, rst;
    logic signed [31:0] in_real, in_imag, out_real, out_imag;
    logic [9:0] count_out;

    reg [31:0] wave [0:511];
    initial begin
        $readmemh("data.mem", wave);
    end

    fft_wrapper
    DUT (
        .clk, .rst,
        .in_real, .in_imag,
        .out_real, .out_imag,
        .count_out
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
        reset_dut;

        for (int i = 0; i < 512; i++) begin
            in_real = i < 256 ? 0 : 1'b1<<12; //(~i[8])<<12;
            @(negedge clk);
        end
        
        for (int i = 0; i < 512; i++) begin
            in_real = wave[i];
            @(negedge clk);
        end

        in_real = '0;
        repeat (600) @(negedge clk);

        $display("Reached end at time %0t", $time);
        $finish;
	end
endmodule 
