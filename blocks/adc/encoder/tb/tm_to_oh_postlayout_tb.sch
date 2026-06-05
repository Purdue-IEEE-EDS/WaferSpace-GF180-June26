v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 2810 -1800 3610 -1400 {flags=graph
y1=-0.06
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1e-13
x2=6e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="wl[7]
wl[6]
wl[5]
wl[4]
wl[3]
wl[2]
wl[1]
wl[0]"
color="4 5 6 7 8 9 10 11"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 2820 -1180 3620 -780 {flags=graph
y1=0
y2=3.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1e-13
x2=6e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="comp[14]
comp[13]
comp[12]
comp[11]
comp[10]
comp[9]
comp[8]
comp[7]
comp[6]
comp[5]
comp[4]
comp[3]
comp[2]
comp[1]
comp[0]"
color="4 5 6 7 8 9 10 11 12 13 14 15 16 17 18"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 2820 -780 3620 -380 {flags=graph
y1=3.3
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=1e-13
x2=6e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
color="4 12"
node="vdd
gnd"}
N 1550 -1280 1550 -1250 {lab=VDD}
N 1550 -1190 1550 -1170 {lab=GND}
N 680 -820 710 -820 {lab=GND}
N 680 -860 710 -860 {lab=VDD}
N 600 -840 710 -840 {lab=comp[0:62]
bus=true}
N 1010 -860 1120 -860 {lab=wl[62:0]
bus=true}
C {vsource.sym} 1550 -1220 0 0 {name=V1 value=3.3 savecurrent=false}
C {vdd.sym} 1550 -1280 0 0 {name=l3 lab=VDD}
C {gnd.sym} 1550 -1170 0 1 {name=l4 lab=GND
}
C {opin.sym} 1115 -860 0 0 {name=p421 lab=wl[62:0]}
C {code_shown.sym} 1700 -1735 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice ss
"}
C {code_shown.sym} 1700 -1575 0 0 {name=SPICE only_toplevel=false value="
.include /foss/designs/encoder/spice/tm_to_bin2.spice
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
C {encoder/sym/tm_to_bin2.sym} 860 -840 0 0 {name=x1}
C {ipin.sym} 607.5 -839.7436562655409 0 0 {name=p22 lab=comp[0:62]}
C {lab_wire.sym} 690 -860 0 0 {name=p23 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 690 -820 0 0 {name=p24 sig_type=std_logic lab=GND}
C {lab_wire.sym} 700 -840 0 0 {name=p77 sig_type=std_logic lab=comp[0:62]}
C {lab_wire.sym} 1110 -860 0 0 {name=p25 sig_type=std_logic lab=wl[62:0]}
C {launcher.sym} 2850 -1290 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/tm_to_oh_postlayout_tb.raw tran"
}
