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
in raw file.} 860 -225 0 0 0.3 0.3 {layer=7}
N -410 -1420 -410 -1410 {lab=Clk}
N 705 -380 705 -360 {lab=0}
N 560 -385 560 -365 {lab=0}
N 560 -455 560 -445 {lab=#net1}
N 705 -450 705 -440 {lab=#net2}
N 705 -540 705 -510 {lab=VoutN}
N 560 -540 560 -515 {lab=VoutP}
N 810 -255 830 -255 {lab=dac_code[11..0]}
N 595 -255 610 -255 {lab=Clk}
N 750 -255 810 -255 {lab=dac_code[11..0]}
N 790 -255 790 -215 {lab=dac_code[11..0]}
N 448.75 -1217.5 547.5 -1217.5 {lab=Vdd}
N 501.25 -1217.5 501.25 -1215 {lab=Vdd}
N 547.5 -1217.5 547.5 -1215 {lab=Vdd}
N 450 -1217.5 450 -1213.75 {lab=Vdd}
N 547.5 -1218.75 547.5 -1217.5 {lab=Vdd}
N 460 -1225 460 -1217.5 {lab=Vdd}
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

tran 100p 200ns

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
C {code_shown.sym} 390 -1515 0 0 {name=s1 only_toplevel=false value="
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
C {lab_pin.sym} -410 -1420 1 0 {name=p88 sig_type=std_logic lab=Clk
value="DC 3.3"
}
C {gnd.sym} -410 -1350 0 0 {name=l7 lab=0
spice_ignore=short}
C {vsource.sym} -410 -1380 0 0 {name=VClkP value="PULSE(0.0 3.3 0 30ps 30ps \{T*0.5\} \{T\})" savecurrent=true
}
C {res.sym} 560 -485 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 705 -480 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 705 -360 0 0 {name=l15 lab=0}
C {gnd.sym} 560 -365 0 0 {name=l16 lab=0}
C {vsource.sym} 560 -415 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 705 -410 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 560 -540 0 1 {name=p18 sig_type=std_logic lab=VoutP}
C {lab_pin.sym} 705 -540 0 1 {name=p19 sig_type=std_logic lab=VoutN}
C {vsource.sym} -400 -960 0 0 {name=VB4 value="0.0" savecurrent=true
}
C {lab_pin.sym} -400 -930 2 0 {name=p6 sig_type=std_logic lab=dac_code3
value="DC 3.3"
}
C {lab_pin.sym} -280 -930 2 0 {name=p8 sig_type=std_logic lab=dac_code9
value="DC 3.3"
}
C {vsource.sym} -400 -775 0 0 {name=VB7 value="0.0" savecurrent=true
}
C {lab_pin.sym} -400 -745 2 0 {name=p35 sig_type=std_logic lab=dac_code5
value="DC 3.3"
}
C {vsource.sym} -280 -960 0 0 {name=VB8 value="0.0" savecurrent=true
}
C {vsource.sym} -280 -775 0 0 {name=VB9 value="0.0" savecurrent=true
}
C {lab_pin.sym} -280 -745 2 0 {name=p37 sig_type=std_logic lab=dac_code11
value="DC 3.3"
}
C {lab_pin.sym} -400 -805 2 0 {name=p41 sig_type=std_logic lab=VU0bufP
value="DC 3.3"
}
C {lab_pin.sym} -280 -990 2 0 {name=p42 sig_type=std_logic lab=VB3bufN
value="DC 3.3"
}
C {lab_pin.sym} -280 -805 2 0 {name=p45 sig_type=std_logic lab=VU0bufN
value="DC 3.3"
}
C {lab_pin.sym} -400 -990 2 0 {name=p7 sig_type=std_logic lab=VB3bufP}
C {vsource.sym} -400 -1050 0 0 {name=VB2 value="0.0" savecurrent=true
}
C {lab_pin.sym} -400 -1020 2 0 {name=p52 sig_type=std_logic lab=dac_code2
value="DC 3.3"
}
C {lab_pin.sym} -280 -1020 2 0 {name=p53 sig_type=std_logic lab=dac_code8
value="DC 3.3"
}
C {vsource.sym} -280 -1050 0 0 {name=VB13 value="0.0" savecurrent=true
}
C {lab_pin.sym} -280 -1080 2 0 {name=p56 sig_type=std_logic lab=VB2bufN
value="DC 3.3"
}
C {lab_pin.sym} -400 -1080 2 0 {name=p58 sig_type=std_logic lab=VB2bufP}
C {vsource.sym} -400 -870 0 0 {name=VB17 value="0.0" savecurrent=true
}
C {lab_pin.sym} -400 -840 2 0 {name=p62 sig_type=std_logic lab=dac_code4
value="DC 3.3"
}
C {lab_pin.sym} -280 -840 2 0 {name=p63 sig_type=std_logic lab=dac_code10
value="DC 3.3"
}
C {vsource.sym} -280 -870 0 0 {name=VB18 value="0.0" savecurrent=true
}
C {lab_pin.sym} -280 -900 2 0 {name=p66 sig_type=std_logic lab=VB4bufN
value="DC 3.3"
}
C {lab_pin.sym} -400 -900 2 0 {name=p68 sig_type=std_logic lab=VB4bufP}
C {vsource.sym} -400 -1140 0 0 {name=VB22 value="0.0" savecurrent=true
}
C {lab_pin.sym} -400 -1110 2 0 {name=p86 sig_type=std_logic lab=dac_code1
value="DC 3.3"
}
C {lab_pin.sym} -280 -1110 2 0 {name=p87 sig_type=std_logic lab=dac_code7
value="DC 3.3"
}
C {vsource.sym} -280 -1140 0 0 {name=VB23 value="0.0" savecurrent=true
}
C {lab_pin.sym} -280 -1170 2 0 {name=p93 sig_type=std_logic lab=VB1bufN
value="DC 3.3"
}
C {lab_pin.sym} -400 -1170 2 0 {name=p95 sig_type=std_logic lab=VB1bufP}
C {opin.sym} 830 -255 0 0 {name=p97 lab=dac_code[11..0]}
C {parax_cap.sym} 790 -205 0 0 {name=C2[11..0] gnd=0 value=1p m=1}
C {dac_codegen.sym} 680 -255 0 0 {device_model=".model dac_codegen d_cosim simulation=\\"/foss/designs/dac/dac_codegen.so\\""}
C {ipin.sym} 595 -255 0 0 {name=p96 lab=Clk}
C {vsource.sym} -400 -1235 0 0 {name=VB1 value="0.0" savecurrent=true
}
C {lab_pin.sym} -400 -1205 2 0 {name=p104 sig_type=std_logic lab=dac_code0
value="DC 3.3"
}
C {lab_pin.sym} -280 -1205 2 0 {name=p105 sig_type=std_logic lab=dac_code6
value="DC 3.3"
}
C {vsource.sym} -280 -1235 0 0 {name=VB3 value="0.0" savecurrent=true
}
C {lab_pin.sym} -280 -1265 2 0 {name=p108 sig_type=std_logic lab=VB0bufN
value="DC 3.3"
}
C {lab_pin.sym} -400 -1265 2 0 {name=p110 sig_type=std_logic lab=VB0bufP}
C {lab_pin.sym} -1.25 -901.25 2 1 {name=p26 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -1.25 -881.25 2 1 {name=p27 sig_type=std_logic lab=VB3bufN}
C {lab_pin.sym} -1.25 -631.25 2 1 {name=p15 sig_type=std_logic lab=VU0bufP}
C {lab_pin.sym} -1.25 -611.25 2 1 {name=p16 sig_type=std_logic lab=VU0bufN}
C {lab_pin.sym} -1.25 -746.25 2 1 {name=p30 sig_type=std_logic lab=VB4bufN}
C {lab_pin.sym} -1.25 -1036.25 2 1 {name=p72 sig_type=std_logic lab=VB2bufP}
C {lab_pin.sym} -1.25 -1016.25 2 1 {name=p73 sig_type=std_logic lab=VB2bufN}
C {lab_pin.sym} -1.25 -1166.25 2 1 {name=p79 sig_type=std_logic lab=VB1bufP}
C {lab_pin.sym} -1.25 -1146.25 2 1 {name=p80 sig_type=std_logic lab=VB1bufN}
C {lab_pin.sym} -1.25 -766.25 2 1 {name=p4 sig_type=std_logic lab=VB4bufP}
C {lab_pin.sym} -1.25 -1301.25 2 1 {name=p99 sig_type=std_logic lab=VB0bufP}
C {lab_pin.sym} -1.25 -1281.25 2 1 {name=p100 sig_type=std_logic lab=VB0bufN}
C {cellv9/dac_cell_160ua_v9.sym} 98.75 -716.25 0 0 {name=x1}
C {cellv9/dac_cell_320ua_v9.sym} 98.75 -581.25 0 0 {name=x2}
C {cellv9/dac_cell_80ua_v9.sym} 98.75 -851.25 0 0 {name=x4}
C {cellv9/dac_cell_20ua_v9.sym} 98.75 -1116.25 0 0 {name=x5}
C {cellv9/dac_cell_40ua_v9.sym} 98.75 -986.25 0 0 {name=x6}
C {cellv9/dac_cell_10ua_v9.sym} 98.75 -1251.25 0 0 {name=x7}
C {lab_pin.sym} -1.25 -1201.25 2 1 {name=p11 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -1.25 -1221.25 2 1 {name=p25 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -1.25 -1241.25 2 1 {name=p12 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -1.25 -1261.25 2 1 {name=p14 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -1.25 -1066.25 2 1 {name=p17 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -1.25 -1086.25 2 1 {name=p21 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -1.25 -1106.25 2 1 {name=p22 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -1.25 -1126.25 2 1 {name=p23 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -1.25 -936.25 2 1 {name=p24 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -1.25 -956.25 2 1 {name=p28 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -1.25 -976.25 2 1 {name=p32 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -1.25 -996.25 2 1 {name=p46 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -1.25 -801.25 2 1 {name=p47 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -1.25 -821.25 2 1 {name=p48 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -1.25 -841.25 2 1 {name=p59 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -1.25 -861.25 2 1 {name=p69 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -1.25 -666.25 2 1 {name=p90 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -1.25 -686.25 2 1 {name=p70 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -1.25 -706.25 2 1 {name=p71 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -1.25 -726.25 2 1 {name=p74 sig_type=std_logic lab=VPCas[0]}
C {lab_pin.sym} -1.25 -531.25 2 1 {name=p75 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -1.25 -551.25 2 1 {name=p76 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -1.25 -571.25 2 1 {name=p77 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -1.25 -591.25 2 1 {name=p78 sig_type=std_logic lab=VPCas[1]}
C {lab_pin.sym} 258.75 -881.25 0 1 {name=p81 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 258.75 -901.25 0 1 {name=p82 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 228.75 -901.25 3 0 {name=VB3P savecurrent=true spice_ignore=0}
C {ammeter.sym} 228.75 -881.25 3 0 {name=VB3N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 258.75 -746.25 0 1 {name=p84 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 258.75 -766.25 0 1 {name=p98 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 228.75 -766.25 3 0 {name=VB4P savecurrent=true spice_ignore=0}
C {ammeter.sym} 228.75 -746.25 3 0 {name=VB4N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 258.75 -611.25 0 1 {name=p101 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 258.75 -631.25 0 1 {name=p102 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 228.75 -631.25 3 0 {name=VU0P savecurrent=true spice_ignore=0}
C {ammeter.sym} 228.75 -611.25 3 0 {name=VU0N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 258.75 -1146.25 0 1 {name=p128 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 258.75 -1166.25 0 1 {name=p129 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 228.75 -1166.25 3 0 {name=VB1P savecurrent=true spice_ignore=0}
C {ammeter.sym} 228.75 -1146.25 3 0 {name=VB1N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 258.75 -1281.25 0 1 {name=p130 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 258.75 -1301.25 0 1 {name=p131 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 228.75 -1301.25 3 0 {name=VB0P savecurrent=true spice_ignore=0}
C {ammeter.sym} 228.75 -1281.25 3 0 {name=VB0N savecurrent=true spice_ignore=0}
C {lab_pin.sym} 258.75 -1016.25 0 1 {name=p132 sig_type=std_logic lab=VoutN}
C {lab_pin.sym} 258.75 -1036.25 0 1 {name=p133 sig_type=std_logic lab=VoutP}
C {ammeter.sym} 228.75 -1036.25 3 0 {name=VB2P savecurrent=true spice_ignore=0}
C {ammeter.sym} 228.75 -1016.25 3 0 {name=VB2N savecurrent=true spice_ignore=0}
C {param.sym} -425 -1472.5 0 0 {name=s3 value="T=1000ps"}
C {iref/dac_iref.sym} 60 -1450 0 0 {name=x3}
C {lab_pin.sym} -40 -1470 2 1 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 160 -1470 0 1 {name=p36 sig_type=std_logic lab=VPCas[2:0]}
C {lab_pin.sym} 160 -1450 0 1 {name=p38 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 160 -1430 0 1 {name=p39 sig_type=std_logic lab=VNCas}
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
