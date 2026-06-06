module twiddle_rom #(
    parameter int BITS = 16,
    parameter int DEPTH = 16,
    parameter int BRANCH = 1,
    parameter int ADDR_W = $clog2(DEPTH)
)(
    input  logic clk, rst,
    input logic in_valid, 
    output logic signed [BITS-1:0] tw_re,
    output logic signed [BITS-1:0] tw_im
);

    logic signed [2*BITS-1:0] rom [0:DEPTH-1];

    (* keep *) logic [ADDR_W-1:0] addr_re; 
    (* keep *) logic [ADDR_W-1:0] addr_im;

    always_ff @(posedge clk) begin 
        if (in_valid) addr_re <= addr_re + 1; 
        else addr_re <= '0; 
    end

    always_ff @(posedge clk) begin 
        if (in_valid) addr_im <= addr_im + 1; 
        else addr_im <= '0; 
    end

    generate 
        if ((DEPTH == 64) && (BRANCH == 1)) begin : rom_256_1k
        always_ff @(posedge clk) begin
                case(addr_re)
                        6'd0: tw_re = 16'h1000;
                        6'd1: tw_re <= 16'h0ffe;
                        6'd2: tw_re <= 16'h0ffb;
                        6'd3: tw_re <= 16'h0ff4;
                        6'd4: tw_re <= 16'h0fec;
                        6'd5: tw_re <= 16'h0fe1;
                        6'd6: tw_re <= 16'h0fd3;
                        6'd7: tw_re <= 16'h0fc3;
                        6'd8: tw_re <= 16'h0fb1;
                        6'd9: tw_re <= 16'h0f9c;
                        6'd10: tw_re <= 16'h0f85;
                        6'd11: tw_re <= 16'h0f6b;
                        6'd12: tw_re <= 16'h0f4f;
                        6'd13: tw_re <= 16'h0f31;
                        6'd14: tw_re <= 16'h0f10;
                        6'd15: tw_re <= 16'h0eed;
                        6'd16: tw_re <= 16'h0ec8;
                        6'd17: tw_re <= 16'h0ea0;
                        6'd18: tw_re <= 16'h0e76;
                        6'd19: tw_re <= 16'h0e4a;
                        6'd20: tw_re <= 16'h0e1c;
                        6'd21: tw_re <= 16'h0deb;
                        6'd22: tw_re <= 16'h0db9;
                        6'd23: tw_re <= 16'h0d84;
                        6'd24: tw_re <= 16'h0d4d;
                        6'd25: tw_re <= 16'h0d14;
                        6'd26: tw_re <= 16'h0cd9;
                        6'd27: tw_re <= 16'h0c9d;
                        6'd28: tw_re <= 16'h0c5e;
                        6'd29: tw_re <= 16'h0c1d;
                        6'd30: tw_re <= 16'h0bda;
                        6'd31: tw_re <= 16'h0b96;
                        6'd32: tw_re <= 16'h0b50;
                        6'd33: tw_re <= 16'h0b08;
                        6'd34: tw_re <= 16'h0abe;
                        6'd35: tw_re <= 16'h0a73;
                        6'd36: tw_re <= 16'h0a26;
                        6'd37: tw_re <= 16'h09d7;
                        6'd38: tw_re <= 16'h0987;
                        6'd39: tw_re <= 16'h0936;
                        6'd40: tw_re <= 16'h08e3;
                        6'd41: tw_re <= 16'h088f;
                        6'd42: tw_re <= 16'h0839;
                        6'd43: tw_re <= 16'h07e2;
                        6'd44: tw_re <= 16'h078a;
                        6'd45: tw_re <= 16'h0731;
                        6'd46: tw_re <= 16'h06d7;
                        6'd47: tw_re <= 16'h067b;
                        6'd48: tw_re <= 16'h061f;
                        6'd49: tw_re <= 16'h05c2;
                        6'd50: tw_re <= 16'h0563;
                        6'd51: tw_re <= 16'h0504;
                        6'd52: tw_re <= 16'h04a5;
                        6'd53: tw_re <= 16'h0444;
                        6'd54: tw_re <= 16'h03e3;
                        6'd55: tw_re <= 16'h0381;
                        6'd56: tw_re <= 16'h031f;
                        6'd57: tw_re <= 16'h02bc;
                        6'd58: tw_re <= 16'h0259;
                        6'd59: tw_re <= 16'h01f5;
                        6'd60: tw_re <= 16'h0191;
                        6'd61: tw_re <= 16'h012d;
                        6'd62: tw_re <= 16'h00c8;
                        6'd63: tw_re <= 16'h0064;
                endcase


                case(addr_im)
                        6'd0: tw_im <= 16'h0000;
                        6'd1: tw_im <= 16'hff9c;
                        6'd2: tw_im <= 16'hff38;
                        6'd3: tw_im <= 16'hfed3;
                        6'd4: tw_im <= 16'hfe6f;
                        6'd5: tw_im <= 16'hfe0b;
                        6'd6: tw_im <= 16'hfda7;
                        6'd7: tw_im <= 16'hfd44;
                        6'd8: tw_im <= 16'hfce1;
                        6'd9: tw_im <= 16'hfc7f;
                        6'd10: tw_im <= 16'hfc1d;
                        6'd11: tw_im <= 16'hfbbc;
                        6'd12: tw_im <= 16'hfb5b;
                        6'd13: tw_im <= 16'hfafc;
                        6'd14: tw_im <= 16'hfa9d;
                        6'd15: tw_im <= 16'hfa3e;
                        6'd16: tw_im <= 16'hf9e1;
                        6'd17: tw_im <= 16'hf985;
                        6'd18: tw_im <= 16'hf929;
                        6'd19: tw_im <= 16'hf8cf;
                        6'd20: tw_im <= 16'hf876;
                        6'd21: tw_im <= 16'hf81e;
                        6'd22: tw_im <= 16'hf7c7;
                        6'd23: tw_im <= 16'hf771;
                        6'd24: tw_im <= 16'hf71d;
                        6'd25: tw_im <= 16'hf6ca;
                        6'd26: tw_im <= 16'hf679;
                        6'd27: tw_im <= 16'hf629;
                        6'd28: tw_im <= 16'hf5da;
                        6'd29: tw_im <= 16'hf58d;
                        6'd30: tw_im <= 16'hf542;
                        6'd31: tw_im <= 16'hf4f8;
                        6'd32: tw_im <= 16'hf4b0;
                        6'd33: tw_im <= 16'hf46a;
                        6'd34: tw_im <= 16'hf426;
                        6'd35: tw_im <= 16'hf3e3;
                        6'd36: tw_im <= 16'hf3a2;
                        6'd37: tw_im <= 16'hf363;
                        6'd38: tw_im <= 16'hf327;
                        6'd39: tw_im <= 16'hf2ec;
                        6'd40: tw_im <= 16'hf2b3;
                        6'd41: tw_im <= 16'hf27c;
                        6'd42: tw_im <= 16'hf247;
                        6'd43: tw_im <= 16'hf215;
                        6'd44: tw_im <= 16'hf1e4;
                        6'd45: tw_im <= 16'hf1b6;
                        6'd46: tw_im <= 16'hf18a;
                        6'd47: tw_im <= 16'hf160;
                        6'd48: tw_im <= 16'hf138;
                        6'd49: tw_im <= 16'hf113;
                        6'd50: tw_im <= 16'hf0f0;
                        6'd51: tw_im <= 16'hf0cf;
                        6'd52: tw_im <= 16'hf0b1;
                        6'd53: tw_im <= 16'hf095;
                        6'd54: tw_im <= 16'hf07b;
                        6'd55: tw_im <= 16'hf064;
                        6'd56: tw_im <= 16'hf04f;
                        6'd57: tw_im <= 16'hf03d;
                        6'd58: tw_im <= 16'hf02d;
                        6'd59: tw_im <= 16'hf01f;
                        6'd60: tw_im <= 16'hf014;
                        6'd61: tw_im <= 16'hf00c;
                        6'd62: tw_im <= 16'hf005;
                        6'd63: tw_im <= 16'hf002;
                endcase
        end
