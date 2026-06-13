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
<<<<<<< HEAD
                        6'd0: tw_re <= 16'h7fff;
                        6'd1: tw_re <= 16'h7ff6;
                        6'd2: tw_re <= 16'h7fd8;
                        6'd3: tw_re <= 16'h7fa7;
                        6'd4: tw_re <= 16'h7f62;
                        6'd5: tw_re <= 16'h7f09;
                        6'd6: tw_re <= 16'h7e9d;
                        6'd7: tw_re <= 16'h7e1d;
                        6'd8: tw_re <= 16'h7d8a;
                        6'd9: tw_re <= 16'h7ce3;
                        6'd10: tw_re <= 16'h7c29;
                        6'd11: tw_re <= 16'h7b5d;
                        6'd12: tw_re <= 16'h7a7d;
                        6'd13: tw_re <= 16'h798a;
                        6'd14: tw_re <= 16'h7884;
                        6'd15: tw_re <= 16'h776c;
                        6'd16: tw_re <= 16'h7641;
                        6'd17: tw_re <= 16'h7504;
                        6'd18: tw_re <= 16'h73b5;
                        6'd19: tw_re <= 16'h7255;
                        6'd20: tw_re <= 16'h70e2;
                        6'd21: tw_re <= 16'h6f5f;
                        6'd22: tw_re <= 16'h6dca;
                        6'd23: tw_re <= 16'h6c24;
                        6'd24: tw_re <= 16'h6a6d;
                        6'd25: tw_re <= 16'h68a6;
                        6'd26: tw_re <= 16'h66cf;
                        6'd27: tw_re <= 16'h64e8;
                        6'd28: tw_re <= 16'h62f2;
                        6'd29: tw_re <= 16'h60ec;
                        6'd30: tw_re <= 16'h5ed7;
                        6'd31: tw_re <= 16'h5cb4;
                        6'd32: tw_re <= 16'h5a82;
                        6'd33: tw_re <= 16'h5842;
                        6'd34: tw_re <= 16'h55f5;
                        6'd35: tw_re <= 16'h539b;
                        6'd36: tw_re <= 16'h5133;
                        6'd37: tw_re <= 16'h4ebf;
                        6'd38: tw_re <= 16'h4c3f;
                        6'd39: tw_re <= 16'h49b4;
                        6'd40: tw_re <= 16'h471c;
                        6'd41: tw_re <= 16'h447a;
                        6'd42: tw_re <= 16'h41ce;
                        6'd43: tw_re <= 16'h3f17;
                        6'd44: tw_re <= 16'h3c56;
                        6'd45: tw_re <= 16'h398c;
                        6'd46: tw_re <= 16'h36ba;
                        6'd47: tw_re <= 16'h33de;
                        6'd48: tw_re <= 16'h30fb;
                        6'd49: tw_re <= 16'h2e11;
                        6'd50: tw_re <= 16'h2b1f;
                        6'd51: tw_re <= 16'h2826;
                        6'd52: tw_re <= 16'h2528;
                        6'd53: tw_re <= 16'h2223;
                        6'd54: tw_re <= 16'h1f19;
                        6'd55: tw_re <= 16'h1c0b;
                        6'd56: tw_re <= 16'h18f8;
                        6'd57: tw_re <= 16'h15e2;
                        6'd58: tw_re <= 16'h12c8;
                        6'd59: tw_re <= 16'h0fab;
                        6'd60: tw_re <= 16'h0c8b;
                        6'd61: tw_re <= 16'h096a;
                        6'd62: tw_re <= 16'h0647;
                        6'd63: tw_re <= 16'h0324;
=======
                        6'd0: tw_re <= 16'h1000;
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase


                case(addr_im)
                        6'd0: tw_im <= 16'h0000;
