v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 180 -40 230 -40 {lab=#net1}
N -180 -40 -120 -40 {lab=Vdd}
N -240 -20 -170 -20 {lab=#net2}
N -240 0 -170 -0 {lab=#net3}
N -575 -35 -530 -35 {lab=Vdd}
N -595 145 -575 145 {lab=Vcm}
N -575 25 -575 145 {lab=Vcm}
N -575 25 -530 25 {lab=Vcm}
N -1060 25 -1060 85 {lab=#net4}
N -1060 145 -1060 195 {lab=GND}
N -840 25 -840 85 {lab=#net5}
N -840 145 -840 195 {lab=GND}
N -840 55 -740 55 {lab=#net5}
N -740 10 -740 55 {lab=#net5}
N -740 5 -740 10 {lab=#net5}
N -740 5 -530 5 {lab=#net5}
N -1005 -20 -1005 50 {lab=#net4}
N -1060 50 -1005 50 {lab=#net4}
N -1005 -15 -530 -15 {lab=#net4}
N -170 -20 -120 -20 {lab=#net2}
N -170 -0 -120 0 {lab=#net3}
N -230 -15 -230 -0 {lab=#net3}
N -230 -35 -230 -20 {lab=#net2}
C {code_shown.sym} 150 -540 0 0 {name=s1 only_toplevel=false value="
.param VDD=3.3
.param VCM=1.2
.param VDIFF=0.3
.param FREQ=1G
.param VBIAS=1.65

Vdd   Vdd   0 \{VDD\}
Vbias Vbias 0 \{VBIAS\}
Vcm VCM 0 \{VCM\}


.tran 1p 5n
.save all

.control 
run 
plot v(net1) v(net2) v(net3)
plot v(net2) v(net3)
.endc
"}
C {lab_pin.sym} -180 -40 0 0 {name=p3 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} -595 145 0 0 {name=p16 sig_type=std_logic lab=Vcm}
C {gnd.sym} -1060 195 0 0 {name=l11 lab=GND}
C {gnd.sym} -840 195 0 0 {name=l12 lab=GND}
C {vsource.sym} -1060 115 0 0 {name=V3 value="pulse(3.3 0 0 10p 10p 240p 500p)" savecurrent=false}
C {vsource.sym} -840 115 0 0 {name=V4 value="pulse(0 3.3 0 10p 10p 240p 500p)" savecurrent=false}
C {devices/code_shown.sym} -580 -580 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
* .lib $::180MCU_MODELS/sm141064.ngspice res_statistical
"}
C {lvds_v4.sym} -380 -5 0 0 {name=x2}
C {lvds_rec_v1.sym} 30 -20 0 0 {name=x1}
C {lab_wire.sym} -575 -35 0 0 {name=p1 sig_type=std_logic lab=Vdd}
