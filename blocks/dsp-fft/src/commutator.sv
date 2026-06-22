(* keep_hierarchy = "yes" *)
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
    (* keep = "true", dont_touch = "true" *) logic select_pip1;
    (* keep = "true", dont_touch = "true" *) logic select_pip2;

    always_ff @(posedge clk) begin 
        up_in_del <= up_in;
        select_pip1 <= select;
    end

    always_ff @(posedge clk) begin
        select_pip2 <= select;
    end

    mdc_ram_delay #(.DATA_WIDTH(WIDTH), .DELAY_STAGES(DELAY)) delay1(.clk, .din(low_in), .dout(low_in_del));
    mdc_ram_delay #(.DATA_WIDTH(WIDTH), .DELAY_STAGES(DELAY)) delay2(.clk, .din(branch1_sel), .dout(up_out));

    always_comb begin
        // branch1_sel = select_pip1 ? low_in_del : up_in_del;
        if (select_pip1 == 1'b1) branch1_sel = low_in_del;
        else branch1_sel = up_in_del;  
    end 

    always_comb begin  
        // low_out_temp = select_pip2 ? up_in_del: low_in_del;
        if (select_pip2 == 1'b1) low_out_temp = up_in_del;
        else low_out_temp = low_in_del;   
    end
    

    always_ff @(posedge clk) begin 
        low_out <= low_out_temp;
    end
endmodule