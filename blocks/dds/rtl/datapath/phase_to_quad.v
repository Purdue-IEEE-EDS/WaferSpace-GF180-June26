`default_nettype none
`timescale 1ns/1ps

// Phase truncation and quadrant decode for I/Q.
// Purely comb
//
// Input: full-width phase (already includes any offset).
// Output: quarter-wave ROM address + sign for I and Q channels.
//
module phase_to_quad #(
    parameter PHASE_W = 32,
    parameter TRUNC_W = 12,
    parameter ADDR_W  = TRUNC_W - 2
)(
    input  logic [PHASE_W-1:0] phase,
    output logic [ADDR_W-1:0]  addr_i,
    output logic [ADDR_W-1:0]  addr_q,
    output logic               sign_i,
    output logic               sign_q
);

    logic [TRUNC_W-1:0] trunc;
    logic fold;
    logic [ADDR_W-1:0] raw_addr;

    assign trunc = phase[PHASE_W-1 -: TRUNC_W];

    assign sign_i   = trunc[TRUNC_W-1];
    assign fold     = trunc[TRUNC_W-2];
    assign raw_addr = trunc[ADDR_W-1:0];

    assign addr_i = fold ? ~raw_addr : raw_addr;
    assign addr_q = fold ?  raw_addr : ~raw_addr;
    assign sign_q = sign_i ^ fold;

endmodule