<<<<<<< HEAD
                        6'd1: tw_im <= 16'hfcdc;
                        6'd2: tw_im <= 16'hf9b9;
                        6'd3: tw_im <= 16'hf696;
                        6'd4: tw_im <= 16'hf375;
                        6'd5: tw_im <= 16'hf055;
                        6'd6: tw_im <= 16'hed38;
                        6'd7: tw_im <= 16'hea1e;
                        6'd8: tw_im <= 16'he708;
                        6'd9: tw_im <= 16'he3f5;
                        6'd10: tw_im <= 16'he0e7;
                        6'd11: tw_im <= 16'hdddd;
                        6'd12: tw_im <= 16'hdad8;
                        6'd13: tw_im <= 16'hd7da;
                        6'd14: tw_im <= 16'hd4e1;
                        6'd15: tw_im <= 16'hd1ef;
                        6'd16: tw_im <= 16'hcf05;
                        6'd17: tw_im <= 16'hcc22;
                        6'd18: tw_im <= 16'hc946;
                        6'd19: tw_im <= 16'hc674;
                        6'd20: tw_im <= 16'hc3aa;
                        6'd21: tw_im <= 16'hc0e9;
                        6'd22: tw_im <= 16'hbe32;
                        6'd23: tw_im <= 16'hbb86;
                        6'd24: tw_im <= 16'hb8e4;
                        6'd25: tw_im <= 16'hb64c;
                        6'd26: tw_im <= 16'hb3c1;
                        6'd27: tw_im <= 16'hb141;
                        6'd28: tw_im <= 16'haecd;
                        6'd29: tw_im <= 16'hac65;
                        6'd30: tw_im <= 16'haa0b;
                        6'd31: tw_im <= 16'ha7be;
                        6'd32: tw_im <= 16'ha57e;
                        6'd33: tw_im <= 16'ha34c;
                        6'd34: tw_im <= 16'ha129;
                        6'd35: tw_im <= 16'h9f14;
                        6'd36: tw_im <= 16'h9d0e;
                        6'd37: tw_im <= 16'h9b18;
                        6'd38: tw_im <= 16'h9931;
                        6'd39: tw_im <= 16'h975a;
                        6'd40: tw_im <= 16'h9593;
                        6'd41: tw_im <= 16'h93dc;
                        6'd42: tw_im <= 16'h9236;
                        6'd43: tw_im <= 16'h90a1;
                        6'd44: tw_im <= 16'h8f1e;
                        6'd45: tw_im <= 16'h8dab;
                        6'd46: tw_im <= 16'h8c4b;
                        6'd47: tw_im <= 16'h8afc;
                        6'd48: tw_im <= 16'h89bf;
                        6'd49: tw_im <= 16'h8894;
                        6'd50: tw_im <= 16'h877c;
                        6'd51: tw_im <= 16'h8676;
                        6'd52: tw_im <= 16'h8583;
                        6'd53: tw_im <= 16'h84a3;
                        6'd54: tw_im <= 16'h83d7;
                        6'd55: tw_im <= 16'h831d;
                        6'd56: tw_im <= 16'h8276;
                        6'd57: tw_im <= 16'h81e3;
                        6'd58: tw_im <= 16'h8163;
                        6'd59: tw_im <= 16'h80f7;
                        6'd60: tw_im <= 16'h809e;
                        6'd61: tw_im <= 16'h8059;
                        6'd62: tw_im <= 16'h8028;
                        6'd63: tw_im <= 16'h800a;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase
        end
end
if ((DEPTH == 64) && (BRANCH == 2)) begin : rom_256_2k
        always_ff @(posedge clk) begin
                case(addr_re)
