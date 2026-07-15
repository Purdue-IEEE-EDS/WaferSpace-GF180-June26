v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 340 -70 370 -70 {lab=#net1}
N 370 -70 380 -70 {lab=#net1}
N 380 -100 380 -70 {lab=#net1}
N 340 -50 380 -50 {lab=#net2}
N 380 -20 400 -20 {lab=#net2}
N 380 -110 380 -100 {lab=#net1}
N 380 -110 400 -110 {lab=#net1}
N 380 -50 380 -20 {lab=#net2}
N 700 -90 770 -90 {lab=#net3}
N 700 0 770 -0 {lab=#net4}
N 790 100 790 120 {lab=vss}
N 790 120 1050 120 {lab=vss}
N 1010 100 1010 120 {lab=vss}
N 790 -90 790 40 {lab=#net3}
N 770 -90 790 -90 {lab=#net3}
N 770 -0 1010 0 {lab=#net4}
N 1010 0 1010 40 {lab=#net4}
N 790 -90 1210 -90 {lab=#net3}
N 1010 0 1210 -0 {lab=#net4}
N 1210 -90 1210 -70 {lab=#net3}
N 1210 -70 1210 -60 {lab=#net3}
N 1210 -60 1260 -60 {lab=#net3}
N 1210 -40 1210 -0 {lab=#net4}
N 1210 -40 1260 -40 {lab=#net4}
N 1120 230 1210 230 {lab=#net5}
N 1220 20 1220 230 {lab=#net5}
N 1220 0 1220 20 {lab=#net5}
N 1220 0 1260 0 {lab=#net5}
N 1210 230 1220 230 {lab=#net5}
N 1120 250 1230 250 {lab=#net6}
N 1230 20 1230 250 {lab=#net6}
N 1230 20 1260 20 {lab=#net6}
N 1120 320 1240 320 {lab=#net7}
N 1240 40 1240 320 {lab=#net7}
N 1240 40 1260 40 {lab=#net7}
N 560 390 620 390 {lab=clkc_pre}
N 620 390 620 430 {lab=clkc_pre}
N 620 430 640 430 {lab=clkc_pre}
C {buffer.sym} 190 -60 0 0 {name=x1}
C {boot3.sym} 550 -80 0 0 {name=x2}
C {boot3.sym} 550 10 0 0 {name=x3}
C {lab_wire.sym} 340 -90 0 1 {name=p24 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 340 -30 2 0 {name=p1 sig_type=std_logic lab=vss}
C {lab_wire.sym} 700 -110 0 1 {name=p2 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 700 -50 2 0 {name=p3 sig_type=std_logic lab=vss}
C {lab_wire.sym} 700 -20 0 1 {name=p4 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 700 40 2 0 {name=p5 sig_type=std_logic lab=vss}
C {symbols/cap_mim_analog.sym} 790 70 0 0 {name=C1
W=22.36u
L=22.36u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {symbols/cap_mim_analog.sym} 1010 70 0 0 {name=C2
W=22.36u
L=22.36u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_wire.sym} 1050 120 2 0 {name=p6 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1560 -60 0 1 {name=p7 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1560 -40 0 1 {name=p8 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1260 -20 0 0 {name=p9 sig_type=std_logic lab=clk_array}
C {preamp_comp_block.sym} 1410 -10 0 0 {name=x4}
C {bias.sym} 970 300 0 0 {name=x5}
C {refgen.sym} 970 220 0 0 {name=x6}
C {lab_wire.sym} 1120 190 0 1 {name=p10 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1120 280 0 1 {name=p11 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 1120 210 0 1 {name=p12 sig_type=std_logic lab=vss}
C {lab_wire.sym} 1120 300 0 1 {name=p13 sig_type=std_logic lab=vss}
C {lab_wire.sym} 820 280 0 0 {name=p14 sig_type=std_logic lab=iref_adc}
C {lab_wire.sym} 40 -90 0 0 {name=p15 sig_type=std_logic lab=inp}
C {lab_wire.sym} 40 -70 0 0 {name=p16 sig_type=std_logic lab=inn}
C {iopin.sym} 170 50 0 0 {name=p17 lab=vdd}
C {iopin.sym} 170 80 0 0 {name=p18 lab=vss}
C {ipin.sym} 230 110 0 0 {name=p19 lab=inp}
C {ipin.sym} 230 140 0 0 {name=p20 lab=inn}
C {ipin.sym} 230 170 0 0 {name=p21 lab=clk640}
C {ipin.sym} 230 230 0 0 {name=p22 lab=iref_adc

}
C {opin.sym} 140 260 0 0 {name=p23 lab=q[62:0]}
C {lab_wire.sym} 1560 -20 0 1 {name=p25 sig_type=std_logic lab=q[62:0]}
C {lab_wire.sym} 700 20 0 1 {name=p27 sig_type=std_logic lab=ckb}
C {lab_wire.sym} 700 -70 0 1 {name=p28 sig_type=std_logic lab=ckb}
C {clkshaper.sym} 410 400 0 0 {name=x7}
C {lab_wire.sym} 260 370 0 0 {name=p26 sig_type=std_logic lab=clk640}
C {lab_wire.sym} 560 370 0 1 {name=p29 sig_type=std_logic lab=ckb}
C {lab_wire.sym} 560 390 0 1 {name=p30 sig_type=std_logic lab=clkc_pre}
C {lab_wire.sym} 560 410 0 1 {name=p31 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 560 430 0 1 {name=p32 sig_type=std_logic lab=vss}
C {clkbuf.sym} 790 450 0 0 {name=x8}
C {lab_wire.sym} 940 450 0 1 {name=p33 sig_type=std_logic lab=vdd}
C {lab_wire.sym} 940 470 0 1 {name=p34 sig_type=std_logic lab=vss}
C {lab_wire.sym} 940 430 0 1 {name=p35 sig_type=std_logic lab=clk_array}
