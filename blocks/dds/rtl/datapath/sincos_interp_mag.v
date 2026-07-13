`default_nettype none
`timescale 1ns/1ps

// Truncated phase -> interpolated sin/cos magnitudes + signs.
//
// Timing contract:
//   - A phase_i sample captured at S1 on edge N reaches
//     {mag_i, mag_q, sign_i, sign_q, valid_o} just after edge N+6.
//   - That is 7 registered stages, or 6 full clk intervals.
//
// Registered stages:
//   S1: coarse/fraction/sign register
//   S2: shared sin/cos ROM read
//   S3a: slope * fraction bit partials
//   S3b: partial-product pair sums
//   S3c: final product sum
//   S4: interpolation add + BASE_W rounding
//   S5: guard-bit rounding, fold swap, sign output
module sincos_interp_mag #(
    parameter int SINE_TRUNC_W = 14,
    parameter int MAG_W        = 9,
    parameter int COARSE_W     = 7,
    parameter int FRAC_W       = SINE_TRUNC_W - 2 - COARSE_W,
    parameter int GUARD_W      = 3,
    parameter int BASE_W       = MAG_W + GUARD_W,
    parameter int SLOPE_W      = 8
) (
    input  logic                    clk,
    input  logic                    rst_n,
    input  logic                    valid_i,
    input  logic [SINE_TRUNC_W-1:0] phase_i,
    output logic                    valid_o,
    output logic [MAG_W-1:0]        mag_i,
    output logic [MAG_W-1:0]        mag_q,
    output logic                    sign_i,
    output logic                    sign_q
);

    localparam int SINE_ADDR_W = SINE_TRUNC_W - 2;
    localparam int PROD_W      = SLOPE_W + FRAC_W + 1;
    localparam int ACC_W       = BASE_W + FRAC_W + 2;

    logic [COARSE_W-1:0] coarse_c;
    logic [FRAC_W-1:0]   frac_c;
    logic                fold_c;
    logic                sign_i_c;
    logic                sign_q_c;

    logic [COARSE_W-1:0] coarse_1;
    logic [FRAC_W-1:0]   frac_1;
    logic                fold_1;
    logic                sign_i_1;
    logic                sign_q_1;
    logic                valid_1;

    logic [BASE_W-1:0]         sin_base_2;
    logic signed [SLOPE_W-1:0] sin_slope_2;
    logic [BASE_W-1:0]         cos_base_2;
    logic signed [SLOPE_W-1:0] cos_slope_2;

    logic [FRAC_W-1:0] frac_2;
    logic              fold_2;
    logic              sign_i_2;
    logic              sign_q_2;
    logic              valid_2;

    localparam int PROD_PAIR_N = (FRAC_W + 1) / 2;

    logic signed [PROD_W-1:0] sin_part_3 [FRAC_W];
    logic signed [PROD_W-1:0] cos_part_3 [FRAC_W];
    logic [BASE_W-1:0]        sin_base_3;
    logic [BASE_W-1:0]        cos_base_3;
    logic              fold_3;
    logic              sign_i_3;
    logic              sign_q_3;
    logic              valid_3;

    logic signed [PROD_W-1:0] sin_pair_4 [PROD_PAIR_N];
    logic signed [PROD_W-1:0] cos_pair_4 [PROD_PAIR_N];
    logic signed [PROD_W-1:0] sin_pair_next [PROD_PAIR_N];
    logic signed [PROD_W-1:0] cos_pair_next [PROD_PAIR_N];
    logic [BASE_W-1:0] sin_base_4;
    logic [BASE_W-1:0] cos_base_4;
    logic              fold_4;
    logic              sign_i_4;
    logic              sign_q_4;
    logic              valid_4;

    logic signed [PROD_W-1:0] sin_prod_5;
    logic signed [PROD_W-1:0] cos_prod_5;
    logic signed [PROD_W-1:0] sin_prod_next;
    logic signed [PROD_W-1:0] cos_prod_next;
    logic [BASE_W-1:0] sin_base_5;
    logic [BASE_W-1:0] cos_base_5;
    logic              fold_5;
    logic              sign_i_5;
    logic              sign_q_5;
    logic              valid_5;

    logic signed [ACC_W-1:0] sin_prod_acc_5;
    logic signed [ACC_W-1:0] cos_prod_acc_5;
    logic signed [ACC_W-1:0] sin_base_acc_5;
    logic signed [ACC_W-1:0] cos_base_acc_5;
    logic signed [ACC_W-1:0] sin_acc_5;
    logic signed [ACC_W-1:0] cos_acc_5;

    logic [BASE_W-1:0] sin_ext_6;
    logic [BASE_W-1:0] cos_ext_6;
    logic              fold_6;
    logic              sign_i_6;
    logic              sign_q_6;
    logic              valid_6;

    logic [MAG_W-1:0] sin_mag_6;
    logic [MAG_W-1:0] cos_mag_6;

    initial begin
        if (SINE_TRUNC_W < 4)
            $error("sincos_interp_mag requires SINE_TRUNC_W >= 4");
        if (COARSE_W < 1)
            $error("sincos_interp_mag requires COARSE_W >= 1");
        if (FRAC_W < 1)
            $error("sincos_interp_mag requires FRAC_W >= 1");
        if ((COARSE_W + FRAC_W) != SINE_ADDR_W)
            $error("sincos_interp_mag requires COARSE_W + FRAC_W = SINE_TRUNC_W - 2");
        if (MAG_W < 1)
            $error("sincos_interp_mag requires MAG_W >= 1");
        if (GUARD_W < 0)
            $error("sincos_interp_mag requires GUARD_W >= 0");
        if (BASE_W != (MAG_W + GUARD_W))
            $error("sincos_interp_mag requires BASE_W = MAG_W + GUARD_W");
        if (SLOPE_W < 2)
            $error("sincos_interp_mag requires SLOPE_W >= 2");
    end

    function automatic logic [BASE_W-1:0] round_clip_base(
        input logic signed [ACC_W-1:0] acc
    );
        logic signed [ACC_W-1:0] acc_rounded;
        logic signed [ACC_W-1:0] shifted;
        begin
            acc_rounded = acc;
            if (FRAC_W > 0)
                acc_rounded = acc + ($signed({{(ACC_W-1){1'b0}}, 1'b1}) <<< (FRAC_W - 1));

            if (FRAC_W > 0)
                shifted = acc_rounded >>> FRAC_W;
            else
                shifted = acc_rounded;

            if (shifted <= 0)
                round_clip_base = '0;
            else if (shifted[ACC_W-1:BASE_W] != '0)
                round_clip_base = {BASE_W{1'b1}};
            else
                round_clip_base = shifted[BASE_W-1:0];
        end
    endfunction

    function automatic logic [MAG_W-1:0] round_sat_mag(
        input logic [BASE_W-1:0] v
    );
        logic [BASE_W:0] vr;
        logic [BASE_W:0] vs;
        begin
            vr = {1'b0, v};
            if (GUARD_W > 0)
                vr = vr + ({{BASE_W{1'b0}}, 1'b1} << (GUARD_W - 1));

            if (GUARD_W > 0)
                vs = vr >> GUARD_W;
            else
                vs = vr;

            if (vs[BASE_W:MAG_W] != '0)
                round_sat_mag = {MAG_W{1'b1}};
            else
                round_sat_mag = vs[MAG_W-1:0];
        end
    endfunction

    function automatic logic signed [PROD_W-1:0] slope_frac_bit(
        input logic signed [SLOPE_W-1:0] slope,
        input logic frac_bit,
        input int bit_idx
    );
        logic signed [PROD_W-1:0] slope_ext;
        begin
            slope_ext = {{(PROD_W-SLOPE_W){slope[SLOPE_W-1]}}, slope};
            slope_frac_bit = frac_bit ? (slope_ext <<< bit_idx) : '0;
        end
    endfunction

    phase_to_sincos_interp #(
        .SINE_TRUNC_W (SINE_TRUNC_W),
        .COARSE_W     (COARSE_W),
        .FRAC_W       (FRAC_W)
    ) u_phase_dec (
        .phase_i (phase_i),
        .coarse  (coarse_c),
        .frac    (frac_c),
        .fold    (fold_c),
        .sign_i  (sign_i_c),
        .sign_q  (sign_q_c)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            coarse_1 <= '0;
            frac_1   <= '0;
            fold_1   <= 1'b0;
            sign_i_1 <= 1'b0;
            sign_q_1 <= 1'b0;
            valid_1  <= 1'b0;
        end else begin
            coarse_1 <= coarse_c;
            frac_1   <= frac_c;
            fold_1   <= fold_c;
            sign_i_1 <= sign_i_c;
            sign_q_1 <= sign_q_c;
            valid_1  <= valid_i;
        end
    end

    sincos_interp_rom #(
        .COARSE_W (COARSE_W),
        .BASE_W   (BASE_W),
        .SLOPE_W  (SLOPE_W)
    ) u_interp_rom (
        .clk       (clk),
        .rst_n     (rst_n),
        .coarse    (coarse_1),
        .sin_base  (sin_base_2),
        .sin_slope (sin_slope_2),
        .cos_base  (cos_base_2),
        .cos_slope (cos_slope_2)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            frac_2   <= '0;
            fold_2   <= 1'b0;
            sign_i_2 <= 1'b0;
            sign_q_2 <= 1'b0;
            valid_2  <= 1'b0;
        end else begin
            frac_2   <= frac_1;
            fold_2   <= fold_1;
            sign_i_2 <= sign_i_1;
            sign_q_2 <= sign_q_1;
            valid_2  <= valid_1;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        integer stage3_idx;
        if (!rst_n) begin
            for (stage3_idx = 0; stage3_idx < FRAC_W; stage3_idx = stage3_idx + 1) begin
                sin_part_3[stage3_idx] <= '0;
                cos_part_3[stage3_idx] <= '0;
            end
            sin_base_3    <= '0;
            cos_base_3    <= '0;
            fold_3        <= 1'b0;
            sign_i_3      <= 1'b0;
            sign_q_3      <= 1'b0;
            valid_3       <= 1'b0;
        end else begin
            for (stage3_idx = 0; stage3_idx < FRAC_W; stage3_idx = stage3_idx + 1) begin
                sin_part_3[stage3_idx] <= slope_frac_bit(sin_slope_2, frac_2[stage3_idx], stage3_idx);
                cos_part_3[stage3_idx] <= slope_frac_bit(cos_slope_2, frac_2[stage3_idx], stage3_idx);
            end
            sin_base_3    <= sin_base_2;
            cos_base_3    <= cos_base_2;
            fold_3        <= fold_2;
            sign_i_3      <= sign_i_2;
            sign_q_3      <= sign_q_2;
            valid_3       <= valid_2;
        end
    end

    always_comb begin
        integer pair_comb_idx;
        for (pair_comb_idx = 0; pair_comb_idx < PROD_PAIR_N; pair_comb_idx = pair_comb_idx + 1) begin
            sin_pair_next[pair_comb_idx] = sin_part_3[pair_comb_idx * 2];
            cos_pair_next[pair_comb_idx] = cos_part_3[pair_comb_idx * 2];
            if (((pair_comb_idx * 2) + 1) < FRAC_W) begin
                sin_pair_next[pair_comb_idx] =
                    sin_part_3[pair_comb_idx * 2] + sin_part_3[(pair_comb_idx * 2) + 1];
                cos_pair_next[pair_comb_idx] =
                    cos_part_3[pair_comb_idx * 2] + cos_part_3[(pair_comb_idx * 2) + 1];
            end
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        integer stage4_idx;
        if (!rst_n) begin
            for (stage4_idx = 0; stage4_idx < PROD_PAIR_N; stage4_idx = stage4_idx + 1) begin
                sin_pair_4[stage4_idx] <= '0;
                cos_pair_4[stage4_idx] <= '0;
            end
            sin_base_4 <= '0;
            cos_base_4 <= '0;
            fold_4     <= 1'b0;
            sign_i_4   <= 1'b0;
            sign_q_4   <= 1'b0;
            valid_4    <= 1'b0;
        end else begin
            for (stage4_idx = 0; stage4_idx < PROD_PAIR_N; stage4_idx = stage4_idx + 1) begin
                sin_pair_4[stage4_idx] <= sin_pair_next[stage4_idx];
                cos_pair_4[stage4_idx] <= cos_pair_next[stage4_idx];
            end
            sin_base_4 <= sin_base_3;
            cos_base_4 <= cos_base_3;
            fold_4     <= fold_3;
            sign_i_4   <= sign_i_3;
            sign_q_4   <= sign_q_3;
            valid_4    <= valid_3;
        end
    end

    always_comb begin
        integer sum_comb_idx;
        sin_prod_next = '0;
        cos_prod_next = '0;
        for (sum_comb_idx = 0; sum_comb_idx < PROD_PAIR_N; sum_comb_idx = sum_comb_idx + 1) begin
            sin_prod_next = sin_prod_next + sin_pair_4[sum_comb_idx];
            cos_prod_next = cos_prod_next + cos_pair_4[sum_comb_idx];
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sin_prod_5 <= '0;
            cos_prod_5 <= '0;
            sin_base_5 <= '0;
            cos_base_5 <= '0;
            fold_5    <= 1'b0;
            sign_i_5  <= 1'b0;
            sign_q_5  <= 1'b0;
            valid_5   <= 1'b0;
        end else begin
            sin_prod_5 <= sin_prod_next;
            cos_prod_5 <= cos_prod_next;
            sin_base_5 <= sin_base_4;
            cos_base_5 <= cos_base_4;
            fold_5    <= fold_4;
            sign_i_5  <= sign_i_4;
            sign_q_5  <= sign_q_4;
            valid_5   <= valid_4;
        end
    end

    assign sin_prod_acc_5 = sin_prod_5;
    assign cos_prod_acc_5 = cos_prod_5;
    assign sin_base_acc_5 = $signed({1'b0, sin_base_5, {FRAC_W{1'b0}}});
    assign cos_base_acc_5 = $signed({1'b0, cos_base_5, {FRAC_W{1'b0}}});
    assign sin_acc_5      = sin_base_acc_5 + sin_prod_acc_5;
    assign cos_acc_5      = cos_base_acc_5 + cos_prod_acc_5;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sin_ext_6 <= '0;
            cos_ext_6 <= '0;
            fold_6    <= 1'b0;
            sign_i_6  <= 1'b0;
            sign_q_6  <= 1'b0;
            valid_6   <= 1'b0;
        end else begin
            sin_ext_6 <= round_clip_base(sin_acc_5);
            cos_ext_6 <= round_clip_base(cos_acc_5);
            fold_6    <= fold_5;
            sign_i_6  <= sign_i_5;
            sign_q_6  <= sign_q_5;
            valid_6   <= valid_5;
        end
    end

    assign sin_mag_6 = round_sat_mag(sin_ext_6);
    assign cos_mag_6 = round_sat_mag(cos_ext_6);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mag_i   <= '0;
            mag_q   <= '0;
            sign_i  <= 1'b0;
            sign_q  <= 1'b0;
            valid_o <= 1'b0;
        end else begin
            mag_i   <= fold_6 ? cos_mag_6 : sin_mag_6;
            mag_q   <= fold_6 ? sin_mag_6 : cos_mag_6;
            sign_i  <= sign_i_6;
            sign_q  <= sign_q_6;
            valid_o <= valid_6;
        end
    end

endmodule

`default_nettype wire
