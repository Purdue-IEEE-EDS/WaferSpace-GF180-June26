(* keep_hierarchy = "yes" *)
module CLA4(
    input logic [3:0] a,
    input logic [3:0] b, 
    input logic cin,
    output logic [3:0] s,  
    output logic p2, g2
);
    (* keep = 1 *) logic [3:0] p, g, c;

    assign c[0] = cin; 
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

    full_adder_cla add0(.a(a[0]), .b(b[0]), .cin(c[0]), .p(p[0]), .g(g[0]), .s(s[0]));
    full_adder_cla add1(.a(a[1]), .b(b[1]), .cin(c[1]), .p(p[1]), .g(g[1]), .s(s[1]));
    full_adder_cla add2(.a(a[2]), .b(b[2]), .cin(c[2]), .p(p[2]), .g(g[2]), .s(s[2]));
    full_adder_cla add3(.a(a[3]), .b(b[3]), .cin(c[3]), .p(p[3]), .g(g[3]), .s(s[3]));

    assign g2 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p2 = &p;
endmodule