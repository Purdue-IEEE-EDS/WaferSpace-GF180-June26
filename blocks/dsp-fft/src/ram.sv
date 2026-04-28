module ram #(
    parameter WIDTH = 32,
    parameter DEPTH = 128,
    parameter ADDR_W = $clog2(DEPTH)
)(
    input  logic clk,
    input  logic we,
    input  logic [ADDR_W-1:0] waddr,
    input  logic [ADDR_W-1:0] raddr,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout
);

    logic [WIDTH-1:0] mem [0:DEPTH-1];

    // WRITE
    always_ff @(posedge clk) begin
        if (we)
            mem[waddr] <= din;
    end

    // READ (REGISTERED OUTPUT → IMPORTANT for timing)
    always_ff @(posedge clk) begin
        dout <= mem[raddr];
    end

endmodule