end
if ((DEPTH == 64) && (BRANCH == 2)) begin : rom_256_2k
        always_ff @(posedge clk) begin
                case(addr_re)
                        6'd0: tw_re <= 16'h1000;
                        6'd1: tw_re <= 16'h0ffb;
                        6'd2: tw_re <= 16'h0fec;
                        6'd3: tw_re <= 16'h0fd3;
                        6'd4: tw_re <= 16'h0fb1;
                        6'd5: tw_re <= 16'h0f85;
                        6'd6: tw_re <= 16'h0f4f;
                        6'd7: tw_re <= 16'h0f10;
                        6'd8: tw_re <= 16'h0ec8;
                        6'd9: tw_re <= 16'h0e76;
                        6'd10: tw_re <= 16'h0e1c;
                        6'd11: tw_re <= 16'h0db9;
                        6'd12: tw_re <= 16'h0d4d;
                        6'd13: tw_re <= 16'h0cd9;
                        6'd14: tw_re <= 16'h0c5e;
                        6'd15: tw_re <= 16'h0bda;
                        6'd16: tw_re <= 16'h0b50;
                        6'd17: tw_re <= 16'h0abe;
                        6'd18: tw_re <= 16'h0a26;
                        6'd19: tw_re <= 16'h0987;
                        6'd20: tw_re <= 16'h08e3;
                        6'd21: tw_re <= 16'h0839;
                        6'd22: tw_re <= 16'h078a;
                        6'd23: tw_re <= 16'h06d7;
                        6'd24: tw_re <= 16'h061f;
                        6'd25: tw_re <= 16'h0563;
                        6'd26: tw_re <= 16'h04a5;
                        6'd27: tw_re <= 16'h03e3;
                        6'd28: tw_re <= 16'h031f;
                        6'd29: tw_re <= 16'h0259;
                        6'd30: tw_re <= 16'h0191;
                        6'd31: tw_re <= 16'h00c8;
                        6'd32: tw_re <= 16'h0000;
                        6'd33: tw_re <= 16'hff38;
                        6'd34: tw_re <= 16'hfe6f;
                        6'd35: tw_re <= 16'hfda7;
                        6'd36: tw_re <= 16'hfce1;
                        6'd37: tw_re <= 16'hfc1d;
                        6'd38: tw_re <= 16'hfb5b;
                        6'd39: tw_re <= 16'hfa9d;
                        6'd40: tw_re <= 16'hf9e1;
                        6'd41: tw_re <= 16'hf929;
                        6'd42: tw_re <= 16'hf876;
                        6'd43: tw_re <= 16'hf7c7;
                        6'd44: tw_re <= 16'hf71d;
                        6'd45: tw_re <= 16'hf679;
                        6'd46: tw_re <= 16'hf5da;
                        6'd47: tw_re <= 16'hf542;
                        6'd48: tw_re <= 16'hf4b0;
                        6'd49: tw_re <= 16'hf426;
                        6'd50: tw_re <= 16'hf3a2;
                        6'd51: tw_re <= 16'hf327;
                        6'd52: tw_re <= 16'hf2b3;
                        6'd53: tw_re <= 16'hf247;
                        6'd54: tw_re <= 16'hf1e4;
                        6'd55: tw_re <= 16'hf18a;
                        6'd56: tw_re <= 16'hf138;
                        6'd57: tw_re <= 16'hf0f0;
                        6'd58: tw_re <= 16'hf0b1;
                        6'd59: tw_re <= 16'hf07b;
                        6'd60: tw_re <= 16'hf04f;
                        6'd61: tw_re <= 16'hf02d;
                        6'd62: tw_re <= 16'hf014;
                        6'd63: tw_re <= 16'hf005;
                endcase


                case(addr_im)
                        6'd0: tw_im <= 16'h0000;
                        6'd1: tw_im <= 16'hff38;
                        6'd2: tw_im <= 16'hfe6f;
                        6'd3: tw_im <= 16'hfda7;
                        6'd4: tw_im <= 16'hfce1;
                        6'd5: tw_im <= 16'hfc1d;
                        6'd6: tw_im <= 16'hfb5b;
                        6'd7: tw_im <= 16'hfa9d;
                        6'd8: tw_im <= 16'hf9e1;
                        6'd9: tw_im <= 16'hf929;
                        6'd10: tw_im <= 16'hf876;
                        6'd11: tw_im <= 16'hf7c7;
                        6'd12: tw_im <= 16'hf71d;
                        6'd13: tw_im <= 16'hf679;
                        6'd14: tw_im <= 16'hf5da;
                        6'd15: tw_im <= 16'hf542;
                        6'd16: tw_im <= 16'hf4b0;
                        6'd17: tw_im <= 16'hf426;
                        6'd18: tw_im <= 16'hf3a2;
                        6'd19: tw_im <= 16'hf327;
                        6'd20: tw_im <= 16'hf2b3;
                        6'd21: tw_im <= 16'hf247;
                        6'd22: tw_im <= 16'hf1e4;
                        6'd23: tw_im <= 16'hf18a;
                        6'd24: tw_im <= 16'hf138;
                        6'd25: tw_im <= 16'hf0f0;
                        6'd26: tw_im <= 16'hf0b1;
                        6'd27: tw_im <= 16'hf07b;
                        6'd28: tw_im <= 16'hf04f;
                        6'd29: tw_im <= 16'hf02d;
                        6'd30: tw_im <= 16'hf014;
                        6'd31: tw_im <= 16'hf005;
                        6'd32: tw_im <= 16'hf000;
                        6'd33: tw_im <= 16'hf005;
                        6'd34: tw_im <= 16'hf014;
                        6'd35: tw_im <= 16'hf02d;
                        6'd36: tw_im <= 16'hf04f;
                        6'd37: tw_im <= 16'hf07b;
                        6'd38: tw_im <= 16'hf0b1;
                        6'd39: tw_im <= 16'hf0f0;
                        6'd40: tw_im <= 16'hf138;
                        6'd41: tw_im <= 16'hf18a;
                        6'd42: tw_im <= 16'hf1e4;
                        6'd43: tw_im <= 16'hf247;
                        6'd44: tw_im <= 16'hf2b3;
                        6'd45: tw_im <= 16'hf327;
                        6'd46: tw_im <= 16'hf3a2;
                        6'd47: tw_im <= 16'hf426;
                        6'd48: tw_im <= 16'hf4b0;
                        6'd49: tw_im <= 16'hf542;
                        6'd50: tw_im <= 16'hf5da;
                        6'd51: tw_im <= 16'hf679;
                        6'd52: tw_im <= 16'hf71d;
                        6'd53: tw_im <= 16'hf7c7;
                        6'd54: tw_im <= 16'hf876;
                        6'd55: tw_im <= 16'hf929;
                        6'd56: tw_im <= 16'hf9e1;
                        6'd57: tw_im <= 16'hfa9d;
                        6'd58: tw_im <= 16'hfb5b;
                        6'd59: tw_im <= 16'hfc1d;
                        6'd60: tw_im <= 16'hfce1;
                        6'd61: tw_im <= 16'hfda7;
                        6'd62: tw_im <= 16'hfe6f;
                        6'd63: tw_im <= 16'hff38;
                endcase
        end
