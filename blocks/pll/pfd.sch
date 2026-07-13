v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 880 -220 880 -200 {lab=VDD}
N 720 515 825 515 {lab=#net3}
N 865 440 865 475 {lab=VDD}
N 865 650 865 670 {lab=VDD}
N 915 525 915 625 {lab=#net4}
N 805 625 915 625 {lab=#net4}
N 805 625 805 710 {lab=#net4}
N 805 710 825 710 {lab=#net4}
N 915 720 1000 720 {lab=Qb}
N 815 545 825 545 {lab=Qb}
N 810 545 810 630 {lab=Qb}
N 810 630 935 630 {lab=Qb}
N 935 630 935 720 {lab=Qb}
N 810 545 815 545 {lab=Qb}
N 865 845 865 865 {lab=VDD}
N 865 1040 865 1060 {lab=VDD}
N 765 935 825 935 {lab=#net4}
N 765 680 765 935 {lab=#net4}
N 765 680 805 680 {lab=#net4}
N 800 740 825 740 {lab=#net5}
N 800 740 800 810 {lab=#net5}
N 800 810 915 810 {lab=#net5}
N 915 810 915 915 {lab=#net5}
N 795 905 825 905 {lab=#net6}
N 795 905 795 1005 {lab=#net6}
N 915 1010 915 1110 {lab=#net6}
N 795 1010 915 1010 {lab=#net6}
N 795 1005 795 1010 {lab=#net6}
N 805 1130 825 1130 {lab=#net5}
N 805 1005 805 1130 {lab=#net5}
N 805 1005 910 1005 {lab=#net5}
N 910 1005 915 1005 {lab=#net5}
N 915 915 915 1005 {lab=#net5}
N 865 1170 865 1185 {lab=0}
N 865 975 865 985 {lab=0}
N 865 780 865 790 {lab=0}
N 865 585 865 595 {lab=0}
N 1140 400 1140 425 {lab=0}
N 1140 270 1140 300 {lab=VDD}
N 990 360 990 720 {lab=Qb}
N 990 360 1110 360 {lab=Qb}
N 975 -165 975 325 {lab=#net7}
N 975 330 1110 330 {lab=#net7}
N 975 325 975 330 {lab=#net7}
N 1200 350 1250 350 {lab=Rst}
N 620 -370 820 -370 {lab=#net8}
N 600 520 720 520 {lab=#net3}
N 720 510 720 520 {lab=#net3}
N 750 1100 830 1100 {lab=Rst}
N 900 -360 900 -260 {lab=Qa}
N 820 -350 820 -260 {lab=Qa}
N 820 -260 920 -260 {lab=Qa}
N 920 -260 920 -170 {lab=Qa}
N 820 -260 820 -180 {lab=Qa}
N 820 -180 840 -180 {lab=Qa}
N 780 -180 820 -180 {lab=Qa}
N 920 -170 960 -170 {lab=Qa}
N 800 -160 840 -160 {lab=#net9}
N 800 -160 800 -80 {lab=#net9}
N 800 -80 900 -80 {lab=#net9}
N 780 -180 780 30 {lab=Qa}
N 780 30 820 30 {lab=Qa}
N 900 -80 900 100 {lab=#net9}
N 800 10 820 10 {lab=#net10}
C {devices/code_shown.sym} -10 -915 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
.lib $::180MCU_MODELS/sm141064.ngspice res_typical
.lib $::180MCU_MODELS/sm141064.ngspice moscap_typical
* .lib $::180MCU_MODELS/sm141064.ngspice res_statistical
.lib $::180MCU_MODELS/sm141064.ngspice cap_mim
.lib $::180MCU_MODELS/sm141064.ngspice mimcap_typical
"}
C {blocks/pll/nand.sym} 1150 330 0 0 {name=x1}
C {blocks/pll/nor.sym} 860 -350 0 0 {name=x2}
C {blocks/pll/nor.sym} 880 -160 0 0 {name=x3}
C {lab_wire.sym} 880 -220 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 960 -170 0 1 {name=p4 sig_type=std_logic lab=Qa}
C {blocks/pll/nor.sym} 860 30 0 0 {name=x4}
C {blocks/pll/nor.sym} 885 525 0 0 {name=x6}
C {blocks/pll/nor.sym} 885 720 0 0 {name=x7}
C {gnd.sym} 865 595 0 1 {name=l4 lab=0}
C {lab_wire.sym} 865 440 0 0 {name=p9 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 865 650 0 0 {name=p10 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1000 720 0 1 {name=p11 sig_type=std_logic lab=Qb}
C {gnd.sym} 865 790 0 1 {name=l5 lab=0}
C {blocks/pll/nor.sym} 885 915 0 0 {name=x8}
C {lab_wire.sym} 865 845 0 0 {name=p12 sig_type=std_logic lab=VDD}
C {gnd.sym} 865 985 0 1 {name=l6 lab=0}
C {blocks/pll/nor.sym} 885 1110 0 0 {name=x9}
C {lab_wire.sym} 865 1040 0 0 {name=p13 sig_type=std_logic lab=VDD}
C {gnd.sym} 865 1185 0 1 {name=l7 lab=0}
C {gnd.sym} 1140 425 0 1 {name=l8 lab=0}
C {lab_wire.sym} 1140 270 0 0 {name=p15 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 1250 350 0 1 {name=p16 sig_type=std_logic lab=Rst}
C {devices/code_shown.sym} -25 -665 0 0 {name=NGSPICE only_toplevel=true
value="
VDD vdd 0 dc 3.3
.control
save all
tran 0.10u 30u
plot v(qa) v(qb)
plot v(net1) v(net5)
write VCO_GF180.raw
.endc
"}
C {vsource.sym} 620 -340 0 0 {name=V2 value="PULSE(0 3.3 5n 1n 1n 1u 2u)" savecurrent=false}
C {gnd.sym} 620 -310 0 1 {name=l9 lab=0}
C {vsource.sym} 600 550 0 0 {name=V1 value="PULSE(0 3.3 0 1n 1n 1.5u 2u)" savecurrent=false}
C {gnd.sym} 600 580 0 1 {name=l10 lab=0}
C {lab_wire.sym} 750 1100 0 0 {name=p1 sig_type=std_logic lab=Rst}
C {lab_wire.sym} 860 -390 0 0 {name=p2 sig_type=std_logic lab=VDD}
C {gnd.sym} 860 -330 0 0 {name=l11 lab=GND}
C {gnd.sym} 880 -140 0 0 {name=l1 lab=GND}
C {lab_wire.sym} 860 -10 0 0 {name=p5 sig_type=std_logic lab=VDD}
C {gnd.sym} 860 50 0 0 {name=l12 lab=GND}
