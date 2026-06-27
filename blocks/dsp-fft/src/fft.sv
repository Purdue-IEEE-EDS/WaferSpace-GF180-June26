module fft
(
    input  logic adc_clk, rst,
    input logic valid_in, 

    input logic signed [5:0] din_re, din_im,
    output logic signed [15:0] dout_re, dout_im, 

    output logic valid_out
); 

    logic clk; 
    logic sync_rst1, sync_rst2; 

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            sync_rst1 <= '0; 
            sync_rst2 <= '0; 
        end else begin 
            sync_rst1 <= rst; 
            sync_rst2 <= sync_rst1; 
        end
    end

    clk_divider divider(
    .adc_clk, 
    .rst,    
    .clk   
    );

    logic [5:0] pdata_re0, pdata_re1, pdata_re2, pdata_re3;
    logic [5:0] pdata_im0, pdata_im1, pdata_im2, pdata_im3;

    logic stp_val, reorder_val, fft_val; 

    serial_to_parallel stp_re(
    .valid_in(valid_in),
    .clk(adc_clk), .rst,
    .din(din_re), 
    .dout0(pdata_re0), .dout1(pdata_re1), .dout2(pdata_re2), .dout3(pdata_re3),
    .valid_out(stp_val));

    serial_to_parallel stp_im(
    .valid_in(valid_in),
    .clk(adc_clk), .rst,
    .din(din_im), 
    .dout0(pdata_im0), .dout1(pdata_im1), .dout2(pdata_im2), .dout3(pdata_im3));

    logic [5:0] fft_re0, fft_re1, fft_re2, fft_re3;
    logic [5:0] fft_im0, fft_im1, fft_im2, fft_im3;
    
    reorder
    input_buffer (
        .clk, .rst(sync_rst2),   // 160 MHz Parallel Clock
        .valid_in(stp_val),   // High when valid serial-de-interleaved data arrives
        
        .din_re0(pdata_re0), .din_re1(pdata_re1), .din_re2(pdata_re2), .din_re3(pdata_re3),
        .din_im0(pdata_im0), .din_im1(pdata_im1), .din_im2(pdata_im2), .din_im3(pdata_im3), 

        .valid_out(reorder_val),
        .din_re0_r(fft_re0), .din_re1_r(fft_re2), .din_re2_r(fft_re1), .din_re3_r(fft_re3),
        .din_im0_r(fft_im0), .din_im1_r(fft_im2), .din_im2_r(fft_im1), .din_im3_r(fft_im3) 
    );

    logic signed [15:0] dout_re0, dout_re1, dout_re2, dout_re3;   
    logic signed [15:0] dout_im0, dout_im1, dout_im2, dout_im3;

    mdc_fft
    fft_core(
        .clk, .rst(sync_rst2),
        .in_valid(reorder_val),

        .din_re0(fft_re0+6'd32), .din_re1(fft_re1+6'd32), .din_re2(fft_re2+6'd32), .din_re3(fft_re3+6'd32),
        .din_im0(fft_im0+6'd32), .din_im1(fft_im1+6'd32), .din_im2(fft_im2+6'd32), .din_im3(fft_im3+6'd32), 

        .dout_re0, .dout_re1, .dout_re2, .dout_re3,   
        .dout_im0, .dout_im1, .dout_im2, .dout_im3,

        .out_valid(fft_val)
    ); 

    parallel_to_serial pts_re(
        .adc_clk, .rst, //640 mhz
        .valid_in(fft_val),
        .dout(dout_re), 
        .din0(dout_re0), .din1(dout_re1), .din2(dout_re2), .din3(dout_re3),
        .valid_out(valid_out)
    );

    parallel_to_serial pts_im(
        .adc_clk, .rst, //640 mhz
        .valid_in(fft_val),
        .dout(dout_im), 
        .din0(dout_im0), .din1(dout_im1), .din2(dout_im2), .din3(dout_im3),
        .valid_out()
    );

    
endmodule