<<<<<<< HEAD
                        6'd0: tw_re <= 16'h7fff;
                        6'd1: tw_re <= 16'h7fd8;
                        6'd2: tw_re <= 16'h7f62;
                        6'd3: tw_re <= 16'h7e9d;
                        6'd4: tw_re <= 16'h7d8a;
                        6'd5: tw_re <= 16'h7c29;
                        6'd6: tw_re <= 16'h7a7d;
                        6'd7: tw_re <= 16'h7884;
                        6'd8: tw_re <= 16'h7641;
                        6'd9: tw_re <= 16'h73b5;
                        6'd10: tw_re <= 16'h70e2;
                        6'd11: tw_re <= 16'h6dca;
                        6'd12: tw_re <= 16'h6a6d;
                        6'd13: tw_re <= 16'h66cf;
                        6'd14: tw_re <= 16'h62f2;
                        6'd15: tw_re <= 16'h5ed7;
                        6'd16: tw_re <= 16'h5a82;
                        6'd17: tw_re <= 16'h55f5;
                        6'd18: tw_re <= 16'h5133;
                        6'd19: tw_re <= 16'h4c3f;
                        6'd20: tw_re <= 16'h471c;
                        6'd21: tw_re <= 16'h41ce;
                        6'd22: tw_re <= 16'h3c56;
                        6'd23: tw_re <= 16'h36ba;
                        6'd24: tw_re <= 16'h30fb;
                        6'd25: tw_re <= 16'h2b1f;
                        6'd26: tw_re <= 16'h2528;
                        6'd27: tw_re <= 16'h1f19;
                        6'd28: tw_re <= 16'h18f8;
                        6'd29: tw_re <= 16'h12c8;
                        6'd30: tw_re <= 16'h0c8b;
                        6'd31: tw_re <= 16'h0647;
                        6'd32: tw_re <= 16'h0000;
                        6'd33: tw_re <= 16'hf9b9;
                        6'd34: tw_re <= 16'hf375;
                        6'd35: tw_re <= 16'hed38;
                        6'd36: tw_re <= 16'he708;
                        6'd37: tw_re <= 16'he0e7;
                        6'd38: tw_re <= 16'hdad8;
                        6'd39: tw_re <= 16'hd4e1;
                        6'd40: tw_re <= 16'hcf05;
                        6'd41: tw_re <= 16'hc946;
                        6'd42: tw_re <= 16'hc3aa;
                        6'd43: tw_re <= 16'hbe32;
                        6'd44: tw_re <= 16'hb8e4;
                        6'd45: tw_re <= 16'hb3c1;
                        6'd46: tw_re <= 16'haecd;
                        6'd47: tw_re <= 16'haa0b;
                        6'd48: tw_re <= 16'ha57e;
                        6'd49: tw_re <= 16'ha129;
                        6'd50: tw_re <= 16'h9d0e;
                        6'd51: tw_re <= 16'h9931;
                        6'd52: tw_re <= 16'h9593;
                        6'd53: tw_re <= 16'h9236;
                        6'd54: tw_re <= 16'h8f1e;
                        6'd55: tw_re <= 16'h8c4b;
                        6'd56: tw_re <= 16'h89bf;
                        6'd57: tw_re <= 16'h877c;
                        6'd58: tw_re <= 16'h8583;
                        6'd59: tw_re <= 16'h83d7;
                        6'd60: tw_re <= 16'h8276;
                        6'd61: tw_re <= 16'h8163;
                        6'd62: tw_re <= 16'h809e;
                        6'd63: tw_re <= 16'h8028;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase


                case(addr_im)
                        6'd0: tw_im <= 16'h0000;