end
if ((DEPTH == 64) && (BRANCH == 3)) begin : rom_256_3k
        always_ff @(posedge clk) begin
                case(addr_re)
                        6'd0: tw_re <= 16'h1000;
                        6'd1: tw_re <= 16'h0ff4;
                        6'd2: tw_re <= 16'h0fd3;
                        6'd3: tw_re <= 16'h0f9c;
                        6'd4: tw_re <= 16'h0f4f;
                        6'd5: tw_re <= 16'h0eed;
                        6'd6: tw_re <= 16'h0e76;
                        6'd7: tw_re <= 16'h0deb;
                        6'd8: tw_re <= 16'h0d4d;
                        6'd9: tw_re <= 16'h0c9d;
                        6'd10: tw_re <= 16'h0bda;
                        6'd11: tw_re <= 16'h0b08;
                        6'd12: tw_re <= 16'h0a26;
                        6'd13: tw_re <= 16'h0936;
                        6'd14: tw_re <= 16'h0839;
                        6'd15: tw_re <= 16'h0731;
                        6'd16: tw_re <= 16'h061f;
                        6'd17: tw_re <= 16'h0504;
                        6'd18: tw_re <= 16'h03e3;
                        6'd19: tw_re <= 16'h02bc;
                        6'd20: tw_re <= 16'h0191;
                        6'd21: tw_re <= 16'h0064;
                        6'd22: tw_re <= 16'hff38;
                        6'd23: tw_re <= 16'hfe0b;
                        6'd24: tw_re <= 16'hfce1;
                        6'd25: tw_re <= 16'hfbbc;
                        6'd26: tw_re <= 16'hfa9d;
                        6'd27: tw_re <= 16'hf985;
                        6'd28: tw_re <= 16'hf876;
                        6'd29: tw_re <= 16'hf771;
                        6'd30: tw_re <= 16'hf679;
                        6'd31: tw_re <= 16'hf58d;
                        6'd32: tw_re <= 16'hf4b0;
                        6'd33: tw_re <= 16'hf3e3;
                        6'd34: tw_re <= 16'hf327;
                        6'd35: tw_re <= 16'hf27c;
                        6'd36: tw_re <= 16'hf1e4;
                        6'd37: tw_re <= 16'hf160;
                        6'd38: tw_re <= 16'hf0f0;
                        6'd39: tw_re <= 16'hf095;
                        6'd40: tw_re <= 16'hf04f;
                        6'd41: tw_re <= 16'hf01f;
                        6'd42: tw_re <= 16'hf005;
                        6'd43: tw_re <= 16'hf002;
                        6'd44: tw_re <= 16'hf014;
                        6'd45: tw_re <= 16'hf03d;
                        6'd46: tw_re <= 16'hf07b;
                        6'd47: tw_re <= 16'hf0cf;
                        6'd48: tw_re <= 16'hf138;
                        6'd49: tw_re <= 16'hf1b6;
                        6'd50: tw_re <= 16'hf247;
                        6'd51: tw_re <= 16'hf2ec;
                        6'd52: tw_re <= 16'hf3a2; 
                        6'd53: tw_re <= 16'hf46a;
                        6'd54: tw_re <= 16'hf542;
                        6'd55: tw_re <= 16'hf629;
                        6'd56: tw_re <= 16'hf71d;
                        6'd57: tw_re <= 16'hf81e;
                        6'd58: tw_re <= 16'hf929;
                        6'd59: tw_re <= 16'hfa3e;
                        6'd60: tw_re <= 16'hfb5b;
                        6'd61: tw_re <= 16'hfc7f;
                        6'd62: tw_re <= 16'hfda7;
                        6'd63: tw_re <= 16'hfed3;
                endcase


                case(addr_im)
                        6'd0: tw_im <= 16'h0000;
                        6'd1: tw_im <= 16'hfed3;
                        6'd2: tw_im <= 16'hfda7;
                        6'd3: tw_im <= 16'hfc7f;
                        6'd4: tw_im <= 16'hfb5b;
                        6'd5: tw_im <= 16'hfa3e;
                        6'd6: tw_im <= 16'hf929;
                        6'd7: tw_im <= 16'hf81e;
                        6'd8: tw_im <= 16'hf71d;
                        6'd9: tw_im <= 16'hf629;
                        6'd10: tw_im <= 16'hf542;
                        6'd11: tw_im <= 16'hf46a;
                        6'd12: tw_im <= 16'hf3a2;
                        6'd13: tw_im <= 16'hf2ec;
                        6'd14: tw_im <= 16'hf247;
                        6'd15: tw_im <= 16'hf1b6;
                        6'd16: tw_im <= 16'hf138;
                        6'd17: tw_im <= 16'hf0cf;
                        6'd18: tw_im <= 16'hf07b;
                        6'd19: tw_im <= 16'hf03d;
                        6'd20: tw_im <= 16'hf014;
                        6'd21: tw_im <= 16'hf002;
                        6'd22: tw_im <= 16'hf005;
                        6'd23: tw_im <= 16'hf01f;
                        6'd24: tw_im <= 16'hf04f;
                        6'd25: tw_im <= 16'hf095;
                        6'd26: tw_im <= 16'hf0f0;
                        6'd27: tw_im <= 16'hf160;
                        6'd28: tw_im <= 16'hf1e4;
                        6'd29: tw_im <= 16'hf27c;
                        6'd30: tw_im <= 16'hf327;
                        6'd31: tw_im <= 16'hf3e3;
                        6'd32: tw_im <= 16'hf4b0;
                        6'd33: tw_im <= 16'hf58d;
                        6'd34: tw_im <= 16'hf679;
                        6'd35: tw_im <= 16'hf771;
                        6'd36: tw_im <= 16'hf876;
                        6'd37: tw_im <= 16'hf985;
                        6'd38: tw_im <= 16'hfa9d;
                        6'd39: tw_im <= 16'hfbbc;
                        6'd40: tw_im <= 16'hfce1;
                        6'd41: tw_im <= 16'hfe0b;
                        6'd42: tw_im <= 16'hff38;
                        6'd43: tw_im <= 16'h0064;
                        6'd44: tw_im <= 16'h0191;
                        6'd45: tw_im <= 16'h02bc;
                        6'd46: tw_im <= 16'h03e3;
                        6'd47: tw_im <= 16'h0504;
                        6'd48: tw_im <= 16'h061f;
                        6'd49: tw_im <= 16'h0731;
                        6'd50: tw_im <= 16'h0839;
                        6'd51: tw_im <= 16'h0936;
                        6'd52: tw_im <= 16'h0a26;
                        6'd53: tw_im <= 16'h0b08;
                        6'd54: tw_im <= 16'h0bda;
                        6'd55: tw_im <= 16'h0c9d;
                        6'd56: tw_im <= 16'h0d4d;
                        6'd57: tw_im <= 16'h0deb;
                        6'd58: tw_im <= 16'h0e76;
                        6'd59: tw_im <= 16'h0eed;
                        6'd60: tw_im <= 16'h0f4f;
                        6'd61: tw_im <= 16'h0f9c;
                        6'd62: tw_im <= 16'h0fd3;
                        6'd63: tw_im <= 16'h0ff4;
                endcase
        end
