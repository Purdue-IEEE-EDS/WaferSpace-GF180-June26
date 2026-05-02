`default_nettype none

module r4 #(parameter BITS=16)
(
    input logic clk, rst,
    input logic signed [BITS-1:0] din_re0, din_re1, din_re2, din_re3,
    input logic signed [BITS-1:0] din_im0, din_im1, din_im2, din_im3, 

    output logic signed [BITS-1:0] dout_re0, dout_re1, dout_re2, dout_re3,   
    output logic signed [BITS-1:0] dout_im0, dout_im1, dout_im2, dout_im3
);

    logic signed [BITS-1:0] re0_s1, re1_s1, re2_s1, re3_s1, im0_s1, im1_s1, im2_s1, im3_s1;

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            dout_re0 <= '0; 
            dout_re1 <= '0; 
            dout_re2 <= '0; 
            dout_re3 <= '0; 
            dout_im0 <= '0; 
            dout_im1 <= '0; 
            dout_im2 <= '0; 
            dout_im3 <= '0;

            re0_s1 <= '0; 
            re1_s1 <= '0; 
            re2_s1 <= '0; 
            re3_s1 <= '0; 
            im0_s1 <= '0; 
            im1_s1 <= '0; 
            im2_s1 <= '0; 
            im3_s1 <= '0; 
        end else begin 
            dout_re0 <= re0_s1 + re1_s1; 
            dout_re1 <= re2_s1 + im3_s1; 
            dout_re2 <= re0_s1 - re1_s1; 
            dout_re3 <= re2_s1 - im3_s1; 
            dout_im0 <= im0_s1 + im1_s1; 
            dout_im1 <= im2_s1 - re3_s1; 
            dout_im2 <= im0_s1 - im1_s1; 
            dout_im3 <= im2_s1 + re3_s1;

            re0_s1 <= din_re0 + din_re2; 
            re1_s1 <= din_re1 + din_re3; 
            re2_s1 <= din_re0 - din_re2; 
            re3_s1 <= din_im1 - din_im3; 
            im0_s1 <= din_im0 + din_im2; 
            im1_s1 <= din_im1 + din_im3; 
            im2_s1 <= din_im0 - din_im2; 
            im3_s1 <= din_im1 - din_im3;
        end
    end

endmodule