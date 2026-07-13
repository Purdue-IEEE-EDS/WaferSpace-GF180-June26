`default_nettype none
`timescale 1ns/1ps

// dac_encoder — unsigned magnitude → segmented DAC switch pattern.
//
// Output bit order: {unary_thermometer[N_UNARY-1:0], binary[BINARY_BITS-1:0]}.
// Upper slice of `mag` drives a thermometer decoder against the midscale
// offset; lower slice drives the binary sub-DAC directly.  Combinational
// (S4b in dds_datapath).
module dac_encoder #(
    parameter UNARY_BITS  = 5,
    parameter BINARY_BITS = 5,
    parameter N_UNARY     = (1 << UNARY_BITS) - 1,
    parameter SW_W        = N_UNARY + BINARY_BITS
)(
    input  logic [UNARY_BITS+BINARY_BITS-2:0] mag,
    output logic [SW_W-1:0]                   sw
);

    localparam integer MIDSCALE = 1 << (UNARY_BITS - 1);

    logic [N_UNARY-1:0] unary;

    genvar g;
    generate
        for (g = 0; g < N_UNARY; g = g + 1) begin : dec
            if (g < MIDSCALE) begin : lo
                assign unary[g] = 1'b1;
            end else begin : hi
                assign unary[g] = (mag[UNARY_BITS+BINARY_BITS-2 : BINARY_BITS] > g - MIDSCALE);
            end
        end
    endgenerate

    assign sw = {unary, mag[BINARY_BITS-1:0]};

endmodule
