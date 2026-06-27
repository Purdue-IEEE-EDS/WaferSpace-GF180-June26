module tb_serial_to_parallel();

    logic clk, rst;
    logic valid_in;
    logic [5:0] din; 
    logic [5:0] dout0, dout1, dout2, dout3;
    logic valid_out;

    serial_to_parallel 
    DUT (
        .clk, .rst,
        .valid_in,
        .din, 
        .dout0, .dout1, .dout2, .dout3, 
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

        valid_in = 1'b0;
        din = '0; 
        reset_dut;

        valid_in = 1'b1; 
        for (int i = 0; i < 64; i ++) begin 
            din=i;
            @(negedge clk);
        end

        valid_in = 1'b0; 

        $display("Reached end at time %0t", $time);
        $finish;
	end

endmodule