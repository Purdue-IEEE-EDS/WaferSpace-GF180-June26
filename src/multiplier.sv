module multiplier (
    input logic clk, rst,
    input logic [15:0] a, b, 
    output logic [31:0] p
);
    logic [31:0] mult_reg_1, mult_reg_2;

    always_ff @(posedge clk) begin
           // Two stages of registers following the operator
            mult_reg_1 <= a * b;
            mult_reg_2 <= mult_reg_1;
    end

    assign p = mult_reg_2;
endmodule