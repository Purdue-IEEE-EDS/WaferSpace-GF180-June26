`default_nettype none
`timescale 1ns/1ps

// DDS signal datapath: CPA → phase-offset → LUT → multiply → DAC.
//
// Phase accumulator outputs redundant {phi_s, phi_c} from CSA.
// S0 resolves to binary via CPA (Kogge-Stone).
//
// Pipeline (5 stages):
//   S0: CPA(phi_s + phi_c) → REG (phi_binary)
//   S1: trunc(phi_binary) + pow_off → quadrant decode (comb) → REG
//       AMP: latch on amp_trigger → REG
//   S2: ROM lookup (comb) → REG, amp delay → REG
//   S3: amplitude multiply (comb) → REG
//   S4: DAC encode + sign (comb) → output REG
//
// Amplitude scaling:
//   scaled_mag = (mag * amp + 0x8000) >> 16
//   AMP = 0xFFFF → unity.  AMP = 0x0000 → mute.
//   AMP resets to 0xFFFF.
module dds_datapath #(
    parameter PHASE_W     = 32,
    parameter TRUNC_W     = 12,
    parameter UNARY_BITS  = 5,
    parameter BINARY_BITS = 5,
    parameter SYM_W       = 2,
    parameter AMP_W       = 16,
    parameter POW_DEPTH   = 1 << SYM_W,
    parameter DAC_SW_W    = (1 << UNARY_BITS) - 1 + BINARY_BITS
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // from phase_accum (carry-save redundant form)
    input  logic [PHASE_W-1:0]   phi_s,
    input  logic [PHASE_W-1:0]   phi_c,

    // phase offset bank — TRUNC_W bits per entry, packed flat, index 0 in LSBs
    input  logic [POW_DEPTH*TRUNC_W-1:0] pow_bank,

    // phase offset selection — continuous (no trigger)
    input  logic [SYM_W-1:0]     pow_sel,

    // amplitude constellation bank — packed flat, index 0 in LSBs
    input  logic [POW_DEPTH*AMP_W-1:0]   amp_bank,

    // amplitude selection — latched on trigger
    input  logic [SYM_W-1:0]     amp_idx,
    input  logic                  amp_trigger,

    // DAC outputs
    output logic [DAC_SW_W-1:0]  dac_i,
    output logic [DAC_SW_W-1:0]  dac_q
);

    localparam ADDR_W   = TRUNC_W - 2;
    localparam MAG_W    = UNARY_BITS + BINARY_BITS - 1;
    localparam N_UNARY  = (1 << UNARY_BITS) - 1;
    localparam MIDSCALE = 1 << (UNARY_BITS - 1);

    // ================================================================
    //  S0: Carry-select resolution at truncation boundary → REG
    //
    //  Only the top TRUNC_W bits (phi[31:20]) feed the LUT.
    //  The lower 20 bits exist only to produce the carry into bit 20.
    //
    //  Architecture:
    //    carry_out (keep_hierarchy): c20 from phi_s[19:0] + phi_c[19:0]
    //    Two speculative TRUNC_W-bit sums (c20=0, c20=1) in parallel
    //    Mux selects correct upper sum based on c20.
    //
    //  Critical path: max(c20, TRUNC_W-bit add) + mux
    //  vs old full 32-bit Kogge-Stone CPA.
    // ================================================================
    localparam LO_W = PHASE_W - TRUNC_W;  // 20

    wire c20;
    carry_out #(.W(LO_W)) u_c20 (
        .a (phi_s[LO_W-1:0]),
        .b (phi_c[LO_W-1:0]),
        .c (c20)
    );

    wire [TRUNC_W-1:0] upper_0 = phi_s[PHASE_W-1:LO_W] + phi_c[PHASE_W-1:LO_W];
    wire [TRUNC_W-1:0] upper_1 = phi_s[PHASE_W-1:LO_W] + phi_c[PHASE_W-1:LO_W]
                                  + {{(TRUNC_W-1){1'b0}}, 1'b1};
    wire [TRUNC_W-1:0] phi_upper = c20 ? upper_1 : upper_0;

    logic [TRUNC_W-1:0] phi_trunc;  // registered top bits — on timing path

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            phi_trunc <= {TRUNC_W{1'b0}};
        else
            phi_trunc <= phi_upper;
    end

    // Full phi_binary — registered for TB probe compatibility.
    // This register is NOT on the functional timing path (nothing
    // downstream reads it in RTL).  STA may report it, but the
    // datapath uses phi_trunc above.
    logic [PHASE_W-1:0] phi_binary;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            phi_binary <= {PHASE_W{1'b0}};
        else
            phi_binary <= phi_s + phi_c;
    end

    // ================================================================
    //  Phase offset — combinational mux on pow_sel (continuous)
    // ================================================================
    logic [TRUNC_W-1:0] pow_off;
    assign pow_off = pow_bank[pow_sel * TRUNC_W +: TRUNC_W];

    // ================================================================
    //  Amplitude — mux on amp_idx (latched on trigger in S1)
    // ================================================================
    logic [AMP_W-1:0] amp_mux;
    assign amp_mux = amp_bank[amp_idx * AMP_W +: AMP_W];

    // ================================================================
    //  S1: phase combine + quadrant decode (comb) → REG
    //      AMP: latch on amp_trigger → REG
    // ================================================================
    logic [TRUNC_W-1:0] trunc_theta;
    assign trunc_theta = phi_trunc + pow_off;

    // quadrant decode (comb)
    logic [ADDR_W-1:0] addr_i, addr_q;
    logic              sign_i, sign_q;

    phase_to_quad #(
        .PHASE_W (TRUNC_W),
        .TRUNC_W (TRUNC_W)
    ) u_quad (
        .phase  (trunc_theta),
        .addr_i (addr_i),
        .addr_q (addr_q),
        .sign_i (sign_i),
        .sign_q (sign_q)
    );

    logic [ADDR_W-1:0] addr_i_1, addr_q_1;
    logic               sign_i_1, sign_q_1;
    logic [AMP_W-1:0]   amp_1;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr_i_1 <= '0;
            addr_q_1 <= '0;
            sign_i_1 <= 1'b0;
            sign_q_1 <= 1'b0;
            amp_1    <= {AMP_W{1'b1}};   // unity default
        end else begin
            addr_i_1 <= addr_i;
            addr_q_1 <= addr_q;
            sign_i_1 <= sign_i;
            sign_q_1 <= sign_q;
            if (amp_trigger)
                amp_1 <= amp_mux;
        end
    end

    // ================================================================
    //  S2: ROM lookup (comb) → REG, sign delay → REG
    //
    //  amp_2 removed — amp is now registered inside each amp_scale
    //  instance (keep_hierarchy).  Parent drives 2 module ports
    //  instead of 165 partial-product gates.
    // ================================================================
    logic [MAG_W-1:0] mag_i_comb, mag_q_comb;
    logic [MAG_W-1:0] mag_i_2, mag_q_2;
    logic              sign_i_2, sign_q_2;

    sine_rom #(.ADDR_W(ADDR_W), .DATA_W(MAG_W)) u_rom (
        .addr_a (addr_i_1), .data_a (mag_i_comb),
        .addr_b (addr_q_1), .data_b (mag_q_comb)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mag_i_2  <= '0;
            mag_q_2  <= '0;
            sign_i_2 <= 1'b0;
            sign_q_2 <= 1'b0;
        end else begin
            mag_i_2  <= mag_i_comb;
            mag_q_2  <= mag_q_comb;
            sign_i_2 <= sign_i_1;
            sign_q_2 <= sign_q_1;
        end
    end

    // ================================================================
    //  S3: amplitude multiply (CSA only) → carry-save REG
    //
    //  amp_scale outputs carry-save upper bits + c16.
    //  No CPA in this stage — just the Wallace tree.
    //  Resolution deferred to S4.
    // ================================================================
    logic [MAG_W-1:0]  ws_hi_i, wc_hi_i, ws_hi_q, wc_hi_q;
    logic               c16_i, c16_q;
    logic               zero_i, zero_q;

    amp_scale #(.MAG_W(MAG_W), .AMP_W(AMP_W)) u_amp_i (
        .clk     (clk),
        .rst_n   (rst_n),
        .mag     (mag_i_2),
        .amp_in  (amp_1),
        .ws_hi   (ws_hi_i),
        .wc_hi   (wc_hi_i),
        .c16     (c16_i),
        .is_zero (zero_i)
    );

    amp_scale #(.MAG_W(MAG_W), .AMP_W(AMP_W)) u_amp_q (
        .clk     (clk),
        .rst_n   (rst_n),
        .mag     (mag_q_2),
        .amp_in  (amp_1),
        .ws_hi   (ws_hi_q),
        .wc_hi   (wc_hi_q),
        .c16     (c16_q),
        .is_zero (zero_q)
    );

    logic [MAG_W-1:0]  ws_hi_i_3, wc_hi_i_3, ws_hi_q_3, wc_hi_q_3;
    logic               c16_i_3, c16_q_3;
    logic               zero_i_3, zero_q_3;
    logic               sign_i_3, sign_q_3;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            ws_hi_i_3 <= '0;
            wc_hi_i_3 <= '0;
            ws_hi_q_3 <= '0;
            wc_hi_q_3 <= '0;
            c16_i_3   <= 1'b0;
            c16_q_3   <= 1'b0;
            zero_i_3  <= 1'b1;
            zero_q_3  <= 1'b1;
            sign_i_3  <= 1'b0;
            sign_q_3  <= 1'b0;
        end else begin
            ws_hi_i_3 <= ws_hi_i;
            wc_hi_i_3 <= wc_hi_i;
            ws_hi_q_3 <= ws_hi_q;
            wc_hi_q_3 <= wc_hi_q;
            c16_i_3   <= c16_i;
            c16_q_3   <= c16_q;
            zero_i_3  <= zero_i;
            zero_q_3  <= zero_q;
            sign_i_3  <= sign_i_2;
            sign_q_3  <= sign_q_2;
        end
    end

    // ================================================================
    //  S4: carry-select resolve + DAC encoding + sign → output REG
    //
    //  Resolve the carry-save upper bits using registered c16:
    //    scaled = ws_hi + wc_hi + c16  (9-bit carry-select)
    //  c16 is a registered 1-bit select — zero logic depth on select.
    //  The two speculative 9-bit sums run in parallel (~4 levels).
    //  Then mag_to_sw + sign XOR.
    // ================================================================
    // ---- carry-select resolve ----
    logic [MAG_W-1:0] scaled_i_0, scaled_i_1, scaled_q_0, scaled_q_1;
    logic [MAG_W-1:0] scaled_i, scaled_q;

    assign scaled_i_0 = ws_hi_i_3 + wc_hi_i_3;
    assign scaled_i_1 = ws_hi_i_3 + wc_hi_i_3 + {{(MAG_W-1){1'b0}}, 1'b1};
    assign scaled_i   = c16_i_3 ? scaled_i_1 : scaled_i_0;

    assign scaled_q_0 = ws_hi_q_3 + wc_hi_q_3;
    assign scaled_q_1 = ws_hi_q_3 + wc_hi_q_3 + {{(MAG_W-1){1'b0}}, 1'b1};
    assign scaled_q   = c16_q_3 ? scaled_q_1 : scaled_q_0;

    // ---- DAC encode ----
    logic [DAC_SW_W-1:0] sw_pos_i, sw_pos_q;
    logic [DAC_SW_W-1:0] sw_i, sw_q;

    mag_to_sw #(
        .UNARY_BITS  (UNARY_BITS),
        .BINARY_BITS (BINARY_BITS)
    ) u_enc_i (.mag(scaled_i), .sw(sw_pos_i));

    mag_to_sw #(
        .UNARY_BITS  (UNARY_BITS),
        .BINARY_BITS (BINARY_BITS)
    ) u_enc_q (.mag(scaled_q), .sw(sw_pos_q));

    assign sw_i = zero_i_3 ? sw_pos_i : (sw_pos_i ^ {DAC_SW_W{sign_i_3}});
    assign sw_q = zero_q_3 ? sw_pos_q : (sw_pos_q ^ {DAC_SW_W{sign_q_3}});

    localparam [DAC_SW_W-1:0] MIDSCALE_SW =
        {{(N_UNARY - MIDSCALE){1'b0}}, {MIDSCALE{1'b1}}, {BINARY_BITS{1'b0}}};

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dac_i <= MIDSCALE_SW;
            dac_q <= MIDSCALE_SW;
        end else begin
            dac_i <= sw_i;
            dac_q <= sw_q;
        end
    end

endmodule
