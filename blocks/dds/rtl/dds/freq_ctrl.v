`default_nettype none
`timescale 1ns/1ps

// Frequency control — delta-phase generator.
//
// Architecture: seg_timer + sequencer + CSA datapath.
//
//   Timer: self-terminating countdown (seg_timer).  Loaded with chirp_n
//   at segment start.  Fires when t == 1 (last active cycle).  Knows
//   nothing about modes.
//
//   Fire actions: combinational muxes on registered state (run_mode,
//   dir, auto_restart).  When fire asserts, the datapath loads the
//   pre-computed value.  1-bit mux select, no wide decode cone.
//
//   dir: T flip-flop.  Toggles on fire in TRI mode.  Action mux reads
//   dir BEFORE the flip (non-blocking semantics).
//
//   CSA datapath: {dp_s, dp_c} carry-save pair.  Step accumulates
//   every cycle while timer is active and not firing.  O(1) depth.
//
//   chirp_active = timer.active.  Timer is the authority on segment time.
//
//   Sequencer: programs timer + actions at segment start.  Handles
//   start, sync_reset, HOP trigger, mode change.  Never runs per-cycle.
module freq_ctrl #(
    parameter PHASE_W = 32,
    parameter COUNT_W = 20
)(
    input  logic                  clk,
    input  logic                  rst_n,

    // configuration (active-register domain)
    input  logic [PHASE_W-1:0]   ftw_a,
    input  logic [PHASE_W-1:0]   ftw_b,
    input  logic [PHASE_W-1:0]   chirp_step,
    input  logic [PHASE_W-1:0]   neg_chirp_step,
    input  logic [COUNT_W-1:0]   chirp_n,
    input  logic                  chirp_n_valid,
    input  logic [1:0]            mode,
    input  logic                  auto_restart,

    // control (synchronised)
    input  logic                  start,
    input  logic                  trigger,
    input  logic                  freq_sel,
    input  logic                  sync_reset,

    // outputs — carry-save pair for phase_accum
    output logic [PHASE_W-1:0]   dp_s,
    output logic [PHASE_W-1:0]   dp_c,

    // output — resolved binary (combinational, for debug/probing)
    output logic [PHASE_W-1:0]   delta_phase,

    output logic                  chirp_active,
    output logic                  chirp_done
);

    localparam [1:0] MODE_CW  = 2'd0,
                     MODE_SAW = 2'd1,
                     MODE_TRI = 2'd2,
                     MODE_HOP = 2'd3;

    localparam ST_IDLE = 1'b0,
               ST_RUN  = 1'b1;

    // ================================================================
    //  State registers
    // ================================================================
    logic                  state;
    logic [PHASE_W-1:0]   step_reg;   // driven by step_half instances
    logic                  dir;
    logic [1:0]            run_mode;

    // ---- resolved delta_phase for debug ----
    assign delta_phase = dp_s + dp_c;

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

    // Timer is the authority on segment time.
    assign chirp_active = timer_active;

    // ================================================================
    //  Fire actions — from registered state, no wide decode
    //
    //  All inputs (run_mode, dir, auto_restart, ftw_a, ftw_b) are
    //  registered.  These are shallow muxes valid when fire asserts.
    // ================================================================
    logic [PHASE_W-1:0] fire_dp_value;
    logic               fire_negate_step;
    logic               fire_reload;
    logic               fire_done;
    logic               fire_stop;

    always_comb begin
        fire_dp_value    = ftw_a;
        fire_negate_step = 1'b0;
        fire_reload      = 1'b0;
        fire_done        = 1'b0;
        fire_stop        = 1'b0;

        case (run_mode)
            MODE_SAW: begin
                fire_done = 1'b1;
                if (auto_restart) begin
                    fire_dp_value = ftw_a;
                    fire_reload   = 1'b1;
                end else begin
                    fire_dp_value = ftw_b;
                    fire_stop     = 1'b1;
                end
            end
            MODE_TRI: begin
                fire_negate_step = 1'b1;
                if (!dir) begin
                    // up-leg end (midpoint): load apex, reload
                    fire_dp_value = ftw_b;
                    fire_reload   = 1'b1;
                end else begin
                    // down-leg end (bottom): load base, done
                    fire_dp_value = ftw_a;
                    fire_done     = 1'b1;
                    if (auto_restart)
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

    assign csa_s   = dp_s ^ dp_c ^ step_reg;
    assign csa_maj = (dp_s & dp_c) | (dp_s & step_reg) | (dp_c & step_reg);

    // ================================================================
    //  Sequencer — boundary events only
    // ================================================================
    logic               seq_dp_load;
    logic [PHASE_W-1:0] seq_dp_value;
    logic               seq_step_load;
    logic [PHASE_W-1:0] seq_step_value;
    logic               seq_timer_start;
    logic [COUNT_W-1:0] seq_timer_value;
    logic               seq_kill;
    logic               seq_next_state;
    logic [1:0]         seq_next_run_mode;

    always_comb begin
        seq_dp_load       = 1'b0;
        seq_dp_value      = ftw_a;
        seq_step_load     = 1'b0;
        seq_step_value    = chirp_step;
        seq_timer_start   = 1'b0;
        seq_timer_value   = chirp_n;
        seq_kill          = 1'b0;
        seq_next_state    = state;
        seq_next_run_mode = run_mode;

        if (sync_reset) begin
            seq_dp_load    = 1'b1;
            seq_dp_value   = ftw_a;
            seq_step_load  = 1'b1;
            seq_step_value = {PHASE_W{1'b0}};
            seq_kill       = 1'b1;
            seq_next_state = ST_IDLE;
        end else

        case (state)
            ST_IDLE: begin
                if (start) begin
                    seq_dp_load  = 1'b1;
                    seq_dp_value = ftw_a;
                    case (mode)
                        MODE_CW: ;
                        MODE_SAW: begin
                            if (chirp_n_valid) begin
                                seq_step_load     = 1'b1;
                                seq_timer_start   = 1'b1;
                                seq_next_run_mode = MODE_SAW;
                                seq_next_state    = ST_RUN;
                            end
                        end
                        MODE_TRI: begin
                            if (chirp_n_valid) begin
                                seq_step_load     = 1'b1;
                                seq_timer_start   = 1'b1;
                                seq_next_run_mode = MODE_TRI;
                                seq_next_state    = ST_RUN;
                            end
                        end
                        MODE_HOP: begin
                            seq_next_run_mode = MODE_HOP;
                            seq_next_state    = ST_RUN;
                        end
                    endcase
                end
            end

            ST_RUN: begin
                if (mode != run_mode) begin
                    seq_kill       = 1'b1;
                    seq_next_state = ST_IDLE;
                end else if (run_mode == MODE_HOP && trigger) begin
                    seq_dp_load  = 1'b1;
                    seq_dp_value = freq_sel ? ftw_b : ftw_a;
                end
            end

            default: begin
                seq_kill       = 1'b1;
                seq_next_state = ST_IDLE;
            end
        endcase
    end

    // ================================================================
    //  Timer control wiring
    //
    //  timer_load: seq start OR (fire + reload), gated by ~seq_kill
    //  to prevent reload during sync_reset or mode-change abort.
    // ================================================================
    assign timer_load  = seq_timer_start
                       | (timer_fire & fire_reload & ~seq_kill);
    assign timer_value = seq_timer_start ? seq_timer_value : chirp_n;
    assign timer_kill  = seq_kill & ~timer_load;

    // ================================================================
    //  dp_s / dp_c — four dp_half instances (W=8) with keep_hierarchy.
    //
    //  ABC cannot merge select trees across module boundaries.
    //  Each instance has 16 FFs (8 dp_s + 8 dp_c).
    //  The 1-bit select signals fan out to 4 module ports + step + ctrl
    //  at the parent level (~10 loads).
    // ================================================================
    wire dp_sel_load = seq_dp_load;
    wire dp_sel_fire = timer_fire & ~seq_kill;
    wire dp_sel_csa  = timer_active & ~timer_fire;

    // ---- Registered fire data values ----
    // fire_dp_value and fire_step_value are combinational from registered
    // inputs, stable for the entire leg.  Registering removes 32+32 data
    // loads from the shared control cone (the source of fanout-36).
    wire [PHASE_W-1:0] fire_step_value = dir ? chirp_step : neg_chirp_step;

    logic [PHASE_W-1:0] fire_dp_value_r;
    logic [PHASE_W-1:0] fire_step_value_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fire_dp_value_r   <= {PHASE_W{1'b0}};
            fire_step_value_r <= {PHASE_W{1'b0}};
        end else begin
            fire_dp_value_r   <= fire_dp_value;
            fire_step_value_r <= fire_step_value;
        end
    end

    dp_half #(.W(8)) u_dp_0 (
        .clk(clk), .rst_n(rst_n),
        .sel_load(dp_sel_load), .sel_fire(dp_sel_fire), .sel_csa(dp_sel_csa),
        .load_s(seq_dp_value[7:0]),     .fire_s(fire_dp_value_r[7:0]),
        .csa_s_in(csa_s[7:0]),          .csa_c_in({csa_maj[6:0], 1'b0}),
        .dp_s(dp_s[7:0]),               .dp_c(dp_c[7:0])
    );

    dp_half #(.W(8)) u_dp_1 (
        .clk(clk), .rst_n(rst_n),
        .sel_load(dp_sel_load), .sel_fire(dp_sel_fire), .sel_csa(dp_sel_csa),
        .load_s(seq_dp_value[15:8]),    .fire_s(fire_dp_value_r[15:8]),
        .csa_s_in(csa_s[15:8]),         .csa_c_in(csa_maj[14:7]),
        .dp_s(dp_s[15:8]),              .dp_c(dp_c[15:8])
    );

    dp_half #(.W(8)) u_dp_2 (
        .clk(clk), .rst_n(rst_n),
        .sel_load(dp_sel_load), .sel_fire(dp_sel_fire), .sel_csa(dp_sel_csa),
        .load_s(seq_dp_value[23:16]),   .fire_s(fire_dp_value_r[23:16]),
        .csa_s_in(csa_s[23:16]),        .csa_c_in(csa_maj[22:15]),
        .dp_s(dp_s[23:16]),             .dp_c(dp_c[23:16])
    );

    dp_half #(.W(8)) u_dp_3 (
        .clk(clk), .rst_n(rst_n),
        .sel_load(dp_sel_load), .sel_fire(dp_sel_fire), .sel_csa(dp_sel_csa),
        .load_s(seq_dp_value[31:24]),   .fire_s(fire_dp_value_r[31:24]),
        .csa_s_in(csa_s[31:24]),        .csa_c_in(csa_maj[30:23]),
        .dp_s(dp_s[31:24]),             .dp_c(dp_c[31:24])
    );

    // ================================================================
    //  step_reg — two step_half instances with keep_hierarchy.
    // ================================================================
    wire step_sel_load = seq_step_load;
    wire step_sel_swap = timer_fire & fire_negate_step & ~seq_kill;

    step_half #(.W(16)) u_step_lo (
        .clk(clk), .rst_n(rst_n),
        .sel_load(step_sel_load), .sel_swap(step_sel_swap),
        .load_val(seq_step_value[15:0]),
        .swap_val(fire_step_value_r[15:0]),
        .step_out(step_reg[15:0])
    );

    step_half #(.W(16)) u_step_hi (
        .clk(clk), .rst_n(rst_n),
        .sel_load(step_sel_load), .sel_swap(step_sel_swap),
        .load_val(seq_step_value[31:16]),
        .swap_val(fire_step_value_r[31:16]),
        .step_out(step_reg[31:16])
    );

    // ---- dir, state, run_mode, chirp_done  (5 FFs) ----
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state      <= ST_IDLE;
            dir        <= 1'b0;
            run_mode   <= MODE_CW;
            chirp_done <= 1'b0;
        end else begin
            // dir
            if (sync_reset || (seq_timer_start && mode == MODE_TRI))
                dir <= 1'b0;
            else if (timer_fire && run_mode == MODE_TRI && !seq_kill)
                dir <= ~dir;

            // state, run_mode
            state    <= seq_next_state;
            run_mode <= seq_next_run_mode;
            if (timer_fire && fire_stop && !seq_kill)
                state <= ST_IDLE;

            // chirp_done
            chirp_done <= timer_fire & fire_done & ~seq_dp_load & ~seq_kill;
        end
    end

endmodule
