v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Master IREF=10uA} -268.75 -867.5 0 0 0.2 0.2 {}
N -367.5 -1292.5 -367.5 -1277.5 {lab=#net1}
N -367.5 -1217.5 -367.5 -1197.5 {lab=pulseP}
N -242.5 -1222.5 -242.5 -1197.5 {lab=pulseN}
N -242.5 -1292.5 -242.5 -1282.5 {lab=#net2}
N 505 -878.75 505 -858.75 {lab=0}
N 410 -883.75 410 -863.75 {lab=0}
N 410 -953.75 410 -943.75 {lab=#net3}
N 505 -948.75 505 -938.75 {lab=#net4}
N 505 -1038.75 505 -1008.75 {lab=VOUT_N}
N 410 -1038.75 410 -1013.75 {lab=VOUT_P}
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
C {code_shown.sym} 600 -1655 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {res.sym} 410 -983.75 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 505 -978.75 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 505 -858.75 0 0 {name=l15 lab=0}
C {gnd.sym} 410 -863.75 0 0 {name=l16 lab=0}
C {vsource.sym} 410 -913.75 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 505 -908.75 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 410 -1038.75 0 1 {name=p18 sig_type=std_logic lab=VOUT_P}
C {lab_pin.sym} 505 -1038.75 0 1 {name=p19 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} -11.25 -1168.75 2 1 {name=p303 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} -11.25 -1148.75 2 1 {name=p304 sig_type=std_logic lab=pulseN}
C {lab_pin.sym} -11.25 -1088.75 2 1 {name=p305 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -11.25 -1108.75 2 1 {name=p306 sig_type=std_logic lab=IREF[3..0]}
C {lab_pin.sym} -11.25 -1128.75 2 1 {name=p308 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} 248.75 -1148.75 0 1 {name=p337 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} 248.75 -1168.75 0 1 {name=p338 sig_type=std_logic lab=VOUT_P}
C {ammeter.sym} 218.75 -1168.75 3 0 {name=VB0P savecurrent=true spice_ignore=0}
C {ammeter.sym} 218.75 -1148.75 3 0 {name=VB0N savecurrent=true spice_ignore=0}
C {iref/dac_iref.sym} -355 -1008.75 0 0 {name=x6}
C {lab_pin.sym} -455 -1018.75 2 1 {name=p128 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -255 -1018.75 0 1 {name=p129 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} -255 -998.75 0 1 {name=p130 sig_type=std_logic lab=IREF[35..0]}
C {isource.sym} -285 -892.5 0 0 {name=Iref2 value="DC 10uA AC 0"}
C {gnd.sym} -285 -862.5 0 0 {name=l5 lab=0}
C {lab_pin.sym} -285 -922.5 2 1 {name=p4 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} -455 -998.75 0 0 {name=p12 sig_type=std_logic lab=IREF_MASTER_10UA}
C {cellv9/dac_cell_320ua_v9.sym} 88.75 -1128.75 0 0 {name=x1}
