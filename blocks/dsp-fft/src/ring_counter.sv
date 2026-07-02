module ring_counter (
    input logic clk, rst, 
    output logic count
);
    logic [3:0] ring_count;
    always_ff @(posedge clk) begin 
        if (!rst) ring_count <= 4'b1000; 
        else ring_count <= {ring_count[2:0], ring_count[3]};
    end

    assign count = ring_count[0];
endmodule