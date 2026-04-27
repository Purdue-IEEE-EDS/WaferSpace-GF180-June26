`default_nettype none

module rotator #(parameter BITS = 16, parameter DECIMAL = 8) 
(
    input logic clk, rst, 
    input logic signed [BITS-1:0] real_in, imag_in, real_tw, imag_tw,
    output logic signed [BITS-1:0] real_out, imag_out
);

    logic signed [BITS-1:0] a, b, c, d, out_real_s2;
    logic signed [2*BITS-1:0] ac, bd, ad, bc;

    assign a = real_in;
    assign b = imag_in;
    assign c = real_tw;
    assign d = imag_tw;

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
            real_out <= '0;
            imag_out <= '0;
        end else begin
            real_out <= out_real_s2;
            imag_out <= ((ad + bc) + (1<<(DECIMAL-1)))>>>DECIMAL;
        end
    end

endmodule