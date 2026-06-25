v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {These capacitors are used to force
auto-creation of dac bridges
(digital count_out --> analog count_out).
Analog nodes can be plotted and saved
in raw file.} -732.5 -1290 0 0 0.3 0.3 {layer=7}
N -611.25 -1506.25 -611.25 -1496.25 {lab=Clk}
N 285 -1121.25 285 -1101.25 {lab=0}
N 140 -1126.25 140 -1106.25 {lab=0}
N 140 -1196.25 140 -1186.25 {lab=#net1}
N 285 -1191.25 285 -1181.25 {lab=#net2}
N 285 -1281.25 285 -1251.25 {lab=VoutN}
N 140 -1281.25 140 -1256.25 {lab=VoutP}
N -782.5 -1320 -762.5 -1320 {lab=dac_code[11..0]}
N -997.5 -1320 -982.5 -1320 {lab=Clk}
N -842.5 -1320 -782.5 -1320 {lab=dac_code[11..0]}
N -802.5 -1320 -802.5 -1280 {lab=dac_code[11..0]}
N 448.75 -1217.5 547.5 -1217.5 {lab=Vdd}
N 501.25 -1217.5 501.25 -1215 {lab=Vdd}
N 547.5 -1217.5 547.5 -1215 {lab=Vdd}
N 450 -1217.5 450 -1213.75 {lab=Vdd}
N 547.5 -1218.75 547.5 -1217.5 {lab=Vdd}
N 460 -1225 460 -1217.5 {lab=Vdd}
N -508.75 -1122.5 -491.25 -1122.5 {lab=#net3}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all

.param VCC=3.3
.control

pre_set auto_bridge_d_out = 
+ ( \\".model auto_dac dac_bridge(out_low=0.0 out_high=3.3 out_undef=1.8 input_load=1E-15 t_rise=50p t_fall=50p)\\" 
+ \\"auto_bridge%d [ %s ] [ %s ] auto_dac\\" )

tran 10p 200ns

* plot VU1syncP+6 VU1syncN+6 VU2syncP+6 VU2syncN+6 VgN+12 VgP Dm ClkP+18 ClkN+18 i(Vl1)*5E4-6 i(Vl2)*5E4-6 (i(Vl1)-i(Vl2))*5E4-12
* plot ClkP+6 ClkN+6 VU0in VB1in VU0syncP-6 VU0syncN-12 VB1syncP-6 VB1syncN-12
* plot Vout1P+15E-3 Vout1N+15E-3 Vout1P-Vout1N
* plot ClkP+5 ClkN+5 VB3syncP VB3syncN VB3bufP-5 VB3bufN-5 x1.Vg1P-10 x1.Vg1N-10 x2.Vg1P-15 x2.Vg1N-15

plot i(VoutB3P)-i(VoutB3N) i(VoutU0P)-i(VoutU0N) i(VoutB4P)-i(VoutB4N) i(VoutB2P)-i(VoutB2N) i(VoutB1P)-i(VoutB1N) xlimit 6.1ns 6.5ns

* plot VB1syncP VB1syncN-6 VB4syncN-6 VU0bufP-12 VB1bufP-12 VB4bufP-12 VU0bufN-18 VB1bufN-18 VB4bufN-18
* plot i(Vl1)-i(Vl2) i(Vl1)+100E-6 i(Vl2)+100E-6
plot i(Vl1)-i(Vl2)
let diff = i(Vl1)-i(Vl2)

* plot pulseP diff/560E-6*5 fghz xlimit 12ns 20ns
* plot pulseP diff/560E-6*5 fghz xlimit 0ns 8ns
* plot pulseP fghz

* plot dac_code0 dac_code1
* plot dac_code0 dac_code5


plot x7.Vshift x7.x1.vfil x7.x1.vref

* plot i(VoutB3P)+100E-6 i(VoutB3N)+100E-6 i(VoutB3P)-i(VoutB3N) i(VoutB3N)+i(VoutB3P) i(v.x1.Vcrr1)-200E-6 i(v.x1.Vcrr2)-200E-6
* plot i(Vl1) VB1in/5E4+200E-6 VU0in/5E4+200E-6
wrdata /foss/designs/dac/waveform_5bit.csv Clk dac_code0 dac_code1 dac_code2 dac_code3 dac_code4 i(Vl1) i(Vl2)  i(Vl1)-i(Vl2)
.endc
"}
C {code_shown.sym} 351.25 -1658.75 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {code_shown.sym} 510 -1655 0 0 {name=s2 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {gnd.sym} 510 -1295 0 0 {name=l4 lab=0}
C {vsource.sym} 510 -1325 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 510 -1415 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -611.25 -1506.25 1 0 {name=p88 sig_type=std_logic lab=Clk
value="DC 3.3"
}
C {gnd.sym} -611.25 -1436.25 0 0 {name=l7 lab=0
spice_ignore=short}
C {vsource.sym} -611.25 -1466.25 0 0 {name=VClkP value="PULSE(0.0 3.3 30ps 30ps 30ps \{T*0.5\} \{T\})" savecurrent=true
}
C {res.sym} 140 -1226.25 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 285 -1221.25 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 285 -1101.25 0 0 {name=l15 lab=0}
C {gnd.sym} 140 -1106.25 0 0 {name=l16 lab=0}
C {vsource.sym} 140 -1156.25 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 285 -1151.25 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 140 -1281.25 0 1 {name=p18 sig_type=std_logic lab=VoutP}
C {lab_pin.sym} 285 -1281.25 0 1 {name=p19 sig_type=std_logic lab=VoutN}
C {opin.sym} -762.5 -1320 0 0 {name=p97 lab=dac_code[11..0]}
C {parax_cap.sym} -802.5 -1270 0 0 {name=C2[11..0] gnd=0 value=1p m=1}
C {dac_codegen.sym} -912.5 -1320 0 0 {device_model=".model dac_codegen d_cosim simulation=\\"/foss/designs/dac/dac_codegen.so\\""}
C {ipin.sym} -997.5 -1320 0 0 {name=p96 lab=Clk}
C {param.sym} -626.25 -1558.75 0 0 {name=s3 value="T=1000ps"}
C {res.sym} 510 -1385 0 0 {name=R1
value=1
footprint=1206
device=resistor
m=1}
C {capa.sym} 450 -1187.5 0 0 {name=C1
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 450 -1157.5 0 0 {name=l1 lab=0}
C {capa.sym} 501.25 -1187.5 0 0 {name=C2
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 501.25 -1157.5 0 0 {name=l2 lab=0}
C {capa.sym} 547.5 -1187.5 0 0 {name=C3
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 547.5 -1157.5 0 0 {name=l3 lab=0}
C {lab_pin.sym} 460 -1225 1 0 {name=p2 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -202.5 -1227.5 2 1 {name=p3 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -202.5 -1272.5 2 1 {name=p5 sig_type=std_logic lab=CODE_P[5:0]}
C {lab_pin.sym} -2.5 -1272.5 0 1 {name=p10 sig_type=std_logic lab=VoutP}
C {lab_pin.sym} -2.5 -1252.5 0 1 {name=p20 sig_type=std_logic lab=VoutN}
C {dac_5b.sym} -102.5 -1242.5 0 0 {name=x8}
C {lab_pin.sym} -202.5 -1252.5 2 1 {name=p1 sig_type=std_logic lab=CODE_N[5:0]}
C {common/cmos_buf.sym} -568.75 -1112.5 0 0 {name=x2[5:0]}
C {lab_pin.sym} -608.75 -1132.5 2 1 {name=p4 sig_type=std_logic lab=dac_code[5..0]}
C {lab_pin.sym} -608.75 -1112.5 2 1 {name=p21 sig_type=std_logic lab=Vdd}
C {common/tg_flop.sym} -436.25 -1087.5 0 0 {name=x4[5:0]}
C {lab_pin.sym} -491.25 -1057.5 2 1 {name=p6 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -381.25 -1122.5 0 1 {name=p7 sig_type=std_logic lab=CODE_P[5:0]}
C {lab_pin.sym} -381.25 -1097.5 0 1 {name=p8 sig_type=std_logic lab=CODE_N[5:0]}
C {lab_pin.sym} -491.25 -1082.5 2 1 {name=p9 sig_type=std_logic lab=CLK}
