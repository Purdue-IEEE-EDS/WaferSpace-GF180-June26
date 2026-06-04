v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 485 -225 485 -182.5 {lab=0}
N 380 -225 380 -185 {lab=0}
N 575 -225 575 -180 {lab=0}
N 660 -225 660 -180 {lab=0}
N 380 -317.5 380 -285 {lab=Vdd}
N 485 -310 485 -285 {lab=Vb1}
N 575 -310 575 -285 {lab=Vb2}
N 660 -310 660 -285 {lab=Vin_n}
N 760 -222.5 760 -177.5 {lab=0}
N 760 -307.5 760 -282.5 {lab=Vin_p}
N 290 -225 290 -185 {lab=0}
N 290 -317.5 290 -285 {lab=Vss}
N 260 10 300 10 {lab=Vout}
N 70 -110 70 -50 {lab=Vdd}
N 70 70 70 120 {lab=Vss}
N -90 -20 -40 -20 {lab=Vb1}
N -90 0 -40 0 {lab=Vb2}
N -90 20 -40 20 {lab=Vin_p}
N -90 40 -40 40 {lab=Vin_n}
N 280 10 280 50 {lab=Vout}
N 280 110 280 140 {lab=0}
N 70 180 70 200 {lab=Vss}
N 70 120 70 180 {lab=Vss}
C {op_amp.sym} 110 10 0 0 {name=x1}
C {vsource.sym} 380 -255 0 0 {name=V1 value=\{VDD\} savecurrent=false}
C {vsource.sym} 485 -255 0 0 {name=V2 value=\{VB1\} savecurrent=false}
C {vsource.sym} 575 -255 0 0 {name=V3 value=\{VB2\} savecurrent=false}
C {vsource.sym} 660 -255 0 0 {name=V4 value="DC \{VCM\} AC -0.5 PULSE(\{VCM+50m\} \{VCM-50m\} 1n 10p 10p 20n 50n)" savecurrent=false}
C {gnd.sym} 380 -185 0 0 {name=l2 lab=0}
C {gnd.sym} 485 -182.5 0 0 {name=l3 lab=0}
C {gnd.sym} 575 -180 0 0 {name=l4 lab=0}
C {gnd.sym} 660 -180 0 0 {name=l5 lab=0}
C {lab_wire.sym} 380 -317.5 0 0 {name=p6 sig_type=std_logic lab=Vdd}
C {vsource.sym} 760 -252.5 0 0 {name=V5 value="DC \{VCM\} AC 0.5 PULSE(\{VCM-50m\} \{VCM+50m\} 1n 10p 10p 20n 50n)" savecurrent=false}
C {gnd.sym} 760 -177.5 0 0 {name=l6 lab=0}
C {lab_wire.sym} 485 -310 0 0 {name=p7 sig_type=std_logic lab=Vb1}
C {lab_wire.sym} 575 -310 0 0 {name=p8 sig_type=std_logic lab=Vb2}
C {lab_wire.sym} 660 -307.5 0 0 {name=p9 sig_type=std_logic lab=Vin_n}
C {lab_wire.sym} 760 -307.5 0 0 {name=p10 sig_type=std_logic lab=Vin_p}
C {vsource.sym} 290 -255 0 0 {name=V6 value=\{VSS\} savecurrent=false}
C {gnd.sym} 290 -185 0 0 {name=l7 lab=0}
C {lab_wire.sym} 290 -317.5 0 0 {name=p4 sig_type=std_logic lab=Vss}
C {code_shown.sym} 1040 -560 0 0 {name=s1 only_toplevel=false value="
.param VDD=3.3
.param VSS=0
.param VCM=1.2
.param VB1=0.0
.param VB2=1.5
.param IB=100u
.param CL=10f

.control
save all
set filetype=ascii
set wr_singlescale
set wr_vecnames

op

* AC gain
ac dec 50 1 100G
let vin_diff_ac = v(Vin_p)-v(Vin_n)
let gain = v(Vout)/vin_diff_ac
wrdata /foss/designs/trans_testing/ota_testing/ota_ac.txt frequency mag(gain) db(gain) ph(gain)

* Transient slew rate
tran 1p 50n
let vin_diff = v(Vin_p)-v(Vin_n)
let slew = deriv(v(Vout))
wrdata /foss/designs/trans_testing/ota_testing/ota_tran.txt time v(Vin_p) v(Vin_n) vin_diff v(Vout) slew

.endc
"}
C {devices/code_shown.sym} 220 -600 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {lab_wire.sym} 300 10 0 1 {name=p1 sig_type=std_logic lab=Vout}
C {lab_wire.sym} 70 -110 3 1 {name=p2 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 70 200 3 0 {name=p3 sig_type=std_logic lab=Vss}
C {lab_wire.sym} -90 -20 0 0 {name=p5 sig_type=std_logic lab=Vb1}
C {lab_wire.sym} -90 0 0 0 {name=p11 sig_type=std_logic lab=Vb2}
C {lab_wire.sym} -90 20 0 0 {name=p12 sig_type=std_logic lab=Vin_p}
C {lab_wire.sym} -90 40 0 0 {name=p13 sig_type=std_logic lab=Vin_n}
C {capa.sym} 280 80 0 0 {name=C1
m=1
value=\{CL\}
footprint=1206
device="ceramic capacitor"}
C {gnd.sym} 280 140 0 0 {name=l1 lab=0}
