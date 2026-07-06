(* keep_hierarchy = "yes" *)
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

    // logic [1:0] counter; 

    // always_ff @(posedge clk) begin 
    //     if (!rst) counter <= '0; 
    //     else counter <= counter + 1'b1; 
    // end

    // always_ff @(posedge clk) begin 
    //     if (!rst) count <= '0; 
    //     else count <= (counter == '0);
    // end
endmodule