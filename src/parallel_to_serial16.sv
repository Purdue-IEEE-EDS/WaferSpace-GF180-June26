(* keep_hierarchy = "yes" *)
module parallel_to_serial16(
    input logic adc_clk, fft_clk, rst, //640 mhz
    input logic valid_in,
    input logic [7:0] din0, din1, din2, din3,  
    output logic [7:0] dout, 
    output logic valid_out
); 

    logic [7:0] din0_reg, din1_reg, din2_reg, din3_reg;

    logic [4:0] val; 
    always_ff @(posedge adc_clk) begin 
        if (!rst) begin 
            val <= '0; 
            valid_out <= '0; 
        end
        else begin 
            val <= {val[3:0], valid_in}; 
            valid_out <= val[4]; 
        end
    end

    always_ff @(posedge adc_clk) begin 
        din0_reg <= din0; 
        din1_reg <= din1; 
        din2_reg <= din2;
        din3_reg <= din3; 
    end

    parallel_to_serial pts0(.adc_clk, .rst, .din({din3_reg[0], din2_reg[0], din1_reg[0], din0_reg[0]}), .dout(dout[0]) );

    generate
        for (genvar i=1; i < 8; i++) begin 
            parallel_to_serial pts(.adc_clk, .rst, .din({din3_reg[i], din2_reg[i], din1_reg[i], din0_reg[i]}), .dout(dout[i]) );
        end
    endgenerate

endmodule