`default_nettype none
`timescale 1ns/1ps

// carry_out — carry-out only from a + b.
//
// Computes the single-bit carry-out without producing the full sum.
// With keep_hierarchy, ABC optimizes this independently — the
// carry computation can't merge with the speculative upper sum.
//
(* keep_hierarchy = "yes" *)
module carry_out #(
    parameter W = 20
)(
    input  logic [W-1:0] a,
    input  logic [W-1:0] b,
    output logic          c
);

    wire [W:0] sum = {1'b0, a} + {1'b0, b};
    assign c = sum[W];

endmodule
