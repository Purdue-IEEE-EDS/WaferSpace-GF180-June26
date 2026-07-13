`default_nettype none
`timescale 1ns/1ps

// Phase accumulator — 4:2 carry-save compressor.
//
// Inputs: {dp_s, dp_c} redundant lane-0/base FTW from freq_runner.
// Internal: {phi_s, phi_c} carry-save phase state.
//
// Every cycle: phi += dp_s + dp_c  via two cascaded CSA stages.
//   Stage 1: CSA(phi_s, phi_c, dp_s) → {t_s, t_c}
//   Stage 2: CSA(t_s, t_c, dp_c)    → {phi_s_next, phi_c_next}
//
// O(1) depth: 4 gate levels total (two XOR3/MAJ3 stages).
// No carry chain anywhere in the feedback loop.
module phase_accum #(
    parameter PHASE_W = 32
)(
    input  logic                  clk,
    input  logic                  rst_n,
    input  logic [PHASE_W-1:0]   dp_s,
    input  logic [PHASE_W-1:0]   dp_c,
    input  logic                  phase_reset,
    output logic [PHASE_W-1:0]   phi_s,
    output logic [PHASE_W-1:0]   phi_c
);

    // ---- Stage 1: CSA(phi_s, phi_c, dp_s) ----
    logic [PHASE_W-1:0] t_s, t_maj;

    assign t_s   = phi_s ^ phi_c ^ dp_s;
    assign t_maj = (phi_s & phi_c) | (phi_s & dp_s) | (phi_c & dp_s);

    // ---- Stage 2: CSA(t_s, t_c_shifted, dp_c) ----
    logic [PHASE_W-1:0] t_c;
    logic [PHASE_W-1:0] s_next, m_next;

    assign t_c = {t_maj[PHASE_W-2:0], 1'b0};

    assign s_next = t_s ^ t_c ^ dp_c;
    assign m_next = (t_s & t_c) | (t_s & dp_c) | (t_c & dp_c);

    // ---- Sequential ----
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phi_s <= {PHASE_W{1'b0}};
            phi_c <= {PHASE_W{1'b0}};
        end else if (phase_reset) begin
            phi_s <= {PHASE_W{1'b0}};
            phi_c <= {PHASE_W{1'b0}};
        end else begin
            phi_s <= s_next;
            phi_c <= {m_next[PHASE_W-2:0], 1'b0};
        end
    end

endmodule
