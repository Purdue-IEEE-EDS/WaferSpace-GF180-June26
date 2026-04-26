`default_nettype none

module fft_wrapper 
(
    input logic clk, rst, 
    input logic signed [31:0] in_real, in_imag, 
    output logic signed [31:0] out_real, out_imag,
    output logic [8:0] count_out
);


fft #(.BITS(32), .DECIMAL(12)) 
f (
    .clk, .rst, 
    .in_real, .in_imag, 
    .out_real, .out_imag,
    .count_out
);

endmodule