module reorder
(
    input  logic        clk, rst,   // 160 MHz Parallel Clock
    input  logic        valid_in,   // High when valid serial-de-interleaved data arrives

    input  logic signed [5:0] din0, din1, din2, din3,

    output logic              valid_out,
    output logic signed [5:0] dout0, dout1, dout2, dout3
);

    // assign dout0 = din0; 
    // assign dout1 = din1; 
    // assign dout2 = din2; 
    // assign dout3 = din3;

    // assign valid_out = valid_in; 

    logic [3:0] count; 
    logic sel0;
    logic [3:0] sel1, sel2;
    logic [5:0] sel3; 

    logic [5:0] s0_in [0:3];
    logic [5:0] s1_in [0:3];
    logic [5:0] s2_in [0:3];
    logic [5:0] s3_in [0:3];

    logic [22:0] val;

    always_ff @(posedge clk, negedge rst) begin 
        if (!rst) begin 
            val <= '0; 
            valid_out <= '0; 
        end else begin 
            val <= {val[21:0], valid_in};
            valid_out <= val[22];
        end
    end

    always_ff @(posedge clk) begin 
        if (valid_in) begin 
            count <= count + 1; 
            sel0 <= count[0];
            sel1 <= {sel1[2:0], count[1]};
            sel2 <= {sel2[2:0], ~count[2]};
            sel3 <= {sel3[4:0], ~count[3]};
        end else begin 
            count <= '0; 
            sel0 <= '0; 
            sel1 <= '0; 
            sel2 <= '0;
            sel3 <= '0;  
        end
    end

    always_ff @(posedge clk) begin 
        s0_in[0] <= din0; 
        s0_in[1] <= din1; 
        s0_in[2] <= din2;
        s0_in[3] <= din3; 
    end

    commutator #(
        .DELAY(1),
        .WIDTH(6)
    )
    top_comm1(
        .clk,
        .select(sel0), 
        .up_in(s0_in[0]), .low_in(s0_in[1]), 
        .up_out(s1_in[0]), .low_out(s1_in[2])
    );

    commutator #(
        .DELAY(1),
        .WIDTH(6)
    )
    bottom_comm1(
        .clk,
        .select(sel0), 
        .up_in(s0_in[2]), .low_in(s0_in[3]), 
        .up_out(s1_in[1]), .low_out(s1_in[3])
    );

    commutator #(
        .DELAY(2),
        .WIDTH(6)
    )
    top_comm2(
        .clk,
        .select(sel1[3]), 
        .up_in(s1_in[0]), .low_in(s1_in[1]), 
        .up_out(s2_in[0]), .low_out(s2_in[2])
    );

    commutator #(
        .DELAY(2),
        .WIDTH(6)
    )
    bottom_comm2(
        .clk,
        .select(sel1[3]), 
        .up_in(s1_in[2]), .low_in(s1_in[3]), 
        .up_out(s2_in[1]), .low_out(s2_in[3])
    );

    commutator #(
        .DELAY(4),
        .WIDTH(6)
    )
    top_comm3(
        .clk,
        .select(sel2[3]), 
        .up_in(s2_in[0]), .low_in(s2_in[1]), 
        .up_out(s3_in[0]), .low_out(s3_in[2])
    );

    commutator #(
        .DELAY(4),
        .WIDTH(6)
    )
    bottom_comm3(
        .clk,
        .select(sel2[3]), 
        .up_in(s2_in[2]), .low_in(s2_in[3]), 
        .up_out(s3_in[1]), .low_out(s3_in[3])
    );

    commutator #(
        .DELAY(8),
        .WIDTH(6)
    )
    top_comm4(
        .clk,
        .select(sel3[5]), 
        .up_in(s3_in[0]), .low_in(s3_in[1]), 
        .up_out(dout0), .low_out(dout2)
    );

    commutator #(
        .DELAY(8),
        .WIDTH(6)
    )
    bottom_comm4(
        .clk,
        .select(sel3[5]), 
        .up_in(s3_in[2]), .low_in(s3_in[3]), 
        .up_out(dout1), .low_out(dout3)
    );
    
endmodule
