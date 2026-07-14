`default_nettype none
`timescale 1ns/1ps

// Decode truncated DDS phase for one-read sin/cos interpolation.
//
// phase_i format:
//   phase_i[SINE_TRUNC_W-1:SINE_TRUNC_W-2] = quadrant
//   phase_i[SINE_TRUNC_W-3:0]              = position inside quadrant
//
// The lower quarter-wave coordinate is split into a coarse ROM address and
// a fine interpolation fraction. Quadrant fold/sign bits select the final
// I/Q swap and polarity.
module phase_to_sincos_interp #(
    parameter int SINE_TRUNC_W = 14,
    parameter int COARSE_W     = 7,
    parameter int FRAC_W       = SINE_TRUNC_W - 2 - COARSE_W
) (
    input  logic [SINE_TRUNC_W-1:0] phase_i,
    output logic [COARSE_W-1:0]     coarse,
    output logic [FRAC_W-1:0]       frac,
    output logic                    fold,
    output logic                    sign_i,
    output logic                    sign_q
);

    localparam int SINE_ADDR_W = SINE_TRUNC_W - 2;

    logic [SINE_ADDR_W-1:0] u;

    initial begin
        if (SINE_TRUNC_W < 4)
            $error("phase_to_sincos_interp requires SINE_TRUNC_W >= 4");
        if (COARSE_W < 1)
            $error("phase_to_sincos_interp requires COARSE_W >= 1");
        if (FRAC_W < 1)
            $error("phase_to_sincos_interp requires FRAC_W >= 1");
        if ((COARSE_W + FRAC_W) != SINE_ADDR_W)
            $error("phase_to_sincos_interp requires COARSE_W + FRAC_W = SINE_TRUNC_W - 2");
    end

    assign u      = phase_i[SINE_ADDR_W-1:0];
    assign coarse = u[SINE_ADDR_W-1:FRAC_W];
    assign frac   = u[FRAC_W-1:0];

    assign fold   = phase_i[SINE_TRUNC_W-2];
    assign sign_i = phase_i[SINE_TRUNC_W-1];
    assign sign_q = phase_i[SINE_TRUNC_W-1] ^ phase_i[SINE_TRUNC_W-2];

endmodule

`default_nettype wire
