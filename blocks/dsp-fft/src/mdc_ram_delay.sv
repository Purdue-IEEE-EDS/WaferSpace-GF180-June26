module mdc_ram_delay #(
    parameter int DATA_WIDTH = 32,
    parameter int DELAY_STAGES = 64,
    parameter int ADDR_WIDTH = $clog2(DELAY_STAGES)
)(
    input  logic clk, rst, 
    input  logic [DATA_WIDTH-1:0] din,
    output logic [DATA_WIDTH-1:0] dout
);

    generate 
        if (DELAY_STAGES == 1) begin 
            logic [DATA_WIDTH-1:0] del;
            always_ff @(posedge clk) begin 
                del <= din; 
                dout <= del; 
            end
            assign next_dout = del; 
        end else begin 
            logic [DATA_WIDTH-1:0] mem [0:DELAY_STAGES-1];

            logic [ADDR_WIDTH-1:0] wr_ptr;
            logic [ADDR_WIDTH-1:0] rd_ptr;

            always_ff @(posedge clk, negedge rst) begin
                    if (!rst) begin 
                        rd_ptr <= '0; 
                        wr_ptr <= '0; 
                    end else begin 
                        wr_ptr <= wr_ptr + 1'b1;
                        rd_ptr <= rd_ptr + 1'b1;
                        mem[wr_ptr] <= din;
                    end

            end
            assign next_dout = mem[rd_ptr]; 
        end
    endgenerate

    always_ff @(posedge clk) begin 
        dout <= next_dout; 
    end
endmodule