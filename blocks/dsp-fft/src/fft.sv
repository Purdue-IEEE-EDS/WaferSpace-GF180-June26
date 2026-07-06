module fft
(
    input  logic adc_clk, rst,
    input logic valid_in, 

    input logic signed [5:0] din_re, din_im,
    output logic signed [7:0] dout_re, dout_im, 

    output logic valid_out
); 

    logic fft_clk; 
    (* keep *) logic sync_rst1, sync_rst2; 

    always_ff @(posedge fft_clk, negedge rst) begin 
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
    .clk(fft_clk) 
    );

    logic [5:0] pdata_re0, pdata_re1, pdata_re2, pdata_re3;
    logic [5:0] pdata_im0, pdata_im1, pdata_im2, pdata_im3;

    logic stp_val, reorder_val, fft_val; 

    serial_to_parallel16 stp_re(
    .clk(adc_clk), .rst,
    .din(din_re), 
    .dout0(pdata_re0), .dout1(pdata_re1), .dout2(pdata_re2), .dout3(pdata_re3));

    serial_to_parallel16 stp_im(
    .clk(adc_clk), .rst,
    .din(din_im), 
    .dout0(pdata_im0), .dout1(pdata_im1), .dout2(pdata_im2), .dout3(pdata_im3));

    logic [5:0] fft_re0, fft_re1, fft_re2, fft_re3;
    logic [5:0] fft_im0, fft_im1, fft_im2, fft_im3;

    (* keep *) logic valid_in_reg1, valid_in_reg2; 

    always_ff @(posedge fft_clk, negedge sync_rst2) begin 
        if (!sync_rst2) begin 
            valid_in_reg1 <= '0;
            valid_in_reg2 <= '0; 
        end else begin 
            valid_in_reg1 <= valid_in;
            valid_in_reg2 <= valid_in_reg1; 
        end
    end 
    
    reorder
    reorder_re (
        .clk(fft_clk), .rst(sync_rst2),   // 160 MHz Parallel Clock
        .valid_in(valid_in_reg2),   // High when valid serial-de-interleaved data arrives
        
        .din0(pdata_re0), .din1(pdata_re1), .din2(pdata_re2), .din3(pdata_re3),

        .valid_out(reorder_val),
        .dout0(fft_re0), .dout1(fft_re2), .dout2(fft_re1), .dout3(fft_re3)
    );

    reorder
    reorder_im (
        .clk(fft_clk), .rst(sync_rst2),   // 160 MHz Parallel Clock
        .valid_in(valid_in_reg2),   // High when valid serial-de-interleaved data arrives
        
        .din0(pdata_im0), .din1(pdata_im1), .din2(pdata_im2), .din3(pdata_im3),

        .valid_out(),
        .dout0(fft_im0), .dout1(fft_im2), .dout2(fft_im1), .dout3(fft_im3)
    );

    logic signed [15:0] dout_re0, dout_re1, dout_re2, dout_re3;   
    logic signed [15:0] dout_im0, dout_im1, dout_im2, dout_im3;

    mdc_fft
    fft_core(
        .clk(fft_clk), .rst(sync_rst2),
        .in_valid(reorder_val),

        .din_re0(fft_re0+6'd32), .din_re1(fft_re2+6'd32), .din_re2(fft_re1+6'd32), .din_re3(fft_re3+6'd32),
        .din_im0(fft_im0+6'd32), .din_im1(fft_im2+6'd32), .din_im2(fft_im1+6'd32), .din_im3(fft_im3+6'd32), 

        .dout_re0, .dout_re1, .dout_re2, .dout_re3,   
        .dout_im0, .dout_im1, .dout_im2, .dout_im3,

        .out_valid(fft_val)
    ); 

    logic [7:0] re0, re1, re2, re3, im0, im1, im2, im3; 

    always_ff @(posedge fft_clk) begin 
        re0 <= dout_re0[15:8];
        re1 <= dout_re1[15:8]; 
        re2 <= dout_re2[15:8]; 
        re3 <= dout_re3[15:8]; 

        im0 <= dout_im0[15:8]; 
        im1 <= dout_im1[15:8]; 
        im2 <= dout_im2[15:8]; 
        im3 <= dout_im3[15:8]; 
    end

    logic pts_val, pts_val_sync1;
    (* keep *) (* dont_touch = "true" *) logic pts_val_sync2; 
    (* keep *) (* dont_touch = "true" *) logic pts_val_sync2_cpy; 

    always_ff @(posedge fft_clk, negedge sync_rst2) begin 
        if (!sync_rst2) pts_val <= '0; 
        else pts_val <= fft_val; 
    end

    always_ff @(posedge adc_clk) begin 
        if (!rst) begin 
            pts_val_sync1 <= '0; 
            pts_val_sync2 <= '0; 
        end else begin 
            pts_val_sync1 <= pts_val; 
            pts_val_sync2 <= pts_val_sync1; 
        end
    end

    always_ff @(posedge adc_clk) begin 
        if (!rst) begin 
            pts_val_sync2_cpy <= '0; 
        end else begin  
            pts_val_sync2_cpy <= pts_val_sync1; 
        end
    end

    parallel_to_serial16 pts_re(
        .adc_clk, .fft_clk, .rst, //640 mhz
        .valid_in(pts_val),
        .dout(dout_re), 
        .din0(re0), .din1(re1), .din2(re2), .din3(re3),
        .valid_out(valid_out)
    );

    parallel_to_serial16 pts_im(
        .adc_clk, .fft_clk, .rst, //640 mhz
        .valid_in(pts_val),
        .dout(dout_im), 
        .din0(im0), .din1(im1), .din2(im2), .din3(im3),
        .valid_out()
    );
endmodule