module commutator #(
    parameter DELAY = 1,
    parameter WIDTH = 16
)
(
    input logic clk, 
    input logic select, 
    input logic [WIDTH-1:0] up_in, low_in, 
    output logic [WIDTH-1:0] up_out, low_out
);

    logic [WIDTH-1:0] low_in_del, low_in_del2, up_in_del, branch1_sel, low_out_temp; 
    (* keep *) logic select_pip1;
    (* keep *) logic select_pip2;

    always_ff @(posedge clk) begin 
        up_in_del <= up_in;
        select_pip1 <= select;
        select_pip2 <= select;
    end

    mdc_ram_delay #(.DATA_WIDTH(WIDTH), .DELAY_STAGES(DELAY)) delay1(.clk, .en(1'b1), .din(low_in), .dout(low_in_del));
    mdc_ram_delay #(.DATA_WIDTH(WIDTH), .DELAY_STAGES(DELAY)) delay2(.clk, .en(1'b1), .din(branch1_sel), .dout(up_out));

    always_comb begin
        branch1_sel = select_pip1 ? low_in_del : up_in_del;
    end 

    always_comb begin  
        low_out_temp = select_pip2 ? up_in_del: low_in_del;  
    end
    

    always_ff @(posedge clk) begin 
        low_out <= low_out_temp;
    end
endmodule