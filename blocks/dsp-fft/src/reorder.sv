module reorder
(
    input  logic        clk, rst,   // 160 MHz Parallel Clock
    input  logic        valid_in,   // High when valid serial-de-interleaved data arrives

    input  logic signed [5:0] din0, din1, din2, din3,

    output logic              valid_out,
    output logic signed [5:0] dout0, dout1, dout2, dout3
);

    assign dout0 = din0; 
    assign dout1 = din1; 
    assign dout2 = din2; 
    assign dout3 = din3;

    assign valid_out = valid_in; 
    
endmodule
