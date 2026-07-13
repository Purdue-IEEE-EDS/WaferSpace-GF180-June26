`default_nettype none
`timescale 1ns/1ps

//  2-FF reset synchronizer
//  Asserts asynchronously, deasserts synchronously to clk

module reset_sync (
    input  logic clk,
    input  logic arst_n,
    output logic srst_n
);

    logic sync_ff1;

    always_ff @(posedge clk or negedge arst_n) begin
        if (!arst_n) begin
            sync_ff1 <= 1'b0;
            srst_n   <= 1'b0;
        end else begin
            sync_ff1 <= 1'b1;
            srst_n   <= sync_ff1;
        end
    end

endmodule
