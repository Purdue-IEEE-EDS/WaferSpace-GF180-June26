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
C {op_amp.sym} 110 10 0 0 {name=x1}
C {vsource.sym} 380 -255 0 0 {name=V1 value=\{VDD\} savecurrent=false}
C {vsource.sym} 485 -255 0 0 {name=V2 value=\{VB1\} savecurrent=false}
C {vsource.sym} 575 -255 0 0 {name=V3 value=\{VB2\} savecurrent=false}
C {vsource.sym} 660 -255 0 0 {name=V4 value=\{VCM\} savecurrent=false}
C {gnd.sym} 380 -185 0 0 {name=l2 lab=0}
C {gnd.sym} 485 -182.5 0 0 {name=l3 lab=0}
C {gnd.sym} 575 -180 0 0 {name=l4 lab=0}
C {gnd.sym} 660 -180 0 0 {name=l5 lab=0}
C {lab_wire.sym} 380 -317.5 0 0 {name=p6 sig_type=std_logic lab=Vdd}
C {vsource.sym} 760 -252.5 0 0 {name=V5 value="DC \{VCM\} AC 0.2" savecurrent=false}
C {gnd.sym} 760 -177.5 0 0 {name=l6 lab=0}
C {lab_wire.sym} 485 -310 0 0 {name=p7 sig_type=std_logic lab=Vb1}
C {lab_wire.sym} 575 -310 0 0 {name=p8 sig_type=std_logic lab=Vb2}
C {lab_wire.sym} 660 -307.5 0 0 {name=p9 sig_type=std_logic lab=Vin_n}
C {lab_wire.sym} 760 -307.5 0 0 {name=p10 sig_type=std_logic lab=Vin_p}
C {vsource.sym} 290 -255 0 0 {name=V6 value=\{VSS\} savecurrent=false}
C {gnd.sym} 290 -185 0 0 {name=l7 lab=0}
C {lab_wire.sym} 290 -317.5 0 0 {name=p4 sig_type=std_logic lab=Vss}
C {code_shown.sym} 1070 -560 0 0 {name=s1 only_toplevel=false value="
.param VDD=3.3
.param VSS=0
.param VCM=0
.param VB1=-2.5
.param VB2=0.19
.param CL=100f
.control
save all


* AC Analysis
ac dec 50 1 10G
write /foss/designs/trans_testing/ota_testing/ota_ac.raw v(Vout)


DC Analysis 
dc V5 -0.1 0.1 0.1m
write /foss/designs/trans_testing/ota_testing/ota_dc.raw v(Vout)

* Transient Analysis (Slew Rate)
* Alter V5 to a pulse source for the step response
alter v5 = pulse(-0.5 0.5 1n 10p 10p 20n 50n)
tran 10p 50n
write /foss/designs/trans_testing/ota_testing/ota_tran.raw v(Vout) v(Vin_p)



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
C {lab_wire.sym} 70 120 3 0 {name=p3 sig_type=std_logic lab=Vss}
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
