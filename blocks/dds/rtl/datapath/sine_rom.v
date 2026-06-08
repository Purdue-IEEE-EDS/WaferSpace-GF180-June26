`default_nettype none
`timescale 1ns/1ps

// Quarter-wave sine ROM, 2x read with an internal pipeline cut.
// Stores unsigned magnitude [0 .. 2^DATA_W - 1]
// DATA_W = MAG_W = UNARY_BITS + BINARY_BITS - 1
//
// A plain 1024x9 behavioral array maps to a deep mux tree in the current
// ASIC flow. Split the address into high/low halves so the read becomes:
//   small-bank read -> register -> bank select
// For the default 10-bit address this is 32x(32-entry read) + reg + 32:1 mux.

module sine_rom #(
    parameter ADDR_W = 10,
    parameter DATA_W = 9
)(
    input  logic              clk,
    input  logic              rst_n,
    input  logic [ADDR_W-1:0] addr_a,
    input  logic [ADDR_W-1:0] addr_b,
    output logic [DATA_W-1:0] data_a,
    output logic [DATA_W-1:0] data_b
);

    localparam integer DEPTH = 1 << ADDR_W;
    localparam integer LO_W  = ADDR_W / 2;
    localparam integer HI_W  = ADDR_W - LO_W;
    localparam integer BANKS = 1 << HI_W;

    reg [DATA_W-1:0] rom [0:DEPTH-1];

    logic [LO_W-1:0]   addr_a_lo, addr_b_lo;
    logic [HI_W-1:0]   addr_a_hi, addr_b_hi;
    logic [HI_W-1:0]   addr_a_hi_r, addr_b_hi_r;
    logic [DATA_W-1:0] bank_a_comb [0:BANKS-1];
    logic [DATA_W-1:0] bank_b_comb [0:BANKS-1];
    logic [DATA_W-1:0] bank_a_r    [0:BANKS-1];
    logic [DATA_W-1:0] bank_b_r    [0:BANKS-1];

    // Generated ROM contents live in a separate Verilog file so the flow
    // does not depend on a runtime $readmemh side file.
    initial begin
    `include "./rtl/datapath/sine_lut_init.v"
    end

    assign addr_a_lo = addr_a[LO_W-1:0];
    assign addr_b_lo = addr_b[LO_W-1:0];
    assign addr_a_hi = addr_a[ADDR_W-1:LO_W];
    assign addr_b_hi = addr_b[ADDR_W-1:LO_W];

    genvar bank;
    generate
        for (bank = 0; bank < BANKS; bank = bank + 1) begin : gen_bank_reads
            localparam integer BASE = bank << LO_W;
            assign bank_a_comb[bank] = rom[BASE + addr_a_lo];
            assign bank_b_comb[bank] = rom[BASE + addr_b_lo];
        end
    endgenerate

    integer i;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr_a_hi_r <= '0;
            addr_b_hi_r <= '0;
            for (i = 0; i < BANKS; i = i + 1) begin
                bank_a_r[i] <= '0;
                bank_b_r[i] <= '0;
            end
        end else begin
            addr_a_hi_r <= addr_a_hi;
            addr_b_hi_r <= addr_b_hi;
            for (i = 0; i < BANKS; i = i + 1) begin
                bank_a_r[i] <= bank_a_comb[i];
                bank_b_r[i] <= bank_b_comb[i];
            end
        end
    end

    always_comb begin
        data_a = bank_a_r[addr_a_hi_r];
        data_b = bank_b_r[addr_b_hi_r];
    end

endmodule
