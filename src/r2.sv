`default_nettype none

module r2 #(parameter BITS=16)
(
    input logic clk,
    input logic [BITS-1:0] a_in_real, a_in_imag, b_in_real, b_in_imag,
    output logic [BITS:0] a_out_real, a_out_imag, b_out_real, b_out_imag
);

localparam PAD = 16 - BITS;  

adder #(.SUB(0)) real_add(.a({{PAD{a_in_real[BITS-1]}}, a_in_real}), .b({{PAD{b_in_real[BITS-1]}}, b_in_real}), .result(a_out_real));
adder #(.SUB(0)) imag_add(.a({{PAD{a_in_imag[BITS-1]}}, a_in_imag}), .b({{PAD{b_in_imag[BITS-1]}}, b_in_imag}), .result(a_out_imag));
adder #(.SUB(1)) real_sub(.a({{PAD{a_in_real[BITS-1]}}, a_in_real}), .b({{PAD{b_in_real[BITS-1]}}, b_in_real}), .result(b_out_real));
adder #(.SUB(1)) imag_sub(.a({{PAD{a_in_imag[BITS-1]}}, a_in_imag}), .b({{PAD{b_in_imag[BITS-1]}}, b_in_imag}), .result(b_out_imag));

endmodule