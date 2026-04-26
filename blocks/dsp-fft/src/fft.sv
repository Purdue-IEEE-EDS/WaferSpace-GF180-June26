`default_nettype none

module fft #(
    parameter BITS = 32,
    parameter DECIMAL = 12
)(
    input  logic clk,
    input  logic rst,

    input  logic signed [BITS-1:0] in_real,
    input  logic signed [BITS-1:0] in_imag,

    output logic signed [BITS-1:0] out_real,
    output logic signed [BITS-1:0] out_imag,

    output logic [8:0] count_out
);

    logic signed [BITS-1:0] in_r  [0:8];
    logic signed [BITS-1:0] in_i  [0:8];

    logic signed [BITS-1:0] out_r [0:8];
    logic signed [BITS-1:0] out_i [0:8];

    logic [8:0] count_buf [0:541];

    assign in_r[0] = in_real;
    assign in_i[0] = in_imag;

    assign out_real = out_r[8];
    assign out_imag = out_i[8];

    assign count_out = count_buf[541];

    integer j;

    always_ff @(posedge clk) begin
        if (!rst) begin
            for (j = 0; j < 542; j++) begin
                count_buf[j] <= '0;
            end
        end
        else begin
            for (j = 541; j > 0; j--) begin
                count_buf[j] <= count_buf[j-1];
            end
            count_buf[0] <= count_buf[0] + 1;
        end
    end

    genvar i;

    generate
        for (i = 0; i < 9; i++) begin : gen_stages

            localparam [8:0] MASK  = (9'h1ff << (9-i));
            localparam int DELAY   = (i < 8) ? (MASK + 4*i) : (MASK + 28);

            stage #(
                .BITS(BITS),
                .DECIMAL(DECIMAL),
                .STAGES(9),
                .CURR_STAGE(i+1)
            ) st (
                .clk(clk),
                .rst(rst),

                .in_real(in_r[i]),
                .in_imag(in_i[i]),

                .out_real(out_r[i]),
                .out_imag(out_i[i]),

                .count(count_buf[DELAY])
            );

            if (i < 8) begin
                assign in_r[i+1] = out_r[i];
                assign in_i[i+1] = out_i[i];
            end

        end
    endgenerate

endmodule

