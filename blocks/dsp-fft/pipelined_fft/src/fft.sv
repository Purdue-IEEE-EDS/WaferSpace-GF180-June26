`default_nettype none

module fft #(parameter BITS = 32, parameter DECIMAL = 12) 
(
    input logic clk, rst, 
    input logic signed [BITS-1:0] in_real, in_imag, 
    output logic signed [BITS-1:0] out_real, out_imag,
    output logic [8:0] count_out
);

    // TO IMPLEMENT LATER
    // logic [511:0] [2*BITS-1:0] reorder_buf;

    logic [8:0] [2*BITS-1:0] in_data;
    logic [8:0] [2*BITS-1:0] out_data;

    logic [541:0] [8:0] count_buf;

    assign in_data[0] = {in_real, in_imag};
    assign out_real = out_data[8][2*BITS-1:BITS];
    assign out_imag = out_data[8][BITS-1:0];

    assign count_out = count_buf[541];

    always_ff @(posedge clk) begin
        if (!rst) begin 
            count_buf <= '0;
        end
        else begin
            count_buf <= {count_buf[540:0], count_buf[0] + 1'b1};
        end
    end
    
    genvar i;
    generate
        for (i = 0; i < 9; i++) begin : gen_stages
            //localparam int DELAY = compute_delay(i);
            localparam [8:0] MASK  = (9'h1ff << (9-i)); 
            localparam int   DELAY = (i < 8) ? (int'(MASK) + 4*i) : (int'(MASK) + 28);
            stage #(.BITS(BITS), .DECIMAL(DECIMAL), .STAGES(9), .CURR_STAGE(i+1))
            st (
                .clk, .rst,
                .in_real(in_data[i][2*BITS-1:BITS]), .in_imag(in_data[i][BITS-1:0]),
                .out_real(out_data[i][2*BITS-1:BITS]), .out_imag(out_data[i][BITS-1:0]),
                .count(count_buf[DELAY])
            );

            if (i < 8) assign in_data[i+1] = out_data[i];
        end

    endgenerate

    function automatic int compute_delay(input int i);
        if (i < 8)
            return (((9'h1ff >> (9-i)) << (9-i)) + 4*i);
        else
            return (((9'h1ff >> (9-i)) << (9-i)) + 28);
    endfunction
endmodule