`default_nettype none

module buffer #(
    parameter BITS = 16,
    parameter STAGES = 8,
    parameter CURR_STAGE = 1
)(
    input  logic clk,
    input  logic rst,
    input  logic signed [2*BITS-1:0] in_data,
    output logic signed [2*BITS-1:0] out_data
);

    localparam int BUFFER_SIZE = (1 << (STAGES - CURR_STAGE));

    logic signed [2*BITS-1:0] mem [0:BUFFER_SIZE-1];

    integer i;

    always_ff @(posedge clk) begin
        if (!rst) begin
            for (i = 0; i < BUFFER_SIZE; i++)
                mem[i] <= '0;
        end else begin
            mem[0] <= in_data;
            for (i = 1; i < BUFFER_SIZE; i++)
                mem[i] <= mem[i-1];
        end
    end

    always_ff @(posedge clk) begin
        if (!rst)
            out_data <= '0;
        else
            out_data <= mem[BUFFER_SIZE-1];
    end

endmodule
