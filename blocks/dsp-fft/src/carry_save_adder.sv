module carry_save_adder #(parameter WIDTH=32) 
(
    input logic [WIDTH-1:0] a, 
    input logic [WIDTH-1:0] b, 
    input logic [WIDTH-1:0] cin,
    output logic [WIDTH-1:0] s, 
    output logic [WIDTH-1:0] cout  
);  

    always_comb begin
        for (int i = 0; i < WIDTH; i++) begin 
            // full_adder fa(.a(a[i]), .b(b[i]), .cin(cin[i]), .s(s[i]), .cout(cout[i]));

            s[i] = a[i] ^ b[i] ^ cin[i];
            cout[i] = (a[i] & b[i]) | (cin[i] & (a[i] ^ b[i]));
        end 
    end
endmodule