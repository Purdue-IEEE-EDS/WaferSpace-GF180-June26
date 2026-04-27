`default_nettype none

module stage #(
    parameter BITS = 16, 
    parameter STAGES=3, 
    parameter CURR_STAGE=1,
    parameter CNT_BITS = STAGES-CURR_STAGE+1)
(
    input logic clk, rst,
    input logic in_valid, 
    input logic signed [BITS-1:0] in_real, in_imag, 
    output logic signed [BITS-1:0] out_real, out_imag,
    output logic out_valid
);


logic [CNT_BITS-1:0] cnt, cnt_d;

always_ff @(posedge clk, negedge rst) begin 
    if (!rst) begin 
        cnt <= '0; 
        cnt_d <= '0;
    end else begin 
        if (in_valid) begin 
            cnt <= cnt+1; 
            cnt_d <= cnt;
        end else begin 
            cnt <= '0;
            cnt_d <= cnt; 
        end
    end
end

generate
    if (STAGES == CURR_STAGE) begin 
        logic signed [BITS-1:0] x, y, b_in_real, b_in_imag; 
        logic mode; 

        always_ff @(posedge clk, negedge rst) begin 
            if (!rst) begin 
                mode <= '0; 
                b_in_real <= '0; 
                b_in_imag <= '0;
            end else begin 
                mode <= cnt[0];
                b_in_real <= in_real; 
                b_in_imag <= in_imag;
            end
        end

        r2 #(
                .BITS(BITS)
            ) 
            butterfly (
                .clk(clk), .rst(rst),
                .mode(mode), 
                .a_in_real(x), .a_in_imag(y), .b_in_real(b_in_real), .b_in_imag(b_in_imag),
                .a_out_real(out_real), .a_out_imag(out_imag), .b_out_real(x), .b_out_imag(y)
            );

            localparam LATENCY = 3; 
            logic [LATENCY-1:0] valid_pipe;

            always_ff @(posedge clk, negedge rst) begin
                if (!rst)
                    valid_pipe <= '0;
                else
                    valid_pipe <= {valid_pipe[LATENCY-2:0], in_valid};
            end

            assign out_valid = valid_pipe[LATENCY-1];
    end 
    else if (STAGES == CURR_STAGE + 1) begin 
        localparam BUFF_BITS   = STAGES - CURR_STAGE;
        localparam BUFF_SIZE  = (1 << BUFF_BITS);

        logic signed [2*BITS-1:0] buff_reg [0:BUFF_SIZE-1];
        logic signed [BITS-1:0] a_in_real, a_in_imag, b_in_real, b_in_imag, b_out_real, b_out_imag, rot_re, rot_im; 
            
        assign a_in_real = buff_reg[cnt[CNT_BITS-2:0]][2*BITS-1:BITS];
        assign a_in_imag = buff_reg[cnt[CNT_BITS-2:0]][BITS-1:0];

        logic mode, rot_en; 

        always_ff @(posedge clk, negedge rst) begin 
            if (!rst) begin 
                mode <= '0; 
                rot_en <= '0;
                b_in_real <= '0; 
                b_in_imag <= '0; 
            end else begin 
                mode <= cnt[1]; 
                rot_en <= cnt[1]&~cnt[0];
                b_in_real <= in_real; 
                b_in_imag <= in_imag;
            end
        end

        always_ff @(posedge clk, negedge rst) begin
            if (!rst) begin
                for (int i = 0; i < BUFF_SIZE; i++) begin
                    buff_reg[i] <= '0;
                end
            end
            else begin
                buff_reg[cnt_d[CNT_BITS-2:0]] <= {b_out_real, b_out_imag}; 
            end
        end
        r2 #(
                .BITS(BITS)
            ) 
            butterfly (
                .clk(clk), .rst(rst),
                .mode(mode), 
                .a_in_real(a_in_real), .a_in_imag(a_in_imag), .b_in_real(b_in_real), .b_in_imag(b_in_imag),
                .a_out_real(rot_re), .a_out_imag(rot_im), .b_out_real(b_out_real), .b_out_imag(b_out_imag)
            );

            triv_rotator #(.BITS(16), .DECIMAL(8)) 
            triv_rot(
                .clk, .rst, 
                .rot_en(rot_en),
                .real_in(rot_re), .imag_in(rot_im),
                .real_out(out_real), .imag_out(out_imag)
            );

            localparam LATENCY = 4; 
            logic [LATENCY-1:0] valid_pipe;

            assign out_valid = valid_pipe[LATENCY-1];

            always_ff @(posedge clk or negedge rst) begin
                if (!rst)
                    valid_pipe <= '0;
                else
                    valid_pipe <= {valid_pipe[LATENCY-2:0], in_valid};
            end
    end
    else begin 
        localparam BUFF_BITS   = STAGES - CURR_STAGE;
        localparam BUFF_SIZE  = (1 << BUFF_BITS);

        localparam int ROM_DEPTH = 1 << (STAGES - CURR_STAGE);

        logic signed [2*BITS-1:0] buff_reg [0:BUFF_SIZE-1];
        logic signed [BITS-1:0] a_in_real, a_in_imag, b_out_real, b_out_imag, rot_re, rot_im, p_rot_re, p_rot_im, tw_re, tw_im, b_in_real, b_in_imag; 

        assign a_in_real = buff_reg[cnt[CNT_BITS-2:0]][2*BITS-1:BITS];
        assign a_in_imag = buff_reg[cnt[CNT_BITS-2:0]][BITS-1:0];

        logic [CNT_BITS-2:0] addr, p_addr; 
        logic en, p_en; 

        always_ff @(posedge clk, negedge rst) begin 
            if (!rst) begin 
                addr <= '0; 
                en <= '0; 
                p_rot_re <= '0;
                p_rot_im <= '0; 
                b_in_real <= '0; 
                b_in_imag <= '0;
                p_en <= '0; 
                p_addr <= '0; 
            end else begin 
                addr <= cnt[CNT_BITS-2:0]; 
                en <= cnt[CNT_BITS-1];
                p_rot_re <= rot_re; 
                p_rot_im <= rot_im;
                b_in_real <= in_real; 
                b_in_imag <= in_imag;
                p_en <= en; 
                p_addr <= addr; 
            end
        end

        always_ff @(posedge clk, negedge rst) begin
            if (!rst) begin
                for (int i = 0; i < BUFF_SIZE; i++) begin
                    buff_reg[i] <= '0;
                end
            end
            else begin
                buff_reg[cnt_d[CNT_BITS-2:0]] <= {b_out_real, b_out_imag}; 
            end
        end
        r2 #(
                .BITS(BITS)
            ) 
            butterfly (
                .clk(clk), .rst(rst),
                .mode(en), 
                .a_in_real(a_in_real), .a_in_imag(a_in_imag), .b_in_real(b_in_real), .b_in_imag(b_in_imag),
                .a_out_real(rot_re), .a_out_imag(rot_im), .b_out_real(b_out_real), .b_out_imag(b_out_imag)
            );

            rotator #(.BITS(BITS), .DECIMAL(8)) 
            rot (
                .clk(clk), .rst(rst), 
                .real_in(p_rot_re), .imag_in(p_rot_im), .real_tw(tw_re), .imag_tw(tw_im),
                .real_out(out_real), .imag_out(out_imag)
            );

            twiddle_rom #(
                .BITS(16),
                .DEPTH(ROM_DEPTH)
            )tw_rom(
                .clk, .rst, 
                .en(p_en), 
                .addr(p_addr),
                .tw_re,
                .tw_im
            );

            localparam LATENCY = ROM_DEPTH + 6; 
            logic [LATENCY-1:0] valid_pipe;

            always_ff @(posedge clk or negedge rst) begin
                if (!rst)
                    valid_pipe <= '0;
                else
                    valid_pipe <= {valid_pipe[LATENCY-2:0], in_valid};
            end

            assign out_valid = valid_pipe[LATENCY-1];
    end
endgenerate

endmodule