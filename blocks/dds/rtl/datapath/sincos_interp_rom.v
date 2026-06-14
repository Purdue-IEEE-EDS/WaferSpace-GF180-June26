`default_nettype none
`timescale 1ns/1ps

// One-read quarter-wave sin/cos interpolation ROM.
//
// Each coarse address returns:
//   sin(u) ≈ sin_base + sin_slope * frac / 2^FRAC_W
//   cos(u) ≈ cos_base + cos_slope * frac / 2^FRAC_W
module sincos_interp_rom #(
    parameter int COARSE_W = 7,
    parameter int BASE_W   = 12,
    parameter int SLOPE_W  = 8
) (
    input  logic                      clk,
    input  logic                      rst_n,
    input  logic [COARSE_W-1:0]       coarse,
    output logic [BASE_W-1:0]         sin_base,
    output logic signed [SLOPE_W-1:0] sin_slope,
    output logic [BASE_W-1:0]         cos_base,
    output logic signed [SLOPE_W-1:0] cos_slope
);

    localparam int DEPTH = 1 << COARSE_W;

    logic [BASE_W-1:0]         rom_sin_base  [0:DEPTH-1];
    logic signed [SLOPE_W-1:0] rom_sin_slope [0:DEPTH-1];
    logic [BASE_W-1:0]         rom_cos_base  [0:DEPTH-1];
    logic signed [SLOPE_W-1:0] rom_cos_slope [0:DEPTH-1];

    initial begin
        if (COARSE_W < 1)
            $error("sincos_interp_rom requires COARSE_W >= 1");
        if (BASE_W < 1)
            $error("sincos_interp_rom requires BASE_W >= 1");
        if (SLOPE_W < 2)
            $error("sincos_interp_rom requires SLOPE_W >= 2");
        `include "./rtl/datapath/sincos_interp_init.v"
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sin_base  <= '0;
            sin_slope <= '0;
            cos_base  <= '0;
            cos_slope <= '0;
        end else begin
            sin_base  <= rom_sin_base[coarse];
            sin_slope <= rom_sin_slope[coarse];
            cos_base  <= rom_cos_base[coarse];
            cos_slope <= rom_cos_slope[coarse];
        end
    end

endmodule

`default_nettype wire
