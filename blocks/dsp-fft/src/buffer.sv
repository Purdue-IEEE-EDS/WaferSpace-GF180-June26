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

    localparam BUFF_BITS   = STAGES - CURR_STAGE;
    localparam BUFFER_SIZE  = (BUFF_BITS <= 0) ? 1 : (1 << BUFF_BITS);

    logic signed [2*BITS-1:0] buff_reg [0:BUFFER_SIZE-1];

    integer i;

    assign out_data = buff_reg[BUFFER_SIZE-1];

    always_ff @(posedge clk) begin
        if (!rst) begin
            for (i = 0; i < BUFFER_SIZE; i++) begin
                buff_reg[i] <= '0;
            end
        end
        else begin
            for (i = BUFFER_SIZE-1; i > 0; i--) begin
                buff_reg[i] <= buff_reg[i-1];
            end
            buff_reg[0] <= in_data;
        end
    end

endmodule
