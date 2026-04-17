`default_nettype none

module buffer #(parameter BITS = 16, parameter STAGES=8, parameter CURR_STAGE=1)
(
    input logic clk, rst,
    input logic signed [2*BITS-1:0] in_data,
    output logic signed [2*BITS-1:0] out_data 
);

    localparam BUFF_BITS = STAGES - CURR_STAGE;
    localparam BUFFER_SIZE = (1 << BUFF_BITS);

    logic signed [BUFFER_SIZE-1:0] [2*BITS-1:0] buff_reg;

    assign out_data = buff_reg[BUFFER_SIZE-1];

    always_ff @(posedge clk) begin
        if (!rst) begin
            buff_reg <= '0;
            //out_data <= '0;
        end else begin
            if (BUFFER_SIZE > 1) buff_reg <= {buff_reg[BUFFER_SIZE-2:0], in_data};
            else buff_reg <= in_data;
            //out_data <= buff_reg[BUFFER_SIZE-1];
        end
    end
endmodule