end
if ((DEPTH == 16) && (BRANCH == 1)) begin : rom_64_1k
        always_ff @(posedge clk) begin
                case(addr_re)
                        4'd0: tw_re <= 16'h1000;
                        4'd1: tw_re <= 16'h0fec;
                        4'd2: tw_re <= 16'h0fb1;
                        4'd3: tw_re <= 16'h0f4f;
                        4'd4: tw_re <= 16'h0ec8;
                        4'd5: tw_re <= 16'h0e1c;
                        4'd6: tw_re <= 16'h0d4d;
                        4'd7: tw_re <= 16'h0c5e;
                        4'd8: tw_re <= 16'h0b50;
                        4'd9: tw_re <= 16'h0a26;
                        4'd10: tw_re <= 16'h08e3;
                        4'd11: tw_re <= 16'h078a;
                        4'd12: tw_re <= 16'h061f;
                        4'd13: tw_re <= 16'h04a5;
                        4'd14: tw_re <= 16'h031f;
                        4'd15: tw_re <= 16'h0191;
                endcase


                case(addr_im)
                        4'd0: tw_im <= 16'h0000;
                        4'd1: tw_im <= 16'hfe6f;
                        4'd2: tw_im <= 16'hfce1;
                        4'd3: tw_im <= 16'hfb5b;
                        4'd4: tw_im <= 16'hf9e1;
                        4'd5: tw_im <= 16'hf876;
                        4'd6: tw_im <= 16'hf71d;
                        4'd7: tw_im <= 16'hf5da;
                        4'd8: tw_im <= 16'hf4b0;
                        4'd9: tw_im <= 16'hf3a2;
                        4'd10: tw_im <= 16'hf2b3;
                        4'd11: tw_im <= 16'hf1e4;
                        4'd12: tw_im <= 16'hf138;
                        4'd13: tw_im <= 16'hf0b1;
                        4'd14: tw_im <= 16'hf04f;
                        4'd15: tw_im <= 16'hf014;
                endcase
        end
