`default_nettype none

module r2 #(parameter BITS=16, parameter DECIMAL=8)
(
    input logic clk, rst,
    input logic  [2*BITS-1:0] a_in, b_in,
    output logic [2*BITS-1:0] a_out, b_out
);

    always_ff @(posedge clk) begin
         if (!rst) begin
             a_out <= '0; 
             b_out <= '0;
         end else begin
             a_out <= {a_in[2*BITS-1:BITS] + b_in[2*BITS-1:BITS], a_in[BITS-1:0] + b_in[BITS-1:0]};
             b_out <= {a_in[2*BITS-1:BITS] - b_in[2*BITS-1:BITS], a_in[BITS-1:0] - b_in[BITS-1:0]};
         end
     end

    // assign a_out = {a_in[2*BITS-1:BITS] + b_in[2*BITS-1:BITS], a_in[BITS-1:0] + b_in[BITS-1:0]};
    // assign b_out = {a_in[2*BITS-1:BITS] - b_in[2*BITS-1:BITS], a_in[BITS-1:0] - b_in[BITS-1:0]};
endmodule
