v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 620 -370 820 -370 {lab=Va}
N 820 -180 840 -180 {lab=#net1}
N 780 -180 820 -180 {lab=#net1}
N 920 -170 1000 -170 {lab=Qa}
N 800 -160 840 -160 {lab=#net2}
N 800 -160 800 -80 {lab=#net2}
N 800 -80 900 -80 {lab=#net2}
N 780 -180 780 10 {lab=#net1}
N 780 10 820 10 {lab=#net1}
N 900 -80 900 100 {lab=#net2}
N 900 -360 900 -280 {lab=#net1}
N 780 -280 900 -280 {lab=#net1}
N 780 -280 780 -180 {lab=#net1}
N 820 -350 820 -260 {lab=Qa}
N 820 -260 940 -260 {lab=Qa}
N 940 -260 940 -170 {lab=Qa}
N 780 100 900 100 {lab=#net2}
N 800 30 800 120 {lab=#net3}
N 800 120 940 120 {lab=#net3}
N 940 120 940 210 {lab=#net3}
N 920 210 940 210 {lab=#net3}
N 780 100 780 200 {lab=#net2}
N 780 200 840 200 {lab=#net2}
N 760 220 840 220 {lab=RST}
N 620 330 820 330 {lab=Vb}
N 820 520 840 520 {lab=#net4}
N 780 520 820 520 {lab=#net4}
N 920 530 1000 530 {lab=Qb}
N 800 540 840 540 {lab=#net5}
N 800 540 800 620 {lab=#net5}
N 800 620 900 620 {lab=#net5}
N 780 520 780 710 {lab=#net4}
N 780 710 820 710 {lab=#net4}
N 900 620 900 800 {lab=#net5}
N 900 340 900 420 {lab=#net4}
N 780 420 900 420 {lab=#net4}
N 780 420 780 520 {lab=#net4}
N 820 350 820 440 {lab=Qb}
N 820 440 940 440 {lab=Qb}
N 940 440 940 530 {lab=Qb}
N 780 800 900 800 {lab=#net5}
N 800 730 800 820 {lab=#net6}
N 800 820 940 820 {lab=#net6}
N 940 820 940 900 {lab=#net6}
N 920 900 940 900 {lab=#net6}
N 780 800 780 890 {lab=#net5}
N 780 890 840 890 {lab=#net5}
N 760 910 840 910 {lab=RST}
N 1000 -170 1000 170 {lab=Qa}
N 1000 190 1000 530 {lab=Qb}
N 800 730 820 730 {lab=#net6}
N 800 30 820 30 {lab=#net3}
N 1220 160 1220 220 {lab=RST}
N 1180 130 1180 250 {lab=#net7}
N 1080 180 1180 180 {lab=#net7}
N 1220 250 1220 280 {lab=GND}
N 1220 100 1220 130 {lab=VDD}
N 1220 200 1340 200 {lab=RST}
C {devices/code_shown.sym} 10 -875 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
* .lib $::180MCU_MODELS/sm141064.ngspice res_statistical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
"
lvs_ignore=true}
C {blocks/pll/nor.sym} 860 -350 0 0 {name=x2}
C {blocks/pll/nor.sym} 880 -160 0 0 {name=x3}
C {lab_wire.sym} 880 -200 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {blocks/pll/nor.sym} 860 30 0 0 {name=x4}
C {devices/code_shown.sym} 10 -665 0 0 {name=NGSPICE only_toplevel=true
value="
V_VDD vdd 0 3.3v
* V_RST rst 0 pulse(0 3.3 0 1n 1n 10u 20u)
.control
save all
tran 0.10u 30u
plot v(qa) v(qb)
plot v(net1) v(net5)
write VCO_GF180.raw
.endc
"
lvs_ignore=true}
C {vsource.sym} 620 -340 0 0 {name=V2 value="PULSE(0 3.3 1.5u 1n 1n 1u 2u)" savecurrent=false only_toplevel=true lvs_ignore=true}
C {gnd.sym} 620 -310 0 1 {name=l9 lab=GND lvs_ignore=true
only_toplevel=true}
C {lab_wire.sym} 860 -390 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 860 -330 0 0 {name=p8 lab=GND}
C {lab_pin.sym} 880 -140 0 0 {name=p18 lab=GND}
C {lab_wire.sym} 860 -10 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 860 50 0 0 {name=p19 lab=GND}
C {blocks/pll/nor.sym} 880 220 0 0 {name=x5}
C {lab_wire.sym} 760 220 0 0 {name=p6 sig_type=std_logic lab=RST}
C {lab_pin.sym} 880 240 0 0 {name=p20 lab=GND}
C {blocks/pll/nor.sym} 860 350 0 0 {name=x1}
C {blocks/pll/nor.sym} 880 540 0 0 {name=x6}
C {lab_wire.sym} 880 500 0 0 {name=p1 sig_type=std_logic lab=VDD}
C {blocks/pll/nor.sym} 860 730 0 0 {name=x7}
C {vsource.sym} 620 360 0 0 {name=V1 value="PULSE(0 3.3 0 1n 1n 1.5u 2u)" savecurrent=false lvs_ignore=true
only_toplevel=true}
C {gnd.sym} 620 390 0 1 {name=l3 lab=GND lvs_ignore=true
only_toplevel=true}
C {lab_wire.sym} 860 310 0 0 {name=p9 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 860 370 0 0 {name=p21 lab=GND}
C {lab_pin.sym} 880 560 0 0 {name=p22 lab=GND}
C {lab_wire.sym} 860 690 0 0 {name=p10 sig_type=std_logic lab=VDD}
C {lab_pin.sym} 860 750 0 0 {name=p23 lab=GND}
C {blocks/pll/nor.sym} 880 910 0 0 {name=x8}
C {lab_wire.sym} 760 910 0 0 {name=p11 sig_type=std_logic lab=RST}
C {lab_pin.sym} 880 930 0 0 {name=p24 lab=GND}
C {lab_wire.sym} 880 870 0 0 {name=p12 sig_type=std_logic lab=VDD}
C {blocks/pll/nand.sym} 1040 180 0 0 {name=x9}
C {lab_pin.sym} 1030 220 0 0 {name=p25 lab=GND}
C {lab_wire.sym} 1030 140 0 0 {name=p14 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 880 180 0 0 {name=p7 sig_type=std_logic lab=VDD}
C {ipin.sym} 620 330 0 0 {name=p15 lab=Vb}
C {ipin.sym} 620 -370 0 0 {name=p16 lab=Va}
C {opin.sym} 1000 -170 0 0 {name=p4 lab=Qa}
C {opin.sym} 1000 530 0 0 {name=p17 lab=Qb}
C {iopin.sym} 780 -480 0 0 {name=p26 lab=VDD}
C {iopin.sym} 780 -460 0 0 {name=p27 lab=GND}
C {symbols/nfet_03v3.sym} 1200 250 0 0 {name=M1
L=0.28u
W=0.22u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=nfet_03v3
spiceprefix=X
}
C {symbols/pfet_03v3.sym} 1200 130 0 0 {name=M2
L=0.28u
W=0.22u
nf=1
m=1
ad="'int((nf+1)/2) * W/nf * 0.18u'"
pd="'2*int((nf+1)/2) * (W/nf + 0.18u)'"
as="'int((nf+2)/2) * W/nf * 0.18u'"
ps="'2*int((nf+2)/2) * (W/nf + 0.18u)'"
nrd="'0.18u / W'" nrs="'0.18u / W'"
sa=0 sb=0 sd=0
model=pfet_03v3
spiceprefix=X
}
C {lab_pin.sym} 1220 280 0 0 {name=p28 lab=GND}
C {lab_wire.sym} 1220 100 0 0 {name=p29 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1340 200 0 0 {name=p30 sig_type=std_logic lab=RST}