end
if ((DEPTH == 16) && (BRANCH == 2)) begin : rom_64_2k
        always_ff @(posedge clk) begin
                case(addr_re)
                        4'd0: tw_re <= 16'h1000;
                        4'd1: tw_re <= 16'h0fb1;
                        4'd2: tw_re <= 16'h0ec8;
                        4'd3: tw_re <= 16'h0d4d;
                        4'd4: tw_re <= 16'h0b50;
                        4'd5: tw_re <= 16'h08e3;
                        4'd6: tw_re <= 16'h061f;
                        4'd7: tw_re <= 16'h031f;
                        4'd8: tw_re <= 16'h0000;
                        4'd9: tw_re <= 16'hfce1;
                        4'd10: tw_re <= 16'hf9e1;
                        4'd11: tw_re <= 16'hf71d;
                        4'd12: tw_re <= 16'hf4b0;
                        4'd13: tw_re <= 16'hf2b3;
                        4'd14: tw_re <= 16'hf138;
                        4'd15: tw_re <= 16'hf04f;
                endcase


                case(addr_im)
                        4'd0: tw_im <= 16'h0000;
                        4'd1: tw_im <= 16'hfce1;
                        4'd2: tw_im <= 16'hf9e1;
                        4'd3: tw_im <= 16'hf71d;
                        4'd4: tw_im <= 16'hf4b0;
                        4'd5: tw_im <= 16'hf2b3;
                        4'd6: tw_im <= 16'hf138;
                        4'd7: tw_im <= 16'hf04f;
                        4'd8: tw_im <= 16'hf000;
                        4'd9: tw_im <= 16'hf04f;
                        4'd10: tw_im <= 16'hf138;
                        4'd11: tw_im <= 16'hf2b3;
                        4'd12: tw_im <= 16'hf4b0;
                        4'd13: tw_im <= 16'hf71d;
                        4'd14: tw_im <= 16'hf9e1;
                        4'd15: tw_im <= 16'hfce1;
                endcase
        end
