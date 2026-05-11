`timescale 1 ns / 1ps 
module mdc_stage #(BITS = 16, STAGES = 8, CURR_STAGE = 0)
( 
    input logic clk, rst,
    input logic in_valid, 
    input logic signed [BITS-1:0] din_re0, din_re1, din_re2, din_re3,
    input logic signed [BITS-1:0] din_im0, din_im1, din_im2, din_im3, 

    output logic signed [BITS-1:0] dout_re0, dout_re1, dout_re2, dout_re3,   
    output logic signed [BITS-1:0] dout_im0, dout_im1, dout_im2, dout_im3, 
    output logic out_valid
);

// generate
//     logic signed [BITS-1:0] bf_out_re0, bf_out_re1, bf_out_re2, bf_out_re3;
//     logic signed [BITS-1:0] bf_out_im0, bf_out_im1, bf_out_im2, bf_out_im3; 

//     always_ff @(posedge clk, negedge rst) begin 
//         if (!rst) begin 
//             dout_re0 <= '0; 
//             dout_re1 <= '0; 
//             dout_re2 <= '0; 
//             dout_im0 <= '0; 
//             dout_im1 <= '0; 
//             dout_im2 <= '0; 
//         end else begin 
//             dout_re0 <= bf_out_re0; 
//             dout_re1 <= bf_out_re2; 
//             dout_re2 <= bf_out_re1; 
//             dout_im0 <= bf_out_im0; 
//             dout_im1 <= bf_out_im2; 
//             dout_im2 <= bf_out_im1; 
//         end
//     end

//     if (CURR_STAGE == 0) begin 
//         r2 #(.BITS(16))
//         butterfly1(
//             .clk, .rst, 
//             .mode(1'b1), 
//             .a_in_real(din_re0), .a_in_imag(din_im0), .b_in_real(din_re1), .b_in_imag(din_im1),
//             .a_out_real(bf_out_re0), .a_out_imag(bf_out_im0), .b_out_real(bf_out_re1), .b_out_imag(bf_out_im1)
//         );

//         r2 #(.BITS(16))
//         butterfly2(
//             .clk, .rst, 
//             .mode(1'b1), 
//             .a_in_real(din_re2), .a_in_imag(din_im2), .b_in_real(din_re3), .b_in_imag(din_im3),
//             .a_out_real(bf_out_re2), .a_out_imag(bf_out_im2), .b_out_real(bf_out_re3), .b_out_imag(bf_out_im3)
//         );

//         triv_rotator #(.BITS(16), .DECIMAL(8)) 
//         triv_rot(
//             .clk, .rst, 
//             .rot_en(1'b1),
//             .real_in(bf_out_re3), .imag_in(bf_out_im3),
//             .real_out(dout_re3), .imag_out(dout_im3)
//         );
//     end 
//     else if (CURR_STAGE == 1) begin 
//         logic signed [BITS-1:0] bf_out_re0, bf_out_re1, bf_out_re2, bf_out_re3;
//         logic signed [BITS-1:0] bf_out_im0, bf_out_im1, bf_out_im2, bf_out_im3; 

//         always_ff @(posedge clk, negedge rst) begin 
//             if (!rst) begin 
//                 dout_re0 <= '0; 
//                 dout_re1 <= '0; 
//                 dout_re2 <= '0; 
//                 dout_im0 <= '0; 
//                 dout_im1 <= '0; 
//                 dout_im2 <= '0; 
//             end else begin 
//                 dout_re0 <= ; 
//                 dout_re1 <= ; 
//                 dout_re2 <= ; 
//                 dout_im0 <= ; 
//                 dout_im1 <= ; 
//                 dout_im2 <= ; 
//             end
//         end

//         r2 #(.BITS(16))
//         butterfly1(
//             .clk, .rst, 
//             .mode(1'b1), 
//             .a_in_real(din_re0), .a_in_imag(din_im0), .b_in_real(din_re1), .b_in_imag(din_im1),
//             .a_out_real(bf_out_re0), .a_out_imag(bf_out_im0), .b_out_real(bf_out_re1), .b_out_imag(bf_out_im1)
//         );

//         r2 #(.BITS(16))
//         butterfly2(
//             .clk, .rst, 
//             .mode(1'b1), 
//             .a_in_real(din_re2), .a_in_imag(din_im2), .b_in_real(din_re3), .b_in_imag(din_im3),
//             .a_out_real(bf_out_re2), .a_out_imag(bf_out_im2), .b_out_real(bf_out_re3), .b_out_imag(bf_out_im3)
//         );

        

    // end
// endgenerate
endmodule