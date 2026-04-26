`default_nettype none

module stage #(
    parameter BITS = 16,
    parameter DECIMAL = 8,
    parameter STAGES = 3,
    parameter CURR_STAGE = 1
)(
    input  logic clk,
    input  logic rst,
    input  logic [STAGES-CURR_STAGE:0] count,
    input  logic [BITS-1:0] in_real,
    input  logic [BITS-1:0] in_imag,
    output logic [BITS-1:0] out_real,
    output logic [BITS-1:0] out_imag
);

    logic signed [2*BITS-1:0] in, buf_out;

    assign in = {in_real, in_imag};

    buffer #(
        .BITS(BITS),
        .STAGES(STAGES),
        .CURR_STAGE(CURR_STAGE)
    ) delay (
        .clk(clk),
        .rst(rst),
        .in_data(in),
        .out_data(buf_out)
    );

    logic signed [2*BITS-1:0] bf_a, bf_b;

    r2 #(.BITS(BITS)) butterfly (
        .clk(clk),
        .rst(rst),
        .a_in(buf_out),
        .b_in(in),
        .a_out(bf_a),
        .b_out(bf_b)
    );

    logic signed [2*BITS-1:0] bf_reg;

    always_ff @(posedge clk) begin
        if (!rst)
            bf_reg <= '0;
        else
            bf_reg <= bf_a;   // selected path pre-multiplier stage
    end

    logic signed [2*BITS-1:0] rot_out;
    logic signed [2*BITS-1:0] twiddle;

    logic [7:0] addr;
    assign addr = (count) << (CURR_STAGE-1);

    twiddle_rom twid_rom (
        .clk(clk),
        .rst(rst),
        .address(addr),
        .real_out(twiddle[2*BITS-1:BITS]),
        .imag_out(twiddle[BITS-1:0])
    );


    rotator #(.BITS(32), .DECIMAL(12)) rot (
        .clk(clk),
        .rst(rst),
        .data_in(bf_reg),
        .twiddle(twiddle),
        .data_out(rot_out)
    );

    logic mode;
    assign mode = count[STAGES-CURR_STAGE];

    logic signed [2*BITS-1:0] stage_out;

    always_ff @(posedge clk) begin
        if (!rst)
            stage_out <= '0;
        else
            stage_out <= mode ? rot_out : bf_b;
    end

    assign out_real = stage_out[2*BITS-1:BITS];
    assign out_imag = stage_out[BITS-1:0];

endmodule
