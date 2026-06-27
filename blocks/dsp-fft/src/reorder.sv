module reorder
(
    input  logic        clk, rst,   // 160 MHz Parallel Clock
    input  logic        valid_in,   // High when valid serial-de-interleaved data arrives
    
    input  logic signed [5:0] din_re0, din_re1, din_re2, din_re3,
    input  logic signed [5:0] din_im0, din_im1, din_im2, din_im3, 

    output logic              valid_out,
    output logic signed [5:0] din_re0_r, din_re1_r, din_re2_r, din_re3_r,
    output logic signed [5:0] din_im0_r, din_im1_r, din_im2_r, din_im3_r 
);

    logic [11:0] mem [0:127];
    logic buffer_num1, buffer_num2, buffer_num3, buffer_num4; 
    logic [3:0] w_addr, r_addr1, r_addr2, r_addr3, r_addr4; 
    logic count_up; 
    logic val; 
    
    always_ff @(posedge clk) begin 
        if (valid_in) w_addr <= w_addr + 1'b1; 
        else w_addr <= '0;
    end 

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            val <= '0; 
            valid_out <= '0; 
            count_up <= '0; 
        end else begin 
            val <= count_up; 
            valid_out <= val; 
            if (w_addr == 4'd15) begin 
                count_up <= 1'b1; 
            end 
            else if (r_addr1 == 4'd15 ) begin 
                count_up <= 1'b0; 
            end 
            else begin 
                count_up <= count_up; 
            end
        end
    end

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            buffer_num1 <= '0; 
        end else begin 
            if (w_addr == 4'd15) begin 
                buffer_num1 <= ~buffer_num1; 
            end 
            else if (r_addr1 == 4'd15 ) begin 
                buffer_num1 <= '0; 
            end
            else begin 
                buffer_num1 <= buffer_num1;
            end
        end
    end

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            buffer_num2 <= '0; 
        end else begin 
            if (w_addr == 4'd15) begin 
                buffer_num2 <= ~buffer_num2; 
            end 
            else if (r_addr2 == 4'd15 ) begin 
                buffer_num2 <= '0; 
            end
            else begin 
                buffer_num2 <= buffer_num2;
            end
        end
    end

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            buffer_num3 <= '0; 
        end else begin 
            if (w_addr == 4'd15) begin 
                buffer_num3 <= ~buffer_num3; 
            end 
            else if (r_addr3 == 4'd15 ) begin 
                buffer_num3 <= '0; 
            end
            else begin 
                buffer_num3 <= buffer_num3;
            end
        end
    end

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            buffer_num4 <= '0; 
        end else begin 
            if (w_addr == 4'd15) begin 
                buffer_num4 <= ~buffer_num4; 
            end 
            else if (r_addr4 == 4'd15 ) begin 
                buffer_num4 <= '0; 
            end
            else begin 
                buffer_num4 <= buffer_num4;
            end
        end
    end

    always_ff @(posedge clk) begin 
        if (valid_in || count_up) begin 
            r_addr1 <= r_addr1 + 1'b1; 
        end else begin 
            r_addr1 <= '0; 
        end
    end

    always_ff @(posedge clk) begin 
        if (valid_in || count_up) begin 
            r_addr2 <= r_addr2 + 1'b1; 
        end else begin 
            r_addr2 <= '0; 
        end
    end

    always_ff @(posedge clk) begin 
        if (valid_in || count_up) begin 
            r_addr3 <= r_addr3 + 1'b1; 
        end else begin 
            r_addr3 <= '0; 
        end
    end

    always_ff @(posedge clk) begin 
        if (valid_in || count_up) begin 
            r_addr4 <= r_addr4 + 1'b1; 
        end else begin 
            r_addr4 <= '0; 
        end
    end

    logic [11:0] win_data [0:3];
    assign win_data[0] = {din_re0, din_im0};
    assign win_data[1] = {din_re1, din_im1};
    assign win_data[2] = {din_re2, din_im2};
    assign win_data[3] = {din_re3, din_im3};

    always_ff @(posedge clk) begin 
        mem[{buffer_num1, w_addr, 2'd0}] <= win_data[0];
        mem[{buffer_num2, w_addr, 2'd1}] <= win_data[1];
        mem[{buffer_num3, w_addr, 2'd2}] <= win_data[2];
        mem[{buffer_num4, w_addr, 2'd3}] <= win_data[3];
    end

    logic [11:0] rout_data [0:3];

    always_ff @(posedge clk) begin 
        rout_data[0] <= mem[{~buffer_num1, 2'd0, r_addr1}];
        rout_data[1] <= mem[{~buffer_num2, 2'd1, r_addr2}];
        rout_data[2] <= mem[{~buffer_num3, 2'd2, r_addr3}];
        rout_data[3] <= mem[{~buffer_num4, 2'd3, r_addr4}];
    end

    always_ff @(posedge clk) begin  
        din_re0_r <= rout_data[0][11:6];
        din_im0_r <= rout_data[0][5:0];
        
        din_re1_r <= rout_data[1][11:6];
        din_im1_r <= rout_data[1][5:0];
        
        din_re2_r <= rout_data[2][11:6];
        din_im2_r <= rout_data[2][5:0];
        
        din_re3_r <= rout_data[3][11:6];
        din_im3_r <= rout_data[3][5:0];
    end
endmodule