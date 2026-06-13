module wallace_mult #(
    parameter W = 16,
    parameter DECIMAL = 12
)(
    input logic clk, 
    input  logic signed [W-1:0] a,
    input  logic signed [W-1:0] b,
    output logic signed [W-1:0] p
); 

    logic [(2*W)-1:0] partial [0:W-1];

    always_comb begin
        // 1. Default initialization to prevent latches
        for (int i = 0; i < 16; i++) begin
            partial[i] = 32'b0;
        end

        // 2. Rows 0 through 14 (Standard Baugh-Wooley Rows)
        for (int i = 0; i < 15; i++) begin
            partial[i] = {~(a[15] & b[i]), (a[14:0] & {15{b[i]}})} << i;
        end

        // 4. Row 15 (The Sign Row - Negative Weight)
        for (int j = 0; j < 16; j++) begin
            partial[15] = {(a[15] & b[15]), ~(a[14:0] & {15{b[15]}})}<<15;
        end

        partial[15][31] = 1'b1;
        partial[0][16] = 1'b1;
    end

    logic [(2*W)-1:0] partial_pip [0:W-1];
    always_ff @(posedge clk) begin
        for (int i = 0; i < W; i++) begin
            partial_pip[i] <= partial[i];
        end
    end

    logic [(2*W)-1:0] s10, s11, s12, s13, s14, s15, s16, s17, s18, s19;
    logic [(2*W)-1:0] s20, s21, s22, s23, s24, s25;
    logic [(2*W)-1:0] s30, s31, s32, s33;
    logic [(2*W)-1:0] s40, s41, s42, s43;
    logic [(2*W)-1:0] s50, s51;
    logic [(2*W)-1:0] s60, s61;
    logic [(2*W)-1:0] op1, op2;

    carry_save_adder #(.WIDTH(2*W)) csa_s1_0(.a(partial_pip[0]), .b(partial_pip[1]), .cin(partial_pip[2]), .s(s10), .cout(s11));
    carry_save_adder #(.WIDTH(2*W)) csa_s1_1(.a(partial_pip[3]), .b(partial_pip[4]), .cin(partial_pip[5]), .s(s12), .cout(s13));
    carry_save_adder #(.WIDTH(2*W)) csa_s1_2(.a(partial_pip[6]), .b(partial_pip[7]), .cin(partial_pip[8]), .s(s14), .cout(s15));
    carry_save_adder #(.WIDTH(2*W)) csa_s1_3(.a(partial_pip[9]), .b(partial_pip[10]), .cin(partial_pip[11]), .s(s16), .cout(s17));
    carry_save_adder #(.WIDTH(2*W)) csa_s1_4(.a(partial_pip[12]), .b(partial_pip[13]), .cin(partial_pip[14]), .s(s18), .cout(s19));

    carry_save_adder #(.WIDTH(2*W)) csa_s2_0(.a(s10), .b(s11<<1), .cin(s12), .s(s20), .cout(s21));
    carry_save_adder #(.WIDTH(2*W)) csa_s2_1(.a(s13<<1), .b(s14), .cin(s15<<1), .s(s22), .cout(s23));
    carry_save_adder #(.WIDTH(2*W)) csa_s2_2(.a(s16), .b(s17<<1), .cin(partial_pip[15]), .s(s24), .cout(s25));
    
    carry_save_adder #(.WIDTH(2*W)) csa_s3_1(.a(s18), .b(s19<<1), .cin(s20), .s(s30), .cout(s31));
    carry_save_adder #(.WIDTH(2*W)) csa_s3_2(.a(s21<<1), .b(s22), .cin(s23<<1), .s(s32), .cout(s33));

    logic [(2*W)-1:0] s24_pip, s25_pip, s30_pip, s31_pip, s32_pip, s33_pip; 

    always_ff @(posedge clk) begin 
        s24_pip <= s24;
        s25_pip <= s25 << 1; 
        s30_pip <= s30; 
        s31_pip <= s31 << 1; 
        s32_pip <= s32; 
        s33_pip <= s33 << 1; 
    end

    carry_save_adder #(.WIDTH(2*W)) csa_s4_1(.a(s24_pip), .b(s25_pip), .cin(s30_pip), .s(s40), .cout(s41));
    carry_save_adder #(.WIDTH(2*W)) csa_s4_2(.a(s31_pip), .b(s32_pip), .cin(s33_pip), .s(s42), .cout(s43));

    carry_save_adder #(.WIDTH(2*W)) csa_s5_1(.a(s40), .b(s41<<1), .cin(s42), .s(s50), .cout(s51));

    carry_save_adder #(.WIDTH(2*W)) csa_s6_1(.a(s43<<1), .b(s50), .cin(s51<<1), .s(s60), .cout(s61));

    always_ff @(posedge clk) begin 
        op1 <= s60;
        op2 <= s61<<1; 
    end

    //assign p = op1 + op2; 

    //CLA32 #(.SUB(0)) final_add(.a(op1), .b(op2), .result(p));
    adder final_add(.a(op1>>>15), .b(op2>>>15), .result(p));
endmodule