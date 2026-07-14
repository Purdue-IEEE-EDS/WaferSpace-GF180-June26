`default_nettype none
`timescale 1ns/1ps

// Profile normalizer — raw register fields to a uniform execution contract.
// `chirp_n` remains the register name, but its value is interpreted as a
// whole-vector segment length in fabric-clock blocks.
module profile_normalizer #(
    parameter PHASE_W = 32,
    parameter COUNT_W = 20,
    parameter [PHASE_W-1:0] TEST_TONE_FTW = 32'h2284_DFCE
)(
    input  logic [PHASE_W-1:0]    ftw_a,
    input  logic [PHASE_W-1:0]    ftw_b,
    input  logic [PHASE_W-1:0]    ftw_step,
    input  logic [COUNT_W-1:0]    chirp_n,
    input  logic [1:0]            mode,
    input  logic                  auto_restart,
    input  logic                  phase_rst_on_launch,

    output logic [1:0]            shape,
    output logic                  loop_en,
    output logic                  phase_reset_on_launch,
    output logic [PHASE_W-1:0]    ftw_start,
    output logic [PHASE_W-1:0]    ftw_end,
    output logic [PHASE_W-1:0]    ftw_step_sample_pos,
    output logic [PHASE_W-1:0]    ftw_step_sample_neg,
    output logic [COUNT_W-1:0]    seg_blocks
);

    localparam [1:0] MODE_CW   = 2'd0,
                     MODE_SAW  = 2'd1,
                     MODE_TRI  = 2'd2,
                     MODE_TEST = 2'd3;

    localparam [1:0] SHAPE_STEADY = 2'd0,
                     SHAPE_RAMP   = 2'd1,
                     SHAPE_TRI    = 2'd2;

    always_comb begin
        shape                 = SHAPE_STEADY;
        loop_en               = 1'b0;
        phase_reset_on_launch = phase_rst_on_launch;
        ftw_start             = ftw_a;
        ftw_end               = ftw_b;
        ftw_step_sample_pos   = ftw_step;
        ftw_step_sample_neg   = -ftw_step;
        seg_blocks            = chirp_n;

        case (mode)
            MODE_SAW: begin
                shape   = SHAPE_RAMP;
                loop_en = auto_restart;
            end

            MODE_TRI: begin
                shape   = SHAPE_TRI;
                loop_en = auto_restart;
            end

            MODE_TEST: begin
                shape                 = SHAPE_STEADY;
                phase_reset_on_launch = 1'b1;
                ftw_start             = TEST_TONE_FTW;
                loop_en               = 1'b0;
            end

            default: begin
                shape   = SHAPE_STEADY;
                loop_en = 1'b0;
            end
        endcase
    end

endmodule

`default_nettype wire
