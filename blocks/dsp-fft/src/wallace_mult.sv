module wallace_mult #(
    parameter W = 16
)(
    input logic clk, 
    input  logic signed [W-1:0] a,
    input  logic signed [W-1:0] b,
    output logic signed [(2*W)-1:0] p
);

    // localparam PP = W/2 + 1;

    // logic [W:0] b_ext;

    // assign b_ext = {b, 1'b0};

    // // -------------------------------------------------------------------------
    // // Partial products
    // // -------------------------------------------------------------------------

    // logic signed [(2*W)-1:0] partial [0:PP-1];
    // logic signed [(2*W)-1:0] partial_pip [0:PP-1];
    // logic signed [(2*W)-1:0] partial_pip_b [0:PP-1];
    // logic signed [(2*W)-1:0] partial_pip_c [0:PP-1];
    // logic signed [(2*W)-1:0] partial_pip_d [0:PP-1];
    // logic signed [(2*W)-1:0] partial_pip_e [0:PP-1];

    // logic [2:0] booth_bits;

    // logic signed [W-1:0] neg_a; 

    // adder #(.SUB(1)) sub0(
    //     .a(16'b0), .b(a),
    //     .result(neg_a)
    // );

    // always_comb begin
    //     for (int i = 0; i < PP; i = i + 1) begin

    //         booth_bits = b_ext[2*i +: 3];

    //         case (booth_bits)

    //             // 0
    //             3'b000,
    //             3'b111:
    //                 partial[i] = 0;

    //             // +A
    //             3'b001,
    //             3'b010:
    //                 partial[i] =
    //                     $signed(a) <<< (2*i);

    //             // +2A
    //             3'b011:
    //                 partial[i] =
    //                     ($signed(a) <<< 1) <<< (2*i);

    //             // -2A
    //             3'b100:
    //                 partial[i] =
    //                     $signed(neg_a) <<< (2*i+1);

    //             // -A
    //             3'b101,
    //             3'b110:
    //                 partial[i] =
    //                     $signed(neg_a) <<< (2*i);

    //             default:
    //                 partial[i] = 0;

    //         endcase
    //     end
    // end

    // always_ff @(posedge clk) begin 
    //     for (int i = 0; i < PP; i++) partial_pip[i] <= partial[i];
    //     for (int i = 0; i < PP; i++) partial_pip_b[i] <= partial[i];
    //     for (int i = 0; i < PP; i++) partial_pip_c[i] <= partial[i];
    //     for (int i = 0; i < PP; i++) partial_pip_d[i] <= partial[i];
    //     for (int i = 0; i < PP; i++) partial_pip_e[i] <= partial[i];
    // end


    // // CSA adders 
    // logic [(2*W)-1:0] s11, s12, s13, s14, s15, s16, s21, s22, s23, s24, s31, s32, op1, op2; 

    // carry_save_adder #(.WIDTH(2*W)) csa1(.a(partial_pip[0]), .b(partial_pip_c[1]), .cin(partial_pip_d[2]), .s(s11), .cout(s12));
    // carry_save_adder #(.WIDTH(2*W)) csa2(.a(partial_pip_d[3]), .b(partial_pip_e[4]), .cin(partial_pip[5]), .s(s13), .cout(s14));
    // carry_save_adder #(.WIDTH(2*W)) csa3(.a(partial_pip[6]), .b(partial_pip_b[7]), .cin(partial_pip[8]), .s(s15), .cout(s16));

    // logic [(2*W)-1:0] s11_pip, s12_pip, s13_pip, s14_pip, s15_pip, s16_pip; 
    // always_ff @(posedge clk) begin 
    //     s11_pip <= s11; 
    //     s12_pip <= s12<<<1;  
    //     s13_pip <= s13;  
    //     s14_pip <= s14 <<1;  
    //     s15_pip <= s15;  
    //     s16_pip <= s16 <<<1;
    // end

    // carry_save_adder #(.WIDTH(2*W)) csa4(.a(s11_pip), .b(s12_pip), .cin(s13_pip), .s(s21), .cout(s22));
    // carry_save_adder #(.WIDTH(2*W)) csa5(.a(s14_pip), .b(s15_pip), .cin(s16_pip), .s(s23), .cout(s24));

    // carry_save_adder #(.WIDTH(2*W)) csa6(.a(s21), .b(s22<<<1), .cin(s23), .s(s31), .cout(s32));

    // carry_save_adder #(.WIDTH(2*W)) csa7(.a(s31), .b(s32<<<1), .cin(s24<<<1), .s(op1), .cout(op2));

    // logic [(2*W)-1:0] op1_pip, op2_pip; 

    // always_ff @(posedge clk) begin 
    //     op1_pip <= op1; 
    //     op2_pip <= op2<<1; 
    // end
    // assign p = op1_pip + op2_pip; 

    logic [(2*W)-1:0] partial [0:W-1];

    always_comb begin
        for (int i = 0; i < W-1; i++) begin
            // Bitwise AND of a_reg with each bit of b_reg
            // We sign-extend to 32 bits for the Wallace tree
            partial[i] = (b[i]) ? ($signed(a) <<< i) : 32'b0;
        end
        partial[W-1] = (b[W-1]) ? (-$signed(a) <<< (W-1)) : 32'b0;
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

    assign p = op1 + op2; 
endmodule