module parallel_to_serial(
    input logic adc_clk, rst, //640 mhz
    input logic valid_in,
    output logic [15:0] dout, 
    input logic [15:0] din0, din1, din2, din3,  
    output logic valid_out
);

    logic val; 
    logic [15:0] buffer [0:3];
    logic [1:0] count1, count2, count3, count4; 

    always_ff @(posedge adc_clk) begin 
        if (!rst) begin 
            valid_out <= '0; 
            val <= '0; 
        end else begin 
            valid_out <= val;
            val <= valid_in;
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (valid_in) begin 
            count1 <= count1 + 1'b1; 
        end else begin 
            count1 <= '0; 
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (valid_in) begin 
            count2 <= count2 + 1'b1; 
        end else begin 
            count2 <= '0; 
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (valid_in) begin 
            count3 <= count3 + 1'b1; 
        end else begin 
            count3 <= '0; 
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (valid_in) begin 
            count4 <= count4 + 1'b1; 
        end else begin 
            count4 <= '0; 
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (count1 == 2'd0) begin 
            buffer[0] <= din0;
        end else begin 
            buffer[0] <= buffer[1];
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (count2 == 2'd0) begin 
            buffer[1] <= din1;
        end else begin 
            buffer[1] <= buffer[2];
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (count3 == 2'd0) begin 
            buffer[2] <= din2;
        end else begin 
            buffer[2] <= buffer[3];
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (count4 == 2'd0) begin 
            buffer[3] <= din3;
        end else begin 
            buffer[3] <= '0;
        end
    end

    always_ff @(posedge adc_clk) begin 
        dout <= buffer[0];
    end
endmodule