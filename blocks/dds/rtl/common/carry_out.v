`default_nettype none
`timescale 1ns/1ps

// carry_out — carry-out only from a + b.
//
// Computes the single-bit carry-out without producing the full sum.
// The prefix tree keeps the discarded lower-slice carry off the critical
// ripple-adder path into the upper phase slice.
//
(* keep_hierarchy = "yes" *)
module carry_out #(
    parameter int W = 20
)(
    input  logic [W-1:0] a,
    input  logic [W-1:0] b,
    output logic          c
);

    localparam int STAGES = (W <= 1) ? 0 : $clog2(W);

    initial begin
        if (W < 1)
            $error("carry_out requires W >= 1");
    end

    logic [W-1:0] gen_stage [0:STAGES];
    logic [W-1:0] prop_stage [0:STAGES];

    assign gen_stage[0]  = a & b;
    assign prop_stage[0] = a ^ b;

    genvar stage;
    genvar bit_idx;
    generate
        for (stage = 0; stage < STAGES; stage = stage + 1) begin : g_stage
            localparam int DIST = 1 << stage;
            for (bit_idx = 0; bit_idx < W; bit_idx = bit_idx + 1) begin : g_bit
                if (bit_idx >= DIST) begin : g_merge
                    assign gen_stage[stage+1][bit_idx] =
                        gen_stage[stage][bit_idx]
                        | (prop_stage[stage][bit_idx] & gen_stage[stage][bit_idx-DIST]);
                    assign prop_stage[stage+1][bit_idx] =
                        prop_stage[stage][bit_idx] & prop_stage[stage][bit_idx-DIST];
                end else begin : g_pass
                    assign gen_stage[stage+1][bit_idx]  = gen_stage[stage][bit_idx];
                    assign prop_stage[stage+1][bit_idx] = prop_stage[stage][bit_idx];
                end
            end
        end
    endgenerate

    assign c = gen_stage[STAGES][W-1];

endmodule
