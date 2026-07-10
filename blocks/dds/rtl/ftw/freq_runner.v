`default_nettype none
`timescale 1ns/1ps

// Frequency runner — normalized profile executor.
//
// The runner consumes a single profile contract:
//   - commit: latch the next profile and launch it on the next clk
//   - sync: relaunch the armed profile with a forced phase reset
//
// Shapes:
//   STEADY   — load ftw_start and hold forever
//   RAMP     — finite SAW segment
//   TRIANGLE — finite up/down segment
//
// The timing-safe pieces from the old carrier path stay intact:
//   - seg_timer for finite segment timing
//   - carry-save delta-phase datapath
//   - dp_half / step_half hierarchy cuts
module freq_runner #(
    parameter PHASE_W = 32,
    parameter COUNT_W = 20,
    parameter LANES   = 1
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // Control
    input  logic                  commit,
    input  logic                  sync,

    // Next profile
    input  logic [1:0]            next_shape,
    input  logic                  next_loop_en,
    input  logic                  next_phase_reset_on_launch,
    input  logic [PHASE_W-1:0]    next_ftw_start,
    input  logic [PHASE_W-1:0]    next_ftw_end,
    input  logic [PHASE_W-1:0]    next_ftw_step_sample_pos,
    input  logic [PHASE_W-1:0]    next_ftw_step_sample_neg,
    input  logic [COUNT_W-1:0]    next_seg_blocks,

    // Outputs
    output logic                  out_enable,
    output logic                  phase_reset_req,
    output logic [PHASE_W-1:0]    dp_s,
    output logic [PHASE_W-1:0]    dp_c,
`ifndef SYNTHESIS
    output logic [PHASE_W-1:0]    ftw_lane0,
`endif
    output logic [PHASE_W-1:0]    ftw_step_now,
    output logic                  run_active,
    output logic                  segment_done,
    output logic                  dir,
    output logic                  profile_valid
);

    localparam [1:0] SHAPE_STEADY = 2'd0,
                     SHAPE_RAMP   = 2'd1,
                     SHAPE_TRI    = 2'd2;

    localparam ST_IDLE = 1'b0,
               ST_RUN  = 1'b1;

    // Armed profile
    logic [1:0]            act_shape;
    logic                  act_loop_en;
    logic [PHASE_W-1:0]    act_ftw_start;
    logic [PHASE_W-1:0]    act_ftw_end;
    logic [PHASE_W-1:0]    act_ftw_step_sample_pos;
    logic [PHASE_W-1:0]    act_ftw_step_sample_neg;
    logic [COUNT_W-1:0]    act_seg_blocks;
    logic                  launch_pending;
    logic                  launch_phase_reset_pending;

    // Debug / test-visible internals.
    logic                  state;
    logic [PHASE_W-1:0]    ftw_step_block_reg;

    localparam int LANES_LOG2 = (LANES > 1) ? $clog2(LANES) : 0;

    // Visible FTW state: lane 0 / base FTW for the current emitted block.
