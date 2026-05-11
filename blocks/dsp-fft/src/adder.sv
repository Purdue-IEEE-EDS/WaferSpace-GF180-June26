module adder #(parameter SUB = 0)
(
    input logic [15:0] a, b,
    output logic [15:0] result
);

    generate 
        if (SUB == 0) begin 
            logic [3:0] p, g; 
            logic [3:0] c; 

            assign c[0] = 1'b0; 
            assign c[1] = g[0] | (p[0] & c[0]);
            assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
            assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

            CLA4 block0(.a(a[3:0]), .b(b[3:0]), .cin(c[0]), .s(result[3:0]), .p2(p[0]), .g2(g[0]));
            CLA4 block1(.a(a[7:4]), .b(b[7:4]), .cin(c[1]), .s(result[7:4]), .p2(p[1]), .g2(g[1]));
            CLA4 block2(.a(a[11:8]), .b(b[11:8]), .cin(c[2]), .s(result[11:8]), .p2(p[2]), .g2(g[2]));
            CLA4 block3(.a(a[15:12]), .b(b[15:12]), .cin(c[3]), .s(result[15:12]), .p2(p[3]), .g2(g[3]));
        end 
        else begin 
            logic [3:0] p, g; 
            logic [3:0] c; 

            assign c[0] = 1'b1; 
            assign c[1] = g[0] | (p[0] & c[0]);
            assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
            assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

            CLA4 block0(.a(a[3:0]), .b(~b[3:0]), .cin(c[0]), .s(result[3:0]), .p2(p[0]), .g2(g[0]));
            CLA4 block1(.a(a[7:4]), .b(~b[7:4]), .cin(c[1]), .s(result[7:4]), .p2(p[1]), .g2(g[1]));
            CLA4 block2(.a(a[11:8]), .b(~b[11:8]), .cin(c[2]), .s(result[11:8]), .p2(p[2]), .g2(g[2]));
            CLA4 block3(.a(a[15:12]), .b(~b[15:12]), .cin(c[3]), .s(result[15:12]), .p2(p[3]), .g2(g[3]));
        end
    endgenerate
endmodule 