end
if ((DEPTH == 16) && (BRANCH == 3)) begin : rom_64_3k
        always_ff @(posedge clk) begin
                case(addr_re)
                        4'd0: tw_re <= 16'h1000;
                        4'd1: tw_re <= 16'h0f4f;
                        4'd2: tw_re <= 16'h0d4d;
                        4'd3: tw_re <= 16'h0a26;
                        4'd4: tw_re <= 16'h061f;
                        4'd5: tw_re <= 16'h0191;
                        4'd6: tw_re <= 16'hfce1;
                        4'd7: tw_re <= 16'hf876;
                        4'd8: tw_re <= 16'hf4b0;
                        4'd9: tw_re <= 16'hf1e4;
                        4'd10: tw_re <= 16'hf04f;
                        4'd11: tw_re <= 16'hf014;
                        4'd12: tw_re <= 16'hf138;
                        4'd13: tw_re <= 16'hf3a2;
                        4'd14: tw_re <= 16'hf71d;
                        4'd15: tw_re <= 16'hfb5b;
                endcase


                case(addr_im)
                        4'd0: tw_im <= 16'h0000;
                        4'd1: tw_im <= 16'hfb5b;
                        4'd2: tw_im <= 16'hf71d;
                        4'd3: tw_im <= 16'hf3a2;
                        4'd4: tw_im <= 16'hf138;
                        4'd5: tw_im <= 16'hf014;
                        4'd6: tw_im <= 16'hf04f;
                        4'd7: tw_im <= 16'hf1e4;
                        4'd8: tw_im <= 16'hf4b0;
                        4'd9: tw_im <= 16'hf876;
                        4'd10: tw_im <= 16'hfce1;
                        4'd11: tw_im <= 16'h0191;
                        4'd12: tw_im <= 16'h061f;
                        4'd13: tw_im <= 16'h0a26;
                        4'd14: tw_im <= 16'h0d4d;
                        4'd15: tw_im <= 16'h0f4f;
                endcase
        end
