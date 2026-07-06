(* keep_hierarchy = "yes" *)
module serial_to_parallel (
    input logic clk, rst,
    input logic din, 
    output logic [3:0] dout
);

    logic [3:0] shift_reg, shift_reg_del, shift_reg_del2;
    logic load0, load1, load2, load3;
    logic load0_p, load1_p, load2_p, load3_p;

    always_ff @(posedge clk) begin
        load0 <= load0_p;
        load1 <= load1_p;
        load2 <= load2_p;
        load3 <= load3_p;
    end

    (* keep_hierarchy = "yes" *) ring_counter rc1 (.clk, .rst, .count(load0_p));
    (* keep_hierarchy = "yes" *) ring_counter rc2 (.clk, .rst, .count(load1_p));
    (* keep_hierarchy = "yes" *) ring_counter rc3 (.clk, .rst, .count(load2_p));
    (* keep_hierarchy = "yes" *) ring_counter rc4 (.clk, .rst, .count(load3_p));

    always_ff @(posedge clk) begin
        shift_reg[3] <= shift_reg[2];
        shift_reg[2] <= shift_reg[1];
        shift_reg[1] <= shift_reg[0];
        shift_reg[0] <= din;
    end

    always_ff @(posedge clk) begin
        if (load0) dout[0] <= shift_reg[3];
        if (load1) dout[1] <= shift_reg[2];
        if (load2) dout[2] <= shift_reg[1];
        if (load3) dout[3] <= shift_reg[0];
    end


    // logic [3:0] shift_reg, shift_reg_del, shift_reg_del2; 
    // logic valid_in_reg; 

    // always_ff @(posedge clk) begin 
    //     if (!rst) begin 
    //         valid_in_reg <= '0; 
    //     end else begin 
    //         valid_in_reg <= valid_in; 
    //     end
    // end

    // logic [4:0] val; 

    // always_ff @(posedge clk, negedge rst) begin 
    //     if (!rst) begin 
    //         valid_out <= '0; 
    //         val <= '0; 
    //     end else begin 
    //         valid_out <= val[4];
    //         val <= {val[3:0], valid_in_reg};
    //     end
    // end

    // logic count_up; 
    // logic [1:0] count; 
    // logic load;
    // logic count_high; 

    // always_ff @(posedge clk) begin 
    //     if (count_up) count <= count + 1'b1; 
    //     else count <= '0; 

    //     load <= (count == '0);
    //     count_high <= (count == 2'b1);
    // end

    // always_ff @(posedge clk, negedge rst) begin 
    //     if (!rst) begin 
    //         count_up <= '0; 
    //     end else begin 
    //         if (valid_in) count_up <= 1'b1; 
    //         else if (count_high) count_up <= '0; 
    //         else count_up <= count_up; 
    //     end
    // end

    // always_ff @(posedge clk) begin 
    //     shift_reg[3] <= shift_reg[2];
    //     shift_reg[2] <= shift_reg[1];
    //     shift_reg[1] <= shift_reg[0];
    //     shift_reg[0] <= din;

    //     shift_reg_del[3] <= shift_reg[3];
    //     shift_reg_del[2] <= shift_reg[2];
    //     shift_reg_del[1] <= shift_reg[1];
    //     shift_reg_del[0] <= shift_reg[0];

    //     shift_reg_del2[3] <= shift_reg_del[3];
    //     shift_reg_del2[2] <= shift_reg_del[2];
    //     shift_reg_del2[1] <= shift_reg_del[1];
    //     shift_reg_del2[0] <= shift_reg_del[0];
    // end

    // always_ff @(posedge clk) begin 
    //     if (load) begin 
    //         dout[0] <= shift_reg_del2[3];
    //         dout[1] <= shift_reg_del2[2];
    //         dout[2] <= shift_reg_del2[1];
    //         dout[3] <= shift_reg_del2[0];
    //     end
    // end

    // // logic [1:0] count, count1, count2, count3; 
    // // logic load00, load01, load10, load11, load20, load21, load30, load31; 
    // // logic [5:0] shift_reg [0:3];
    // // logic [5:0] shift_reg_del [0:3];
    // // logic [4:0] val; 
    // // logic count_up1, count_up2; 

    // // always_ff @(posedge clk, negedge rst) begin 
    // //     if (!rst) begin 
    // //         valid_out <= '0; 
    // //         val <= '0; 
    // //     end else begin 
    // //         valid_out <= val[4];
    // //         val <= {val[3:0], valid_in};
    // //     end
    // // end

    // // always_ff @(posedge clk, negedge rst) begin 
    // //     if (!rst) begin 
    // //         count_up1 <= '0; 
    // //     end else begin 
    // //         if (count == 2'd3 && valid_in ) count_up1 <= 1'b1; 
    // //         else if (count == 2'd3) count_up1 <= '0; 
    // //         else count_up1 <= count_up1; 
    // //     end
    // // end

    // // always_ff @(posedge clk, negedge rst) begin 
    // //     if (!rst) begin 
    // //         count_up2 <= '0; 
    // //     end else begin 
    // //         if (count1 == 2'd3 && valid_in ) count_up2 <= 1'b1; 
    // //         else if (count1 == 2'd3) count_up2 <= '0; 
    // //         else count_up2 <= count_up2; 
    // //     end
    // // end

    // // always_ff @(posedge clk) begin 
    // //     if (valid_in || count_up1) count <= count + 1'b1; 
    // //     else count <= '0; 
    // // end

    // // always_ff @(posedge clk) begin 
    // //     if (valid_in || count_up1) count1 <= count1 + 1'b1; 
    // //     else count1 <= '0; 
    // // end

    // // always_ff @(posedge clk) begin 
    // //     if (valid_in || count_up2) count2 <= count2 + 1'b1; 
    // //     else count2 <= '0; 
    // // end

    // // always_ff @(posedge clk) begin 
    // //     if (valid_in || count_up2) count3 <= count3 + 1'b1; 
    // //     else count3 <= '0; 
    // // end

    // // always_ff @(posedge clk) begin 
    // //     shift_reg[3] <= shift_reg[2];
    // //     shift_reg[2] <= shift_reg[1];
    // //     shift_reg[1] <= shift_reg[0];
    // //     shift_reg[0] <= din;

    // //     shift_reg_del[3] <= shift_reg[3];
    // //     shift_reg_del[2] <= shift_reg[2];
    // //     shift_reg_del[1] <= shift_reg[1];
    // //     shift_reg_del[0] <= shift_reg[0];
    // // end

    // // always_ff @(posedge clk) begin 
    // //     load00 <= (count == '0);
    // //     load10 <= (count1 == '0);
    // //     load20 <= (count2 == '0);
    // //     load30 <= (count3 == '0);
    // // end

    // // always_ff @(posedge clk) begin 
    // //     if (load00) begin 
    // //         dout0 <= shift_reg_del[3];
    // //     end else begin 
    // //         dout0 <= dout0;
    // //     end
    // // end

    // // always_ff @(posedge clk) begin 
    // //     if (load10) begin 
    // //         dout1 <= shift_reg_del[2];
    // //     end else begin 
    // //         dout1 <= dout1;
    // //     end
    // // end

    // // always_ff @(posedge clk) begin 
    // //     if (load20) begin 
    // //         dout2 <= shift_reg_del[1];
    // //     end else begin 
    // //         dout2 <= dout2;
    // //     end
    // // end

    // // always_ff @(posedge clk) begin 
    // //     if (load30) begin 
    // //         dout3 <= shift_reg_del[0];
    // //     end else begin 
    // //         dout3 <= dout3;
    // //     end
    // // end

endmodule