v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
T {Master IREF=10uA} -561.25 -723.75 0 0 0.2 0.2 {}
N 410 -1225 410 -1205 {lab=Vdd}
N -440 -1170 -440 -1155 {lab=VB1bufP}
N -440 -1095 -440 -1075 {lab=pulseP}
N -315 -1100 -315 -1075 {lab=pulseN}
N -315 -1170 -315 -1160 {lab=VB1bufN}
N 241.25 -665 241.25 -645 {lab=0}
N 146.25 -670 146.25 -650 {lab=0}
N 146.25 -740 146.25 -730 {lab=#net1}
N 241.25 -735 241.25 -725 {lab=#net2}
N 241.25 -825 241.25 -795 {lab=VOUT_N}
N 146.25 -825 146.25 -800 {lab=VOUT_P}
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
C {gnd.sym} 410 -1145 0 0 {name=l4 lab=0}
C {vsource.sym} 410 -1175 0 0 {name=Vdd value=3.3 savecurrent=true}
C {lab_pin.sym} 410 -1225 1 0 {name=p13 sig_type=std_logic lab=Vdd}
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
C {iref/dac_iref.sym} -647.5 -865 0 0 {name=x6}
C {lab_pin.sym} -747.5 -875 2 1 {name=p128 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -547.5 -875 0 1 {name=p129 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} -547.5 -855 0 1 {name=p130 sig_type=std_logic lab=IREF[35..0]}
C {isource.sym} -577.5 -748.75 0 0 {name=Iref2 value="DC 10uA AC 0"}
C {gnd.sym} -577.5 -718.75 0 0 {name=l5 lab=0}
C {lab_pin.sym} -577.5 -778.75 2 1 {name=p7 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} -747.5 -855 0 0 {name=p9 sig_type=std_logic lab=IREF_MASTER_10UA}
C {lab_pin.sym} -318.75 -876.25 2 1 {name=p303 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} -318.75 -856.25 2 1 {name=p304 sig_type=std_logic lab=pulseN}
C {lab_pin.sym} -318.75 -796.25 2 1 {name=p305 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -318.75 -816.25 2 1 {name=p306 sig_type=std_logic lab=IREF0}
C {lab_pin.sym} -318.75 -836.25 2 1 {name=p308 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} -58.75 -856.25 0 1 {name=p337 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} -58.75 -876.25 0 1 {name=p338 sig_type=std_logic lab=VOUT_P}
C {ammeter.sym} -88.75 -876.25 3 0 {name=VB0P savecurrent=true spice_ignore=0}
C {ammeter.sym} -88.75 -856.25 3 0 {name=VB0N savecurrent=true spice_ignore=0}
C {lab_pin.sym} -320 -736.25 2 1 {name=p1 sig_type=std_logic lab=pulseP}
C {lab_pin.sym} -320 -716.25 2 1 {name=p5 sig_type=std_logic lab=pulseN}
C {lab_pin.sym} -320 -656.25 2 1 {name=p6 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} -320 -676.25 2 1 {name=p3 sig_type=std_logic lab=IREF1}
C {lab_pin.sym} -320 -696.25 2 1 {name=p4 sig_type=std_logic lab=VCAS}
C {lab_pin.sym} -60 -716.25 0 1 {name=p10 sig_type=std_logic lab=VOUT_N}
C {lab_pin.sym} -60 -736.25 0 1 {name=p11 sig_type=std_logic lab=VOUT_P}
C {ammeter.sym} -90 -736.25 3 0 {name=VB2 savecurrent=true spice_ignore=0}
C {ammeter.sym} -90 -716.25 3 0 {name=VB1 savecurrent=true spice_ignore=0}
C {cellv9/dac_cell_40ua_v9.sym} -218.75 -836.25 0 0 {name=x1}
C {cellv9/dac_cell_40ua_v9.sym} -220 -696.25 0 0 {name=x2}
C {res.sym} 146.25 -770 0 0 {name=R3
value=100
footprint=1206
device=resistor
m=1
savecurrent=true}
C {res.sym} 241.25 -765 0 0 {name=R4
value=100
footprint=1206
device=resistor
m=1}
C {gnd.sym} 241.25 -645 0 0 {name=l15 lab=0}
C {gnd.sym} 146.25 -650 0 0 {name=l16 lab=0}
C {vsource.sym} 146.25 -700 0 0 {name=Vl1 value=0.0 savecurrent=true
}
C {vsource.sym} 241.25 -695 0 0 {name=Vl2 value=0.0 savecurrent=true
}
C {lab_pin.sym} 146.25 -825 0 1 {name=p18 sig_type=std_logic lab=VOUT_P}
C {lab_pin.sym} 241.25 -825 0 1 {name=p19 sig_type=std_logic lab=VOUT_N}
C {code_shown.sym} 603.75 -1647.5 0 0 {name=s3 only_toplevel=false value=
"
.include /foss/pdks/gf180mcuD/libs.tech/ngspice/design.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice res_typical
.lib /foss/pdks/gf180mcuD/libs.tech/ngspice/sm141064.ngspice mimcap_typical
"}
