module parallel_to_serial(
    input logic adc_clk, fft_clk, rst, //640 mhz
    input logic valid_in,
    output logic [15:0] dout, 
    input logic [15:0] din0, din1, din2, din3,  
    output logic valid_out
);

    logic val; 
    logic [15:0] buffer [0:3];
    logic [1:0] count [0:3];

    logic valid_in_reg1, valid_in_reg2, valid_in_reg3, valid_in_reg4; 


    always_ff @(posedge adc_clk) begin 
        if (!rst) begin 
            valid_out <= '0; 
            val <= '0; 
        end else begin 
            valid_out <= val;
            val <= valid_in_reg1;
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (!rst) valid_in_reg1 <= valid_in; 
        else valid_in_reg1 <= valid_in; 

        for (int i = 0; i < 2; i++) begin 
            if (valid_in_reg1) begin 
                count[i] <= count[i] + 1'b1; 
            end else begin
                count[i] <= '0;
            end
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (!rst) valid_in_reg2 <= valid_in; 
        else valid_in_reg2 <= valid_in; 

        for (int i = 2; i < 4; i++) begin 
            if (valid_in_reg2) begin 
                count[i] <= count[i] + 1'b1; 
            end else begin
                count[i] <= '0;
            end
        end
    end

    // always_ff @(posedge adc_clk) begin 
    //     if (!rst) valid_in_reg2 <= '0; 
    //     else valid_in_reg2 <= valid_in; 

    //     if (valid_in_reg2) begin 
    //         count[1] <= count[1] + 1'b1; 
    //     end else begin
    //         count[1] <= '0;
    //     end 
    // end

    // always_ff @(posedge adc_clk) begin 
    //     if (!rst) valid_in_reg3 <= '0; 
    //     else valid_in_reg3 <= valid_in; 

    //     if (valid_in_reg3) begin 
    //         count[2] <= count[2] + 1'b1; 
    //     end else begin
    //         count[2] <= '0;
    //     end 
    // end

    // always_ff @(posedge adc_clk) begin 
    //     if (!rst) valid_in_reg4 <= '0; 
    //     else valid_in_reg4 <= valid_in; 

    //     if (valid_in_reg4) begin 
    //         count[3] <= count[3y] + 1'b1; 
    //     end else begin
    //         count[3] <= '0;
    //     end 
    // end

    always_ff @(posedge fft_clk) begin 
        buffer[1] <= din0; 
        buffer[2] <= din1;
        buffer[3] <= din2;
        buffer[0] <= din3; 
    end 

    // logic [15:0] opt1, opt2; 
    // logic prev_count [0:3]; 

    // always_ff @(posedge adc_clk) begin 
    //     for (int i = 0; i < 4; i++) begin 
    //         prev_count[i] <= count[i][1];
    //     end
    // end 

    // always_ff @(posedge adc_clk) begin 
    //     for (int i = 0; i < 4; i++) begin 
    //         opt1[4*i +:4] <= buffer[{1'b0, count[i][0]}][4*i +:4];
    //         opt2[4*i +:4] <= buffer[{1'b1, count[i][0]}][4*i +:4];
    //     end
    // end

    // always_comb begin 
    //     for (int i = 0; i < 4; i++) begin 
    //         dout[4*i +:4] = prev_count[i] ? opt2[4*i +:4] : opt1[4*i +:4];
    //     end
    // end

    always_comb begin
        for (int i = 0; i < 4; i++) begin 
            dout[4*i +:4] = buffer[{count[i]}][4*i +:4];
        end
    end
endmodule