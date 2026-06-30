module serial_to_parallel (
    input logic valid_in,
    input logic clk, rst,
    input logic [5:0] din, 
    output logic [5:0] dout0, dout1, dout2, dout3, 
    output logic valid_out
);

    logic [1:0] count, count1, count2, count3; 
    logic load00, load01, load10, load11, load20, load21, load30, load31; 
    logic [5:0] shift_reg [0:3];
    logic [5:0] shift_reg_del [0:3];
    logic [4:0] val; 
    logic count_up1, count_up2; 

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            valid_out <= '0; 
            val <= '0; 
        end else begin 
            valid_out <= val[4];
            val <= {val[3:0], valid_in};
        end
    end

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            count_up1 <= '0; 
        end else begin 
            if (count == 2'd3 && valid_in ) count_up1 <= 1'b1; 
            else if (count == 2'd3) count_up1 <= '0; 
            else count_up1 <= count_up1; 
        end
    end

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            count_up2 <= '0; 
        end else begin 
            if (count1 == 2'd3 && valid_in ) count_up2 <= 1'b1; 
            else if (count1 == 2'd3) count_up2 <= '0; 
            else count_up2 <= count_up2; 
        end
    end

    always_ff @(posedge clk) begin 
        if (valid_in || count_up1) count <= count + 1'b1; 
        else count <= '0; 
    end

    always_ff @(posedge clk) begin 
        if (valid_in || count_up1) count1 <= count1 + 1'b1; 
        else count1 <= '0; 
    end

    always_ff @(posedge clk) begin 
        if (valid_in || count_up2) count2 <= count2 + 1'b1; 
        else count2 <= '0; 
    end

    always_ff @(posedge clk) begin 
        if (valid_in || count_up2) count3 <= count3 + 1'b1; 
        else count3 <= '0; 
    end

    always_ff @(posedge clk) begin 
        shift_reg[3] <= shift_reg[2];
        shift_reg[2] <= shift_reg[1];
        shift_reg[1] <= shift_reg[0];
        shift_reg[0] <= din;

        shift_reg_del[3] <= shift_reg[3];
        shift_reg_del[2] <= shift_reg[2];
        shift_reg_del[1] <= shift_reg[1];
        shift_reg_del[0] <= shift_reg[0];
    end

    always_ff @(posedge clk) begin 
        load00 <= (count == '0);
        load10 <= (count1 == '0);
        load20 <= (count2 == '0);
        load30 <= (count3 == '0);
    end

    always_ff @(posedge clk) begin 
        if (load00) begin 
            dout0 <= shift_reg_del[3];
        end else begin 
            dout0 <= dout0;
        end
    end

    always_ff @(posedge clk) begin 
        if (load10) begin 
            dout1 <= shift_reg_del[2];
        end else begin 
            dout1 <= dout1;
        end
    end

    always_ff @(posedge clk) begin 
        if (load20) begin 
            dout2 <= shift_reg_del[1];
        end else begin 
            dout2 <= dout2;
        end
    end

    always_ff @(posedge clk) begin 
        if (load30) begin 
            dout3 <= shift_reg_del[0];
        end else begin 
            dout3 <= dout3;
        end
    end

endmodule