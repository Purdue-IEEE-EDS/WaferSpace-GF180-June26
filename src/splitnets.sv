(* keep_hierarchy = "yes" *)

module splitnets(
    input logic clk,
    input logic din, 
    output logic [3:0] dout

); 
    always_ff @(posedge clk) begin 
        dout <= {din, din, din, din}; 
    end
endmodule