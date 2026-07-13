v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 2150 -1380 2950 -980 {flags=graph
y1=-0.054
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3.024688e-10
x2=1.3682375e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="wl[6]
wl[5]
wl[4]
wl[3]
wl[2]
wl[1]
wl[0]"
color="4 5 21 16 14 12 17"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 2160 -830 2960 -430 {flags=graph
y1=0
y2=3.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=3.024688e-10
x2=1.3682375e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
color="4 5 7 8 10"
node="comp[4]
comp[3]
comp[2]
comp[1]
comp[0]"}
N 890 -1170 960 -1170 {lab=wl[1:61]}
N 740 -1230 740 -1200 {lab=VDD}
N 740 -1060 740 -1030 {lab=GND}
N 1290 -1260 1290 -1230 {lab=VDD}
N 1290 -1170 1290 -1150 {lab=GND}
N 490 -1150 590 -1150 {lab=comp[0:60]}
N 490 -1130 585 -1130 {lab=comp[1:61]}
N 585 -1130 590 -1130 {lab=comp[1:61]}
N 490 -1110 590 -1110 {lab=comp[2:62]}
N 890 -880 960 -880 {lab=wl[0]}
N 740 -940 740 -910 {lab=VDD}
N 740 -770 740 -740 {lab=GND}
N 490 -860 590 -860 {lab=VDD}
N 490 -840 585 -840 {lab=comp[0]}
N 585 -840 590 -840 {lab=comp[0]}
N 490 -820 590 -820 {lab=comp[1]}
N 890 -1470 960 -1470 {lab=wl[62]}
N 740 -1530 740 -1500 {lab=VDD}
N 740 -1360 740 -1330 {lab=GND}
N 490 -1450 590 -1450 {lab=comp[61]}
N 490 -1430 585 -1430 {lab=comp[62]}
N 585 -1430 590 -1430 {lab=comp[62]}
N 490 -1410 590 -1410 {lab=GND}
N 970 -1480 970 -890 {lab=wl[0:62]
bus=true}
N 220 -1480 370 -1480 {lab=comp[0:62]
bus=true
}
N 380 -1490 490 -1490 {lab=comp[61]}
N 490 -1490 490 -1450 {lab=comp[61]}
N 360 -1480 360 -800 {lab=comp[0:62]
bus=true}
N 370 -840 490 -840 {lab=comp[0]}
N 370 -860 490 -860 {lab=VDD}
N 370 -1110 490 -1110 {lab=comp[2:62]}
N 370 -1130 490 -1130 {lab=comp[1:61]}
N 370 -1150 490 -1150 {lab=comp[0:60]}
N 370 -1430 490 -1430 {lab=comp[62]}
C {vsource.sym} 1290 -1200 0 0 {name=V1 value=3.3 savecurrent=false}
C {vdd.sym} 1290 -1260 0 0 {name=l3 lab=VDD}
C {gnd.sym} 1290 -1150 0 1 {name=l4 lab=GND
}
C {opin.sym} 975 -1110 0 0 {name=p421 lab=wl[62:0]}
C {code_shown.sym} 1440 -1715 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice ss
"}
C {code_shown.sym} 1440 -1555 0 0 {name=SPICE only_toplevel=false value="
V_C0 comp[0] 0 PWL(0 0 0.50n 0 0.51n 3.3)
V_C1 comp[1] 0 PWL(0 0 1.00n 0 1.01n 3.3)
V_C2 comp[2] 0 PWL(0 0 1.50n 0 1.51n 3.3)
V_C3 comp[3] 0 PWL(0 0 2.00n 0 2.01n 3.3)
V_C4 comp[4] 0 PWL(0 0 2.50n 0 2.51n 3.3)
V_C5 comp[5] 0 PWL(0 0 3.00n 0 3.01n 3.3)
V_C6 comp[6] 0 PWL(0 0 3.50n 0 3.51n 3.3)
V_C7 comp[7] 0 PWL(0 0 4.00n 0 4.01n 3.3)
V_C8 comp[8] 0 PWL(0 0 4.50n 0 4.51n 3.3)
V_C9 comp[9] 0 PWL(0 0 5.00n 0 5.01n 3.3)
V_C10 comp[10] 0 PWL(0 0 5.50n 0 5.51n 3.3)
V_C11 comp[11] 0 PWL(0 0 6.00n 0 6.01n 3.3)
V_C12 comp[12] 0 PWL(0 0 6.50n 0 6.51n 3.3)
V_C13 comp[13] 0 PWL(0 0 7.00n 0 7.01n 3.3)
V_C14 comp[14] 0 PWL(0 0 7.50n 0 7.51n 3.3)
V_C15 comp[15] 0 PWL(0 0 8.00n 0 8.01n 3.3)
V_C16 comp[16] 0 PWL(0 0 8.50n 0 8.51n 3.3)
V_C17 comp[17] 0 PWL(0 0 9.00n 0 9.01n 3.3)
V_C18 comp[18] 0 PWL(0 0 9.50n 0 9.51n 3.3)
V_C19 comp[19] 0 PWL(0 0 10.00n 0 10.01n 3.3)
V_C20 comp[20] 0 PWL(0 0 10.50n 0 10.51n 3.3)
V_C21 comp[21] 0 PWL(0 0 11.00n 0 11.01n 3.3)
V_C22 comp[22] 0 PWL(0 0 11.50n 0 11.51n 3.3)
V_C23 comp[23] 0 PWL(0 0 12.00n 0 12.01n 3.3)
V_C24 comp[24] 0 PWL(0 0 12.50n 0 12.51n 3.3)
V_C25 comp[25] 0 PWL(0 0 13.00n 0 13.01n 3.3)
V_C26 comp[26] 0 PWL(0 0 13.50n 0 13.51n 3.3)
V_C27 comp[27] 0 PWL(0 0 14.00n 0 14.01n 3.3)
V_C28 comp[28] 0 PWL(0 0 14.50n 0 14.51n 3.3)
V_C29 comp[29] 0 PWL(0 0 15.00n 0 15.01n 3.3)
V_C30 comp[30] 0 PWL(0 0 15.50n 0 15.51n 3.3)
V_C31 comp[31] 0 PWL(0 0 16.00n 0 16.01n 3.3)
V_C32 comp[32] 0 PWL(0 0 16.50n 0 16.51n 3.3)
V_C33 comp[33] 0 PWL(0 0 17.00n 0 17.01n 3.3)
V_C34 comp[34] 0 PWL(0 0 17.50n 0 17.51n 3.3)
V_C35 comp[35] 0 PWL(0 0 18.00n 0 18.01n 3.3)
V_C36 comp[36] 0 PWL(0 0 18.50n 0 18.51n 3.3)
V_C37 comp[37] 0 PWL(0 0 19.00n 0 19.01n 3.3)
V_C38 comp[38] 0 PWL(0 0 19.50n 0 19.51n 3.3)
V_C39 comp[39] 0 PWL(0 0 20.00n 0 20.01n 3.3)
V_C40 comp[40] 0 PWL(0 0 20.50n 0 20.51n 3.3)
V_C41 comp[41] 0 PWL(0 0 21.00n 0 21.01n 3.3)
V_C42 comp[42] 0 PWL(0 0 21.50n 0 21.51n 3.3)
V_C43 comp[43] 0 PWL(0 0 22.00n 0 22.01n 3.3)
V_C44 comp[44] 0 PWL(0 0 22.50n 0 22.51n 3.3)
V_C45 comp[45] 0 PWL(0 0 23.00n 0 23.01n 3.3)
V_C46 comp[46] 0 PWL(0 0 23.50n 0 23.51n 3.3)
V_C47 comp[47] 0 PWL(0 0 24.00n 0 24.01n 3.3)
V_C48 comp[48] 0 PWL(0 0 24.50n 0 24.51n 3.3)
V_C49 comp[49] 0 PWL(0 0 25.00n 0 25.01n 3.3)
V_C50 comp[50] 0 PWL(0 0 25.50n 0 25.51n 3.3)
V_C51 comp[51] 0 PWL(0 0 26.00n 0 26.01n 3.3)
V_C52 comp[52] 0 PWL(0 0 26.50n 0 26.51n 3.3)
V_C53 comp[53] 0 PWL(0 0 27.00n 0 27.01n 3.3)
V_C54 comp[54] 0 PWL(0 0 27.50n 0 27.51n 3.3)
V_C55 comp[55] 0 PWL(0 0 28.00n 0 28.01n 3.3)
V_C56 comp[56] 0 PWL(0 0 28.50n 0 28.51n 3.3)
V_C57 comp[57] 0 PWL(0 0 29.00n 0 29.01n 3.3)
V_C58 comp[58] 0 PWL(0 0 29.50n 0 29.51n 3.3)
V_C59 comp[59] 0 PWL(0 0 30.00n 0 30.01n 3.3)
V_C60 comp[60] 0 PWL(0 0 30.50n 0 30.51n 3.3)
V_C61 comp[61] 0 PWL(0 0 31.00n 0 31.01n 3.3)
V_C62 comp[62] 0 PWL(0 0 31.50n 0 31.51n 3.3)

.tran 10p 6n uic

.control
  run
  write full_decoder_test.raw
.endc
"}
C {lab_wire.sym} 920 -1470 0 0 {name=p10 sig_type=std_logic lab=wl[62]}
C {lab_wire.sym} 930 -880 0 0 {name=p16 sig_type=std_logic lab=wl[0]}
C {lab_wire.sym} 940 -1170 0 0 {name=p17 sig_type=std_logic lab=wl[1:61]}
C {lab_wire.sym} 290 -1480 0 0 {name=p4 sig_type=std_logic lab=comp[0:62]}
C {bus_connect_nolab.sym} 370 -1480 0 0 {name=r1}
C {lab_wire.sym} 460 -1430 0 0 {name=p6 sig_type=std_logic lab=comp[62]}
C {ipin.sym} 217.5 -1479.743656265541 0 0 {name=p8 lab=comp[0:62]}
C {bus_connect_nolab.sym} 360 -1420 0 0 {name=r2}
C {bus_connect_nolab.sym} 360 -1140 0 0 {name=r3}
C {bus_connect_nolab.sym} 360 -1120 0 0 {name=r4}
C {bus_connect_nolab.sym} 360 -1100 0 0 {name=r5}
C {bus_connect_nolab.sym} 360 -850 0 0 {name=r6}
C {bus_connect_nolab.sym} 360 -830 0 0 {name=r7}
C {lab_wire.sym} 470 -1490 0 0 {name=p11 sig_type=std_logic lab=comp[61]}
C {lab_wire.sym} 490 -1150 0 0 {name=p14 sig_type=std_logic lab=comp[0:60]}
C {lab_wire.sym} 490 -1130 0 0 {name=p15 sig_type=std_logic lab=comp[1:61]}
C {lab_wire.sym} 490 -1110 0 0 {name=p18 sig_type=std_logic lab=comp[2:62]}
C {lab_wire.sym} 500 -840 0 0 {name=p19 sig_type=std_logic lab=comp[0]}
C {lab_wire.sym} 500 -820 0 0 {name=p20 sig_type=std_logic lab=comp[1]}
C {lab_wire.sym} 740 -1230 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 740 -1030 0 0 {name=p2 sig_type=std_logic lab=GND}
C {lab_wire.sym} 740 -930 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 740 -740 0 0 {name=p9 sig_type=std_logic lab=GND}
C {lab_wire.sym} 500 -860 0 0 {name=p12 sig_type=std_logic lab=VDD}
C {bus_connect_nolab.sym} 960 -1470 0 0 {name=r8}
C {bus_connect_nolab.sym} 960 -1170 0 0 {name=r9}
C {bus_connect_nolab.sym} 960 -880 0 0 {name=r10}
C {lab_wire.sym} 510 -1410 0 0 {name=p13 sig_type=std_logic lab=GND}
C {lab_wire.sym} 740 -1330 0 0 {name=p3 sig_type=std_logic lab=GND}
C {lab_wire.sym} 740 -1530 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 970 -1240 0 0 {name=p21 sig_type=std_logic lab=wl[0:62]}
C {encoder/sym/NAND3.sym} 740 -1430 0 0 {name=x_top2}
C {encoder/sym/NAND3.sym} 740 -1130 0 0 {name=x1[61:1]}
C {encoder/sym/NAND3.sym} 740 -840 0 0 {name=x_bot1}
C {launcher.sym} 2210 -930 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/th_to_oh_test.raw tran"
}
