`default_nettype none
`timescale 1ns/1ps

// FTW controller — raw register fields to executed FTW stream.
//
// This wraps:
//   1. profile_normalizer: user-facing mode/register contract
//   2. freq_runner:        normalized profile executor
module ftw_ctrl #(
    parameter PHASE_W = 32,
    parameter COUNT_W = 20,
    parameter LANES   = 1,
    parameter [PHASE_W-1:0] TEST_TONE_FTW = 32'h2284_DFCE
)(
    input  logic                  clk,
    input  logic                  rst_n,

    input  logic                  commit,
    input  logic                  sync,

    input  logic [PHASE_W-1:0]    ftw_a,
    input  logic [PHASE_W-1:0]    ftw_b,
    input  logic [PHASE_W-1:0]    ftw_step,
    input  logic [COUNT_W-1:0]    chirp_n,
    input  logic [1:0]            mode,
    input  logic                  auto_restart,
    input  logic                  phase_rst_on_launch,

    output logic                  out_enable,
    output logic                  phase_reset_req,
    output logic [PHASE_W-1:0]    dp_s,
    output logic [PHASE_W-1:0]    dp_c,
    output logic [PHASE_W-1:0]    ftw_lane0,
    output logic [PHASE_W-1:0]    ftw_step_now,
    output logic                  run_active,
    output logic                  segment_done,
    output logic                  dir,
    output logic                  profile_valid
);

    logic [1:0]         norm_shape;
    logic               norm_loop_en;
    logic               norm_phase_reset_on_launch;
    logic [PHASE_W-1:0] norm_ftw_start;
    logic [PHASE_W-1:0] norm_ftw_end;
    logic [PHASE_W-1:0] norm_ftw_step_sample_pos;
    logic [PHASE_W-1:0] norm_ftw_step_sample_neg;
    logic [COUNT_W-1:0] norm_seg_blocks;

    profile_normalizer #(
        .PHASE_W       (PHASE_W),
        .COUNT_W       (COUNT_W),
        .TEST_TONE_FTW (TEST_TONE_FTW)
    ) u_profile (
        .ftw_a                (ftw_a),
        .ftw_b                (ftw_b),
        .ftw_step             (ftw_step),
        .chirp_n              (chirp_n),
        .mode                 (mode),
        .auto_restart         (auto_restart),
        .phase_rst_on_launch  (phase_rst_on_launch),
        .shape                (norm_shape),
        .loop_en              (norm_loop_en),
        .phase_reset_on_launch(norm_phase_reset_on_launch),
        .ftw_start            (norm_ftw_start),
        .ftw_end              (norm_ftw_end),
        .ftw_step_sample_pos  (norm_ftw_step_sample_pos),
        .ftw_step_sample_neg  (norm_ftw_step_sample_neg),
        .seg_blocks           (norm_seg_blocks)
    );

    freq_runner #(
        .PHASE_W (PHASE_W),
        .COUNT_W (COUNT_W),
        .LANES   (LANES)
    ) u_run (
        .clk                       (clk),
        .rst_n                     (rst_n),
        .commit                    (commit),
        .sync                      (sync),
        .next_shape                (norm_shape),
        .next_loop_en              (norm_loop_en),
        .next_phase_reset_on_launch(norm_phase_reset_on_launch),
        .next_ftw_start            (norm_ftw_start),
        .next_ftw_end              (norm_ftw_end),
        .next_ftw_step_sample_pos  (norm_ftw_step_sample_pos),
        .next_ftw_step_sample_neg  (norm_ftw_step_sample_neg),
        .next_seg_blocks           (norm_seg_blocks),
        .out_enable                (out_enable),
        .phase_reset_req           (phase_reset_req),
        .dp_s                      (dp_s),
        .dp_c                      (dp_c),
        .ftw_lane0                 (ftw_lane0),
        .ftw_step_now              (ftw_step_now),
        .run_active                (run_active),
        .segment_done              (segment_done),
        .dir                       (dir),
        .profile_valid             (profile_valid)
    );

endmodule

`default_nettype wire
