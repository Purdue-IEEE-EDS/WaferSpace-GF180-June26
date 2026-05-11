module full_adder(
    input logic a, b, cin, 
    output logic s, cout
);

assign s = a ^ b ^ cin; 
assign cout = (a & b) | (cin & (a ^ b));

endmodule