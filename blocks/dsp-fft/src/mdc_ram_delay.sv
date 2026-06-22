module mdc_ram_delay #(
    parameter int DATA_WIDTH = 32,
    parameter int DELAY_STAGES = 64,
    parameter int ADDR_WIDTH = $clog2(DELAY_STAGES)
)(
    input  logic clk,
    input  logic [DATA_WIDTH-1:0] din, 
    output logic [DATA_WIDTH-1:0] dout
);

    logic [DATA_WIDTH-1:0] shift_reg [DELAY_STAGES-1:0];

    integer i;

    always_ff @(posedge clk) begin
        shift_reg[0] <= din;

        for(i=1; i<DELAY_STAGES; i=i+1)
            shift_reg[i] <= shift_reg[i-1];

        dout <= shift_reg[DELAY_STAGES-1];
        
    end

    // logic [DATA_WIDTH-1:0] next_dout; 

    // generate 
    //     if (DELAY_STAGES == 1) begin 
    //         logic [DATA_WIDTH-1:0] del;
    //         always_ff @(posedge clk) begin 
    //             del <= din; 
    //             dout <= del; 
    //         end
    //         assign next_dout = del; 
    //     end else begin 
    //         logic [DATA_WIDTH/2-1:0] mem_re [0:DELAY_STAGES-1];
    //         logic [DATA_WIDTH/2-1:0] mem_im [0:DELAY_STAGES-1];

    //         logic [ADDR_WIDTH-1:0] wr_ptr_re, wr_ptr_im;
    //         logic [ADDR_WIDTH-1:0] rd_ptr_re, rd_ptr_im;

    //         always_ff @(posedge clk, negedge rst) begin
    //                 if (!rst) begin 
    //                     rd_ptr_re <= '0; 
    //                     wr_ptr_re <= '0; 
    //                     rd_ptr_im <= '0; 
    //                     wr_ptr_im <= '0; 
    //                 end else begin 
    //                     wr_ptr_re <= wr_ptr_re + 1'b1;
    //                     rd_ptr_re <= rd_ptr_re + 1'b1;
    //                     wr_ptr_im <= wr_ptr_im + 1'b1;
    //                     rd_ptr_im <= rd_ptr_im + 1'b1;
    //                     mem_re[wr_ptr_re] <= din[31:16];
    //                     mem_im[wr_ptr_im] <= din[15:0];
    //                 end

    //         end
    //         assign next_dout = {mem_re[rd_ptr_re], mem_im[rd_ptr_im]}; 
    //     end
    // endgenerate

    // always_ff @(posedge clk) begin 
    //     dout <= next_dout; 
    // end
endmodule