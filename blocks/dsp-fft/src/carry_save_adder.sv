(* keep_hierarchy *)
module carry_save_adder #(parameter WIDTH) 
(
    input logic [WIDTH-1:0] a, 
    input logic [WIDTH-1:0] b, 
    input logic [WIDTH-1:0] cin,
    output logic [WIDTH-1:0] s, 
    output logic [WIDTH-1:0] cout  
);

    generate
        for (genvar i = 0; i < WIDTH; i++) begin 
            full_adder fa(.a(a[i]), .b(b[i]), .cin(cin[i]), .s(s[i]), .cout(cout[i]));
        end
    endgenerate
endmodule