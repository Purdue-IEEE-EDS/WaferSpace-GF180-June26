`default_nettype none
`timescale 1ns/1ps

//  2-FF synchroniser + rising-edge detect

module sync_edge (
    input  logic clk,
    input  logic rst_n,
    input  logic d,
    output logic rise
);

    logic [2:0] sync_pipe;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) sync_pipe <= 3'd0;
        else        sync_pipe <= {sync_pipe[1:0], d};
    end

    assign rise = sync_pipe[1] & ~sync_pipe[2];

endmodule
