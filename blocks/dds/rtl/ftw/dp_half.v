`default_nettype none
`timescale 1ns/1ps

// dp_half — 16-bit slice of the delta-phase carry-save pair.
// Two instances (lo/hi) partition the 64-FF fanout into 32 each.

(* keep_hierarchy = "yes" *)
module dp_half #(
    parameter W = 16
)(
    input  logic          clk,
    input  logic          rst_n,

    // mux selects (1-bit each, evaluated inside this module)
    input  logic          sel_load,    // seq_dp_load: highest priority
    input  logic          sel_fire,    // timer_fire & ~seq_kill
    input  logic          sel_csa,     // timer_active & ~timer_fire

    // mux data
    input  logic [W-1:0]  load_s,      // seq_dp_value slice
    input  logic [W-1:0]  fire_s,      // fire_dp_value slice
    input  logic [W-1:0]  csa_s_in,    // CSA sum slice
    input  logic [W-1:0]  csa_c_in,    // CSA carry slice (already shifted)

    output logic [W-1:0]  dp_s,
    output logic [W-1:0]  dp_c
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            dp_s <= {W{1'b0}};
            dp_c <= {W{1'b0}};
        end else if (sel_load) begin
            dp_s <= load_s;
            dp_c <= {W{1'b0}};
        end else if (sel_fire) begin
            dp_s <= fire_s;
            dp_c <= {W{1'b0}};
        end else if (sel_csa) begin
            dp_s <= csa_s_in;
            dp_c <= csa_c_in;
        end
    end

endmodule
