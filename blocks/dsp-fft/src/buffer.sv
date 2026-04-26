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

    generate
        if (CURR_STAGE == STAGES) begin 
            assign out_data = in_data; 
        end 
        else if (CURR_STAGE == (STAGES-1)) begin
            always_ff @(posedge clk) begin 
                out_data <= in_data; 
            end
        end
        else 

        end
    endgenerate
endmodule