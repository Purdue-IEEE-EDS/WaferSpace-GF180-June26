v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 550 -1425 550 -1405 {lab=Vdd}
N 425 -570 425 -550 {lab=0}
N 330 -575 330 -555 {lab=0}
N 330 -645 330 -635 {lab=#net1}
N 425 -640 425 -630 {lab=#net2}
N 425 -730 425 -700 {lab=Vout1N}
N 330 -730 330 -705 {lab=Vout1P}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
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

let imax = 10E-6
let imin = -10E-6
plot i(VB3P)-i(VB3N) imax imin

let diff = i(Vl1)-i(Vl2)
plot pulseP diff/\{imax\}*5 fghz
* plot pulseP fghz
.endc
"}
C {code_shown.sym} 390 -1515 0 0 {name=s1 only_toplevel=false value="
.op
.save all
"}
C {code_shown.sym} 390 -1615 0 0 {name=s2 only_toplevel=false value=
"
.include /headless/QucsWorkspace/IHP-Open-PDK/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /headless/QucsWorkspace/IHP-Open-PDK/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
"}
C {gnd.sym} 550 -1345 0 0 {name=l4 lab=0}
C {vsource.sym} 550 -1375 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 550 -1425 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {res.sym} 330 -675 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 425 -670 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 425 -550 0 0 {name=l15 lab=0}
C {gnd.sym} 330 -555 0 0 {name=l16 lab=0}
C {vsource.sym} 330 -605 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 425 -600 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 330 -730 0 1 {name=p18 sig_type=std_logic lab=Vout1P}
C {lab_pin.sym} 425 -730 0 1 {name=p19 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} -253.75 -912.5 2 0 {name=p2 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -253.75 -942.5 0 0 {name=VB3 value="0.0" savecurrent=true
}
C {vsource.sym} -148.75 -942.5 0 0 {name=VB4 value="0.0" savecurrent=true
}
C {lab_pin.sym} -148.75 -912.5 2 0 {name=p8 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {code_shown.sym} 645 -820 0 0 {name=s5 only_toplevel=false value=".param fs=0.5G fe=6G Tsw=15ns Vhi=3.3 Vlo=0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {lab_pin.sym} -148.75 -972.5 2 0 {name=p42 sig_type=std_logic lab=VB3bufN
value="DC 3.3"
}
C {lab_pin.sym} -253.75 -972.5 2 0 {name=p7 sig_type=std_logic lab=VB3bufP}
C {cellv9/dac_cell_10ua_v9.sym} -25 -630 0 0 {name=x1}
C {lab_pin.sym} -125 -580 2 1 {name=p6 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -125 -680 2 1 {name=p9 sig_type=std_logic lab=VB3bufP}
C {lab_pin.sym} -125 -660 2 1 {name=p10 sig_type=std_logic lab=VB3bufN}
C {lab_pin.sym} 135 -660 0 1 {name=p11 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} 135 -680 0 1 {name=p12 sig_type=std_logic lab=Vout1P}
C {iref/dac_iref.sym} 135 -937.5 0 0 {name=x4}
C {lab_pin.sym} 35 -957.5 2 1 {name=p14 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 235 -957.5 0 1 {name=p15 sig_type=std_logic lab=VPCas}
C {lab_pin.sym} 235 -937.5 0 1 {name=p16 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} 235 -917.5 0 1 {name=p17 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -125 -600 2 1 {name=p20 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -125 -620 2 1 {name=p22 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -125 -640 2 1 {name=p23 sig_type=std_logic lab=VPCas}
C {ammeter.sym} 105 -680 3 0 {name=VB3P savecurrent=true spice_ignore=0}
C {ammeter.sym} 105 -660 3 0 {name=VB3N savecurrent=true spice_ignore=0}