<<<<<<< HEAD
                        6'd1: tw_im <= 16'hf9b9;
                        6'd2: tw_im <= 16'hf375;
                        6'd3: tw_im <= 16'hed38;
                        6'd4: tw_im <= 16'he708;
                        6'd5: tw_im <= 16'he0e7;
                        6'd6: tw_im <= 16'hdad8;
                        6'd7: tw_im <= 16'hd4e1;
                        6'd8: tw_im <= 16'hcf05;
                        6'd9: tw_im <= 16'hc946;
                        6'd10: tw_im <= 16'hc3aa;
                        6'd11: tw_im <= 16'hbe32;
                        6'd12: tw_im <= 16'hb8e4;
                        6'd13: tw_im <= 16'hb3c1;
                        6'd14: tw_im <= 16'haecd;
                        6'd15: tw_im <= 16'haa0b;
                        6'd16: tw_im <= 16'ha57e;
                        6'd17: tw_im <= 16'ha129;
                        6'd18: tw_im <= 16'h9d0e;
                        6'd19: tw_im <= 16'h9931;
                        6'd20: tw_im <= 16'h9593;
                        6'd21: tw_im <= 16'h9236;
                        6'd22: tw_im <= 16'h8f1e;
                        6'd23: tw_im <= 16'h8c4b;
                        6'd24: tw_im <= 16'h89bf;
                        6'd25: tw_im <= 16'h877c;
                        6'd26: tw_im <= 16'h8583;
                        6'd27: tw_im <= 16'h83d7;
                        6'd28: tw_im <= 16'h8276;
                        6'd29: tw_im <= 16'h8163;
                        6'd30: tw_im <= 16'h809e;
                        6'd31: tw_im <= 16'h8028;
                        6'd32: tw_im <= 16'h8000;
                        6'd33: tw_im <= 16'h8028;
                        6'd34: tw_im <= 16'h809e;
                        6'd35: tw_im <= 16'h8163;
                        6'd36: tw_im <= 16'h8276;
                        6'd37: tw_im <= 16'h83d7;
                        6'd38: tw_im <= 16'h8583;
                        6'd39: tw_im <= 16'h877c;
                        6'd40: tw_im <= 16'h89bf;
                        6'd41: tw_im <= 16'h8c4b;
                        6'd42: tw_im <= 16'h8f1e;
                        6'd43: tw_im <= 16'h9236;
                        6'd44: tw_im <= 16'h9593;
                        6'd45: tw_im <= 16'h9931;
                        6'd46: tw_im <= 16'h9d0e;
                        6'd47: tw_im <= 16'ha129;
                        6'd48: tw_im <= 16'ha57e;
                        6'd49: tw_im <= 16'haa0b;
                        6'd50: tw_im <= 16'haecd;
                        6'd51: tw_im <= 16'hb3c1;
                        6'd52: tw_im <= 16'hb8e4;
                        6'd53: tw_im <= 16'hbe32;
                        6'd54: tw_im <= 16'hc3aa;
                        6'd55: tw_im <= 16'hc946;
                        6'd56: tw_im <= 16'hcf05;
                        6'd57: tw_im <= 16'hd4e1;
                        6'd58: tw_im <= 16'hdad8;
                        6'd59: tw_im <= 16'he0e7;
                        6'd60: tw_im <= 16'he708;
                        6'd61: tw_im <= 16'hed38;
                        6'd62: tw_im <= 16'hf375;
                        6'd63: tw_im <= 16'hf9b9;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase
        end
end
if ((DEPTH == 64) && (BRANCH == 3)) begin : rom_256_3k
        always_ff @(posedge clk) begin
                case(addr_re)
