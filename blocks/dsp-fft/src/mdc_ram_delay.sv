module mdc_ram_delay #(
    parameter DATA_WIDTH = 32,
    parameter DELAY_STAGES = 64,
    parameter ADDR_WIDTH = $clog2(DELAY_STAGES)
)(
    input  logic                   clk,
    input  logic                   en,
    input  logic [DATA_WIDTH-1:0]  din,
    output logic [DATA_WIDTH-1:0]  dout
);

    logic [DATA_WIDTH-1:0] shift_reg [DELAY_STAGES-1:0];

integer i;

always_ff @(posedge clk) begin
    if(en) begin
        shift_reg[0] <= din;

        for(i=1; i<DELAY_STAGES; i=i+1)
            shift_reg[i] <= shift_reg[i-1];

        dout <= shift_reg[DELAY_STAGES-1];
    end
end

endmodule