(* keep_hierarchy = "yes" *)
module clk_divider(
    input  logic adc_clk, 
    input  logic rst,    
    output logic clk   
);

    logic [1:0] clk_reg, clk_reg1;

    always_ff @(posedge adc_clk, negedge rst) begin
        if (!rst) begin
            clk_reg <= 2'b00;
        end else begin
            case (clk_reg)
                2'b00:   clk_reg <= 2'b10;
                2'b10:   clk_reg <= 2'b11;
                2'b11:   clk_reg <= 2'b01;
                2'b01:   clk_reg <= 2'b00;
                default: clk_reg <= 2'b00;
            endcase
        end
    end

    // assign clk = clk_reg[1];

    always_ff @(posedge adc_clk, negedge rst) begin 
        if (!rst) begin 
            clk <= '0; 
        end else begin 
            clk <= clk_reg[1];
        end
    end

endmodule