<<<<<<< HEAD
                        6'd0: tw_re <= 16'h7fff;
                        6'd1: tw_re <= 16'h7fa7;
                        6'd2: tw_re <= 16'h7e9d;
                        6'd3: tw_re <= 16'h7ce3;
                        6'd4: tw_re <= 16'h7a7d;
                        6'd5: tw_re <= 16'h776c;
                        6'd6: tw_re <= 16'h73b5;
                        6'd7: tw_re <= 16'h6f5f;
                        6'd8: tw_re <= 16'h6a6d;
                        6'd9: tw_re <= 16'h64e8;
                        6'd10: tw_re <= 16'h5ed7;
                        6'd11: tw_re <= 16'h5842;
                        6'd12: tw_re <= 16'h5133;
                        6'd13: tw_re <= 16'h49b4;
                        6'd14: tw_re <= 16'h41ce;
                        6'd15: tw_re <= 16'h398c;
                        6'd16: tw_re <= 16'h30fb;
                        6'd17: tw_re <= 16'h2826;
                        6'd18: tw_re <= 16'h1f19;
                        6'd19: tw_re <= 16'h15e2;
                        6'd20: tw_re <= 16'h0c8b;
                        6'd21: tw_re <= 16'h0324;
                        6'd22: tw_re <= 16'hf9b9;
                        6'd23: tw_re <= 16'hf055;
                        6'd24: tw_re <= 16'he708;
                        6'd25: tw_re <= 16'hdddd;
                        6'd26: tw_re <= 16'hd4e1;
                        6'd27: tw_re <= 16'hcc22;
                        6'd28: tw_re <= 16'hc3aa;
                        6'd29: tw_re <= 16'hbb86;
                        6'd30: tw_re <= 16'hb3c1;
                        6'd31: tw_re <= 16'hac65;
                        6'd32: tw_re <= 16'ha57e;
                        6'd33: tw_re <= 16'h9f14;
                        6'd34: tw_re <= 16'h9931;
                        6'd35: tw_re <= 16'h93dc;
                        6'd36: tw_re <= 16'h8f1e;
                        6'd37: tw_re <= 16'h8afc;
                        6'd38: tw_re <= 16'h877c;
                        6'd39: tw_re <= 16'h84a3;
                        6'd40: tw_re <= 16'h8276;
                        6'd41: tw_re <= 16'h80f7;
                        6'd42: tw_re <= 16'h8028;
                        6'd43: tw_re <= 16'h800a;
                        6'd44: tw_re <= 16'h809e;
                        6'd45: tw_re <= 16'h81e3;
                        6'd46: tw_re <= 16'h83d7;
                        6'd47: tw_re <= 16'h8676;
                        6'd48: tw_re <= 16'h89bf;
                        6'd49: tw_re <= 16'h8dab;
                        6'd50: tw_re <= 16'h9236;
                        6'd51: tw_re <= 16'h975a;
                        6'd52: tw_re <= 16'h9d0e;
                        6'd53: tw_re <= 16'ha34c;
                        6'd54: tw_re <= 16'haa0b;
                        6'd55: tw_re <= 16'hb141;
                        6'd56: tw_re <= 16'hb8e4;
                        6'd57: tw_re <= 16'hc0e9;
                        6'd58: tw_re <= 16'hc946;
                        6'd59: tw_re <= 16'hd1ef;
                        6'd60: tw_re <= 16'hdad8;
                        6'd61: tw_re <= 16'he3f5;
                        6'd62: tw_re <= 16'hed38;
                        6'd63: tw_re <= 16'hf696;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase


                case(addr_im)
                        6'd0: tw_im <= 16'h0000;
