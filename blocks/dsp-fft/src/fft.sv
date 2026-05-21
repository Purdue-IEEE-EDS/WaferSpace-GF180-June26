module fft
(
    input  logic clk, rst,
    input logic in_valid,

    input logic signed [15:0] din_re0, din_re1, din_re2, din_re3,
    input logic signed [15:0] din_im0, din_im1, din_im2, din_im3, 

    output logic signed [15:0] dout_re0, dout_re1, dout_re2, dout_re3,   
    output logic signed [15:0] dout_im0, dout_im1, dout_im2, dout_im3,

    output logic out_valid
); 
    
    logic signed [15:0] din_re0_reg, din_re1_reg, din_re2_reg, din_re3_reg;
    logic signed [15:0] din_im0_reg, din_im1_reg, din_im2_reg, din_im3_reg; 
    logic in_valid_reg;

    logic [8:0] val;

    logic [15:0] w_re [0:8], w_im [0:8], 
                x_re [0:8], x_im [0:8], 
                y_re [0:8], y_im [0:8], 
                z_re [0:8], z_im [0:8];

    assign w_re[0] = din_re0_reg;
    assign w_im[0] = din_im0_reg;
    assign x_re[0] = din_re1_reg;
    assign x_im[0] = din_im1_reg;
    assign y_re[0] = din_re2_reg;
    assign y_im[0] = din_im2_reg;
    assign z_re[0] = din_re3_reg;
    assign z_im[0] = din_im3_reg;

    assign dout_re0 = w_re[8];
    assign dout_im0 = w_im[8];
    assign dout_re1 = x_re[8];
    assign dout_im1 = x_im[8];
    assign dout_re2 = y_re[8];
    assign dout_im2 = y_im[8];
    assign dout_re3 = z_re[8];
    assign dout_im3 = z_im[8];

    assign val[0] = in_valid_reg;
    assign out_valid = val[8];

    always_ff @(posedge clk) begin 
        din_re0_reg <= din_re0;
        din_re1_reg <= din_re1; 
        din_re2_reg <= din_re2; 
        din_re3_reg <= din_re3; 
        din_im0_reg <= din_im0;
        din_im1_reg <= din_im1;
        din_im2_reg <= din_im2;
        din_im3_reg <= din_im3; 

        in_valid_reg <= in_valid;
    end

    // mdc_stage #(.CURR_STAGE(2))
    // stage1 ( 
    //     .clk, .rst,
    //     .in_valid(val[i-1]), 
    //     .din_re0(din_re0_reg), .din_re1(din_re1_reg), .din_re2(din_re2_reg), .din_re3(din_re3_reg),
    //     .din_im0(din_im0_reg), .din_im1(din_im1_reg), .din_im2(din_im2_reg), .din_im3(din_im3_reg), 

    //     .dout_re0, .dout_re1, .dout_re2, .dout_re3,   
    //     .dout_im0, .dout_im1, .dout_im2, .dout_im3, 
    //     .out_valid(val[i])
    // );

    generate 
        for (genvar i = 1; i <= 8; i++) begin : stages_gen_blk
            mdc_stage #(.CURR_STAGE(i))
            stage ( 
                .clk, .rst,
                .in_valid(val[i-1]), 
                .din_re0(w_re[i-1]), .din_re1(x_re[i-1]), .din_re2(y_re[i-1]), .din_re3(z_re[i-1]),
                .din_im0(w_im[i-1]), .din_im1(x_im[i-1]), .din_im2(y_im[i-1]), .din_im3(z_im[i-1]), 

                .dout_re0(w_re[i]), .dout_re1(x_re[i]), .dout_re2(y_re[i]), .dout_re3(z_re[i]),   
                .dout_im0(w_im[i]), .dout_im1(x_im[i]), .dout_im2(y_im[i]), .dout_im3(z_im[i]), 
                .out_valid(val[i])
            );
        end
    endgenerate
    
endmodule