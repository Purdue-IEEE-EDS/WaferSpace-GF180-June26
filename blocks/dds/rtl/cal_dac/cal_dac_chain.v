`default_nettype none
`timescale 1ns/1ps

module cal_dac_cell #(
    parameter integer CELL_W = 4,
    parameter [CELL_W-1:0] RESET_CODE = {1'b1, {(CELL_W-1){1'b0}}}
) (
    input  logic              rst_n,
    input  logic              cal_clk,
    input  logic              load,
    input  logic              serial_in,
    output logic              serial_out,
    output logic [CELL_W-1:0] dac_code
);

    logic [CELL_W-1:0] shift_reg;

    // Two-stage storage model:
    //   - shift_reg shifts serial scan data on cal_clk
    //   - dac_code updates only on load and represents the cell's applied trim
    always_ff @(posedge cal_clk or negedge rst_n) begin
        if (!rst_n)
            shift_reg <= RESET_CODE;
        else
            shift_reg <= {serial_in, shift_reg[CELL_W-1:1]};
    end

    always_ff @(posedge load or negedge rst_n) begin
        if (!rst_n)
            dac_code <= RESET_CODE;
        else
            dac_code <= shift_reg;
    end

    assign serial_out = shift_reg[0];

endmodule

// cal_dac_chain
//
// Daisy-chain of N_CELLS calibration-DAC islands sharing the same
// serial_in, cal_clk, and load pins. cell 0 is closest to serial_in;
// cell N_CELLS-1 is closest to serial_out.
//
// To load a full frame, shift words for cells N_CELLS-1 down to 0,
// each word LSB-first, then pulse load.
//
// This is intentionally a 3-wire serial interface, not a parallel
// 4*N_CELLS top-level route bundle. The wide dac_code bus is only the
// internal/behavioral view of the per-cell trim state after load.
module cal_dac_chain #(
    parameter integer N_CELLS = 1,
    parameter integer CELL_W  = 4,
    parameter [CELL_W-1:0] RESET_CODE = {1'b1, {(CELL_W-1){1'b0}}}
) (
    input  logic                        rst_n,
    input  logic                        cal_clk,
    input  logic                        load,
    input  logic                        serial_in,
    output logic                        serial_out,
    output logic [N_CELLS*CELL_W-1:0]   dac_code
);

    logic [N_CELLS:0] serial_link;

    assign serial_link[0] = serial_in;
    assign serial_out     = serial_link[N_CELLS];

    genvar g;
    generate
        for (g = 0; g < N_CELLS; g = g + 1) begin : gen_cells
            cal_dac_cell #(
                .CELL_W     (CELL_W),
                .RESET_CODE (RESET_CODE)
            ) u_cell (
                .rst_n      (rst_n),
                .cal_clk    (cal_clk),
                .load       (load),
                .serial_in  (serial_link[g]),
                .serial_out (serial_link[g+1]),
                .dac_code   (dac_code[(g*CELL_W) +: CELL_W])
            );
        end
    endgenerate

endmodule

`default_nettype wire