<<<<<<< HEAD
                        6'd1: tw_im <= 16'hf696;
                        6'd2: tw_im <= 16'hed38;
                        6'd3: tw_im <= 16'he3f5;
                        6'd4: tw_im <= 16'hdad8;
                        6'd5: tw_im <= 16'hd1ef;
                        6'd6: tw_im <= 16'hc946;
                        6'd7: tw_im <= 16'hc0e9;
                        6'd8: tw_im <= 16'hb8e4;
                        6'd9: tw_im <= 16'hb141;
                        6'd10: tw_im <= 16'haa0b;
                        6'd11: tw_im <= 16'ha34c;
                        6'd12: tw_im <= 16'h9d0e;
                        6'd13: tw_im <= 16'h975a;
                        6'd14: tw_im <= 16'h9236;
                        6'd15: tw_im <= 16'h8dab;
                        6'd16: tw_im <= 16'h89bf;
                        6'd17: tw_im <= 16'h8676;
                        6'd18: tw_im <= 16'h83d7;
                        6'd19: tw_im <= 16'h81e3;
                        6'd20: tw_im <= 16'h809e;
                        6'd21: tw_im <= 16'h800a;
                        6'd22: tw_im <= 16'h8028;
                        6'd23: tw_im <= 16'h80f7;
                        6'd24: tw_im <= 16'h8276;
                        6'd25: tw_im <= 16'h84a3;
                        6'd26: tw_im <= 16'h877c;
                        6'd27: tw_im <= 16'h8afc;
                        6'd28: tw_im <= 16'h8f1e;
                        6'd29: tw_im <= 16'h93dc;
                        6'd30: tw_im <= 16'h9931;
                        6'd31: tw_im <= 16'h9f14;
                        6'd32: tw_im <= 16'ha57e;
                        6'd33: tw_im <= 16'hac65;
                        6'd34: tw_im <= 16'hb3c1;
                        6'd35: tw_im <= 16'hbb86;
                        6'd36: tw_im <= 16'hc3aa;
                        6'd37: tw_im <= 16'hcc22;
                        6'd38: tw_im <= 16'hd4e1;
                        6'd39: tw_im <= 16'hdddd;
                        6'd40: tw_im <= 16'he708;
                        6'd41: tw_im <= 16'hf055;
                        6'd42: tw_im <= 16'hf9b9;
                        6'd43: tw_im <= 16'h0324;
                        6'd44: tw_im <= 16'h0c8b;
                        6'd45: tw_im <= 16'h15e2;
                        6'd46: tw_im <= 16'h1f19;
                        6'd47: tw_im <= 16'h2826;
                        6'd48: tw_im <= 16'h30fb;
                        6'd49: tw_im <= 16'h398c;
                        6'd50: tw_im <= 16'h41ce;
                        6'd51: tw_im <= 16'h49b4;
                        6'd52: tw_im <= 16'h5133;
                        6'd53: tw_im <= 16'h5842;
                        6'd54: tw_im <= 16'h5ed7;
                        6'd55: tw_im <= 16'h64e8;
                        6'd56: tw_im <= 16'h6a6d;
                        6'd57: tw_im <= 16'h6f5f;
                        6'd58: tw_im <= 16'h73b5;
                        6'd59: tw_im <= 16'h776c;
                        6'd60: tw_im <= 16'h7a7d;
                        6'd61: tw_im <= 16'h7ce3;
                        6'd62: tw_im <= 16'h7e9d;
                        6'd63: tw_im <= 16'h7fa7;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase
        end
end
if ((DEPTH == 16) && (BRANCH == 1)) begin : rom_64_1k
        always_ff @(posedge clk) begin
                case(addr_re)
<<<<<<< HEAD
                        4'd0: tw_re <= 16'h7fff;
                        4'd1: tw_re <= 16'h7f62;
                        4'd2: tw_re <= 16'h7d8a;
                        4'd3: tw_re <= 16'h7a7d;
                        4'd4: tw_re <= 16'h7641;
                        4'd5: tw_re <= 16'h70e2;
                        4'd6: tw_re <= 16'h6a6d;
                        4'd7: tw_re <= 16'h62f2;
                        4'd8: tw_re <= 16'h5a82;
                        4'd9: tw_re <= 16'h5133;
                        4'd10: tw_re <= 16'h471c;
                        4'd11: tw_re <= 16'h3c56;
                        4'd12: tw_re <= 16'h30fb;
                        4'd13: tw_re <= 16'h2528;
                        4'd14: tw_re <= 16'h18f8;
                        4'd15: tw_re <= 16'h0c8b;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase


                case(addr_im)
                        4'd0: tw_im <= 16'h0000;
<<<<<<< HEAD
                        4'd1: tw_im <= 16'hf375;
                        4'd2: tw_im <= 16'he708;
                        4'd3: tw_im <= 16'hdad8;
                        4'd4: tw_im <= 16'hcf05;
                        4'd5: tw_im <= 16'hc3aa;
                        4'd6: tw_im <= 16'hb8e4;
                        4'd7: tw_im <= 16'haecd;
                        4'd8: tw_im <= 16'ha57e;
                        4'd9: tw_im <= 16'h9d0e;
                        4'd10: tw_im <= 16'h9593;
                        4'd11: tw_im <= 16'h8f1e;
                        4'd12: tw_im <= 16'h89bf;
                        4'd13: tw_im <= 16'h8583;
                        4'd14: tw_im <= 16'h8276;
                        4'd15: tw_im <= 16'h809e;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase
        end
