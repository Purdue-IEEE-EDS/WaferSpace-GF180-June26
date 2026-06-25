v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Master IREF=10uA} -285 -531.25 0 0 0.2 0.2 {}
N 380 -1230 380 -1210 {lab=Vdd}
N 462.5 -1212.5 561.25 -1212.5 {lab=Vdd}
N 515 -1212.5 515 -1210 {lab=Vdd}
N 561.25 -1212.5 561.25 -1210 {lab=Vdd}
N 463.75 -1212.5 463.75 -1208.75 {lab=Vdd}
N 561.25 -1213.75 561.25 -1212.5 {lab=Vdd}
N 473.75 -1220 473.75 -1212.5 {lab=Vdd}
N 488.75 -542.5 488.75 -522.5 {lab=0}
N 393.75 -547.5 393.75 -527.5 {lab=0}
N 393.75 -617.5 393.75 -607.5 {lab=#net1}
N 488.75 -612.5 488.75 -602.5 {lab=#net2}
N 488.75 -702.5 488.75 -672.5 {lab=VOUT_N}
N 393.75 -702.5 393.75 -677.5 {lab=VOUT_P}
C {simulator_commands_shown.sym} 710 -965 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.save all
.control

tran 1p 5ns
* plot VU1syncP+6 VU1syncN+6 VU2syncP+6 VU2syncN+6 VgN+12 VgP Dm ClkP+18 ClkN+18 i(Vl1)*5E4-6 i(Vl2)*5E4-6 (i(Vl1)-i(Vl2))*5E4-12
* plot ClkP+6 ClkN+6 VU0in VB1in VU0syncP-6 VU0syncN-12 VB1syncP-6 VB1syncN-12
* plot Vout1P+15E-3 Vout1N+15E-3 Vout1P-Vout1N
* plot ClkP+5 ClkN+5 VB3syncP VB3syncN VB3bufP-5 VB3bufN-5 xb3.x1.Vg1P-10 xb3.x1.Vg1N-10
plot 3.3-xb3.Vg1P 3.3-xb3.Vg1N

* plot x1.x1.Vcx x1.x1.Vg1P x1.x1.Vg1N

* plot VB1syncP VB1syncN-6 VB4syncN-6 VU0bufP-12 VB1bufP-12 VB4bufP-12 VU0bufN-18 VB1bufN-18 VB4bufN-18
plot i(Vl1)-i(Vl2) i(Vl1)+100E-6 i(Vl2)+100E-6

let imax = 20E-6
let imin = -20E-6
plot i(VB3P)-i(VB3N) imax imin

let diff = i(Vl1)-i(Vl2)
plot pulseP diff/\{imax\}*5 fghz
* plot pulseP fghz

.endc
"}
C {code_shown.sym} 705 -1120 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {code_shown.sym} 695 -1380 0 0 {name=s5 only_toplevel=false value=".param fs=0.5G fe=6G Tsw=15ns Vhi=3.3 Vlo=0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9
"}
C {gnd.sym} 380 -1090 0 0 {name=l1 lab=0}
C {vsource.sym} 380 -1120 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 380 -1230 1 0 {name=p24 sig_type=std_logic lab=Vdd}
C {res.sym} 380 -1180 0 0 {name=R1
value=2
footprint=1206
device=resistor
m=1}
C {capa.sym} 463.75 -1182.5 0 0 {name=C1
m=1
value=0.1u
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 463.75 -1152.5 0 0 {name=l2 lab=0}
C {capa.sym} 515 -1182.5 0 0 {name=C2
m=1
value=10p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 515 -1152.5 0 0 {name=l3 lab=0}
C {capa.sym} 561.25 -1182.5 0 0 {name=C3
m=1
value=1p
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 561.25 -1152.5 0 0 {name=l4 lab=0}
C {lab_pin.sym} 473.75 -1220 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {res.sym} 393.75 -647.5 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 488.75 -642.5 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 488.75 -522.5 0 0 {name=l15 lab=0}
C {gnd.sym} 393.75 -527.5 0 0 {name=l16 lab=0}
C {vsource.sym} 393.75 -577.5 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 488.75 -572.5 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 393.75 -702.5 0 1 {name=p18 sig_type=std_logic lab=VOUT_P}
C {lab_pin.sym} 488.75 -702.5 0 1 {name=p19 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} -142.5 -947.5 2 0 {name=p1 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -142.5 -977.5 0 0 {name=VB1 value="0.0" savecurrent=true
}
C {vsource.sym} -37.5 -977.5 0 0 {name=VB4 value="0.0" savecurrent=true
}
C {lab_pin.sym} -37.5 -947.5 2 0 {name=p3 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {lab_pin.sym} -37.5 -1007.5 2 0 {name=p42 sig_type=std_logic lab=VB3bufN
value="DC 3.3"
}
C {lab_pin.sym} -142.5 -1007.5 2 0 {name=p7 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -27.5 -832.5 2 1 {name=p303 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} -27.5 -812.5 2 1 {name=p304 sig_type=std_logic lab=pulseN}
C {lab_pin.sym} -27.5 -752.5 2 1 {name=p305 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -27.5 -772.5 2 1 {name=p306 sig_type=std_logic lab=IREF0}
C {lab_pin.sym} -27.5 -792.5 2 1 {name=p308 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} 232.5 -812.5 0 1 {name=p337 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} 232.5 -832.5 0 1 {name=p338 sig_type=std_logic lab=VOUT_P}
C {ammeter.sym} 202.5 -832.5 3 0 {name=VB0P savecurrent=true spice_ignore=0}
C {ammeter.sym} 202.5 -812.5 3 0 {name=VB0N savecurrent=true spice_ignore=0}
C {iref/dac_iref.sym} -371.25 -672.5 0 0 {name=x6}
C {lab_pin.sym} -471.25 -682.5 2 1 {name=p128 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -271.25 -682.5 0 1 {name=p129 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} -271.25 -662.5 0 1 {name=p130 sig_type=std_logic lab=IREF[35..0]}
C {isource.sym} -301.25 -556.25 0 0 {name=Iref2 value="DC 10uA AC 0"}
C {gnd.sym} -301.25 -526.25 0 0 {name=l5 lab=0}
C {lab_pin.sym} -301.25 -586.25 2 1 {name=p4 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} -471.25 -662.5 0 0 {name=p12 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} -28.75 -692.5 2 1 {name=p2 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} -28.75 -672.5 2 1 {name=p5 sig_type=std_logic lab=pulseN}
C {lab_pin.sym} -28.75 -612.5 2 1 {name=p6 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -28.75 -632.5 2 1 {name=p8 sig_type=std_logic lab=IREF1}
C {lab_pin.sym} -28.75 -652.5 2 1 {name=p9 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} 231.25 -672.5 0 1 {name=p10 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} 231.25 -692.5 0 1 {name=p11 sig_type=std_logic lab=VOUT_P}
C {ammeter.sym} 201.25 -692.5 3 0 {name=VB2 savecurrent=true spice_ignore=0}
C {ammeter.sym} 201.25 -672.5 3 0 {name=VB3 savecurrent=true spice_ignore=0}
C {cellv9/dac_cell_20ua_v9.sym} 72.5 -792.5 0 0 {name=x1}
C {code_shown.sym} 706.25 -1587.5 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
C {cellv9/dac_cell_20ua_v9.sym} 71.25 -652.5 0 0 {name=x2}
