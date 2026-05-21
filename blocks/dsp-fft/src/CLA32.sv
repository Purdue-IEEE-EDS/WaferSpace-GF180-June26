(* keep_hierarchy *)
module CLA32 #(parameter SUB = 0)
(
    input logic [31:0] a, b,
    output logic [31:0] result
);

    generate 
        if (SUB == 0) begin 
            logic [3:0] p, g; 
            logic [1:0] c; 

            assign c[0] = 1'b0; 
            assign c[1] = g[0] | (p[0] & c[0]);

            CLA16 block1(.a(a[15:0]), .b(b[15:0]), .cin(c[0]), .s(result[15:0]), .p_out(p[0]), .g_out(g[0]));
            CLA16 block2(.a(a[31:16]), .b(b[31:16]), .cin(c[1]), .s(result[31:16]), .p_out(p[1]), .g_out(g[1]));

        end 
        else begin 
            logic [3:0] p, g; 
            logic [3:0] c; 

            assign c[0] = 1'b1; 
            assign c[1] = g[0] | (p[0] & c[0]);
            
            CLA16 block1(.a(a[15:0]), .b(~b[15:0]), .cin(c[0]), .s(result[15:0]), .p_out(p[0]), .g_out(g[0]));
            CLA16 block2(.a(a[31:16]), .b(~b[31:16]), .cin(c[1]), .s(result[31:16]), .p_out(p[1]), .g_out(g[1]));
            
        end
    endgenerate
endmodule 