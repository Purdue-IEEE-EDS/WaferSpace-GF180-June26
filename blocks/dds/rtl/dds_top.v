`default_nettype none
`timescale 1ns/1ps

// DDS top-level
//
// SCLK domain: spi_slave, dds_regmap.
// CLK domain:  freq_ctrl, phase_accum, dds_datapath.
// CDC bridge:  sync_edge on all control pins. shadow→active latch on commit.
//
// io_update commit architecture:
//   io_upd (sync_edge pulse) → 4 registered commit signals, one per block.
//   Each commit fans out only to its own block's active registers.
//   Eliminates the 113-flop fanout that blew STA.
//
//   freq_commit, chirp_commit:  gated by ~chirp_active (frozen during ramp)
//   pow_commit, amp_commit:     always fire (symbols update during carrier)
//
//   Commit adds 1 cycle of latency.  start_d and sync_d are delayed by
//   2 cycles (was 1) to preserve the guarantee that config latches before
//   start/sync when both arrive on the same external edge.

module dds_top #(
    parameter PHASE_W     = 32,
    parameter TRUNC_W     = 12,
    parameter UNARY_BITS  = 5,
    parameter BINARY_BITS = 5,
    parameter COUNT_W     = 20,
    parameter SYM_W       = 2,
    parameter DAC_SW_W    = (1 << UNARY_BITS) - 1 + BINARY_BITS,
    parameter DEVID       = 8'hD5
)(
    // system clock domain
    input  logic                  clk,
    input  logic                  rst_n,

    // SPI pins
    input  logic                  sclk,
    input  logic                  csn,
    input  logic                  mosi,
    output logic                  miso,

    // control pins
    input  logic                  io_update,
    input  logic                  start,
    input  logic                  sync_in,
    input  logic                  freq_trigger,
    input  logic                  amp_trigger,

    // modulation data pins
    input  logic [SYM_W-1:0]      amp_idx,
    input  logic [SYM_W-1:0]      pow_sel,
    input  logic                  freq_sel,

    // DAC outputs
    output logic [DAC_SW_W-1:0]  dac_i,
    output logic [DAC_SW_W-1:0]  dac_q,

    // status outputs (CLK domain)
    output logic                  chirp_active,
    output logic                  chirp_done
);

    // ================================================================
    //  SPI slave (SCLK domain)
    // ================================================================
    logic        spi_wr_en, spi_rd_en;
    logic [6:0]  spi_addr;
    logic [7:0]  spi_wdata, spi_rdata;

    spi_slave u_spi (
        .sclk  (sclk),
        .csn   (csn),
        .mosi  (mosi),
        .miso  (miso),
        .wr_en (spi_wr_en),
        .rd_en (spi_rd_en),
        .addr  (spi_addr),
        .wdata (spi_wdata),
        .rdata (spi_rdata)
    );

    // ================================================================
    //  Register map (SCLK domain, rst_n for power-on reset)
    // ================================================================
    logic [PHASE_W-1:0] rf_ftw_a, rf_ftw_b, rf_chirp_step;
    logic [COUNT_W-1:0] rf_chirp_n;
    logic [1:0]         rf_mode;
    logic               rf_auto_restart;
    logic               rf_phase_rst_on_start;
    logic [15:0]        rf_pow_0, rf_pow_1, rf_pow_2, rf_pow_3;
    logic [15:0]        rf_amp_0, rf_amp_1, rf_amp_2, rf_amp_3;

    logic               chirp_done_sticky;

    dds_regmap #(
        .PHASE_W (PHASE_W),
        .COUNT_W (COUNT_W),
        .DEVID   (DEVID)
    ) u_regmap (
        .sclk               (sclk),
        .csn                 (csn),
        .rst_n               (rst_n),
        .wr_en               (spi_wr_en),
        .addr                (spi_addr),
        .wdata               (spi_wdata),
        .rdata               (spi_rdata),
        .chirp_active        (chirp_active),
        .chirp_done_sticky   (chirp_done_sticky),
        .ftw_a               (rf_ftw_a),
        .ftw_b               (rf_ftw_b),
        .chirp_step          (rf_chirp_step),
        .chirp_n             (rf_chirp_n),
        .mode                (rf_mode),
        .auto_restart        (rf_auto_restart),
        .phase_rst_on_start  (rf_phase_rst_on_start),
        .pow_0               (rf_pow_0),
        .pow_1               (rf_pow_1),
        .pow_2               (rf_pow_2),
        .pow_3               (rf_pow_3),
        .amp_0               (rf_amp_0),
        .amp_1               (rf_amp_1),
        .amp_2               (rf_amp_2),
        .amp_3               (rf_amp_3)
    );

    // ================================================================
    //  CDC: synchronizers (pin → CLK domain)
    // ================================================================
    logic io_upd, start_s, sync_s, freq_trigger_s, amp_trigger_s;

    sync_edge u_sync_ioup (.clk(clk), .rst_n(rst_n), .d(io_update),    .rise(io_upd));
    sync_edge u_sync_start(.clk(clk), .rst_n(rst_n), .d(start),        .rise(start_s));
    sync_edge u_sync_sync (.clk(clk), .rst_n(rst_n), .d(sync_in),      .rise(sync_s));
    sync_edge u_sync_ftrig(.clk(clk), .rst_n(rst_n), .d(freq_trigger), .rise(freq_trigger_s));
    sync_edge u_sync_atrig(.clk(clk), .rst_n(rst_n), .d(amp_trigger),  .rise(amp_trigger_s));

    // ================================================================
    //  Start / sync delay chain (2 stages)
    //
    //  Commit registers add 1 cycle to the io_update → active path.
    //  start_d and sync_d need 2 cycles of delay (was 1) so that
    //  config is latched before start/sync when both arrive on the
    //  same external edge.
    //
    //  Timeline (same external edge):
    //    T+3: io_upd fires, start_s fires, sync_s fires
    //    T+4: commit regs capture io_upd → active config latches
    //          start_d1 = start_s, sync_d1 = sync_s
    //    T+5: start_d fires → freq_ctrl sees new config ✓
    //          sync_d fires → phase_accum resets ✓
    // ================================================================
    logic start_d1, start_d;
    logic sync_d1,  sync_d;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_d1 <= 1'b0;
            start_d  <= 1'b0;
            sync_d1  <= 1'b0;
            sync_d   <= 1'b0;
        end else begin
            start_d1 <= start_s;
            start_d  <= start_d1;
            sync_d1  <= sync_s;
            sync_d   <= sync_d1;
        end
    end

    // ================================================================
    //  CDC: data pins — double-registered for metastability
    // ================================================================
    logic [SYM_W-1:0] amp_idx_meta, amp_idx_r;
    logic [SYM_W-1:0] pow_sel_meta, pow_sel_r;
    logic              freq_sel_meta, freq_sel_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            amp_idx_meta  <= '0;
            amp_idx_r     <= '0;
            pow_sel_meta  <= '0;
            pow_sel_r     <= '0;
            freq_sel_meta <= 1'b0;
            freq_sel_r    <= 1'b0;
        end else begin
            amp_idx_meta  <= amp_idx;
            amp_idx_r     <= amp_idx_meta;
            pow_sel_meta  <= pow_sel;
            pow_sel_r     <= pow_sel_meta;
            freq_sel_meta <= freq_sel;
            freq_sel_r    <= freq_sel_meta;
        end
    end

    // ================================================================
    //  Per-block commit registers
    //
    //  io_upd fans out to 4 FFs only.  Each commit fans out to its
    //  own block's active registers (~56-64 flops each).
    // ================================================================
    logic freq_commit, chirp_commit, pow_commit, amp_commit;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            freq_commit  <= 1'b0;
            chirp_commit <= 1'b0;
            pow_commit   <= 1'b0;
            amp_commit   <= 1'b0;
        end else begin
            freq_commit  <= io_upd && !chirp_active;
            chirp_commit <= io_upd && !chirp_active;
            pow_commit   <= io_upd;
            amp_commit   <= io_upd;
        end
    end

    // ================================================================
    //  Active registers — freq (FTW_A, FTW_B)
    // ================================================================
    logic [PHASE_W-1:0] act_ftw_a, act_ftw_b;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            act_ftw_a <= '0;
            act_ftw_b <= '0;
        end else if (freq_commit) begin
            act_ftw_a <= rf_ftw_a;
            act_ftw_b <= rf_ftw_b;
        end
    end

    // ================================================================
    //  Active registers — chirp (step, N, mode, flags)
    // ================================================================
    logic [PHASE_W-1:0] act_chirp_step;
    logic [PHASE_W-1:0] act_neg_chirp_step;
    logic [COUNT_W-1:0] act_chirp_n;
    logic               act_chirp_n_valid;
    logic [1:0]         act_mode;
    logic               act_auto_restart;
    logic               act_phase_rst_on_start;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            act_chirp_step         <= '0;
            act_neg_chirp_step     <= '0;
            act_chirp_n            <= '0;
            act_chirp_n_valid      <= 1'b0;
            act_mode               <= 2'd0;
            act_auto_restart       <= 1'b0;
            act_phase_rst_on_start <= 1'b0;
        end else if (chirp_commit) begin
            act_chirp_step         <= rf_chirp_step;
            act_neg_chirp_step     <= -rf_chirp_step;
            act_chirp_n            <= rf_chirp_n;
            act_chirp_n_valid      <= (rf_chirp_n != {COUNT_W{1'b0}});
            act_mode               <= rf_mode;
            act_auto_restart       <= rf_auto_restart;
            act_phase_rst_on_start <= rf_phase_rst_on_start;
        end
    end

    // ================================================================
    //  Active registers — POW (phase offset bank)
    // ================================================================
    logic [15:0] act_pow_0, act_pow_1, act_pow_2, act_pow_3;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            act_pow_0 <= 16'h0;
            act_pow_1 <= 16'h0;
            act_pow_2 <= 16'h0;
            act_pow_3 <= 16'h0;
        end else if (pow_commit) begin
            act_pow_0 <= rf_pow_0;
            act_pow_1 <= rf_pow_1;
            act_pow_2 <= rf_pow_2;
            act_pow_3 <= rf_pow_3;
        end
    end

    // ================================================================
    //  Active registers — AMP (amplitude bank)
    // ================================================================
    logic [15:0] act_amp_0, act_amp_1, act_amp_2, act_amp_3;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            act_amp_0 <= 16'hFFFF;
            act_amp_1 <= 16'hFFFF;
            act_amp_2 <= 16'hFFFF;
            act_amp_3 <= 16'hFFFF;
        end else if (amp_commit) begin
            act_amp_0 <= rf_amp_0;
            act_amp_1 <= rf_amp_1;
            act_amp_2 <= rf_amp_2;
            act_amp_3 <= rf_amp_3;
        end
    end

    // ================================================================
    //  Frequency control
    // ================================================================
    logic [PHASE_W-1:0] delta_phase;
    logic [PHASE_W-1:0] fc_dp_s, fc_dp_c;
    logic               chirp_done_raw;

    freq_ctrl #(
        .PHASE_W (PHASE_W),
        .COUNT_W (COUNT_W)
    ) u_freq (
        .clk          (clk),
        .rst_n        (rst_n),
        .ftw_a        (act_ftw_a),
        .ftw_b        (act_ftw_b),
        .chirp_step   (act_chirp_step),
        .neg_chirp_step(act_neg_chirp_step),
        .chirp_n      (act_chirp_n),
        .chirp_n_valid(act_chirp_n_valid),
        .mode         (act_mode),
        .auto_restart (act_auto_restart),
        .start        (start_d),
        .trigger      (freq_trigger_s),
        .freq_sel     (freq_sel_r),
        .sync_reset   (sync_d),
        .dp_s         (fc_dp_s),
        .dp_c         (fc_dp_c),
        .delta_phase  (delta_phase),
        .chirp_active (chirp_active),
        .chirp_done   (chirp_done_raw)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            chirp_done_sticky <= 1'b0;
        end else begin
            if (start_d || sync_d)
                chirp_done_sticky <= 1'b0;
            else if (chirp_done_raw)
                chirp_done_sticky <= 1'b1;
        end
    end

    assign chirp_done = chirp_done_raw;

    // ================================================================
    //  Phase accumulator — 4:2 CSA, redundant {dp_s, dp_c} input
    // ================================================================
    logic [PHASE_W-1:0] phi_s, phi_c;
    logic phase_reset;

    assign phase_reset = sync_d || (start_d && act_phase_rst_on_start);
    phase_accum #(.PHASE_W(PHASE_W)) u_accum (
        .clk         (clk),
        .rst_n       (rst_n),
        .dp_s        (fc_dp_s),
        .dp_c        (fc_dp_c),
        .phase_reset (phase_reset),
        .phi_s       (phi_s),
        .phi_c       (phi_c)
    );

    // ================================================================
    //  POW bank: extract top TRUNC_W bits from 16-bit registers
    // ================================================================
    localparam POW_DEPTH = 1 << SYM_W;
    logic [POW_DEPTH*TRUNC_W-1:0] pow_bank_trunc;

    assign pow_bank_trunc = {
        act_pow_3[15 -: TRUNC_W],
        act_pow_2[15 -: TRUNC_W],
        act_pow_1[15 -: TRUNC_W],
        act_pow_0[15 -: TRUNC_W]
    };

    // ================================================================
    //  DDS datapath
    // ================================================================
    dds_datapath #(
        .PHASE_W     (PHASE_W),
        .TRUNC_W     (TRUNC_W),
        .UNARY_BITS  (UNARY_BITS),
        .BINARY_BITS (BINARY_BITS),
        .SYM_W       (SYM_W)
    ) u_dp (
        .clk         (clk),
        .rst_n       (rst_n),
        .phi_s       (phi_s),
        .phi_c       (phi_c),
        .pow_bank    (pow_bank_trunc),
        .pow_sel     (pow_sel_r),
        .amp_bank    ({act_amp_3, act_amp_2, act_amp_1, act_amp_0}),
        .amp_idx     (amp_idx_r),
        .amp_trigger (amp_trigger_s),
        .dac_i       (dac_i),
        .dac_q       (dac_q)
    );

endmodule
