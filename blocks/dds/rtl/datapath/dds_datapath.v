`default_nettype none
`timescale 1ns/1ps

// DDS signal datapath: phase -> LUT -> DAC.
//
// The external control at the datapath boundary is out_enable, which keeps
// the DAC at midscale until the first launch event.
//
// Pipeline depth is preserved at 10 phi-path stages:
//   S0a  carry_out + upper-slice register
//   S0b  upper CPA + c20 select            -> phi_trunc
//   S1a  phi register                      -> theta_r
//   S1b  quadrant decode                   -> addr_{i,q}_1, sign_{i,q}_1
//   S2a  ROM low-bank read + partial register (inside sine_rom)
//   S2b  ROM bank select                   -> mag_{i,q}_2
//   S3a  magnitude hold                    -> mag_{i,q}_3
//   S3b  magnitude hold                    -> mag_{i,q}_4
//   S4a  magnitude hold                    -> scaled_{i,q}_r
//   S4b  dac_encoder                       -> sw_pos_{i,q}_r
//   S4c  sign XOR + enable mux             -> dac_{i,q}

module dds_datapath #(
    parameter PHASE_W     = 32,
    parameter TRUNC_W     = 12,
    parameter UNARY_BITS  = 5,
    parameter BINARY_BITS = 5,
    parameter DAC_SW_W    = (1 << UNARY_BITS) - 1 + BINARY_BITS
) (
    input  logic                          clk,
    input  logic                          rst_n,
    input  logic [PHASE_W-1:0]            phi_s,
    input  logic [PHASE_W-1:0]            phi_c,
    input  logic                          out_enable,
    output logic [DAC_SW_W-1:0]           dac_i,
    output logic [DAC_SW_W-1:0]           dac_q
);

    localparam int ADDR_W   = TRUNC_W - 2;
    localparam int MAG_W    = UNARY_BITS + BINARY_BITS - 1;
    localparam int N_UNARY  = (1 << UNARY_BITS) - 1;
    localparam int MIDSCALE = 1 << (UNARY_BITS - 1);
    localparam int LO_W     = PHASE_W - TRUNC_W;

    localparam logic [DAC_SW_W-1:0] MIDSCALE_SW =
        {{(N_UNARY - MIDSCALE){1'b0}}, {MIDSCALE{1'b1}}, {BINARY_BITS{1'b0}}};

    // S0a: lower-carry + upper-slice register.
    logic c20;
    carry_out #(.W(LO_W)) u_c20 (
        .a (phi_s[LO_W-1:0]),
        .b (phi_c[LO_W-1:0]),
        .c (c20)
    );

    logic               c20_r;
    logic [TRUNC_W-1:0] phi_s_up_r;
    logic [TRUNC_W-1:0] phi_c_up_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            c20_r      <= 1'b0;
            phi_s_up_r <= '0;
            phi_c_up_r <= '0;
        end else begin
            c20_r      <= c20;
            phi_s_up_r <= phi_s[PHASE_W-1:LO_W];
            phi_c_up_r <= phi_c[PHASE_W-1:LO_W];
        end
    end

    // S0b: upper CPA + carry-select -> phi_trunc.
    logic [TRUNC_W-1:0] upper_0;
    logic [TRUNC_W-1:0] upper_1;
    logic [TRUNC_W-1:0] phi_upper;
    logic [TRUNC_W-1:0] phi_trunc;

    assign upper_0   = phi_s_up_r + phi_c_up_r;
    assign upper_1   = upper_0 + TRUNC_W'(1);
    assign phi_upper = c20_r ? upper_1 : upper_0;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) phi_trunc <= '0;
        else        phi_trunc <= phi_upper;
    end

    // S1a: theta register.
    logic [TRUNC_W-1:0] theta_r;
    logic               en_1;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            theta_r <= '0;
            en_1    <= 1'b0;
        end else begin
            theta_r <= phi_trunc;
            en_1    <= out_enable;
        end
    end

    // S1b: quadrant decode.
    logic [ADDR_W-1:0] addr_i, addr_q;
    logic              sign_i, sign_q;
    logic [ADDR_W-1:0] addr_i_1, addr_q_1;
    logic              sign_i_1, sign_q_1;
    logic              en_2;

    phase_to_quad #(.PHASE_W(TRUNC_W), .TRUNC_W(TRUNC_W)) u_quad (
        .phase  (theta_r),
        .addr_i (addr_i),
        .addr_q (addr_q),
        .sign_i (sign_i),
        .sign_q (sign_q)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr_i_1 <= '0;
            addr_q_1 <= '0;
            sign_i_1 <= 1'b0;
            sign_q_1 <= 1'b0;
            en_2     <= 1'b0;
        end else begin
            addr_i_1 <= addr_i;
            addr_q_1 <= addr_q;
            sign_i_1 <= sign_i;
            sign_q_1 <= sign_q;
            en_2     <= en_1;
        end
    end

    // S2a/S2b: pipelined ROM lookup.
    logic               sign_i_1d, sign_q_1d;
    logic [MAG_W-1:0]   mag_i_comb, mag_q_comb;
    logic [MAG_W-1:0]   mag_i_2, mag_q_2;
    logic               sign_i_2, sign_q_2;
    logic               en_3;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sign_i_1d <= 1'b0;
            sign_q_1d <= 1'b0;
        end else begin
            sign_i_1d <= sign_i_1;
            sign_q_1d <= sign_q_1;
        end
    end

    sine_rom #(.ADDR_W(ADDR_W), .DATA_W(MAG_W)) u_rom (
        .clk    (clk),
        .rst_n  (rst_n),
        .addr_a (addr_i_1),
        .data_a (mag_i_comb),
        .addr_b (addr_q_1),
        .data_b (mag_q_comb)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mag_i_2  <= '0;
            mag_q_2  <= '0;
            sign_i_2 <= 1'b0;
            sign_q_2 <= 1'b0;
            en_3     <= 1'b0;
        end else begin
            mag_i_2  <= mag_i_comb;
            mag_q_2  <= mag_q_comb;
            sign_i_2 <= sign_i_1d;
            sign_q_2 <= sign_q_1d;
            en_3     <= en_2;
        end
    end

    // S3a/S3b: preserved register depth without runtime scaling.
    logic [MAG_W-1:0] mag_i_3, mag_q_3;
    logic [MAG_W-1:0] mag_i_4, mag_q_4;
    logic             sign_i_3, sign_q_3;
    logic             sign_i_4, sign_q_4;
    logic             en_4, en_5;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mag_i_3  <= '0;
            mag_q_3  <= '0;
            sign_i_3 <= 1'b0;
            sign_q_3 <= 1'b0;
            en_4     <= 1'b0;
        end else begin
            mag_i_3  <= mag_i_2;
            mag_q_3  <= mag_q_2;
            sign_i_3 <= sign_i_2;
            sign_q_3 <= sign_q_2;
            en_4     <= en_3;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mag_i_4  <= '0;
            mag_q_4  <= '0;
            sign_i_4 <= 1'b0;
            sign_q_4 <= 1'b0;
            en_5     <= 1'b0;
        end else begin
            mag_i_4  <= mag_i_3;
            mag_q_4  <= mag_q_3;
            sign_i_4 <= sign_i_3;
            sign_q_4 <= sign_q_3;
            en_5     <= en_4;
        end
    end

    // S4a: final magnitude hold before encoding.
    logic [MAG_W-1:0] scaled_i_r, scaled_q_r;
    logic             sign_i_5, sign_q_5;
    logic             en_6;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scaled_i_r <= '0;
            scaled_q_r <= '0;
            sign_i_5   <= 1'b0;
            sign_q_5   <= 1'b0;
            en_6       <= 1'b0;
        end else begin
            scaled_i_r <= mag_i_4;
            scaled_q_r <= mag_q_4;
            sign_i_5   <= sign_i_4;
            sign_q_5   <= sign_q_4;
            en_6       <= en_5;
        end
    end

    // S4b: encode magnitude into switch pattern.
    logic [DAC_SW_W-1:0] sw_pos_i, sw_pos_q;
    logic [DAC_SW_W-1:0] sw_pos_i_r, sw_pos_q_r;
    logic                sign_i_6, sign_q_6;
    logic                en_7;

    dac_encoder #(.UNARY_BITS(UNARY_BITS), .BINARY_BITS(BINARY_BITS))
        u_enc_i (.mag(scaled_i_r), .sw(sw_pos_i));
    dac_encoder #(.UNARY_BITS(UNARY_BITS), .BINARY_BITS(BINARY_BITS))
        u_enc_q (.mag(scaled_q_r), .sw(sw_pos_q));

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sw_pos_i_r <= MIDSCALE_SW;
            sw_pos_q_r <= MIDSCALE_SW;
            sign_i_6   <= 1'b0;
            sign_q_6   <= 1'b0;
            en_7       <= 1'b0;
        end else begin
            sw_pos_i_r <= sw_pos_i;
            sw_pos_q_r <= sw_pos_q;
            sign_i_6   <= sign_i_5;
            sign_q_6   <= sign_q_5;
            en_7       <= en_6;
        end
    end

    // S4c: sign application + output enable.
    logic [DAC_SW_W-1:0] sw_i, sw_q;

    assign sw_i = en_7 ? (sw_pos_i_r ^ {DAC_SW_W{sign_i_6}}) : MIDSCALE_SW;
    assign sw_q = en_7 ? (sw_pos_q_r ^ {DAC_SW_W{sign_q_6}}) : MIDSCALE_SW;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dac_i <= MIDSCALE_SW;
            dac_q <= MIDSCALE_SW;
        end else begin
            dac_i <= sw_i;
            dac_q <= sw_q;
        end
    end

    // TB probe, not on the functional path.
    logic [PHASE_W-1:0] phi_binary;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) phi_binary <= '0;
        else        phi_binary <= phi_s + phi_c;
    end

endmodule

`default_nettype wire
