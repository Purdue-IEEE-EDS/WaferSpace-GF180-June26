`timescale 1 ns / 1ps 
module mdc_stage #(BITS = 16, STAGES = 8, CURR_STAGE = 1)
( 
    input logic clk, rst,
    input logic in_valid, 
    input logic [BITS-1:0] din_re0, din_re1, din_re2, din_re3,
    input logic [BITS-1:0] din_im0, din_im1, din_im2, din_im3, 

    output logic [BITS:0] dout_re0, dout_re1, dout_re2, dout_re3,   
    output logic [BITS:0] dout_im0, dout_im1, dout_im2, dout_im3, 
    output logic out_valid
);

    logic [BITS:0] bf_out_re0, bf_out_re1, bf_out_re2, bf_out_re3;
    logic [BITS:0] bf_out_im0, bf_out_im1, bf_out_im2, bf_out_im3; 

generate

    if (CURR_STAGE == 1) begin : stage1

        logic [BITS:0] bf_out_re0_pip, bf_out_re1_pip, bf_out_re2_pip, bf_out_re3_pip;
        logic [BITS:0] bf_out_im0_pip, bf_out_im1_pip, bf_out_im2_pip, bf_out_im3_pip; 

        logic [BITS:0] rot_out_re, rot_out_im; 

        logic val;

        always_ff @(posedge clk, negedge rst) begin 
            if (!rst) begin 
                out_valid <= '0; 
                val <= '0; 
            end else begin
                out_valid <= val; 
                val <= in_valid;
            end
        end

        always_ff @(posedge clk) begin 
            dout_re0 <= bf_out_re0_pip; 
            dout_re1 <= bf_out_re2_pip; 
            dout_re2 <= bf_out_re1_pip; 
            dout_re3 <= rot_out_re;
            dout_im0 <= bf_out_im0_pip; 
            dout_im1 <= bf_out_im2_pip; 
            dout_im2 <= bf_out_im1_pip; 
            dout_im3 <= rot_out_im; 
        end

        always_ff @(posedge clk) begin 
            bf_out_re0_pip <= bf_out_re0; 
            bf_out_re1_pip <= bf_out_re1; 
            bf_out_re2_pip <= bf_out_re2; 
            bf_out_re3_pip <= bf_out_re3; 
            bf_out_im0_pip <= bf_out_im0; 
            bf_out_im1_pip <= bf_out_im1; 
            bf_out_im2_pip <= bf_out_im2; 
            bf_out_im3_pip <= bf_out_im3; 
        end

        r2 #(.BITS(BITS))
        butterfly1(
            .clk, 
            .a_in_real(din_re0), .a_in_imag(din_im0), .b_in_real(din_re1), .b_in_imag(din_im1),
            .a_out_real(bf_out_re0), .a_out_imag(bf_out_im0), .b_out_real(bf_out_re1), .b_out_imag(bf_out_im1)
        );

        r2 #(.BITS(BITS))
        butterfly2(
            .clk, 
            .a_in_real(din_re2), .a_in_imag(din_im2), .b_in_real(din_re3), .b_in_imag(din_im3),
            .a_out_real(bf_out_re2), .a_out_imag(bf_out_im2), .b_out_real(bf_out_re3), .b_out_imag(bf_out_im3)
        );

        triv_rotator #(.BITS(BITS+1)) 
        triv_rot(
            .clk, 
            .real_in(bf_out_re3), .imag_in(bf_out_im3),
            .real_out(rot_out_re), .imag_out(rot_out_im)
        );
    end 
    else if ((CURR_STAGE == 2) || (CURR_STAGE == 4) || (CURR_STAGE == 6)) begin : even_stage

        logic [15:0] real_tw1, imag_tw1, real_tw2, imag_tw2, real_tw3, imag_tw3;
        logic [15:0] real_tw1_pip, imag_tw1_pip, real_tw2_pip, imag_tw2_pip, real_tw3_pip, imag_tw3_pip;

        logic [BITS:0] bf_out_re0_pip, bf_out_re1_pip, bf_out_re2_pip, bf_out_re3_pip;
        logic [BITS:0] bf_out_im0_pip, bf_out_im1_pip, bf_out_im2_pip, bf_out_im3_pip; 
        logic [2*BITS+1:0] comm0, comm1, comm2, comm3;

        logic [BITS:0] rot1_out_re, rot2_out_re, rot3_out_re; 
        logic [BITS:0] rot1_out_im, rot2_out_im, rot3_out_im; 

        localparam DELAY = (1<<(7-CURR_STAGE)) + 8;
        logic [DELAY-1:0] val; 

        always_ff @(posedge clk, negedge rst) begin 
            if (!rst) begin 
                out_valid <= '0;
                val <= '0;  
            end else begin
                out_valid <= val[DELAY-1];
                val <= {val[DELAY-2:0], in_valid}; 
            end
        end

        always_ff @(posedge clk) begin 
            bf_out_re0_pip <= bf_out_re0; 
            bf_out_re1_pip <= bf_out_re1; 
            bf_out_re2_pip <= bf_out_re2; 
            bf_out_re3_pip <= bf_out_re3; 
            bf_out_im0_pip <= bf_out_im0; 
            bf_out_im1_pip <= bf_out_im1; 
            bf_out_im2_pip <= bf_out_im2; 
            bf_out_im3_pip <= bf_out_im3; 
        end

        logic [STAGES-CURR_STAGE-1:0] count1; 
        logic sel;
        logic [5:0] s; 
        logic [2*BITS+1:0] top_out_pip [0:5];

        always_ff @(posedge clk) begin 
            s <= {s[4:0], count1[STAGES-CURR_STAGE-1]};
            sel <= s[5];
            if (in_valid) begin 
                count1 <= count1 + 1; 
            end else begin 
                count1 <= '0;  
            end
        end

        always_ff @(posedge clk) begin 
            top_out_pip[5] <= top_out_pip[4];
            top_out_pip[4] <= top_out_pip[3];
            top_out_pip[3] <= top_out_pip[2];
            top_out_pip[2] <= top_out_pip[1];
            top_out_pip[1] <= top_out_pip[0];
            top_out_pip[0] <= {bf_out_re0, bf_out_im0};
            comm0 <= top_out_pip[5];
            comm1 <= {rot1_out_re, rot1_out_im};
            comm2 <= {rot2_out_re, rot2_out_im};
            comm3 <= {rot3_out_re, rot3_out_im};
        end

        r2 #(.BITS(BITS))
        butterfly1(
            .clk, 
            .a_in_real(din_re0), .a_in_imag(din_im0), .b_in_real(din_re1), .b_in_imag(din_im1),
            .a_out_real(bf_out_re0), .a_out_imag(bf_out_im0), .b_out_real(bf_out_re1), .b_out_imag(bf_out_im1)
        );

        r2 #(.BITS(BITS))
        butterfly2(
            .clk,   
            .a_in_real(din_re2), .a_in_imag(din_im2), .b_in_real(din_re3), .b_in_imag(din_im3),
            .a_out_real(bf_out_re2), .a_out_imag(bf_out_im2), .b_out_real(bf_out_re3), .b_out_imag(bf_out_im3)
        );

        rotator #(.BITS(BITS+1), .DECIMAL(8)) rot1(.clk, .real_in(bf_out_re1_pip), .imag_in(bf_out_im1_pip), .real_tw(real_tw1), .imag_tw(imag_tw1), .real_out(rot1_out_re), .imag_out(rot1_out_im));
        rotator #(.BITS(BITS+1), .DECIMAL(8)) rot2(.clk, .real_in(bf_out_re2_pip), .imag_in(bf_out_im2_pip), .real_tw(real_tw2), .imag_tw(imag_tw2), .real_out(rot2_out_re), .imag_out(rot2_out_im));
        rotator #(.BITS(BITS+1), .DECIMAL(8)) rot3(.clk, .real_in(bf_out_re3_pip), .imag_in(bf_out_im3_pip), .real_tw(real_tw3), .imag_tw(imag_tw3), .real_out(rot3_out_re), .imag_out(rot3_out_im));
    
        twiddle_rom #(.BITS(16), .DEPTH(1<<(STAGES-CURR_STAGE)), .BRANCH(1)) rom1(.clk, .in_valid, .tw_re(real_tw1), .tw_im(imag_tw1));
        twiddle_rom #(.BITS(16), .DEPTH(1<<(STAGES-CURR_STAGE)), .BRANCH(2)) rom2(.clk, .in_valid, .tw_re(real_tw2), .tw_im(imag_tw2));
        twiddle_rom #(.BITS(16), .DEPTH(1<<(STAGES-CURR_STAGE)), .BRANCH(3)) rom3(.clk, .in_valid, .tw_re(real_tw3), .tw_im(imag_tw3));

        commutator #(.DELAY(1<<(STAGES-CURR_STAGE-1)), .WIDTH(2*BITS+2)) top_comm(.clk, .select(sel), .up_in(comm0), .low_in(comm2), .up_out({dout_re0, dout_im0}), .low_out({dout_re1, dout_im1}));
        commutator #(.DELAY(1<<(STAGES-CURR_STAGE-1)), .WIDTH(2*BITS+2)) bottom_comm(.clk, .select(sel), .up_in(comm1), .low_in(comm3), .up_out({dout_re2, dout_im2}), .low_out({dout_re3, dout_im3}));

    end
    else if ((CURR_STAGE == 3) || (CURR_STAGE == 5) || (CURR_STAGE == 7)) begin : odd_stage   
        logic [BITS:0] bf_out_re0_pip, bf_out_re1_pip, bf_out_re2_pip, bf_out_re3_pip;
        logic [BITS:0] bf_out_im0_pip, bf_out_im1_pip, bf_out_im2_pip, bf_out_im3_pip; 
        logic [2*BITS+1:0] comm0, comm1, comm2, comm3;
        logic [2*BITS+1:0] comm0_out, comm1_out, comm2_out, comm3_out;
        logic [2*BITS+1:0] comm0_out_pip, comm1_out_pip, comm2_out_pip, comm3_out_pip;

        logic [BITS:0] rot_in_re, rot_in_im, rot_out_re, rot_out_im; 

        localparam DELAY = (1<<(STAGES-CURR_STAGE-1)) + 5;
        logic [DELAY-1:0] val; 

        always_ff @(posedge clk, negedge rst) begin 
            if (!rst) begin 
                out_valid <= '0;
                val <= '0;  
            end else begin
                out_valid <= val[DELAY-1];
                val <= {val[DELAY-2:0], in_valid}; 
            end
        end

        always_ff @(posedge clk) begin 
            bf_out_re0_pip <= bf_out_re0; 
            bf_out_re1_pip <= bf_out_re1; 
            bf_out_re2_pip <= bf_out_re2; 
            bf_out_re3_pip <= bf_out_re3; 
            bf_out_im0_pip <= bf_out_im0; 
            bf_out_im1_pip <= bf_out_im1; 
            bf_out_im2_pip <= bf_out_im2; 
            bf_out_im3_pip <= bf_out_im3; 
        end

        logic [STAGES-CURR_STAGE-1:0] count1; 
        logic sel;
        logic [5:0] s; 
        logic [2*BITS+1:0] top_out_pip [0:5];

        always_ff @(posedge clk) begin 
            s <= {s[4:0], count1[STAGES-CURR_STAGE-1]};
            sel <= s[0];
            if (in_valid) begin 
                count1 <= count1 + 1; 
            end else begin 
                count1 <= '0;  
            end
        end

        always_ff @(posedge clk) begin 
            comm0_out_pip <= comm0_out; 
            comm1_out_pip <= comm1_out; 
            comm2_out_pip <= comm2_out; 
            comm3_out_pip <= comm3_out; 
        end

        always_ff @(posedge clk) begin 
            dout_re0 <= comm0_out_pip[2*BITS+1:BITS+1]; 
            dout_re1 <= comm1_out_pip[2*BITS+1:BITS+1]; 
            dout_re2 <= comm2_out_pip[2*BITS+1:BITS+1]; 
            dout_re3 <= rot_out_re;
            dout_im0 <= comm0_out_pip[BITS:0]; 
            dout_im1 <= comm1_out_pip[BITS:0]; 
            dout_im2 <= comm2_out_pip[BITS:0]; 
            dout_im3 <= rot_out_im; 
        end

        always_ff @(posedge clk) begin 
            comm0 <= {bf_out_re0_pip, bf_out_im0_pip};
            comm1 <= {bf_out_re1_pip, bf_out_im1_pip};
            comm2 <= {bf_out_re2_pip, bf_out_im2_pip};
            comm3 <= {bf_out_re3_pip, bf_out_im3_pip};
        end
        
        r2 #(.BITS(BITS))
        butterfly1(
            .clk,
            .a_in_real(din_re0), .a_in_imag(din_im0), .b_in_real(din_re1), .b_in_imag(din_im1),
            .a_out_real(bf_out_re0), .a_out_imag(bf_out_im0), .b_out_real(bf_out_re1), .b_out_imag(bf_out_im1)
        );

        r2 #(.BITS(BITS))
        butterfly2(
            .clk,
            .a_in_real(din_re2), .a_in_imag(din_im2), .b_in_real(din_re3), .b_in_imag(din_im3),
            .a_out_real(bf_out_re2), .a_out_imag(bf_out_im2), .b_out_real(bf_out_re3), .b_out_imag(bf_out_im3)
        );

        triv_rotator #(.BITS(BITS+1)) 
        triv_rot(
            .clk,
            .real_in(comm3_out[2*BITS+1:BITS+1]), .imag_in(comm3_out[BITS:0]),
            .real_out(rot_out_re), .imag_out(rot_out_im)
        );

        commutator #(.DELAY(1<<(STAGES-CURR_STAGE-1)), .WIDTH(2*BITS+2)) top_comm(.clk, .select(sel), .up_in(comm0), .low_in(comm2), .up_out(comm0_out), .low_out(comm1_out));
        commutator #(.DELAY(1<<(STAGES-CURR_STAGE-1)), .WIDTH(2*BITS+2)) bottom_comm(.clk, .select(sel), .up_in(comm1), .low_in(comm3), .up_out(comm2_out), .low_out(comm3_out));

    end
    else if (CURR_STAGE == 8) begin : last_stage

        always_ff @(posedge clk, negedge rst) begin 
            if (!rst) begin 
                out_valid <= '0;
            end else begin
                out_valid <= in_valid;
            end
        end

        r2 #(.BITS(BITS))
        butterfly1(
            .clk,
            .a_in_real(din_re0), .a_in_imag(din_im0), .b_in_real(din_re1), .b_in_imag(din_im1),
            .a_out_real(bf_out_re0), .a_out_imag(bf_out_im0), .b_out_real(bf_out_re1), .b_out_imag(bf_out_im1)
        );

        r2 #(.BITS(BITS))
        butterfly2(
            .clk,
            .a_in_real(din_re2), .a_in_imag(din_im2), .b_in_real(din_re3), .b_in_imag(din_im3),
            .a_out_real(bf_out_re2), .a_out_imag(bf_out_im2), .b_out_real(bf_out_re3), .b_out_imag(bf_out_im3)
        );

        always_ff @(posedge clk) begin  
            dout_re0 <= bf_out_re0; 
            dout_re1 <= bf_out_re1; 
            dout_re2 <= bf_out_re2; 
            dout_re3 <= bf_out_re3; 
            dout_im0 <= bf_out_im0; 
            dout_im1 <= bf_out_im1; 
            dout_im2 <= bf_out_im2; 
            dout_im3 <= bf_out_im3;
        end
    end
endgenerate
endmodule