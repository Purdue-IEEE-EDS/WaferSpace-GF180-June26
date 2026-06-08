`default_nettype none
`timescale 1ns/1ps

(* keep_hierarchy = "yes" *)
module serializer_4to1 #(
    parameter int WORD_W = 36
)(
    input  logic                    clk_ser,
    input  logic                    rst_n,

    input  logic [3:0][WORD_W-1:0]  din_vec,

    output logic [WORD_W-1:0]       dout,
    output logic [1:0]              ser_lane,
    output logic                    vec_load
);

    logic wrap_now;
    logic load_blk;

    assign wrap_now = (ser_lane == 2'd3);
    assign vec_load = load_blk;

    // Only reset the tiny global control state.
    always_ff @(posedge clk_ser) begin
        if (!rst_n) begin
            ser_lane <= 2'd0;
            load_blk <= 1'b1;
        end else begin
            ser_lane <= ser_lane + 2'd1;
            load_blk <= wrap_now;
        end
    end

    genvar i;
    generate
        for (i = 0; i < WORD_W; i++) begin : g_ser_bit
            (* keep_hierarchy = "yes" *)
            serializer_4to1_bit u_bit (
                .clk_ser  (clk_ser),
                .wrap_now (wrap_now),

                .din0     (din_vec[0][i]),
                .din1     (din_vec[1][i]),
                .din2     (din_vec[2][i]),
                .din3     (din_vec[3][i]),

                .dout     (dout[i])
            );
        end
    endgenerate

endmodule

// One physical serializer bit.
// No reset here: avoids high-fanout synchronous reset paths into every bit slice.
(* keep_hierarchy = "yes" *)
module serializer_4to1_bit (
    input  logic clk_ser,

    input  logic wrap_now,

    input  logic din0,
    input  logic din1,
    input  logic din2,
    input  logic din3,

    output logic dout
);

    logic sh1;
    logic sh2;
    logic sh3;

    // Local per-bit registered selects.
    // Do not reset these; they settle from wrap_now after reset release.
    (* keep = "true", dont_touch = "true" *) logic load_dout_i;
    (* keep = "true", dont_touch = "true" *) logic load_sh1_i;
    (* keep = "true", dont_touch = "true" *) logic load_sh2_i;
    (* keep = "true", dont_touch = "true" *) logic load_sh3_i;

    always_ff @(posedge clk_ser) begin
        // Current lane 3 means next cycle is lane 0/load.
        load_dout_i <= wrap_now;
        load_sh1_i  <= wrap_now;
        load_sh2_i  <= wrap_now;
        load_sh3_i  <= wrap_now;
    end

    always_ff @(posedge clk_ser) begin
        dout <= load_dout_i ? din0 : sh1;
        sh1  <= load_sh1_i  ? din1 : sh2;
        sh2  <= load_sh2_i  ? din2 : sh3;
        sh3  <= load_sh3_i  ? din3 : 1'b0;
    end

endmodule

`default_nettype wire
