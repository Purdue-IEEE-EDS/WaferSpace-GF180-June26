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
endmodule