(* keep_hierarchy = "yes" *)
module serial_to_parallel16(
    input logic clk, rst,
    input logic [5:0] din, 
    output logic [5:0] dout0, dout1, dout2, dout3
); 

    serial_to_parallel stp0 (.clk, .rst, .din(din[0]), .dout({dout3[0], dout2[0], dout1[0], dout0[0]}));

    genvar i;
    generate
        for (i = 1; i < 6; i++) begin 
            serial_to_parallel stp (.clk, .rst, .din(din[i]), .dout({dout3[i], dout2[i], dout1[i], dout0[i]}));
        end
    endgenerate

endmodule