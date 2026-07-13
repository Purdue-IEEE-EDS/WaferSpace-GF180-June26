`default_nettype none
`timescale 1ns/1ps

// 4-lane phase accumulator / phase lookahead.
//
// Contract:
//   - One clk captures the FTW/control handoff, then one clk registers four
//     consecutive phase samples.
//   - In the intended 4:1 build, this clk is the 125 MHz vector clock.
//   - phase_vec[0] is the earliest serialized sample.
//   - phase_vec[3] is the latest serialized sample.
//   - {ftw_now, ftw_c_now} is the carry-save FTW for phase_vec[0].
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
    input  logic [PHASE_W-1:0] ftw_c_now,

    // Per-output-sample FTW step. Zero for CW.
    input  logic [PHASE_W-1:0] ftw_step_now,

    output logic [3:0][PHASE_W-1:0] phase_s_vec,
    output logic [3:0][PHASE_W-1:0] phase_c_vec,
    output logic [3:0][PHASE_W-1:0] phase_vec,
    output logic [3:0]              valid_vec
);

    logic [PHASE_W-1:0] phase_base_s;
    logic [PHASE_W-1:0] phase_base_c;
    logic [PHASE_W-1:0] ftw_s_1;
    logic [PHASE_W-1:0] ftw_c_1;
    logic [PHASE_W-1:0] ftw_step_1;
    logic               out_enable_1;
    logic [3:0][PHASE_W-1:0] phase_s_comb;
    logic [3:0][PHASE_W-1:0] phase_c_comb;
    logic [3:0]              valid_comb;

