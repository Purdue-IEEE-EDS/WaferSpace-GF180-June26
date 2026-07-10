`default_nettype none
`timescale 1ns/1ps

// DDS signal datapath: phase -> interpolated sin/cos -> DAC.
//
// The external control at the datapath boundary is out_enable, which keeps
// the DAC at midscale until the first launch event.
//
// Timing contract in the clk_vec domain:
//   - A phase sample captured on edge N reaches dac_i/dac_q just after edge N+11.
//   - That is 12 registered stages, or 11 full clk_vec intervals.
//   - dds_top then adds serializer latency before the word reaches the DAC pins.
//
// Registered stages:
//   S0a  lower-slice carry_out + upper-slice register
//   S0b  upper CPA
//   S0c  lower-carry increment/select      -> phi_trunc_sine
//   S1   coarse/fraction/sign register
//   S2   shared sin/cos ROM read
//   S3a  interpolation multiply bit partials
//   S3b  interpolation multiply pair sums
//   S3c  interpolation multiply final sum
//   S4   interpolation add + BASE_W rounding
//   S5   guard-bit rounding + fold swap    -> mag_{i,q}_2
//   S6   dac_encoder                       -> sw_pos_{i,q}_r
//   S7   sign XOR + enable mux             -> dac_{i,q}

