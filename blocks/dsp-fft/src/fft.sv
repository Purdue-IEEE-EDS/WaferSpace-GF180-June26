module fft
(
    input  logic clk, rst,
    input logic in_valid,

    input  logic signed [15:0] in_real,
    input  logic signed [15:0] in_imag,

    output logic signed [15:0] out_real,
    output logic signed [15:0] out_imag,
    output logic out_valid
); 
    
    logic [15:0] in_re [0:8];
    logic [15:0] in_im [0:8];

    logic valid [0:8]; 

    assign in_re[0] = in_real;
    assign in_im[0] = in_imag;

    assign valid[0] = in_valid;

    assign out_real = in_re[8];
    assign out_imag = in_im[8];
    assign out_valid = valid[8];
    
    genvar i;
    generate 
        for (i = 0; i < 8; i++) begin 
            stage #(
                .BITS(16), 
                .STAGES(8), 
                .CURR_STAGE((i+1)))
            stage (
                .clk(clk), .rst(rst),
                .in_valid(valid[i]), 
                .in_real(in_re[i]), .in_imag(in_im[i]), 
                .out_real(in_re[i+1]), .out_imag(in_im[i+1]), 
                .out_valid(valid[i+1])
            );
        end
    endgenerate
endmodule