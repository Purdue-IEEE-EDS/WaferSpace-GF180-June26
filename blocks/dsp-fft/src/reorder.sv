module reorder
(
    input logic clk, 
    input logic signed [5:0] din_re0, din_re1, din_re2, din_re3,
    input logic signed [5:0] din_im0, din_im1, din_im2, din_im3, 
    input logic valid_in, 

    output logic signed [5:0] din_re0_r, din_re1_r, din_re2_r, din_re3_r,
    output logic signed [5:0] din_im0_r, din_im1_r, din_im2_r, din_im3_r, 
    output logic valid_out
);
    local products;
    
    logic [3:0] waddr_cnt; // 0 to 15 tracking the write cycle in a frame
    logic [3:0] raddr_cnt; // 0 to 15 tracking the read cycle in a frame
    logic       ping_pong_w; // Tracks which frame is being written (0 or 1)
    logic       ping_pong_r; // Tracks which frame is being read (0 or 1)
    logic       frame_ready; // Asserted when a full frame is buffered
    logic       reading;     // Actively reading out a frame

    // 4 Independent Memory Banks to allow 4 parallel reads/writes per cycle
    // Width: 12 bits (6-bit Real + 6-bit Imag). Depth: 32 (16 rows * 2 frames)
    logic [11:0] bank_mem [0:3][0:31];

    // Pack input signals into buses for algorithmic routing
    logic [11:0] win_data [0:3];
    assign win_data[0] = {din_re0, din_im0};
    assign win_data[1] = {din_re1, din_im1};
    assign win_data[2] = {din_re2, din_im2};
    assign win_data[3] = {din_re3, din_im3};

    always_ff @(posedge clk) begin
        // Write Pointer Management
        if (valid_in) begin
            if (waddr_cnt == 4'd15) begin
                waddr_cnt   <= '0;
                ping_pong_w <= ~ping_pong_w;
                frame_ready <= 1'b1; // Signal that a frame is ready to read
            end else begin
                waddr_cnt   <= waddr_cnt + 1'b1;
            end
        end

        // Read Pointer Management
        if (frame_ready || reading) begin
            reading   <= 1'b1;
            valid_out <= 1'b1;
            if (raddr_cnt == 4'd15) begin
                raddr_cnt   <= '0;
                ping_pong_r <= ~ping_pong_r;
                reading     <= 1'b0;
                frame_ready <= 1'b0; // Clear flag unless another frame dropped in
            end else begin
                raddr_cnt   <= raddr_cnt + 1'b1;
            end
        end else begin
            valid_out <= 1'b0;
        end
    end

    // -------------------------------------------------------------------------
    // WRITE PORT: Diagonalized Mapping to Prevent Bank Conflicts
    // -------------------------------------------------------------------------
    // Shift physical bank allocation dynamically cycle-by-cycle: Bank = (Path + waddr_cnt) mod 4
    always_ff @(posedge clk) begin
        if (valid_in) begin
            case (waddr_cnt[1:0])
                2'b00: begin
                    bank_mem[0][{ping_pong_w, waddr_cnt}] <= win_data[0];
                    bank_mem[1][{ping_pong_w, waddr_cnt}] <= win_data[1];
                    bank_mem[2][{ping_pong_w, waddr_cnt}] <= win_data[2];
                    bank_mem[3][{ping_pong_w, waddr_cnt}] <= win_data[3];
                end
                2'b01: begin
                    bank_mem[3][{ping_pong_w, waddr_cnt}] <= win_data[0];
                    bank_mem[0][{ping_pong_w, waddr_cnt}] <= win_data[1];
                    bank_mem[1][{ping_pong_w, waddr_cnt}] <= win_data[2];
                    bank_mem[2][{ping_pong_w, waddr_cnt}] <= win_data[3];
                end
                2'b10: begin
                    bank_mem[2][{ping_pong_w, waddr_cnt}] <= win_data[0];
                    bank_mem[3][{ping_pong_w, waddr_cnt}] <= win_data[1];
                    bank_mem[0][{ping_pong_w, waddr_cnt}] <= win_data[2];
                    bank_mem[1][{ping_pong_w, waddr_cnt}] <= win_data[3];
                end
                2'b11: begin
                    bank_mem[1][{ping_pong_w, waddr_cnt}] <= win_data[0];
                    bank_mem[2][{ping_pong_w, waddr_cnt}] <= win_data[1];
                    bank_mem[3][{ping_pong_w, waddr_cnt}] <= win_data[2];
                    bank_mem[0][{ping_pong_w, waddr_cnt}] <= win_data[3];
                end
            endcase
        end
    end

    // -------------------------------------------------------------------------
    // READ PORT: Custom MDC Frame Lane Interleaving Addressing
    // -------------------------------------------------------------------------
    // Lane 0: Samples 0 to 15   -> Mapping translates to base Write Address: raddr_cnt
    // Lane 1: Samples 32 to 47  -> Mapping translates to base Write Address: raddr_cnt + 8
    // Lane 2: Samples 16 to 31  -> Mapping translates to base Write Address: raddr_cnt + 4
    // Lane 3: Samples 48 to 63  -> Mapping translates to base Write Address: raddr_cnt + 12

    logic [3:0] raddr_lane0, raddr_lane1, raddr_lane2, raddr_lane3;
    assign raddr_lane0 = raddr_cnt;
    assign raddr_lane1 = raddr_cnt + 4'd8;
    assign raddr_lane2 = raddr_cnt + 4'd4;
    assign raddr_lane3 = raddr_cnt + 4'd12;

    // Resolve which physical bank contains the needed sample based on the diagonal write rule
    // Bank selection formula: Bank = (Target_Sample_Index) mod 4
    // For your specific lane mapping rules, the bank selections evaluate to:
    // Lane 0 (index 4*k)   -> Bank = (0 + raddr_cnt) mod 4
    // Lane 1 (index 4*k+32)-> Bank = (32 + raddr_cnt) mod 4 -> (0 + raddr_cnt) mod 4
    // Lane 2 (index 4*k+16)-> Bank = (16 + raddr_cnt) mod 4 -> (0 + raddr_cnt) mod 4
    // Lane 3 (index 4*k+48)-> Bank = (48 + raddr_cnt) mod 4 -> (0 + raddr_cnt) mod 4
    // Critical realization: All lanes resolve to the exact same physical bank offset structure! 
    // The cyclic mux shifts identically across all lanes based on raddr_cnt[1:0].

    logic [11:0] rout_data [0:3];

    always_comb begin
        // Default assignment to avoid latches
        rout_data[0] = '0; rout_data[1] = '0; rout_data[2] = '0; rout_data[3] = '0;
        
        case (raddr_cnt[1:0])
            2'b00: begin
                rout_data[0] = bank_mem[0][{ping_pong_r, raddr_lane0}];
                rout_data[1] = bank_mem[1][{ping_pong_r, raddr_lane1}];
                rout_data[2] = bank_mem[2][{ping_pong_r, raddr_lane2}];
                rout_data[3] = bank_mem[3][{ping_pong_r, raddr_lane3}];
            end
            2'b01: begin
                rout_data[0] = bank_mem[1][{ping_pong_r, raddr_lane0}];
                rout_data[1] = bank_mem[2][{ping_pong_r, raddr_lane1}];
                rout_data[2] = bank_mem[3][{ping_pong_r, raddr_lane2}];
                rout_data[3] = bank_mem[0][{ping_pong_r, raddr_lane3}];
            end
            2'b10: begin
                rout_data[0] = bank_mem[2][{ping_pong_r, raddr_lane0}];
                rout_data[1] = bank_mem[3][{ping_pong_r, raddr_lane1}];
                rout_data[2] = bank_mem[0][{ping_pong_r, raddr_lane2}];
                rout_data[3] = bank_mem[1][{ping_pong_r, raddr_lane3}];
            end
            2'b11: begin
                rout_data[0] = bank_mem[3][{ping_pong_r, raddr_lane0}];
                rout_data[1] = bank_mem[0][{ping_pong_r, raddr_lane1}];
                rout_data[2] = bank_mem[1][{ping_pong_r, raddr_lane2}];
                rout_data[3] = bank_mem[2][{ping_pong_r, raddr_lane3}];
            end
        endcase
    end

    // Unpack and route to registered outputs for clean structural timing boundaries
    always_ff @(posedge clk) begin
        if (!rst_n) begin
            din_re0_r <= '0; din_im0_r <= '0;
            din_re1_r <= '0; din_im1_r <= '0;
            din_re2_r <= '0; din_im2_r <= '0;
            din_re3_r <= '0; din_im3_r <= '0;
        end else if (reading) begin
            din_re0_r <= rout_data[0][11:6];
            din_im0_r <= rout_data[0][5:0];
            
            din_re1_r <= rout_data[1][11:6];
            din_im1_r <= rout_data[1][5:0];
            
            din_re2_r <= rout_data[2][11:6];
            din_im2_r <= rout_data[2][5:0];
            
            din_re3_r <= rout_data[3][11:6];
            din_im3_r <= rout_data[3][5:0];
        end
    end
endmodule