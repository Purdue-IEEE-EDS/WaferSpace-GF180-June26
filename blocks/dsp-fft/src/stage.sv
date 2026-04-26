`default_nettype none

module stage #(
    parameter BITS = 16, 
    parameter STAGES=3, 
    parameter CURR_STAGE=1)
(
    input logic clk, rst,
    input logic mode,  
    input logic signed [BITS-1:0] in_real, in_imag, 
    output logic signed [BITS-1:0] out_real, out_imag
);

generate
    if (STAGES == CURR_STAGE) begin 
        logic signed [BITS-1:0] x, y; 
        r2 #(
                .BITS(BITS)
            ) 
            butterfly (
                .clk(clk), .rst(rst),
                .mode(mode), 
                .a_in_real(x), .a_in_imag(y), .b_in_real(in_real), .b_in_imag(in_imag),
                .a_out_real(out_real), .a_out_imag(out_imag), .b_out_real(x), .b_out_imag(y)
            );
    end 
    else if (STAGES-1 == CURR_STAGE) begin 
        logic signed [BITS-1:0] a_in_real, a_in_imag, b_out_real, b_out_imag; 
        always_ff @(posedge clk, negedge rst) begin 
            if (!rst) begin 
                a_in_real <= '0;
                a_in_imag <= '0; 
            end else begin 
                a_in_real <= b_out_real;
                a_in_imag <= b_out_imag; 
            end
        end 
        r2 #(
                .BITS(BITS)
            ) 
            butterfly (
                .clk(clk), .rst(rst),
                .mode(mode), 
                .a_in_real(a_in_real), .a_in_imag(a_in_imag), .b_in_real(in_real), .b_in_imag(in_imag),
                .a_out_real(out_real), .a_out_imag(out_imag), .b_out_real(b_out_real), .b_out_imag(b_out_imag)
            );
    end
    else begin 
        localparam BUFF_BITS   = STAGES - CURR_STAGE;
        localparam BUFFER_SIZE  = (1 << BUFF_BITS) - 2;

        logic signed [2*BITS-1:0] buff_reg [0:BUFFER_SIZE-1];

        always_ff @(posedge clk) begin
            if (!rst) begin
                for (i = 0; i < BUFFER_SIZE; i++) begin
                    buff_reg[i] <= '0;
                end
                a_in_imag <= '0; 
                a_in_real <= '0; 
            end
            else begin
                for (i = 1; i < BUFFER_SIZE; i++) begin
                    buff_reg[i] <= buff_reg[i-1];
                end
                buff_reg[0] <= {b_out_real, b_out_imag};

                a_in_real <= buff_reg[BUFFER_SIZE-1][2*BITS-1:BITS];
                a_in_imag <= buff_reg[BUFFER_SIZE-1][BITS-1:0];  
            end
        end
        r2 #(
                .BITS(BITS)
            ) 
            butterfly (
                .clk(clk), .rst(rst),
                .mode(mode), 
                .a_in_real(a_in_real), .a_in_imag(a_in_imag), .b_in_real(in_real), .b_in_imag(in_imag),
                .a_out_real(out_real), .a_out_imag(out_imag), .b_out_real(b_out_real), .b_out_imag(b_out_imag)
            );
    end
endgenerate

endmodule