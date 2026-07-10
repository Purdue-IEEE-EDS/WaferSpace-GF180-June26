`default_nettype none
`timescale 1ns/1ps

// Serial scan wrapper for the calibration-DAC chain.
//
// frame_data[(n*CELL_W) +: CELL_W] is the target code for cell n.
// A start pulse emits one full frame on the 3-wire scan pins as:
//   cell N_CELLS-1 first ... cell 0 last, LSB-first within each cell word.
// After N_CELLS*CELL_W shift pulses, cal_load is pulsed to commit all cells.
module cal_dac_scan #(
    parameter integer N_CELLS      = 1,
    parameter integer CELL_W       = 4,
    parameter integer SHIFT_CYCLES = 3,
    parameter [CELL_W-1:0] RESET_CODE = {1'b1, {(CELL_W-1){1'b0}}}
) (
    input  logic                      clk,
    input  logic                      rst_n,
    input  logic                      start,
    input  logic [N_CELLS*CELL_W-1:0] frame_data,
    output logic                      busy,
    output logic                      cal_clk,
    output logic                      cal_data,
    output logic                      cal_load,
    output logic [N_CELLS*CELL_W-1:0] dac_code
);

    localparam integer TOTAL_W    = N_CELLS * CELL_W;
    localparam integer WAIT_W     = (SHIFT_CYCLES <= 1) ? 1 : $clog2(SHIFT_CYCLES);
    localparam integer START_BIT  = (N_CELLS - 1) * CELL_W;
    localparam integer SHIFT_IDX_W = (TOTAL_W <= 1) ? 1 : $clog2(TOTAL_W);

    typedef enum logic [3:0] {
        ST_IDLE,
        ST_SHIFT_WAIT,
        ST_SHIFT_PULSE,
        ST_SHIFT_HOLD,
        ST_SHIFT_ADVANCE,
        ST_LOAD_WAIT_0,
        ST_LOAD_WAIT_1,
        ST_LOAD_PULSE_0,
        ST_LOAD_PULSE_1
    } state_t;

    state_t state;

    logic [TOTAL_W-1:0]    scan_load_word;
    logic [TOTAL_W-1:0]    scan_shift;
    logic [SHIFT_IDX_W-1:0] shift_idx;
    logic [WAIT_W-1:0]     wait_cnt;

    assign busy = (state != ST_IDLE);

    genvar load_cell;
    genvar load_bit;
    generate
        for (load_cell = 0; load_cell < N_CELLS; load_cell = load_cell + 1) begin : g_scan_cell
            for (load_bit = 0; load_bit < CELL_W; load_bit = load_bit + 1) begin : g_scan_bit
                localparam integer DST = (load_cell * CELL_W) + load_bit;
                localparam integer SRC = ((N_CELLS - 1 - load_cell) * CELL_W) + load_bit;
                assign scan_load_word[DST] = frame_data[SRC];
            end
        end
    endgenerate

    cal_dac_chain #(
        .N_CELLS    (N_CELLS),
        .CELL_W     (CELL_W),
        .RESET_CODE (RESET_CODE)
    ) u_chain (
        .rst_n      (rst_n),
        .cal_clk    (cal_clk),
        .load       (cal_load),
        .serial_in  (cal_data),
        .serial_out (),
        .dac_code   (dac_code)
    );

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state         <= ST_IDLE;
            shift_idx     <= '0;
            scan_shift    <= '0;
            wait_cnt      <= '0;
            cal_clk       <= 1'b0;
            cal_load      <= 1'b0;
            cal_data      <= 1'b0;
        end else begin
            cal_clk <= 1'b0;
            cal_load <= 1'b0;

            case (state)
                ST_IDLE: begin
                    wait_cnt <= '0;
                    if (start) begin
                        shift_idx     <= '0;
                        scan_shift    <= {1'b0, scan_load_word[TOTAL_W-1:1]};
                        cal_data      <= frame_data[START_BIT];
                        state         <= ST_SHIFT_WAIT;
                    end
                end

                ST_SHIFT_WAIT: begin
                    if (wait_cnt == WAIT_W'(SHIFT_CYCLES - 1)) begin
                        wait_cnt <= '0;
                        state    <= ST_SHIFT_PULSE;
                    end else begin
                        wait_cnt <= wait_cnt + WAIT_W'(1);
                    end
                end

                ST_SHIFT_PULSE: begin
                    cal_clk <= 1'b1;
                    if (shift_idx == SHIFT_IDX_W'(TOTAL_W - 1)) begin
                        state <= ST_LOAD_WAIT_0;
                    end else begin
                        state <= ST_SHIFT_HOLD;
                    end
                end

                ST_SHIFT_HOLD: begin
                    state <= ST_SHIFT_ADVANCE;
                end

                ST_SHIFT_ADVANCE: begin
                    wait_cnt   <= '0;
                    shift_idx  <= shift_idx + SHIFT_IDX_W'(1);
                    cal_data   <= scan_shift[0];
                    scan_shift <= {1'b0, scan_shift[TOTAL_W-1:1]};
                    state      <= ST_SHIFT_WAIT;
                end

                ST_LOAD_WAIT_0: begin
                    state <= ST_LOAD_WAIT_1;
                end

                ST_LOAD_WAIT_1: begin
                    state <= ST_LOAD_PULSE_0;
                end

                ST_LOAD_PULSE_0: begin
                    cal_load <= 1'b1;
                    state <= ST_LOAD_PULSE_1;
                end

                ST_LOAD_PULSE_1: begin
                    cal_load <= 1'b1;
                    state <= ST_IDLE;
                end

                default: state <= ST_IDLE;
            endcase
        end
    end

endmodule

`default_nettype wire
