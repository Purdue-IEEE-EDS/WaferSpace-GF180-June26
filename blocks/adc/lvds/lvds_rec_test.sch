v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N -220 -40 -120 -40 {lab=#net1}
N -220 -180 -220 -40 {lab=#net1}
N 140 -10 210 -10 {lab=Vout}
N -160 -180 -90 -180 {lab=0}
N -290 -20 -120 -20 {lab=in_n}
N -290 0 -120 -0 {lab=in_p}
N -290 20 -120 20 {lab=#net2}
N -290 20 -290 90 {lab=#net2}
N -490 -290 -490 -260 {lab=0}
N -560 -290 -560 -260 {lab=0}
N -560 -260 -530 -260 {lab=0}
N -530 -260 -530 -240 {lab=0}
N -530 -260 -490 -260 {lab=0}
N -560 -390 -560 -350 {lab=in_n}
N -490 -380 -490 -350 {lab=in_p}
C {lvds_rec_v1.sym} 0 80 0 0 {name=x1}
C {lab_pin.sym} 210 -10 2 0 {name=p1 sig_type=std_logic lab=Vout
}
C {vsource.sym} -190 -180 3 0 {name=V1 value=3.3 savecurrent=false}
C {gnd.sym} -90 -180 3 0 {name=l1 lab=0}
C {vsource.sym} -290 120 0 0 {name=V2 value=1.65 savecurrent=false}
C {vsource.sym} -560 -320 0 0 {name=V3 value="SINE(1.2 0.15 1.2G 0 0 180)" savecurrent=false}
C {vsource.sym} -490 -320 0 0 {name=V4 value="SINE(1.2 0.15 1.2G)" savecurrent=false}
C {gnd.sym} -530 -240 0 0 {name=l2 lab=0}
C {lab_pin.sym} -560 -390 0 0 {name=p2 sig_type=std_logic lab=in_n
}
C {lab_pin.sym} -490 -380 0 0 {name=p3 sig_type=std_logic lab=in_p}
C {devices/code_shown.sym} -350 -520 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {lab_pin.sym} -290 -20 0 0 {name=p4 sig_type=std_logic lab=in_n}
C {lab_pin.sym} -290 0 0 0 {name=p5 sig_type=std_logic lab=in_p}
C {code_shown.sym} -810 -470 0 0 {name=s1 only_toplevel=false value="
.tran 5p 20n
.control
run
plot (Vout)
plot (in_n) (in_p)
plot I(lvds_rec_v1.ibias)
.endc
"}
