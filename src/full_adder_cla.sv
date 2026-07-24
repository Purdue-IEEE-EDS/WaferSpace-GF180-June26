// (* keep_hierarchy = "yes" *)
module full_adder_cla(
    input logic a, b, cin, 
    output logic p, g, 
    output logic s
);
 
assign s = a ^ b ^ cin; 
assign p = a | b; 
assign g = a & b; 

endmodule