`ifndef SYNTHESIS
    assign ftw_lane0 = dp_s + dp_c;
`endif

    always_comb begin
        ftw_step_now = {PHASE_W{1'b0}};
        if (state == ST_RUN) begin
            case (act_shape)
                SHAPE_RAMP: ftw_step_now = act_ftw_step_sample_pos;
                SHAPE_TRI:  ftw_step_now = dir
                                         ? act_ftw_step_sample_neg
                                         : act_ftw_step_sample_pos;
                default:    ftw_step_now = {PHASE_W{1'b0}};
            endcase
        end
    end

    initial begin
        if (LANES < 1)
            $error("freq_runner requires LANES >= 1");
        if ((1 << LANES_LOG2) != LANES)
            $error("freq_runner currently requires power-of-two LANES");
    end

    wire relaunch_req = sync & profile_valid;
    wire launch_evt   = launch_pending;
    wire next_profile_is_finite = (next_shape == SHAPE_RAMP) | (next_shape == SHAPE_TRI);
    wire next_profile_valid = !next_profile_is_finite
                           | (next_seg_blocks != {COUNT_W{1'b0}});

    assign phase_reset_req = launch_evt & launch_phase_reset_pending;

    // ================================================================
    //  Segment timer
    // ================================================================
    logic               timer_load;
    logic [COUNT_W-1:0] timer_value;
    logic               timer_kill;
    logic               timer_fire;
    logic               timer_active;

    seg_timer #(.W(COUNT_W)) u_timer (
        .clk    (clk),
        .rst_n  (rst_n),
        .load   (timer_load),
        .value  (timer_value),
        .kill   (timer_kill),
        .fire   (timer_fire),
        .active (timer_active)
    );

    assign run_active = timer_active;

    // ================================================================
    //  Fire actions — finite segment boundaries only
    // ================================================================
    logic [PHASE_W-1:0] fire_dp_value;
    logic               fire_negate_step;
    logic               fire_reload;
    logic               fire_stop;

    always_comb begin
        fire_dp_value    = act_ftw_start;
        fire_negate_step = 1'b0;
        fire_reload      = 1'b0;
        fire_stop        = 1'b0;

        case (act_shape)
            SHAPE_RAMP: begin
                if (act_loop_en) begin
                    fire_dp_value = act_ftw_start;
                    fire_reload   = 1'b1;
                end else begin
                    fire_dp_value = act_ftw_end;
                    fire_stop     = 1'b1;
                end
            end

            SHAPE_TRI: begin
                fire_negate_step = 1'b1;
                if (!dir) begin
                    fire_dp_value = act_ftw_end;
                    fire_reload   = 1'b1;
                end else begin
                    fire_dp_value = act_ftw_start;
                    if (act_loop_en)
                        fire_reload = 1'b1;
                    else
                        fire_stop   = 1'b1;
                end
            end

            default: ;
        endcase
    end

    // ================================================================
    //  CSA — always active, no gating
    // ================================================================
    logic [PHASE_W-1:0] csa_s;
    logic [PHASE_W-1:0] csa_maj;
    logic [PHASE_W-1:0] act_ftw_step_block_pos;
    logic [PHASE_W-1:0] act_ftw_step_block_neg;

    assign act_ftw_step_block_pos = act_ftw_step_sample_pos << LANES_LOG2;
    assign act_ftw_step_block_neg = act_ftw_step_sample_neg << LANES_LOG2;
    assign csa_s                  = dp_s ^ dp_c ^ ftw_step_block_reg;
    assign csa_maj                = (dp_s & dp_c)
                                  | (dp_s & ftw_step_block_reg)
                                  | (dp_c & ftw_step_block_reg);

    // ================================================================
    //  Launch / boundary sequencer
    // ================================================================
    logic               seq_dp_load;
    logic [PHASE_W-1:0] seq_dp_value;
    logic               seq_ftw_step_block_load;
    logic [PHASE_W-1:0] seq_ftw_step_block_value;
    logic               seq_timer_start;
    logic [COUNT_W-1:0] seq_timer_value;
    logic               seq_kill;
    logic               seq_next_state;

    always_comb begin
        seq_dp_load     = 1'b0;
        seq_dp_value    = act_ftw_start;
        seq_ftw_step_block_load  = 1'b0;
        seq_ftw_step_block_value = {PHASE_W{1'b0}};
        seq_timer_start = 1'b0;
        seq_timer_value = act_seg_blocks;
        seq_kill        = 1'b0;
        seq_next_state  = state;

        if (launch_evt) begin
            case (act_shape)
                SHAPE_STEADY: begin
                    seq_dp_load    = 1'b1;
                    seq_dp_value   = act_ftw_start;
                    seq_kill       = 1'b1;
                    seq_next_state = ST_IDLE;
                end

                SHAPE_RAMP,
                SHAPE_TRI: begin
                    if (act_seg_blocks != {COUNT_W{1'b0}}) begin
                        seq_dp_load             = 1'b1;
                        seq_dp_value            = act_ftw_start;
                        seq_ftw_step_block_load = 1'b1;
                        seq_ftw_step_block_value = act_ftw_step_block_pos;
                        seq_timer_start         = 1'b1;
                        seq_next_state          = ST_RUN;
                    end else begin
                        seq_kill       = 1'b1;
                        seq_next_state = ST_IDLE;
                    end
                end

                default: begin
                    seq_kill       = 1'b1;
                    seq_next_state = ST_IDLE;
                end
            endcase
        end
    end

    assign timer_load  = seq_timer_start
                       | (timer_fire & fire_reload & ~seq_kill);
    assign timer_value = seq_timer_start ? seq_timer_value : act_seg_blocks;
    assign timer_kill  = seq_kill & ~timer_load;

    // ================================================================
    //  dp_s / dp_c — four dp_half instances (W=8) with keep_hierarchy.
    // ================================================================
    wire dp_sel_load = seq_dp_load;
    wire dp_sel_fire = timer_fire & ~seq_kill;
    wire dp_sel_csa  = timer_active & ~timer_fire;

    wire [PHASE_W-1:0] fire_ftw_step_block_value =
        dir ? act_ftw_step_block_pos : act_ftw_step_block_neg;

    dp_half #(.W(8)) u_dp_0 (
        .clk(clk), .rst_n(rst_n),
        .sel_load(dp_sel_load), .sel_fire(dp_sel_fire), .sel_csa(dp_sel_csa),
        .load_s(seq_dp_value[7:0]),     .fire_s(fire_dp_value[7:0]),
        .csa_s_in(csa_s[7:0]),          .csa_c_in({csa_maj[6:0], 1'b0}),
        .dp_s(dp_s[7:0]),               .dp_c(dp_c[7:0])
    );

    dp_half #(.W(8)) u_dp_1 (
        .clk(clk), .rst_n(rst_n),
        .sel_load(dp_sel_load), .sel_fire(dp_sel_fire), .sel_csa(dp_sel_csa),
        .load_s(seq_dp_value[15:8]),    .fire_s(fire_dp_value[15:8]),
        .csa_s_in(csa_s[15:8]),         .csa_c_in(csa_maj[14:7]),
        .dp_s(dp_s[15:8]),              .dp_c(dp_c[15:8])
    );

    dp_half #(.W(8)) u_dp_2 (
        .clk(clk), .rst_n(rst_n),
        .sel_load(dp_sel_load), .sel_fire(dp_sel_fire), .sel_csa(dp_sel_csa),
        .load_s(seq_dp_value[23:16]),   .fire_s(fire_dp_value[23:16]),
        .csa_s_in(csa_s[23:16]),        .csa_c_in(csa_maj[22:15]),
        .dp_s(dp_s[23:16]),             .dp_c(dp_c[23:16])
    );

    dp_half #(.W(8)) u_dp_3 (
        .clk(clk), .rst_n(rst_n),
        .sel_load(dp_sel_load), .sel_fire(dp_sel_fire), .sel_csa(dp_sel_csa),
        .load_s(seq_dp_value[31:24]),   .fire_s(fire_dp_value[31:24]),
        .csa_s_in(csa_s[31:24]),        .csa_c_in(csa_maj[30:23]),
        .dp_s(dp_s[31:24]),             .dp_c(dp_c[31:24])
    );

    // ================================================================
    //  ftw_step_block_reg — two step_half instances with keep_hierarchy.
    // ================================================================
    wire ftw_step_block_sel_load = seq_ftw_step_block_load;
    wire ftw_step_block_sel_swap = timer_fire & fire_negate_step & ~seq_kill;

    step_half #(.W(16)) u_step_lo (
        .clk(clk), .rst_n(rst_n),
        .sel_load(ftw_step_block_sel_load), .sel_swap(ftw_step_block_sel_swap),
        .load_val(seq_ftw_step_block_value[15:0]),
        .swap_val(fire_ftw_step_block_value[15:0]),
        .step_out(ftw_step_block_reg[15:0])
    );

    step_half #(.W(16)) u_step_hi (
        .clk(clk), .rst_n(rst_n),
        .sel_load(ftw_step_block_sel_load), .sel_swap(ftw_step_block_sel_swap),
        .load_val(seq_ftw_step_block_value[31:16]),
        .swap_val(fire_ftw_step_block_value[31:16]),
        .step_out(ftw_step_block_reg[31:16])
    );

    // ================================================================
    //  State / armed profile / debug pulse
    // ================================================================
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            profile_valid              <= 1'b0;
            act_shape                  <= SHAPE_STEADY;
            act_loop_en                <= 1'b0;
            act_ftw_start              <= {PHASE_W{1'b0}};
            act_ftw_end                <= {PHASE_W{1'b0}};
            act_ftw_step_sample_pos    <= {PHASE_W{1'b0}};
            act_ftw_step_sample_neg    <= {PHASE_W{1'b0}};
            act_seg_blocks             <= {COUNT_W{1'b0}};
            launch_pending             <= 1'b0;
            launch_phase_reset_pending <= 1'b0;
            state                      <= ST_IDLE;
            dir                        <= 1'b0;
            out_enable                 <= 1'b0;
            segment_done               <= 1'b0;
        end else begin
            if (commit) begin
                if (next_profile_valid) begin
                    profile_valid              <= 1'b1;
                    act_shape                  <= next_shape;
                    act_loop_en                <= next_loop_en;
                    act_ftw_start              <= next_ftw_start;
                    act_ftw_end                <= next_ftw_end;
                    act_ftw_step_sample_pos    <= next_ftw_step_sample_pos;
                    act_ftw_step_sample_neg    <= next_ftw_step_sample_neg;
                    act_seg_blocks             <= next_seg_blocks;
                    launch_pending             <= 1'b1;
                    launch_phase_reset_pending <= next_phase_reset_on_launch | sync;
                end
            end else if (relaunch_req) begin
                launch_pending             <= 1'b1;
                launch_phase_reset_pending <= 1'b1;
            end else if (launch_evt) begin
                launch_pending             <= 1'b0;
                launch_phase_reset_pending <= 1'b0;
            end

            if (launch_evt && seq_dp_load)
                out_enable <= 1'b1;

            if (launch_evt) begin
                state <= seq_next_state;
            end else begin
                state <= state;
                if (timer_fire && fire_stop && !seq_kill)
                    state <= ST_IDLE;
            end

            if (launch_evt) begin
                dir <= 1'b0;
            end else if (timer_fire && act_shape == SHAPE_TRI && !seq_kill) begin
                dir <= ~dir;
            end

            segment_done <= timer_fire
                         & (act_shape == SHAPE_RAMP
                         | (act_shape == SHAPE_TRI && dir))
                         & ~seq_dp_load
                         & ~seq_kill;
        end
    end

endmodule

`default_nettype wire
