(* keep_hierarchy = "yes" *)
module reorder_bit
(
    input  logic        clk, rst,
    input  logic        valid_in,   

    input  logic signed [3:0] din,

    output logic              valid_out,
    output logic signed [3:0] dout
);

    logic valid_in_reg; 

    logic [3:0] count; 
    logic count_up; 
    logic buffer_num; 

    logic bank0 [0:63];
    logic bank1 [0:63];

    logic [6:0] raddr0, raddr1, raddr2, raddr3, waddr0, waddr1, waddr2, waddr3; 

    logic [3:0] din_s1, din_s2; 

    always_ff @(posedge clk) begin
       din_s2 <= din_s1;
       din_s1 <= din;  
    end

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            valid_out <= '0; 
        end else begin 
            valid_out <= count_up; 
        end
    end 

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            count_up <= '0; 
            valid_in_reg <= '0; 
        end else begin 
            valid_in_reg <= valid_in; 
            if (valid_in_reg || count_up) begin 
                count <= count + 1'b1; 
                count_up <= count_up; 
                buffer_num <= buffer_num; 
                if (valid_in_reg && count == 4'd15) begin 
                    count_up <= 1'b1; 
                    buffer_num <= ~buffer_num; 
                end
            end
            else begin 
                count <= '0; 
                count_up <= '0; 
                buffer_num <= '0; 
            end
        end
    end

    always_ff @(posedge clk) begin 
        raddr0 <= {count, 2'd0};
        raddr1 <= {count, 2'd1};
        raddr2 <= {count, 2'd2};
        raddr3 <= {count, 2'd3};

        waddr0 <= {2'd0, count};
        waddr1 <= {2'd1, count};
        waddr2 <= {2'd2, count};
        waddr3 <= {2'd3, count};
    end

    always_ff @(posedge clk) begin 
        if (buffer_num == 1'b0) begin 
            bank0[waddr0] <= din_s2[0];
            bank0[waddr1] <= din_s2[1];
            bank0[waddr2] <= din_s2[2];
            bank0[waddr3] <= din_s2[3];
        end else begin 
            bank1[waddr0] <= din_s2[0];
            bank1[waddr1] <= din_s2[1];
            bank1[waddr2] <= din_s2[2];
            bank1[waddr3] <= din_s2[3];
        end
    end

    always_ff @(posedge clk) begin 
        if (buffer_num == 1'b1) begin 
            dout[0] <= bank1[raddr0];
            dout[1] <= bank1[raddr1];
            dout[2] <= bank1[raddr2];
            dout[3] <= bank1[raddr3];
        end else begin 
            dout[0] <= bank0[raddr0];
            dout[1] <= bank0[raddr1];
            dout[2] <= bank0[raddr2];
            dout[3] <= bank0[raddr3];
        end
    end
    
endmodule