`ifndef SYNTHESIS
    // TB compatibility: preserve the old probe name.
    wire [PHASE_W-1:0] phase_accum = phase_base_s + phase_base_c;
`endif

    function automatic logic [PHASE_W-1:0] csa_sum3(
        input logic [PHASE_W-1:0] a,
        input logic [PHASE_W-1:0] b,
        input logic [PHASE_W-1:0] c
    );
        begin
            csa_sum3 = a ^ b ^ c;
        end
    endfunction

    function automatic logic [PHASE_W-1:0] csa_carry3(
        input logic [PHASE_W-1:0] a,
        input logic [PHASE_W-1:0] b,
        input logic [PHASE_W-1:0] c
    );
        logic [PHASE_W-1:0] maj;
        begin
            maj = (a & b) | (a & c) | (b & c);
            csa_carry3 = maj << 1;
        end
    endfunction

    logic [PHASE_W-1:0] lane1_s0;
    logic [PHASE_W-1:0] lane1_c0;

    logic [PHASE_W-1:0] lane2_s0;
    logic [PHASE_W-1:0] lane2_c0;
    logic [PHASE_W-1:0] lane2_s1;
    logic [PHASE_W-1:0] lane2_c1;

    logic [PHASE_W-1:0] lane3_a_s;
    logic [PHASE_W-1:0] lane3_a_c;
    logic [PHASE_W-1:0] lane3_b_s;
    logic [PHASE_W-1:0] lane3_b_c;
    logic [PHASE_W-1:0] lane3_c_s;
    logic [PHASE_W-1:0] lane3_c_c;
    logic [PHASE_W-1:0] lane3_d_s;
    logic [PHASE_W-1:0] lane3_d_c;
    logic [PHASE_W-1:0] lane3_e_s;
    logic [PHASE_W-1:0] lane3_e_c;
    logic [PHASE_W-1:0] lane3_f_s;
    logic [PHASE_W-1:0] lane3_f_c;

    logic [PHASE_W-1:0] next_a_s;
    logic [PHASE_W-1:0] next_a_c;
    logic [PHASE_W-1:0] next_b_s;
    logic [PHASE_W-1:0] next_b_c;
    logic [PHASE_W-1:0] next_c_s;
    logic [PHASE_W-1:0] next_c_c;
    logic [PHASE_W-1:0] phase_next_s;
    logic [PHASE_W-1:0] phase_next_c;

    always_comb begin
        phase_s_comb[0] = phase_base_s;
        phase_c_comb[0] = phase_base_c;

        lane1_s0 = csa_sum3(phase_base_s, phase_base_c, ftw_s_1);
        lane1_c0 = csa_carry3(phase_base_s, phase_base_c, ftw_s_1);
        phase_s_comb[1] = csa_sum3(lane1_s0, lane1_c0, ftw_c_1);
        phase_c_comb[1] = csa_carry3(lane1_s0, lane1_c0, ftw_c_1);

        lane2_s0 = csa_sum3(phase_base_s, phase_base_c, ftw_s_1 << 1);
        lane2_c0 = csa_carry3(phase_base_s, phase_base_c, ftw_s_1 << 1);
        lane2_s1 = csa_sum3(lane2_s0, lane2_c0, ftw_c_1 << 1);
        lane2_c1 = csa_carry3(lane2_s0, lane2_c0, ftw_c_1 << 1);
        phase_s_comb[2] = csa_sum3(lane2_s1, lane2_c1, ftw_step_1);
        phase_c_comb[2] = csa_carry3(lane2_s1, lane2_c1, ftw_step_1);

        lane3_a_s = csa_sum3(phase_base_s, phase_base_c, ftw_s_1 << 1);
        lane3_a_c = csa_carry3(phase_base_s, phase_base_c, ftw_s_1 << 1);
        lane3_b_s = csa_sum3(ftw_s_1, ftw_c_1 << 1, ftw_c_1);
        lane3_b_c = csa_carry3(ftw_s_1, ftw_c_1 << 1, ftw_c_1);
        lane3_c_s = csa_sum3(ftw_step_1 << 1, ftw_step_1, {PHASE_W{1'b0}});
        lane3_c_c = csa_carry3(ftw_step_1 << 1, ftw_step_1, {PHASE_W{1'b0}});
        lane3_d_s = csa_sum3(lane3_a_s, lane3_a_c, lane3_b_s);
        lane3_d_c = csa_carry3(lane3_a_s, lane3_a_c, lane3_b_s);
        lane3_e_s = csa_sum3(lane3_b_c, lane3_c_s, lane3_c_c);
        lane3_e_c = csa_carry3(lane3_b_c, lane3_c_s, lane3_c_c);
        lane3_f_s = csa_sum3(lane3_d_s, lane3_d_c, lane3_e_s);
        lane3_f_c = csa_carry3(lane3_d_s, lane3_d_c, lane3_e_s);
        phase_s_comb[3] = csa_sum3(lane3_f_s, lane3_f_c, lane3_e_c);
        phase_c_comb[3] = csa_carry3(lane3_f_s, lane3_f_c, lane3_e_c);

        next_a_s = csa_sum3(phase_base_s, phase_base_c, ftw_s_1 << 2);
        next_a_c = csa_carry3(phase_base_s, phase_base_c, ftw_s_1 << 2);
        next_b_s = csa_sum3(ftw_c_1 << 2, ftw_step_1 << 2, ftw_step_1 << 1);
        next_b_c = csa_carry3(ftw_c_1 << 2, ftw_step_1 << 2, ftw_step_1 << 1);
        next_c_s = csa_sum3(next_a_s, next_a_c, next_b_s);
        next_c_c = csa_carry3(next_a_s, next_a_c, next_b_s);
        phase_next_s = csa_sum3(next_c_s, next_c_c, next_b_c);
        phase_next_c = csa_carry3(next_c_s, next_c_c, next_b_c);

        valid_comb = {4{out_enable_1}};
    end

`ifndef SYNTHESIS
    assign phase_vec[0] = phase_s_vec[0] + phase_c_vec[0];
    assign phase_vec[1] = phase_s_vec[1] + phase_c_vec[1];
    assign phase_vec[2] = phase_s_vec[2] + phase_c_vec[2];
    assign phase_vec[3] = phase_s_vec[3] + phase_c_vec[3];
`else
    assign phase_vec = '0;
`endif

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            phase_base_s <= {PHASE_W{1'b0}};
            phase_base_c <= {PHASE_W{1'b0}};
            ftw_s_1      <= {PHASE_W{1'b0}};
            ftw_c_1      <= {PHASE_W{1'b0}};
            ftw_step_1   <= {PHASE_W{1'b0}};
            out_enable_1 <= 1'b0;
            phase_s_vec  <= '0;
            phase_c_vec  <= '0;
            valid_vec    <= 4'b0000;
        end else begin
            ftw_s_1      <= ftw_now;
            ftw_c_1      <= ftw_c_now;
            ftw_step_1   <= ftw_step_now;
            out_enable_1 <= out_enable & ~phase_reset_req;

            if (phase_reset_req) begin
                phase_base_s <= {PHASE_W{1'b0}};
                phase_base_c <= {PHASE_W{1'b0}};
                phase_s_vec  <= '0;
                phase_c_vec  <= '0;
                valid_vec    <= 4'b0000;
            end else begin
                phase_s_vec <= phase_s_comb;
                phase_c_vec <= phase_c_comb;
                valid_vec   <= valid_comb;
                if (out_enable_1) begin
                    phase_base_s <= phase_next_s;
                    phase_base_c <= phase_next_c;
                end
            end
        end
    end

endmodule

`default_nettype wire
