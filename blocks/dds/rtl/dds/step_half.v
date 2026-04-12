`default_nettype none
`timescale 1ns/1ps

// step_half — 16-bit slice of the step register.
//
// Priority: load > swap > hold.
// Load fires at ramp start (chirp_step from SPI).
// Swap fires at TRI turnaround (precomputed neg value, no carry chain).
//
(* keep_hierarchy = "yes" *)
module step_half #(
    parameter W = 16
)(
    input  logic          clk,
    input  logic          rst_n,
    input  logic          sel_load,
    input  logic          sel_swap,
    input  logic [W-1:0]  load_val,
    input  logic [W-1:0]  swap_val,
    output logic [W-1:0]  step_out
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            step_out <= {W{1'b0}};
        else if (sel_load)
            step_out <= load_val;
        else if (sel_swap)
            step_out <= swap_val;
    end

endmodule
