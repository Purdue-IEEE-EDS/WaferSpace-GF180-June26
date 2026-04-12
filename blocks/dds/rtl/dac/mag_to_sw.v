`default_nettype none
`timescale 1ns/1ps

// Unsigned magnitude to DAC switch pattern {unary, binary}.
// Comb
module mag_to_sw #(
    parameter UNARY_BITS  = 5,
    parameter BINARY_BITS = 5,
    parameter N_UNARY     = (1 << UNARY_BITS) - 1,
    parameter SW_W        = N_UNARY + BINARY_BITS
)(
    input  logic [UNARY_BITS+BINARY_BITS-2:0] mag,
    output logic [SW_W-1:0]                   sw
);

    localparam MIDSCALE = 1 << (UNARY_BITS - 1);

    logic [N_UNARY-1:0] unary;

    genvar g;
    for (g = 0; g < N_UNARY; g = g + 1) begin : dec
        if (g < MIDSCALE) begin : lo
            assign unary[g] = 1'b1;
        end else begin : hi
            assign unary[g] = (mag[UNARY_BITS+BINARY_BITS-2 : BINARY_BITS] > g - MIDSCALE);
        end
    end

    assign sw = {unary, mag[BINARY_BITS-1:0]};

endmodule
