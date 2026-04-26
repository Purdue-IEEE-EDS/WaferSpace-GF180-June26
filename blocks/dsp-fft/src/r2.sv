`default_nettype none

module r2 #(parameter BITS=16)
(
    input logic clk, rst,
    input logic mode, 
    input logic signed  [BITS-1:0] a_in_real, a_in_imag, b_in_real, b_in_imag,
    output logic signed [BITS-1:0] a_out_real, a_out_imag, b_out_real, b_out_imag
);

logic signed [BITS-1:0] next_a_out_real, next_a_out_imag, next_b_out_real, next_b_out_imag;

always_ff @( posedge clk, negedge rst ) begin
    if (!rst) begin 
        a_out_real <= '0; 
        a_out_imag <= '0; 
        b_out_real <= '0; 
        b_out_imag <= '0; 
    end else begin 
        a_out_real <= next_a_out_real;
        a_out_imag <= next_a_out_imag;  
        b_out_real <= next_b_out_real; 
        b_out_imag <= next_b_out_imag; 
    end
end

always_comb begin : next_out_logic
    if (!mode) begin 
        next_a_out_real = a_in_real; 
        next_a_out_imag = a_in_imag; 
        next_b_out_real = b_in_real;
        next_b_out_imag = b_in_imag;
    end else begin 
        next_a_out_real = a_in_real + b_in_real;
        next_a_out_imag = a_in_imag + b_in_imag;
        next_b_out_real = a_in_real - b_in_real;
        next_b_out_imag = a_in_imag - b_in_imag; 
    end
end

endmodule