(* keep_hierarchy = "yes" *)
module parallel_to_serial(
    input logic adc_clk, fft_clk, rst, //640 mhz
    input logic valid_in,
    input logic [3:0] din,  
    output logic dout, 
    output logic valid_out
);

    logic valid_in_reg; 

    always_ff @(posedge adc_clk) begin 
        if (!rst) begin 
            valid_in_reg <= '0; 
        end else begin 
            valid_in_reg <= valid_in; 
        end
    end

    logic [3:0] shift_reg;
    logic [2:0] val; 

    (* keep *) logic pulse0, pulse1, pulse2, pulse3; 
    logic [1:0] count; 

    always_ff @(posedge adc_clk) begin 
        if (!rst) begin 
            valid_out <= '0; 
            val <= '0; 
        end else begin 
            valid_out <= val[2]; 
            val <= {val[1:0], valid_in};
        end
    end

    // always_ff @(posedge adc_clk) begin 
    //     if (valid_in_reg) begin
    //         count <= count + 1'b1; 
    //     end
    //     else begin 
    //         count <= 2'b11; 
    //     end
    // end

    // always_ff @(posedge adc_clk) begin
    //     for (int i =0; i < 4; i++) pulse <= (count == '0);
    // end

    (* keep *) ring_counter rc0 (.clk(adc_clk), .rst, .count(pulse0));
    (* keep *) ring_counter rc1 (.clk(adc_clk), .rst, .count(pulse1));
    (* keep *) ring_counter rc2 (.clk(adc_clk), .rst, .count(pulse2));
    (* keep *) ring_counter rc3 (.clk(adc_clk), .rst, .count(pulse3));

    always_ff @(posedge adc_clk) begin 
        if (pulse0) shift_reg[0] <= din[0];
        else shift_reg[0] <= shift_reg[1];

        if (pulse1) shift_reg[1] <= din[1];
        else shift_reg[1] <= shift_reg[2];

        if (pulse2) shift_reg[2] <= din[2];
        else shift_reg[2] <= shift_reg[3];

        if (pulse3) shift_reg[3] <= din[3];
        else shift_reg[3] <= '0;

        dout <= shift_reg[0];
    end
endmodule