module dds_datapath #(
    parameter int PHASE_W        = 32,
    parameter int SINE_TRUNC_W   = 14,
    parameter int SINE_COARSE_W  = 7,
    parameter int SINE_FRAC_W    = SINE_TRUNC_W - 2 - SINE_COARSE_W,
    parameter int SINE_GUARD_W   = 3,
    parameter int UNARY_BITS     = 5,
    parameter int BINARY_BITS    = 5,
    parameter int DAC_SW_W       = (1 << UNARY_BITS) - 1 + BINARY_BITS
) (
    input  logic                          clk,
    input  logic                          rst_n,
    input  logic [PHASE_W-1:0]            phi_s,
    input  logic [PHASE_W-1:0]            phi_c,
    input  logic                          out_enable,
    output logic [DAC_SW_W-1:0]           dac_i,
    output logic [DAC_SW_W-1:0]           dac_q
);

    localparam int MAG_W      = UNARY_BITS + BINARY_BITS - 1;
    localparam int N_UNARY    = (1 << UNARY_BITS) - 1;
    localparam int MIDSCALE   = 1 << (UNARY_BITS - 1);
    localparam int SINE_LO_W  = PHASE_W - SINE_TRUNC_W;

    localparam logic [DAC_SW_W-1:0] MIDSCALE_SW =
        {{(N_UNARY - MIDSCALE){1'b0}}, {MIDSCALE{1'b1}}, {BINARY_BITS{1'b0}}};

    initial begin
        if (SINE_TRUNC_W < 4)
            $error("dds_datapath requires SINE_TRUNC_W >= 4");
        if (SINE_COARSE_W < 1)
            $error("dds_datapath requires SINE_COARSE_W >= 1");
        if (SINE_FRAC_W < 1)
            $error("dds_datapath requires SINE_FRAC_W >= 1");
        if (SINE_TRUNC_W >= PHASE_W)
            $error("dds_datapath requires SINE_TRUNC_W < PHASE_W so S0a has lower carry bits");
    end

    // S0a: lower-carry + upper-slice register.
    // Requires at least one discarded lower phase bit for carry_out.
    logic lo_carry;
    carry_out #(.W(SINE_LO_W)) u_c20 (
        .a (phi_s[SINE_LO_W-1:0]),
        .b (phi_c[SINE_LO_W-1:0]),
        .c (lo_carry)
    );

    logic               lo_carry_r;
    logic [SINE_TRUNC_W-1:0] phi_s_up_r;
    logic [SINE_TRUNC_W-1:0] phi_c_up_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            lo_carry_r <= 1'b0;
            phi_s_up_r <= '0;
            phi_c_up_r <= '0;
        end else begin
            lo_carry_r <= lo_carry;
            phi_s_up_r <= phi_s[PHASE_W-1:SINE_LO_W];
            phi_c_up_r <= phi_c[PHASE_W-1:SINE_LO_W];
        end
    end

    // S0b/S0c: upper CPA, then lower-carry increment -> phi_trunc_sine.
    logic [SINE_TRUNC_W-1:0] upper_sum;
    logic [SINE_TRUNC_W-1:0] upper_sum_r;
    logic                    lo_carry_2;
    logic [SINE_TRUNC_W-1:0] phi_upper;
    logic [SINE_TRUNC_W-1:0] phi_trunc_sine;

    assign upper_sum = phi_s_up_r + phi_c_up_r;
    assign phi_upper = upper_sum_r + SINE_TRUNC_W'(lo_carry_2);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            upper_sum_r <= '0;
            lo_carry_2  <= 1'b0;
        end else begin
            upper_sum_r <= upper_sum;
            lo_carry_2  <= lo_carry_r;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) phi_trunc_sine <= '0;
        else        phi_trunc_sine <= phi_upper;
    end

    // S1-S4: one-read interpolated sin/cos magnitude generation.
    logic [MAG_W-1:0]   mag_i_2, mag_q_2;
    logic               sign_i_2, sign_q_2;
    logic               en_2;

    sincos_interp_mag #(
        .SINE_TRUNC_W (SINE_TRUNC_W),
        .MAG_W        (MAG_W),
        .COARSE_W     (SINE_COARSE_W),
        .FRAC_W       (SINE_FRAC_W),
        .GUARD_W      (SINE_GUARD_W)
    ) u_sincos_interp (
        .clk     (clk),
        .rst_n   (rst_n),
        .valid_i (out_enable),
        .phase_i (phi_trunc_sine),
        .valid_o (en_2),
        .mag_i   (mag_i_2),
        .mag_q   (mag_q_2),
        .sign_i  (sign_i_2),
        .sign_q  (sign_q_2)
    );

    // S5: encode magnitude into switch pattern.
    logic [DAC_SW_W-1:0] sw_pos_i, sw_pos_q;
    logic [DAC_SW_W-1:0] sw_pos_i_r, sw_pos_q_r;
    logic                sign_i_3, sign_q_3;
    logic                en_3;

    dac_encoder #(.UNARY_BITS(UNARY_BITS), .BINARY_BITS(BINARY_BITS))
        u_enc_i (.mag(mag_i_2), .sw(sw_pos_i));
    dac_encoder #(.UNARY_BITS(UNARY_BITS), .BINARY_BITS(BINARY_BITS))
        u_enc_q (.mag(mag_q_2), .sw(sw_pos_q));

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sw_pos_i_r <= MIDSCALE_SW;
            sw_pos_q_r <= MIDSCALE_SW;
            sign_i_3   <= 1'b0;
            sign_q_3   <= 1'b0;
            en_3       <= 1'b0;
        end else begin
            sw_pos_i_r <= sw_pos_i;
            sw_pos_q_r <= sw_pos_q;
            sign_i_3   <= sign_i_2;
            sign_q_3   <= sign_q_2;
            en_3       <= en_2;
        end
    end

    // S6: sign application + output enable.
    logic [DAC_SW_W-1:0] sw_i, sw_q;

    assign sw_i = en_3 ? (sw_pos_i_r ^ {DAC_SW_W{sign_i_3}}) : MIDSCALE_SW;
    assign sw_q = en_3 ? (sw_pos_q_r ^ {DAC_SW_W{sign_q_3}}) : MIDSCALE_SW;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dac_i <= MIDSCALE_SW;
            dac_q <= MIDSCALE_SW;
        end else begin
            dac_i <= sw_i;
            dac_q <= sw_q;
        end
    end

`ifndef SYNTHESIS
    // TB probe, not on the functional path.
    logic [PHASE_W-1:0] phi_binary;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) phi_binary <= '0;
        else        phi_binary <= phi_s + phi_c;
    end
`endif

endmodule

`default_nettype wire
