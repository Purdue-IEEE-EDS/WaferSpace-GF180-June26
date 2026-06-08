`default_nettype none
`timescale 1ns/1ps

// 4-lane phase accumulator / phase lookahead.
//
// Contract:
//   - One clk produces four consecutive phase samples.
//   - In the intended 4:1 build, this clk is the 125 MHz vector clock.
//   - phase_vec[0] is the earliest serialized sample.
//   - phase_vec[3] is the latest serialized sample.
//   - ftw_now is the FTW for phase_vec[0].
//   - ftw_step_now is the per-output-sample FTW increment.
//   - Segment boundaries are assumed block-aligned outside this module.
//   - This module does not know CW/SAW/TRI; it only sees ftw_now/ftw_step_now.
//
// Phase law:
//   ftw[k]   = ftw_now + k*ftw_step_now
//   phase[k] = phase_base + k*ftw_now + ftw_step_now*k*(k-1)/2
//
// For 4 lanes:
//   phase[0] = phase_base
//   phase[1] = phase_base + ftw
//   phase[2] = phase_base + 2*ftw + step
//   phase[3] = phase_base + 3*ftw + 3*step
//
// Block advance:
//   phase_base_next = phase_base + 4*ftw + 6*step
module phase_accum_vec4 #(
    parameter int PHASE_W = 32
)(
    input  logic clk,
    input  logic rst_n,

    input  logic out_enable,
    input  logic phase_reset_req,

    // FTW for lane 0 of this 4-sample vector block.
    input  logic [PHASE_W-1:0] ftw_now,

    // Per-output-sample FTW step. Zero for CW.
    input  logic [PHASE_W-1:0] ftw_step_now,

    output logic [3:0][PHASE_W-1:0] phase_vec,
    output logic [3:0]              valid_vec
);

    logic [PHASE_W-1:0] phase_base;

    // TB compatibility: preserve the old probe name.
    wire [PHASE_W-1:0] phase_accum = phase_base;

    logic [PHASE_W-1:0] ftw_x2;
    logic [PHASE_W-1:0] ftw_x3;
    logic [PHASE_W-1:0] ftw_x4;
    logic [PHASE_W-1:0] step_x3;
    logic [PHASE_W-1:0] step_x6;

    assign ftw_x2  = ftw_now << 1;
    assign ftw_x3  = (ftw_now << 1) + ftw_now;
    assign ftw_x4  = ftw_now << 2;

    assign step_x3 = (ftw_step_now << 1) + ftw_step_now;
    assign step_x6 = (ftw_step_now << 2) + (ftw_step_now << 1);

    always_comb begin
        phase_vec[0] = phase_base;
        phase_vec[1] = phase_base + ftw_now;
        phase_vec[2] = phase_base + ftw_x2 + ftw_step_now;
        phase_vec[3] = phase_base + ftw_x3 + step_x3;

        valid_vec = {4{out_enable}};
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_base <= {PHASE_W{1'b0}};
        end else if (phase_reset_req) begin
            phase_base <= {PHASE_W{1'b0}};
        end else if (out_enable) begin
            phase_base <= phase_base + ftw_x4 + step_x6;
        end
    end

endmodule

`default_nettype wire
