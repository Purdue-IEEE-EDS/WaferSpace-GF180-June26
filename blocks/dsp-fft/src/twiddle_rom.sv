module twiddle_rom #(
    parameter int BITS = 16,
    parameter int DEPTH = 16,
    parameter int ADDR_W = $clog2(DEPTH)
)(
    input  logic clk, rst, 
    input logic en, 
    input  logic [ADDR_W-1:0] addr,
    output logic signed [BITS-1:0] tw_re,
    output logic signed [BITS-1:0] tw_im
);

    logic signed [2*BITS-1:0] rom [0:DEPTH-1];

    // optional init (file or generate block)
    initial begin
        case (DEPTH) 
            4 : $readmemh("twiddle4.mem", rom);
            8 : $readmemh("twiddle8.mem", rom);
            16 : $readmemh("twiddle16.mem", rom);
            32 : $readmemh("twiddle32.mem", rom);
            64 : $readmemh("twiddle64.mem", rom);
            128 : $readmemh("twiddle128.mem", rom);
        endcase
    end

    always_ff @(posedge clk, negedge rst) begin
        if (!rst) begin 
            {tw_re, tw_im} <= '0; 
        end else begin 
            {tw_re, tw_im} <= en ? 32'h1000000 : rom[addr];
        end
    end
endmodule