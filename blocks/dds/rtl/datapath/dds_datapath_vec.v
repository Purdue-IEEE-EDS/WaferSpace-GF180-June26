`default_nettype none
`timescale 1ns/1ps

// Parallel DDS datapath wrapper.
//
// Each lane processes one finished carry-save phase sample in the slow vector
// domain.
// In the intended 4:1 build, this clock runs at 125 MHz while the serializer
// runs at 500 MHz.
// The scalar datapath remains the per-lane implementation and contributes
// 12 registered clk_vec stages per lane:
//   {phase_s_vec, phase_c_vec} sampled on edge N -> dac_{i,q}_vec valid just
//   after edge N+11.
module dds_datapath_vec #(
    parameter int PHASE_W        = 32,
    parameter int SINE_TRUNC_W   = 14,
    parameter int SINE_COARSE_W  = 7,
    parameter int SINE_GUARD_W   = 3,
    parameter int UNARY_BITS     = 5,
    parameter int BINARY_BITS    = 5,
    parameter int LANES          = 1,
    parameter int DAC_SW_W       = (1 << UNARY_BITS) - 1 + BINARY_BITS
) (
    input  logic                          clk,
    input  logic                          rst_n,
    input  logic [LANES-1:0][PHASE_W-1:0] phase_s_vec,
    input  logic [LANES-1:0][PHASE_W-1:0] phase_c_vec,
    input  logic                          out_enable,
    output wire [LANES-1:0][DAC_SW_W-1:0] dac_i_vec,
    output wire [LANES-1:0][DAC_SW_W-1:0] dac_q_vec
);

    genvar lane;

    initial begin
        if (LANES < 1)
            $error("dds_datapath_vec requires LANES >= 1");
    end

    generate
        for (lane = 0; lane < LANES; lane = lane + 1) begin : g_lane
            dds_datapath #(
                .PHASE_W       (PHASE_W),
                .SINE_TRUNC_W  (SINE_TRUNC_W),
                .SINE_COARSE_W (SINE_COARSE_W),
                .SINE_GUARD_W  (SINE_GUARD_W),
                .UNARY_BITS    (UNARY_BITS),
                .BINARY_BITS   (BINARY_BITS),
                .DAC_SW_W      (DAC_SW_W)
            ) u_lane (
                .clk        (clk),
                .rst_n      (rst_n),
                .phi_s      (phase_s_vec[lane]),
                .phi_c      (phase_c_vec[lane]),
                .out_enable (out_enable),
                .dac_i      (dac_i_vec[lane]),
                .dac_q      (dac_q_vec[lane])
            );
        end
    endgenerate

endmodule

`default_nettype wire
