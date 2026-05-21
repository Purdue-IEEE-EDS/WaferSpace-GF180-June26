`timescale 1 ns / 1ps 
module tb_commutator();	

	logic clk, rst;

    logic select, en; 
    logic [15:0] up_in, low_in, up_out, low_out; 
    
    localparam BITS = 16;

    reg [31:0] wave [0:511];

    commutator
    #(
        .DELAY(32),
        .WIDTH(16)
    ) 
    DUT (
        .clk, 
        .select, .en,
        .up_in, .low_in, 
        .up_out, .low_out
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

    int count = 0; 
	initial begin
	    $dumpfile("testbench.vcd");
    	$dumpvars(0,DUT); 

        select = 1'b1;
        up_in = 1'b0; 
        low_in = 1'b0; 
        en = 1'b0; 
        reset_dut;

        for (int i = 0; i < 64; i++) begin
            up_in = i;
            low_in = i + 128; 
            en = 1'b1; 
            if (i < 32) select = 1'b0; 
            else select = 1'b1;
            @(negedge clk);
        end

        select = 1'b0; 
        // for (int i = 0; i < 512; i++) begin
        //     in_real = wave[i];
        //     @(negedge clk);
        // end

        repeat (20) @(negedge clk);

        $display("Reached end at time %0t", $time);
        $finish;
	end
endmodule 