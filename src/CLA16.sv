(* keep_hierarchy *)
module CLA16
(
    input logic [15:0] a, b,
    input logic cin,
    output logic [15:0] s,
    output logic p_out, g_out
);

    logic [3:0] p, g; 
    logic [3:0] c; 

    assign c[0] = cin; 
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

    CLA4 block0(.a(a[3:0]), .b(b[3:0]), .cin(c[0]), .s(s[3:0]), .p2(p[0]), .g2(g[0]));
    CLA4 block1(.a(a[7:4]), .b(b[7:4]), .cin(c[1]), .s(s[7:4]), .p2(p[1]), .g2(g[1]));
    CLA4 block2(.a(a[11:8]), .b(b[11:8]), .cin(c[2]), .s(s[11:8]), .p2(p[2]), .g2(g[2]));
    CLA4 block3(.a(a[15:12]), .b(b[15:12]), .cin(c[3]), .s(s[15:12]), .p2(p[3]), .g2(g[3]));

    assign g_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p_out = &p;
        
endmodule 