(* keep_hierarchy = "yes" *)
module parallel_to_serial(
    input logic adc_clk, rst, //640 mhz
    // input logic valid_in,
    input logic [3:0] din,  
    output logic dout
    // output logic valid_out
);

    // logic valid_in_reg; 

    // always_ff @(posedge adc_clk) begin 
    //     if (!rst) begin 
    //         valid_in_reg <= '0; 
    //     end else begin 
    //         valid_in_reg <= valid_in; 
    //     end
    // end

    logic [3:0] shift_reg;  
    // logic [1:0] val; 

    (* dont_touch = 1 *) logic pulse0_p, pulse1_p, pulse2_p, pulse3_p; 
    logic pulse0, pulse1, pulse2, pulse3; 
    logic [1:0] count; 

    // always_ff @(posedge adc_clk) begin 
    //     if (!rst) begin 
    //         valid_out <= '0; 
    //         val <= '0; 
    //     end else begin 
    //         valid_out <= val[1]; 
    //         val <= {val[0], valid_in};
    //     end
    // end

    // always_ff @(posedge adc_clk) begin  
    //     pulse0 <= pulse0_p; 
    //     pulse1 <= pulse1_p; 
    //     pulse2 <= pulse2_p; 
    //     pulse3 <= pulse3_p; 
    // end

    splitnets split (.clk(adc_clk), .din(pulse0_p), .dout({pulse0, pulse1, pulse2, pulse3}));

    (* keep *) ring_counter rc0 (.clk(adc_clk), .rst, .count(pulse0_p));

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