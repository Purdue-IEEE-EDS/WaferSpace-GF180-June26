module reorder_lane
(
    input  logic        clk,
    input  logic        rst,
    input  logic        write_en,
    input  logic        read_en,
    input  logic        w_block_done,
    input  logic        r_block_done,
    input  logic [3:0]  w_addr,
    input  logic [3:0]  r_addr,
    input  logic signed [5:0] din_re,
    input  logic signed [5:0] din_im,
    output logic signed [5:0] dout_re,
    output logic signed [5:0] dout_im
);

    (* keep = "true" *) logic [5:0] mem_re [0:31];
    (* keep = "true" *) logic [5:0] mem_im [0:31];

    logic       buffer_num;
    logic [4:0] rd_addr_re;
    logic [4:0] rd_addr_im;

    always_ff @(posedge clk, negedge rst) begin
        if (!rst)
            buffer_num <= '0;
        else if (w_block_done)
            buffer_num <= ~buffer_num;
        else if (r_block_done)
            buffer_num <= '0;
    end

    always_ff @(posedge clk) begin
        if (write_en) begin
            mem_re[{buffer_num, w_addr}] <= din_re;
            mem_im[{buffer_num, w_addr}] <= din_im;
        end
    end

    // Separate address registers per memory so re/im mux trees are not shared
    always_ff @(posedge clk, negedge rst) begin
        if (!rst)
            rd_addr_re <= '0;
        else if (read_en)
            rd_addr_re <= {~buffer_num, r_addr};
        else
            rd_addr_re <= '0;
    end

    always_ff @(posedge clk, negedge rst) begin
        if (!rst)
            rd_addr_im <= '0;
        else if (read_en)
            rd_addr_im <= {~buffer_num, r_addr};
        else
            rd_addr_im <= '0;
    end

    always_ff @(posedge clk) begin
        dout_re <= mem_re[rd_addr_re];
        dout_im <= mem_im[rd_addr_im];
    end
endmodule

