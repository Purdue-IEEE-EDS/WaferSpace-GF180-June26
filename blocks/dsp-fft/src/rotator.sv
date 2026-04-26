`default_nettype none

module rotator #(parameter BITS = 16, parameter DECIMAL = 8) 
(
    input logic clk, rst, 
    input logic signed [2*BITS-1:0] data_in, twiddle, 
    output logic signed [2*BITS-1:0] data_out
);

    logic signed [BITS-1:0] a, b, c, d, out_real_s2;
    logic signed [2*BITS-1:0] ac, bd, ad, bc;

    assign a = data_in[2*BITS-1:BITS];
    assign b = data_in[BITS-1:0];
    assign c = twiddle[2*BITS-1:BITS];
    assign d = twiddle[BITS-1:0];

    logic signed [BITS-1:0] a_s1, b_s1, c_s1, d_s1;

    // Stage 1
    always_ff @(posedge clk) begin
        if (!rst) begin
            a_s1 <= '0;
            b_s1 <= '0;
            c_s1 <= '0;
            d_s1 <= '0;
            ac <= '0;
            bd <= '0;
        end else begin
            a_s1 <= a;
            b_s1 <= b;
            c_s1 <= c;
            d_s1 <= d;
            ac <= a * c;
            bd <= b * d;
        end
    end

    // Stage 2
    always_ff @(posedge clk) begin
        if (!rst) begin
            out_real_s2 <= '0;
            ad <= '0;
            bc <= '0;
        end else begin
            out_real_s2 <= ((ac - bd) + (1<<(DECIMAL-1)))>>>DECIMAL;
            ad <= a_s1 * d_s1;
            bc <= b_s1 * c_s1;
        end
    end

    // Stage 3 / Output Stage
    always_ff @(posedge clk) begin
        if (!rst) begin
            data_out[2*BITS-1:BITS] <= '0;
            data_out[BITS-1:0] <= '0;
        end else begin
            data_out[2*BITS-1:BITS] <= out_real_s2;
            data_out[BITS-1:0] <= ((ad + bc) + (1<<(DECIMAL-1)))>>>DECIMAL;
        end
    end

endmodule