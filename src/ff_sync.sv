module ff_sync #(WIDTH=6) 
(
    input logic clk,
    input logic [WIDTH-1:0] data_in, 
    output logic [WIDTH-1:0] sync_data
);
    logic [WIDTH-1:0] sync1, sync2;

    assign sync_data = sync2; 
    
    always_ff @(posedge clk) begin 
        sync1 <= data_in; 
        sync2 <= sync1; 
    end

endmodule