v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 410 -1225 410 -1205 {lab=Vdd}
N 445 -770 445 -750 {lab=0}
N 300 -775 300 -755 {lab=0}
N 300 -845 300 -835 {lab=#net1}
N 445 -840 445 -830 {lab=#net2}
N 445 -930 445 -900 {lab=Vout1N}
N 300 -930 300 -905 {lab=Vout1P}
N -440 -1170 -440 -1155 {lab=VB1bufP}
N -440 -1095 -440 -1075 {lab=pulseP}
N -315 -1100 -315 -1075 {lab=pulseN}
N -315 -1170 -315 -1160 {lab=VB1bufN}
C {simulator_commands_shown.sym} 630 -1475 0 0 {name=COMMANDS1
simulator=ngspice
only_toplevel=false 
value="
.control
.save all

tran 1p 10ns

* plot VU1syncP+6 VU1syncN+6 VU2syncP+6 VU2syncN+6 VgN+12 VgP Dm ClkP+18 ClkN+18 i(Vl1)*5E4-6 i(Vl2)*5E4-6 (i(Vl1)-i(Vl2))*5E4-12
* plot ClkP+6 ClkN+6 VU0in VB1in VU0syncP-6 VU0syncN-12 VB1syncP-6 VB1syncN-12
* plot Vout1P+15E-3 Vout1N+15E-3 Vout1P-Vout1N

* plot ClkP+5 ClkN+5 VB1syncP VB1syncN VB1bufP-5 VB1bufN-5 x1.Vg1P-10 x1.Vg1N-10
plot VB1bufP+5 VB1bufN+5 x1.Vg1P x1.Vg1N

let imax = 40E-6
let imin = -40E-6
plot i(Vl1)-i(Vl2) imax imin xlimit 1ns 4ns
plot i(x1.VinP) i(x1.VinN)

let diff = i(Vl1)-i(Vl2)
plot pulseP \{diff/\{imax\}\}*5 fghz

* common mode
* plot x1.x1.vi2 x1.x1.vi1b x1.x1.vi1a x1.x1.vi0
* plot x1.Vcx x1.VcbP x1.VcbN x1.Vcx-x1.VxP x1.VxP x1.VxN

plot i(VB3P)-i(VB3N)
plot VNmir VNcas VPcas x1.Vpmir

* wrdata /foss/designs/dds/dac_isource_unary_pmos_80ua_v4_tt_500ps.csv ClkP ClkN Din VdsyncP VdsyncN i(Vl1) i(Vl2) 
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
C {gnd.sym} 410 -1145 0 0 {name=l4 lab=0}
C {vsource.sym} 410 -1175 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 410 -1225 1 0 {name=p13 sig_type=std_logic lab=Vdd}
C {res.sym} 300 -875 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 445 -870 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 445 -750 0 0 {name=l15 lab=0}
C {gnd.sym} 300 -755 0 0 {name=l16 lab=0}
C {vsource.sym} 300 -805 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 445 -800 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 300 -930 0 1 {name=p18 sig_type=std_logic lab=Vout1P}
C {lab_pin.sym} 445 -930 0 1 {name=p19 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} -440 -1170 0 1 {name=p31 sig_type=std_logic lab=VB1bufP}
C {lab_pin.sym} -315 -1170 0 1 {name=p32 sig_type=std_logic lab=VB1bufN}
C {lab_pin.sym} -440 -1075 2 0 {name=p2 sig_type=std_logic lab=pulseP
value="DC 3.3"
}
C {vsource.sym} -440 -1125 0 0 {name=VB3 value="0.0" savecurrent=true
}
C {vsource.sym} -315 -1130 0 0 {name=VB5 value="0.0" savecurrent=true
}
C {lab_pin.sym} -315 -1075 2 0 {name=p8 sig_type=std_logic lab=pulseN
value="DC 3.3"
}
C {code_shown.sym} -655 -1360 0 0 {name=s5 only_toplevel=false value=".param fs=0.5G fe=2G Tsw=10ns Vhi=3.3 Vlo=0.0
Bphase phase 0 V = (fs*Tsw/ln(fe/fs)) * ((fe/fs)^(time/Tsw) - 1)
BpulseP pulseP 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vhi : Vlo
BpulseN pulseN 0 V = (V(phase) - floor(V(phase))) < 0.5 ? Vlo : Vhi
Bfghz  fghz  0 V = (fs * (fe/fs)^(time/Tsw)) / 1e9

"}
C {lab_pin.sym} -335 -765 2 1 {name=p21 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -335 -865 2 1 {name=p5 sig_type=std_logic lab=VB1bufP}
C {lab_pin.sym} -335 -845 2 1 {name=p46 sig_type=std_logic lab=VB1bufN}
C {lab_pin.sym} -75 -845 0 1 {name=p47 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} -75 -865 0 1 {name=p48 sig_type=std_logic lab=Vout1P}
C {iref/dac_iref.sym} -260 -955 0 0 {name=x4}
C {lab_pin.sym} -360 -975 2 1 {name=p7 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -160 -975 0 1 {name=p9 sig_type=std_logic lab=VPCas}
C {lab_pin.sym} -160 -955 0 1 {name=p10 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -160 -935 0 1 {name=p11 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -335 -785 2 1 {name=p6 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -335 -805 2 1 {name=p12 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -335 -825 2 1 {name=p14 sig_type=std_logic lab=VPCas}
C {ammeter.sym} -105 -865 3 0 {name=VB3P savecurrent=true spice_ignore=0}
C {ammeter.sym} -105 -845 3 0 {name=VB3N savecurrent=true spice_ignore=0}
C {cellv9/dac_cell_40ua_v9.sym} -235 -815 0 0 {name=x1}
C {lab_pin.sym} -335 -605 2 1 {name=p1 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -335 -705 2 1 {name=p3 sig_type=std_logic lab=VB1bufP}
C {lab_pin.sym} -335 -685 2 1 {name=p4 sig_type=std_logic lab=VB1bufN}
C {lab_pin.sym} -75 -685 0 1 {name=p15 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} -75 -705 0 1 {name=p16 sig_type=std_logic lab=Vout1P}
C {lab_pin.sym} -335 -625 2 1 {name=p17 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -335 -645 2 1 {name=p20 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -335 -665 2 1 {name=p22 sig_type=std_logic lab=VPCas}
C {ammeter.sym} -105 -705 3 0 {name=VB1 savecurrent=true spice_ignore=0}
C {ammeter.sym} -105 -685 3 0 {name=VB2 savecurrent=true spice_ignore=0}
C {cellv9/dac_cell_40ua_v9.sym} -235 -655 0 0 {name=x2}
C {lab_pin.sym} -335 -455 2 1 {name=p23 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -335 -555 2 1 {name=p24 sig_type=std_logic lab=VB1bufP}
C {lab_pin.sym} -335 -535 2 1 {name=p25 sig_type=std_logic lab=VB1bufN}
C {lab_pin.sym} -135 -535 0 1 {name=p26 sig_type=std_logic lab=Vout1N}
C {lab_pin.sym} -135 -555 0 1 {name=p27 sig_type=std_logic lab=Vout1P}
C {lab_pin.sym} -335 -475 2 1 {name=p28 sig_type=std_logic lab=VNMir}
C {lab_pin.sym} -335 -495 2 1 {name=p29 sig_type=std_logic lab=VNCas}
C {lab_pin.sym} -335 -515 2 1 {name=p30 sig_type=std_logic lab=VPCas}
C {cellv9/dac_cell_40ua_v9.sym} -235 -505 0 0 {name=x3}
