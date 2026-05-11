module wallace_mult #(
    parameter W = 16
)(
    input logic clk, rst, 
    input  logic signed [W-1:0] a,
    input  logic signed [W-1:0] b,
    output logic signed [(2*W)-1:0] p
);

    localparam PP = W/2 + 1;

    logic [W:0] b_ext;

    assign b_ext = {b, 1'b0};

    // -------------------------------------------------------------------------
    // Partial products
    // -------------------------------------------------------------------------

    logic signed [(2*W)-1:0] partial [0:PP-1];
    logic signed [(2*W)-1:0] partial_pip [0:PP-1];

    logic [2:0] booth_bits;

    logic signed [W-1:0] neg_a; 

    adder #(.SUB(1)) sub0(
        .a(16'b0), .b(a),
        .result(neg_a)
    );

    always_comb begin
        for (int i = 0; i < PP; i = i + 1) begin

            booth_bits = b_ext[2*i +: 3];

            case (booth_bits)

                // 0
                3'b000,
                3'b111:
                    partial[i] = 0;

                // +A
                3'b001,
                3'b010:
                    partial[i] =
                        $signed(a) <<< (2*i);

                // +2A
                3'b011:
                    partial[i] =
                        ($signed(a) <<< 1) <<< (2*i);

                // -2A
                3'b100:
                    partial[i] =
                        $signed(neg_a) <<< (2*i+1);

                // -A
                3'b101,
                3'b110:
                    partial[i] =
                        $signed(neg_a) <<< (2*i);

                default:
                    partial[i] = 0;

            endcase
        end
    end

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            for (int i = 0; i < PP; i++) partial_pip[i] <= '0;
        end else begin 
            for (int i = 0; i < PP; i++) partial_pip[i] <= partial[i];
        end
    end

    // -------------------------------------------------------------------------
    // Wallace reduction (simple CSA chain version)
    // -------------------------------------------------------------------------

    logic [31:0] cout [0:6];
    logic [31:0] stage_out [0:6];

    // DIRECT 
    assign p[1:0] = partial_pip[0][1:0];

    // STAGE 0
    half_adder bit2(
        .a(partial_pip[0][2]), .b(partial_pip[1][2]), 
        .s(p[2]), .cout(cout[0][2])
    );

    half_adder bit3(
        .a(partial_pip[0][3]), .b(partial_pip[1][3]),
        .s(stage_out[0][3]), .cout(cout[0][3])
    );

    generate
        for (genvar i = 4; i < 32; i++) begin
            full_adder fa ( 
                .a(partial_pip[0][i]), .b(partial_pip[1][i]), .cin(partial_pip[2][i]),
                .s(stage_out[0][i]), .cout(cout[0][i])
            );
        end
    endgenerate

    // STAGE 1 
    half_adder bit6_s1 (
        .a(stage_out[0][6]), .b(partial_pip[3][6]),
        .s(stage_out[1][6]), .cout(cout[1][6])
    );

    full_adder bit7_s1 (
        .a(stage_out[0][7]), .b(partial_pip[3][7]), .cin(cout[0][6]),
        .s(stage_out[1][7]), .cout(cout[1][7])
    );

    generate
        for (genvar i = 8; i < 32; i++) begin
            full_adder fa ( 
                .a(stage_out[0][i]), .b(partial_pip[3][i]), .cin(cout[0][i-1]),
                .s(stage_out[1][i]), .cout(cout[1][i])
            );
        end
    endgenerate

    // STAGE 2

    half_adder bit8_s2 (
        .a(stage_out[1][8]), .b(partial_pip[4][8]),
        .s(stage_out[2][8]), .cout(cout[2][8])
    );

    full_adder bit9_s2 (
        .a(stage_out[1][9]), .b(partial_pip[4][9]), .cin(cout[1][8]),
        .s(stage_out[2][9]), .cout(cout[2][9])
    );

    generate
        for (genvar i = 10; i < 32; i++) begin
            full_adder fa ( 
                .a(stage_out[1][i]), .b(partial_pip[4][i]), .cin(cout[1][i-1]),
                .s(stage_out[2][i]), .cout(cout[2][i])
            );
        end
    endgenerate

    // STAGE 3 

    half_adder bit10_s3 (
        .a(stage_out[2][10]), .b(partial_pip[5][10]),
        .s(stage_out[3][10]), .cout(cout[3][10])
    );

    full_adder bit11_s3 (
        .a(stage_out[2][11]), .b(partial_pip[5][11]), .cin(cout[2][10]),
        .s(stage_out[3][11]), .cout(cout[3][11])
    );

    generate
        for (genvar i = 12; i < 32; i++) begin
            full_adder fa ( 
                .a(stage_out[2][i]), .b(partial_pip[5][i]), .cin(cout[2][i-1]),
                .s(stage_out[3][i]), .cout(cout[3][i])
            );
        end
    endgenerate

    // STAGE 4 

    half_adder bit12_s4 (
        .a(stage_out[3][12]), .b(partial_pip[6][12]),
        .s(stage_out[4][12]), .cout(cout[4][12])
    );

    full_adder bit13_s4 (
        .a(stage_out[3][13]), .b(partial_pip[6][13]), .cin(cout[3][12]),
        .s(stage_out[4][13]), .cout(cout[4][13])
    );

    generate
        for (genvar i = 14; i < 32; i++) begin
            full_adder fa ( 
                .a(stage_out[3][i]), .b(partial_pip[6][i]), .cin(cout[3][i-1]),
                .s(stage_out[4][i]), .cout(cout[4][i])
            );
        end
    endgenerate

    // STAGE 5

    half_adder bit14_s5 (
        .a(stage_out[4][14]), .b(partial_pip[7][14]),
        .s(stage_out[5][14]), .cout(cout[5][14])
    );

    full_adder bit15_s5 (
        .a(stage_out[4][15]), .b(partial_pip[7][15]), .cin(cout[4][14]),
        .s(stage_out[5][15]), .cout(cout[5][15])
    );

    generate
        for (genvar i = 16; i < 32; i++) begin
            full_adder fa ( 
                .a(stage_out[4][i]), .b(partial_pip[7][i]), .cin(cout[4][i-1]),
                .s(stage_out[5][i]), .cout(cout[5][i])
            );
        end
    endgenerate

    // STAGE 6

    half_adder bit16_s6 (
        .a(stage_out[5][16]), .b(partial_pip[8][16]),
        .s(stage_out[6][16]), .cout(cout[6][16])
    );

    full_adder bit17_s6 (
        .a(stage_out[5][17]), .b(partial_pip[8][17]), .cin(cout[5][16]),
        .s(stage_out[6][17]), .cout(cout[6][17])
    );

    generate
        for (genvar i = 18; i < 32; i++) begin
            full_adder fa ( 
                .a(stage_out[5][i]), .b(partial_pip[8][i]), .cin(cout[5][i-1]),
                .s(stage_out[6][i]), .cout(cout[6][i])
            );
        end
    endgenerate

    // Final add

    assign p[31:3] = {stage_out[6][31], stage_out[6][30], stage_out[6][29], stage_out[6][28], stage_out[6][27], stage_out[6][26], stage_out[6][25], stage_out[6][24], stage_out[6][23], stage_out[6][22], stage_out[6][21], stage_out[6][20], stage_out[6][19], stage_out[6][18], stage_out[6][17], stage_out[6][16], stage_out[5][15], stage_out[5][14], stage_out[4][13], stage_out[4][12], stage_out[3][11], stage_out[3][10], stage_out[2][9], stage_out[2][8], stage_out[1][7], stage_out[1][6], stage_out[0][5], stage_out[0][4], stage_out[0][3]} + {cout[6][30], cout[6][29], cout[6][28], cout[6][27], cout[6][26], cout[6][25], cout[6][24], cout[6][23], cout[6][22], cout[6][21], cout[6][20], cout[6][19], cout[6][18], cout[6][17], cout[6][16], cout[5][15], cout[5][14], cout[4][13], cout[4][12], cout[3][11], cout[3][10], cout[2][9], cout[2][8], cout[1][7], cout[1][6], cout[0][5], cout[0][4], cout[0][3], cout[0][2]};

endmodule