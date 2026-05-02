`default_nettype none

module triv_rotator #(parameter BITS = 16, parameter DECIMAL = 8) 
(
    input logic clk, rst, 
    input logic rot_en,
    input logic signed [BITS-1:0] real_in, imag_in,
    output logic signed [BITS-1:0] real_out, imag_out
);

    logic signed [BITS-1:0] rot_real, rot_imag;

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            rot_real <= '0;
            rot_imag <= '0;
        end else begin 
            rot_real <= imag_in;
            rot_imag <= -2'sd1 * real_in;
        end
    end

    assign real_out = rot_en ? rot_real : real_in;
    assign imag_out = rot_en ? rot_imag : imag_in;
endmodule