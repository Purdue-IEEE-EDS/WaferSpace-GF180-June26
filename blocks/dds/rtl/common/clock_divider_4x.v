`default_nettype none
`timescale 1ns/1ps

// Shared synchronous clock divider for the 4:1 DDS build.
//
// Contract:
//   - clk_in is the fast serializer/output clock (nominally 500 MHz).
//   - clk_div1 is a named pass-through of clk_in.
//   - clk_div2 is the synchronous divide-by-2 clock (nominally 250 MHz).
//   - clk_div4 is the synchronous divide-by-4 clock (nominally 125 MHz).
//   - phase_4x advances 0,1,2,3 on each clk_in edge and aligns to the
//     serializer lane order.
//   - clk_div4 posedges occur on the 3 -> 0 phase wrap so one clk_div4 cycle
//     spans exactly one 4-sample serializer block.

(* keep_hierarchy = "yes" *)
module clock_divider_4x (
    input  logic clk_in,
    input  logic rst_n,
    output wire  clk_div1,
    output wire  clk_div2,
    output wire  clk_div4
);

    // Rotating registered waveforms.
    //
    // div2_pat: 1 0 1 0 ...
    // div4_pat: 1 1 0 0 ...
    //
    // Feedback path is only flop Q -> flop D.
    (* keep = "true" *) logic [3:0] div2_pat;
    (* keep = "true" *) logic [3:0] div4_pat;

    assign clk_div1 = clk_in;
    assign clk_div2 = div2_pat[3];
    assign clk_div4 = div4_pat[3];

    always_ff @(posedge clk_in or negedge rst_n) begin
        if (!rst_n) begin
            div2_pat <= 4'b1010;
            div4_pat <= 4'b1100;
        end else begin
            div2_pat <= {div2_pat[2:0], div2_pat[3]};
            div4_pat <= {div4_pat[2:0], div4_pat[3]};
        end
    end

endmodule

`default_nettype wire
