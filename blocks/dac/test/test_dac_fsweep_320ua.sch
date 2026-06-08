v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -367.5 -1292.5 -367.5 -1277.5 {lab=#net1}
N -367.5 -1217.5 -367.5 -1197.5 {lab=pulseP}
N -242.5 -1222.5 -242.5 -1197.5 {lab=pulseN}
N -242.5 -1292.5 -242.5 -1282.5 {lab=#net2}
N 312.5 -813.75 312.5 -793.75 {lab=0}
N 167.5 -818.75 167.5 -798.75 {lab=0}
N 167.5 -888.75 167.5 -878.75 {lab=#net3}
N 312.5 -883.75 312.5 -873.75 {lab=#net4}
N 312.5 -973.75 312.5 -943.75 {lab=Vout1N}
N 167.5 -973.75 167.5 -948.75 {lab=Vout1P}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all
.control

tran 1p 10ns
* plot VU1syncP+6 VU1syncN+6 VU2syncP+6 VU2syncN+6 VgN+12 VgP Dm ClkP+18 ClkN+18 i(Vl1)*5E4-6 i(Vl2)*5E4-6 (i(Vl1)-i(Vl2))*5E4-12
* plot ClkP+6 ClkN+6 VU0in VB1in VU0syncP-6 VU0syncN-12 VB1syncP-6 VB1syncN-12
* plot Vout1P+15E-3 Vout1N+15E-3 Vout1P-Vout1N
* plot ClkP+5 ClkN+5 VB3syncP VB3syncN VB3bufP-5 VB3bufN-5 xb3.x1.Vg1P-10 xb3.x1.Vg1N-10
plot 3.3-xb3.x1.Vg1P 3.3-xb3.x1.Vg1N

* plot x1.x1.Vcx x1.x1.Vg1P x1.x1.Vg1N

* plot VB1syncP VB1syncN-6 VB4syncN-6 VU0bufP-12 VB1bufP-12 VB4bufP-12 VU0bufN-18 VB1bufN-18 VB4bufN-18
plot i(Vl1)-i(Vl2) i(Vl1)+100E-6 i(Vl2)+100E-6

let imax = 320E-6
let imin = -320E-6
plot i(VB3P)-i(VB3N) imax imin
plot i(x4.Vbias[0])

let diff = i(Vl1)-i(Vl2)
plot pulseP diff/\{imax\}*5 fghz
* plot pulseP fghz

* plot i(VoutB3P)+100E-6 i(VoutB3N)+100E-6 i(VoutB3P)-i(VoutB3N) i(VoutB3N)+i(VoutB3P) i(v.x1.Vcrr1)-200E-6 i(v.x1.Vcrr2)-200E-6
* plot i(v.x1.Vcrr1) i(v.x1.Vcrr2)
* plot i(Vl1) VB1in/5E4+200E-6 VU0in/5E4+200E-6
* wrdata /foss/designs/dds/dac_isource_unary_pmos_80ua_v4_tt_500ps.csv ClkP ClkN Din VdsyncP VdsyncN i(Vl1) i(Vl2) 
.endc
"}
C {code_shown.sym} 390 -1515 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {code_shown.sym} -431.25 -1543.75 0 0 {name=s5 only_toplevel=false value=".param fs=0.25G fe=0.5G Tsw=10ns Vhi=3.3 Vlo=0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {lab_pin.sym} -367.5 -1197.5 2 0 {name=p9 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -367.5 -1247.5 0 0 {name=VB3 value="0.0" savecurrent=true
}
C {vsource.sym} -242.5 -1252.5 0 0 {name=VB1 value="0.0" savecurrent=true
}
C {lab_pin.sym} -242.5 -1197.5 2 0 {name=p10 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {gnd.sym} 472.5 -1203.75 0 0 {name=l1 lab=0}
C {vsource.sym} 472.5 -1233.75 0 0 {name=Vdd1 value=3.3 savecurrent=true}
C {lab_pin.sym} 472.5 -1263.75 1 0 {name=p2 sig_type=std_logic lab=Vdd}
C {res.sym} 167.5 -918.75 0 0 {name=R1
value=25
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 312.5 -913.75 0 0 {name=R2
value=25
footprint=1206
device=resistor
m=1}
C {gnd.sym} 312.5 -793.75 0 0 {name=l2 lab=0}
C {gnd.sym} 167.5 -798.75 0 0 {name=l3 lab=0}
C {vsource.sym} 167.5 -848.75 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 312.5 -843.75 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 167.5 -973.75 0 1 {name=p7 sig_type=std_logic lab=Vout1P}
C {lab_pin.sym} 312.5 -973.75 0 1 {name=p8 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} -12.5 -1053.75 2 1 {name=p15 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 247.5 -1133.75 0 1 {name=p20 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} 247.5 -1153.75 0 1 {name=p22 sig_type=std_logic lab=Vout1P}
C {iref/dac_iref.sym} 61.25 -1245 0 0 {name=x4}
C {lab_pin.sym} -38.75 -1265 2 1 {name=p23 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 161.25 -1265 0 1 {name=p24 sig_type=std_logic lab=VPCas[2:0]}
C {lab_pin.sym} 161.25 -1245 0 1 {name=p25 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 161.25 -1225 0 1 {name=p26 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -12.5 -1073.75 2 1 {name=p27 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -12.5 -1093.75 2 1 {name=p28 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -12.5 -1113.75 2 1 {name=p29 sig_type=std_logic lab=VPCas[0]}
C {ammeter.sym} 217.5 -1153.75 3 0 {name=VB3P savecurrent=true spice_ignore=0}
C {ammeter.sym} 217.5 -1133.75 3 0 {name=VB3N savecurrent=true spice_ignore=0}
C {cellv9/dac_cell_320ua_v9.sym} 87.5 -1103.75 0 0 {name=x1[2:0]}
C {lab_pin.sym} -12.5 -1153.75 0 0 {name=p1 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} -12.5 -1133.75 0 0 {name=p3 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {code_shown.sym} 600 -1655 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
