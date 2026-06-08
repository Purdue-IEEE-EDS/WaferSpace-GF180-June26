`default_nettype none
`timescale 1ns/1ps

// Segment timer — hierarchical countdown.
//
// Splits W-bit countdown into:
//   fine   [FINE_W-1:0]  — decrements every cycle.  Per-cycle critical
//                          path is FINE_W-bit ripple (~2.5 ns for 4 bits).
//   coarse [W-1:FINE_W]  — decrements only when fine wraps (every 2^FINE_W
//                          cycles).  Has 2^FINE_W cycles to settle.
//
// Fire detection:
//   fire = coarse_is_zero (registered flag) AND (fine == 1)
//   Both operands are small / pre-resolved.  ~2 gate levels.
//
// Active detection:
//   active = !coarse_is_zero OR (fine != 0)
//   ~2 gate levels.
//
// The timer knows nothing about SAW, TRI, chirp, or any mode.
//
(* keep_hierarchy = "yes" *)
module seg_timer #(
    parameter W      = 20,
    parameter FINE_W = 4
)(
    input  logic          clk,
    input  logic          rst_n,
    input  logic          load,
    input  logic [W-1:0]  value,
    input  logic          kill,
    output logic          fire,
    output logic          active
);

    localparam COARSE_W = W - FINE_W;

    // ---- State ----
    logic [FINE_W-1:0]   fine;
    logic [COARSE_W-1:0] coarse;
    logic                coarse_is_zero;   // registered flag

    // ---- Outputs (combinational) ----
    //   fire:   last active cycle (total value == 1)
    //   active: total value != 0
    assign fire   = coarse_is_zero & (fine == {{(FINE_W-1){1'b0}}, 1'b1});
    assign active = !coarse_is_zero | (fine != {FINE_W{1'b0}});

    // ---- Fine wrap detection ----
    //   fine_borrow = 1 when fine is 0 (about to wrap to all-1s).
    //   This enables the coarse decrement on the same clock edge.
    wire fine_borrow = (fine == {FINE_W{1'b0}});

    // ---- Sequential ----
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fine           <= {FINE_W{1'b0}};
            coarse         <= {COARSE_W{1'b0}};
            coarse_is_zero <= 1'b1;
        end else if (load) begin
            fine           <= value[FINE_W-1:0];
            coarse         <= value[W-1:FINE_W];
            coarse_is_zero <= (value[W-1:FINE_W] == {COARSE_W{1'b0}});
        end else if (kill) begin
            fine           <= {FINE_W{1'b0}};
            coarse         <= {COARSE_W{1'b0}};
            coarse_is_zero <= 1'b1;
        end else if (active) begin
            fine <= fine - 1'b1;
            if (fine_borrow) begin
                coarse         <= coarse - 1'b1;
                coarse_is_zero <= (coarse == {{(COARSE_W-1){1'b0}}, 1'b1});
            end
        end
    end

endmodule
