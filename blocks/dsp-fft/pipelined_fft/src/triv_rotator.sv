`default_nettype none

module triv_rotator #(parameter BITS = 16, parameter DECIMAL = 8) 
(
    input logic clk, rst, 
    input logic rot_en,
    input logic signed [2*BITS-1:0] data_in, 
    output logic signed [2*BITS-1:0] data_out
);

    logic signed [BITS-1:0] re, imag;
    logic signed [BITS-1:0] rot_real, rot_imag;

    assign re = data_in[2*BITS-1:BITS];
    assign imag = data_in[BITS-1:0];

    assign rot_real = -2'sd1 * imag;
    assign rot_imag = re;

    assign data_out = rot_en ? {rot_real, rot_imag} : data_in;
endmodule