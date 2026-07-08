(* keep_hierarchy = "yes" *)

module splitnets(
    input logic clk,
    input logic [3:0] din, 
    output logic [3:0] dout

); 
    always_ff @(posedge clk) begin 
        dout <= din; 
    end
endmodule