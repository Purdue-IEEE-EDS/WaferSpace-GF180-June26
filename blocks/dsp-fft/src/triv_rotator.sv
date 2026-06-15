`default_nettype none

module triv_rotator #(parameter BITS = 16, parameter DECIMAL = 8) 
(
    input logic clk,
    input logic signed [BITS-1:0] real_in, imag_in,
    output logic signed [BITS-1:0] real_out, imag_out
);

    logic signed [BITS-1:0] rot_real, rot_imag, real_in_reg, imag_in_reg, neg_real;

    always_ff @(posedge clk) begin 
        real_in_reg <= real_in;
        imag_in_reg <= imag_in;
    end

    assign real_out = imag_in_reg;
    assign imag_out = neg_real;

    adder #(.SUB(1)) imag_sub(.a(16'b0), .b(real_in_reg), .result(neg_real));
endmodule