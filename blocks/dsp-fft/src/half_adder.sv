module half_adder(
    input logic a, b, 
    output logic s, cout
);

assign s = a ^ b; 
assign cout = a & b;

endmodule