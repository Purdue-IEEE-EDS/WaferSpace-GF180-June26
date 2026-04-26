`default_nettype none

module stage #(parameter BITS = 16, parameter DECIMAL = 8, parameter STAGES=3, parameter CURR_STAGE=1)
(
    input logic clk, rst,
    input logic [STAGES-CURR_STAGE:0] count, 
    input logic [BITS-1:0] in_real, in_imag, 
    output logic [BITS-1:0] out_real, out_imag
);

    logic [2*BITS-1:0] in;
    logic [2*BITS-1:0] out;
    logic [2*BITS-1:0] out_data, in_data, bfu_out;
    logic [2*BITS-1:0] b_out, a_out, prev_b_out;
    logic mode;

    assign in = {in_real, in_imag};
    assign out_real = out[2*BITS-1:BITS];
    assign out_imag = out[BITS-1:0];

    assign mode = (STAGES == CURR_STAGE) ? ~(count >> (STAGES-CURR_STAGE)): count >> (STAGES-CURR_STAGE);
    //assign mode = count >> (STAGES-CURR_STAGE);

    buffer #(.BITS(BITS), .STAGES(STAGES), .CURR_STAGE(CURR_STAGE))
    delay (
        .clk, .rst,
        .in_data,
        .out_data
    );

    r2 #(.BITS(BITS), .DECIMAL(DECIMAL))
    butterfly (
        .clk, .rst,
        .a_in(out_data), .b_in(in),
        .a_out, .b_out
    );

    always_ff @(posedge clk) begin
        if (!rst) begin 
            bfu_out <= '0;
        end
        else begin 
            if (mode == 1'b1) begin
                bfu_out <= a_out;
            end else begin
                bfu_out <= out_data;
            end
        end
    end

    always_comb begin 
        if (mode == 1'b1) begin
            in_data = b_out; 
        end else begin
            in_data = in; 
        end
    end

    logic sel;
    logic [2*BITS-1:0] twiddle, val;
    logic [7:0] addr; // Specific to N = 512
    localparam DELAY = (1 << (STAGES-CURR_STAGE)) + 4;

    assign addr = (count)<<(CURR_STAGE-1); 
    always_ff @(posedge clk) begin
        if (!rst) sel <= 1'b1;
        else sel <= (count) >> (STAGES-CURR_STAGE) == 1'b1;
    end
    assign val = sel ? 1'b1 << (BITS + DECIMAL) : twiddle; //twiddle multiplier is 1.

    logic rot_en;
    if (STAGES-CURR_STAGE == 1'b1) begin
        assign rot_en = count == 2'h2;
    end else begin
        assign rot_en = 1'b0;
    end

    generate
        if (STAGES == CURR_STAGE) assign out = bfu_out;
        else if (STAGES-CURR_STAGE == 1'b1) begin
            triv_rotator #(.BITS(32), .DECIMAL(12)) triv_rot(.data_in(bfu_out), .rot_en(rot_en), .data_out(out));
        end else begin
            twiddle_rom twid_rom(.clk, .rst, .address(addr), .real_out(twiddle[2*BITS-1:BITS]), .imag_out(twiddle[BITS-1:0]));
            rotator #(.BITS(32), .DECIMAL(12)) rot(.clk, .rst, .data_in(bfu_out), .twiddle(val), .data_out(out));
        end
    endgenerate
endmodule
