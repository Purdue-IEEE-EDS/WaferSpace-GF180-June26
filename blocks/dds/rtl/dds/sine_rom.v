`default_nettype none
`timescale 1ns/1ps

// Quarter-wave sine ROM, 2x combinational read
// Stores unsigned magnitude [0 .. 2^DATA_W - 1]
// DATA_W = MAG_W = UNARY_BITS + BINARY_BITS - 1

// TODO instantiate real ROM

module sine_rom #(
    parameter ADDR_W = 10,
    parameter DATA_W = 9
)(
    input  logic [ADDR_W-1:0] addr_a,
    input  logic [ADDR_W-1:0] addr_b,
    output logic [DATA_W-1:0] data_a,
    output logic [DATA_W-1:0] data_b
);

    localparam DEPTH = 1 << ADDR_W;

    logic [DATA_W-1:0] rom [0:DEPTH-1];

    initial $readmemh("sine_lut.hex", rom);

    assign data_a = rom[addr_a];
    assign data_b = rom[addr_b];

endmodule
