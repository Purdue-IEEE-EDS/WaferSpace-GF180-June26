module delay #(
    parameter int WIDTH = 1,
    parameter int DEPTH = 1
)(
    input  logic clk,
    input  logic rst,
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);

    logic [WIDTH-1:0] pipe [0:DEPTH-1];

    always_ff @(posedge clk or negedge rst) begin
        if (!rst) begin
            for (int i = 0; i < DEPTH; i++) pipe[i] <= '0;
        end else begin
            pipe[0] <= in;
            for (int i = 1; i < DEPTH; i++)
                pipe[i] <= pipe[i-1];
        end
    end

    assign out = pipe[DEPTH-1];

endmodule