end
if ((DEPTH == 16) && (BRANCH == 2)) begin : rom_64_2k
        always_ff @(posedge clk) begin
                case(addr_re)
<<<<<<< HEAD
                        4'd0: tw_re <= 16'h7fff;
                        4'd1: tw_re <= 16'h7d8a;
                        4'd2: tw_re <= 16'h7641;
                        4'd3: tw_re <= 16'h6a6d;
                        4'd4: tw_re <= 16'h5a82;
                        4'd5: tw_re <= 16'h471c;
                        4'd6: tw_re <= 16'h30fb;
                        4'd7: tw_re <= 16'h18f8;
                        4'd8: tw_re <= 16'h0000;
                        4'd9: tw_re <= 16'he708;
                        4'd10: tw_re <= 16'hcf05;
                        4'd11: tw_re <= 16'hb8e4;
                        4'd12: tw_re <= 16'ha57e;
                        4'd13: tw_re <= 16'h9593;
                        4'd14: tw_re <= 16'h89bf;
                        4'd15: tw_re <= 16'h8276;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase


                case(addr_im)
                        4'd0: tw_im <= 16'h0000;
<<<<<<< HEAD
                        4'd1: tw_im <= 16'he708;
                        4'd2: tw_im <= 16'hcf05;
                        4'd3: tw_im <= 16'hb8e4;
                        4'd4: tw_im <= 16'ha57e;
                        4'd5: tw_im <= 16'h9593;
                        4'd6: tw_im <= 16'h89bf;
                        4'd7: tw_im <= 16'h8276;
                        4'd8: tw_im <= 16'h8000;
                        4'd9: tw_im <= 16'h8276;
                        4'd10: tw_im <= 16'h89bf;
                        4'd11: tw_im <= 16'h9593;
                        4'd12: tw_im <= 16'ha57e;
                        4'd13: tw_im <= 16'hb8e4;
                        4'd14: tw_im <= 16'hcf05;
                        4'd15: tw_im <= 16'he708;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase
        end
end
if ((DEPTH == 16) && (BRANCH == 3)) begin : rom_64_3k
        always_ff @(posedge clk) begin
                case(addr_re)
<<<<<<< HEAD
                        4'd0: tw_re <= 16'h7fff;
                        4'd1: tw_re <= 16'h7a7d;
                        4'd2: tw_re <= 16'h6a6d;
                        4'd3: tw_re <= 16'h5133;
                        4'd4: tw_re <= 16'h30fb;
                        4'd5: tw_re <= 16'h0c8b;
                        4'd6: tw_re <= 16'he708;
                        4'd7: tw_re <= 16'hc3aa;
                        4'd8: tw_re <= 16'ha57e;
                        4'd9: tw_re <= 16'h8f1e;
                        4'd10: tw_re <= 16'h8276;
                        4'd11: tw_re <= 16'h809e;
                        4'd12: tw_re <= 16'h89bf;
                        4'd13: tw_re <= 16'h9d0e;
                        4'd14: tw_re <= 16'hb8e4;
                        4'd15: tw_re <= 16'hdad8;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase


                case(addr_im)
                        4'd0: tw_im <= 16'h0000;