end
if ((DEPTH == 4) && (BRANCH == 1)) begin : rom_16_1k
        always_ff @(posedge clk) begin
                case(addr_re)
                        2'd0: tw_re <= 16'h1000;
                        2'd1: tw_re <= 16'h0ec8;
                        2'd2: tw_re <= 16'h0b50;
                        2'd3: tw_re <= 16'h061f;
                endcase


                case(addr_im)
                        2'd0: tw_im <= 16'h0000;
                        2'd1: tw_im <= 16'hf9e1;
                        2'd2: tw_im <= 16'hf4b0;
                        2'd3: tw_im <= 16'hf138;
                endcase
        end
end
if ((DEPTH == 4) && (BRANCH == 2)) begin : rom_16_2k
        always_ff @(posedge clk) begin
                case(addr_re)
                        2'd0: tw_re <= 16'h1000;
                        2'd1: tw_re <= 16'h0b50;
                        2'd2: tw_re <= 16'h0000;
                        2'd3: tw_re <= 16'hf4b0;
                endcase


                case(addr_im)
                        2'd0: tw_im <= 16'h0000;
                        2'd1: tw_im <= 16'hf4b0;
                        2'd2: tw_im <= 16'hf000;
                        2'd3: tw_im <= 16'hf4b0;
                endcase
        end
end
if ((DEPTH == 4) && (BRANCH == 3)) begin : rom_16_3k
        always_ff @(posedge clk) begin
                case(addr_re)
                        2'd0: tw_re <= 16'h1000;
                        2'd1: tw_re <= 16'h061f;
                        2'd2: tw_re <= 16'hf4b0;
                        2'd3: tw_re <= 16'hf138;
                endcase


                case(addr_im)
                        2'd0: tw_im <= 16'h0000;
                        2'd1: tw_im <= 16'hf138;
                        2'd2: tw_im <= 16'hf4b0;
                        2'd3: tw_im <= 16'h061f;
                endcase
        end
end
    endgenerate
endmodule