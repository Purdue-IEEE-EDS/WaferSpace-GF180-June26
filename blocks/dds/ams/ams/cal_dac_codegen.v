`default_nettype none
`timescale 1ns/1ps

/* verilator lint_off WIDTHEXPAND */
`include "rtl/cal_dac/cal_dac_chain.v"
`include "rtl/cal_dac/cal_dac_scan.v"
/* verilator lint_on WIDTHEXPAND */

module cal_dac_codegen #(
    parameter integer N_CELLS      = 2,
    parameter integer CELL_W       = 4,
    parameter integer SHIFT_CYCLES = 3,
    parameter integer RESET_LOW_CYCLES  = 2,
    parameter integer RESET_IDLE_CYCLES = 4,
    parameter integer HOLD_CYCLES  = 1,
    parameter [CELL_W-1:0] RESET_CODE = {1'b1, {(CELL_W-1){1'b0}}}
) (
    input  wire clk,
    output wire sclk,
    output wire data,
    output wire load
);

    localparam integer TOTAL_W = N_CELLS * CELL_W;
    localparam integer RESET_LOW_W  = (RESET_LOW_CYCLES  <= 1) ? 1 : $clog2(RESET_LOW_CYCLES  + 1);
    localparam integer RESET_IDLE_W = (RESET_IDLE_CYCLES <= 1) ? 1 : $clog2(RESET_IDLE_CYCLES + 1);
    localparam integer HOLD_W       = (HOLD_CYCLES       <= 1) ? 1 : $clog2(HOLD_CYCLES       + 1);
    localparam logic [CELL_W-1:0] CODE_MIN = {CELL_W{1'b0}};
    localparam logic [CELL_W-1:0] CODE_MAX = {CELL_W{1'b1}};
    localparam logic [CELL_W-1:0] CODE_MID = {1'b1, {(CELL_W-1){1'b0}}};

    function automatic logic [CELL_W-1:0] sine_code(input logic [4:0] idx);
        begin
            // 32-point sine table scaled down from the 6-bit DAC pattern.
            case (idx)
                5'd0:  sine_code = 4'd8;
                5'd1:  sine_code = 4'd9;
                5'd2:  sine_code = 4'd11;
                5'd3:  sine_code = 4'd12;
                5'd4:  sine_code = 4'd13;
                5'd5:  sine_code = 4'd14;
                5'd6:  sine_code = 4'd15;
                5'd7:  sine_code = 4'd15;
                5'd8:  sine_code = 4'd15;
                5'd9:  sine_code = 4'd15;
                5'd10: sine_code = 4'd15;
                5'd11: sine_code = 4'd14;
                5'd12: sine_code = 4'd13;
                5'd13: sine_code = 4'd12;
                5'd14: sine_code = 4'd11;
                5'd15: sine_code = 4'd9;
                5'd16: sine_code = 4'd8;
                5'd17: sine_code = 4'd6;
                5'd18: sine_code = 4'd5;
                5'd19: sine_code = 4'd3;
                5'd20: sine_code = 4'd2;
                5'd21: sine_code = 4'd1;
                5'd22: sine_code = 4'd0;
                5'd23: sine_code = 4'd0;
                5'd24: sine_code = 4'd0;
                5'd25: sine_code = 4'd0;
                5'd26: sine_code = 4'd0;
                5'd27: sine_code = 4'd1;
                5'd28: sine_code = 4'd2;
                5'd29: sine_code = 4'd3;
                5'd30: sine_code = 4'd5;
                5'd31: sine_code = 4'd6;
                default: sine_code = CODE_MID;
            endcase
        end
    endfunction

    function automatic logic [CELL_W-1:0] triangle_code(input logic [4:0] idx);
        begin
            triangle_code = idx[4] ? ~idx[3:0] : idx[3:0];
        end
    endfunction

    function automatic logic [CELL_W-1:0] toggle_code(input logic sample_sel);
        begin
            toggle_code = sample_sel ? CODE_MAX : CODE_MIN;
        end
    endfunction

    typedef enum logic [2:0] {
        ST_RESET_LOW,
        ST_RESET_IDLE,
        ST_ISSUE,
        ST_WAIT_BUSY_HIGH,
        ST_WAIT_BUSY_LOW,
        ST_HOLD
    } runner_state_t;

    logic rst_n = 1'b0;
    logic start = 1'b0;
    logic [TOTAL_W-1:0] frame_data = {N_CELLS{CODE_MIN}};
    logic busy;
    logic [TOTAL_W-1:0] dac_code;
    logic scan_cal_clk;
    logic scan_cal_data;
    logic scan_cal_load;
    runner_state_t runner_state = ST_RESET_LOW;
    logic [CELL_W-1:0] current_code = CODE_MID;
    logic [4:0] phase = 5'd0;
    logic [7:0] sample_count = 8'd0;
    logic [1:0] mode = 2'd0;
    logic [RESET_LOW_W-1:0]  reset_low_count = '0;
    logic [RESET_IDLE_W-1:0] reset_idle_count = '0;
    logic [HOLD_W-1:0]       hold_count = '0;

    cal_dac_scan #(
        .N_CELLS      (N_CELLS),
        .CELL_W       (CELL_W),
        .SHIFT_CYCLES (SHIFT_CYCLES),
        .RESET_CODE   (RESET_CODE)
    ) dut (
        .clk       (clk),
        .rst_n     (rst_n),
        .start     (start),
        .frame_data(frame_data),
        .busy      (busy),
        .cal_clk   (scan_cal_clk),
        .cal_data  (scan_cal_data),
        .cal_load  (scan_cal_load),
        .dac_code  (dac_code)
    );

    assign sclk = scan_cal_clk;
    assign data = scan_cal_data;
    assign load = scan_cal_load;

    always_ff @(posedge clk) begin
        start <= 1'b0;

        case (runner_state)
            ST_RESET_LOW: begin
                rst_n      <= 1'b0;
                frame_data <= {N_CELLS{CODE_MIN}};
                current_code <= triangle_code(5'd0);
                phase      <= 5'd0;
                sample_count <= 8'd0;
                mode       <= 2'd0;
                hold_count <= '0;
                if (reset_low_count == RESET_LOW_W'(RESET_LOW_CYCLES - 1)) begin
                    reset_low_count  <= '0;
                    reset_idle_count <= '0;
                    rst_n            <= 1'b1;
                    runner_state     <= ST_RESET_IDLE;
                end else begin
                    reset_low_count <= reset_low_count + RESET_LOW_W'(1);
                end
            end

            ST_RESET_IDLE: begin
                if (reset_idle_count == RESET_IDLE_W'(RESET_IDLE_CYCLES - 1)) begin
                    reset_idle_count <= '0;
                    runner_state     <= ST_ISSUE;
                end else begin
                    reset_idle_count <= reset_idle_count + RESET_IDLE_W'(1);
                end
            end

            ST_ISSUE: begin
                frame_data    <= {N_CELLS{current_code}};
                start        <= 1'b1;
                runner_state <= ST_WAIT_BUSY_HIGH;
            end

            ST_WAIT_BUSY_HIGH: begin
                if (busy)
                    runner_state <= ST_WAIT_BUSY_LOW;
            end

            ST_WAIT_BUSY_LOW: begin
                if (!busy) begin
                    hold_count   <= '0;
                    runner_state <= ST_HOLD;
                end
            end

            ST_HOLD: begin
                if (hold_count == HOLD_W'(HOLD_CYCLES - 1)) begin
                    hold_count <= '0;
                    case (mode)
                        2'd0: begin
                            if (sample_count == 8'd31) begin
                                mode         <= 2'd1;
                                sample_count <= 8'd0;
                                phase        <= 5'd0;
                                current_code <= sine_code(5'd0);
                            end else begin
                                sample_count <= sample_count + 8'd1;
                                current_code <= triangle_code(sample_count[4:0] + 5'd1);
                            end
                        end

                        2'd1: begin
                            if (sample_count == 8'd127) begin
                                mode         <= 2'd2;
                                sample_count <= 8'd0;
                                current_code <= toggle_code(1'b0);
                            end else begin
                                phase        <= phase + 5'd1;
                                sample_count <= sample_count + 8'd1;
                                current_code <= sine_code(phase + 5'd1);
                            end
                        end

                        2'd2: begin
                            if (sample_count == 8'd31) begin
                                mode         <= 2'd3;
                                sample_count <= 8'd0;
                                current_code <= CODE_MID;
                            end else begin
                                sample_count <= sample_count + 8'd1;
                                current_code <= toggle_code(~sample_count[0]);
                            end
                        end

                        default: begin
                            current_code <= CODE_MID;
                        end
                    endcase
                    runner_state <= ST_ISSUE;
                end else begin
                    hold_count <= hold_count + HOLD_W'(1);
                end
            end

            default: begin
                frame_data <= {N_CELLS{current_code}};
                rst_n      <= 1'b1;
                start      <= 1'b0;
            end
        endcase
    end

endmodule

`default_nettype wire