<<<<<<< HEAD
                        4'd1: tw_im <= 16'hdad8;
                        4'd2: tw_im <= 16'hb8e4;
                        4'd3: tw_im <= 16'h9d0e;
                        4'd4: tw_im <= 16'h89bf;
                        4'd5: tw_im <= 16'h809e;
                        4'd6: tw_im <= 16'h8276;
                        4'd7: tw_im <= 16'h8f1e;
                        4'd8: tw_im <= 16'ha57e;
                        4'd9: tw_im <= 16'hc3aa;
                        4'd10: tw_im <= 16'he708;
                        4'd11: tw_im <= 16'h0c8b;
                        4'd12: tw_im <= 16'h30fb;
                        4'd13: tw_im <= 16'h5133;
                        4'd14: tw_im <= 16'h6a6d;
                        4'd15: tw_im <= 16'h7a7d;
=======
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
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase
        end
end
if ((DEPTH == 4) && (BRANCH == 1)) begin : rom_16_1k
        always_ff @(posedge clk) begin
                case(addr_re)
<<<<<<< HEAD
                        2'd0: tw_re <= 16'h7fff;
                        2'd1: tw_re <= 16'h7641;
                        2'd2: tw_re <= 16'h5a82;
                        2'd3: tw_re <= 16'h30fb;
=======
                        2'd0: tw_re <= 16'h1000;
                        2'd1: tw_re <= 16'h0ec8;
                        2'd2: tw_re <= 16'h0b50;
                        2'd3: tw_re <= 16'h061f;
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase


                case(addr_im)
                        2'd0: tw_im <= 16'h0000;
<<<<<<< HEAD
                        2'd1: tw_im <= 16'hcf05;
                        2'd2: tw_im <= 16'ha57e;
                        2'd3: tw_im <= 16'h89bf;
=======
                        2'd1: tw_im <= 16'hf9e1;
                        2'd2: tw_im <= 16'hf4b0;
                        2'd3: tw_im <= 16'hf138;
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase
        end
end
if ((DEPTH == 4) && (BRANCH == 2)) begin : rom_16_2k
        always_ff @(posedge clk) begin
                case(addr_re)
<<<<<<< HEAD
                        2'd0: tw_re <= 16'h7fff;
                        2'd1: tw_re <= 16'h5a82;
                        2'd2: tw_re <= 16'h0000;
                        2'd3: tw_re <= 16'ha57e;
=======
                        2'd0: tw_re <= 16'h1000;
                        2'd1: tw_re <= 16'h0b50;
                        2'd2: tw_re <= 16'h0000;
                        2'd3: tw_re <= 16'hf4b0;
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase


                case(addr_im)
                        2'd0: tw_im <= 16'h0000;
<<<<<<< HEAD
                        2'd1: tw_im <= 16'ha57e;
                        2'd2: tw_im <= 16'h8000;
                        2'd3: tw_im <= 16'ha57e;
=======
                        2'd1: tw_im <= 16'hf4b0;
                        2'd2: tw_im <= 16'hf000;
                        2'd3: tw_im <= 16'hf4b0;
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase
        end
end
if ((DEPTH == 4) && (BRANCH == 3)) begin : rom_16_3k
        always_ff @(posedge clk) begin
                case(addr_re)
<<<<<<< HEAD
                        2'd0: tw_re <= 16'h7fff;
                        2'd1: tw_re <= 16'h30fb;
                        2'd2: tw_re <= 16'ha57e;
                        2'd3: tw_re <= 16'h89bf;
=======
                        2'd0: tw_re <= 16'h1000;
                        2'd1: tw_re <= 16'h061f;
                        2'd2: tw_re <= 16'hf4b0;
                        2'd3: tw_re <= 16'hf138;
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase


                case(addr_im)
                        2'd0: tw_im <= 16'h0000;
<<<<<<< HEAD
                        2'd1: tw_im <= 16'h89bf;
                        2'd2: tw_im <= 16'ha57e;
                        2'd3: tw_im <= 16'h30fb;
=======
                        2'd1: tw_im <= 16'hf138;
                        2'd2: tw_im <= 16'hf4b0;
                        2'd3: tw_im <= 16'h061f;
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
                endcase
        end
end
    endgenerate
endmodule