`default_nettype none

module rotator #(parameter BITS = 16, parameter DECIMAL = 8) 
(
    input logic clk, rst, 
    input logic signed [BITS-1:0] real_in, imag_in, real_tw, imag_tw,
    output logic signed [BITS-1:0] real_out, imag_out
);

    logic signed [BITS-1:0] a, b, c, d, sum1, sum2, sum1_pip, sum2_pip;
    logic signed [BITS-1:0] ac, bd, bc, ad, ac_pip, bd_pip, ad_pip, bc_pip;

    always_ff @(posedge clk) begin 
        a <= real_in;
        b <= imag_in;
        c <= real_tw;
        d <= imag_tw;
    end

    wallace_mult #(
     .W(16)
    ) mult1(
        .clk,
        .a(a),
        .b(c),
        .p(ac)
    );

    wallace_mult #(
     .W(16)
    ) mult2(
        .clk,
        .a(b),
        .b(d),
        .p(bd)
    );

    wallace_mult #(
     .W(16)
    ) mult3(
        .clk,
        .a(b),
        .b(c),
        .p(bc)
    );

    wallace_mult #(
     .W(16)
    ) mult4(
        .clk,
        .a(a),
        .b(d),
        .p(ad)
    );

    logic [31:0] real_temp; 
    logic [31:0] imag_temp;

    always_ff @(posedge clk) begin 
        ac_pip <= ac; 
        ad_pip <= ad; 
        bc_pip <= bc; 
        bd_pip <= bd;  
    end

    // CLA32 #(.SUB(1)) re(.a(ac_pip), .b(bd_pip), .result(real_out));
    // CLA32 #(.SUB(0)) im(.a(bc_pip), .b(ad_pip), .result(imag_out));

    adder #(.SUB(1)) re(.a(ac_pip), .b(bd_pip), .result(real_out));
    adder #(.SUB(0)) im(.a(bc_pip), .b(ad_pip), .result(imag_out));
endmodule