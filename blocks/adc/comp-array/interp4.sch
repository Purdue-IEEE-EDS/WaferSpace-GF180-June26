v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 640 -590 640 -570 {lab=op1}
N 640 -510 640 -490 {lab=op2}
N 640 -430 640 -410 {lab=op3}
N 830 -590 830 -570 {lab=on1}
N 830 -510 830 -490 {lab=on2}
N 830 -430 830 -410 {lab=on3}
N 830 -350 830 -340 {lab=onR}
N 830 -660 830 -650 {lab=onL}
N 640 -660 640 -650 {lab=opL}
N 640 -350 640 -340 {lab=opR}
C {title.sym} 190 -820 0 0 {name=l2 author="Pranav Vadde"}
C {ipin.sym} 440 -640 0 0 {name=p1 lab=opL}
C {ipin.sym} 440 -610 0 0 {name=p2 lab=onL}
C {opin.sym} 390 -450 0 0 {name=p5 lab=op1}
C {opin.sym} 390 -420 0 0 {name=p6 lab=on1}
C {ipin.sym} 440 -580 0 0 {name=p3 lab=opR}
C {ipin.sym} 440 -550 0 0 {name=p4 lab=onR}
C {opin.sym} 390 -390 0 0 {name=p7 lab=op2}
C {opin.sym} 390 -360 0 0 {name=p8 lab=on2}
C {opin.sym} 390 -330 0 0 {name=p9 lab=op3}
C {opin.sym} 390 -300 0 0 {name=p10 lab=on3}
C {symbols/ppolyf_u_1k.sym} 640 -620 0 0 {name=R1
W=1u
L=3u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 640 -540 0 0 {name=R2
W=1u
L=3u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 640 -460 0 0 {name=R3
W=1u
L=3u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 640 -380 0 0 {name=R4
W=1u
L=3u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 830 -620 0 0 {name=R5
W=1u
L=3u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 830 -540 0 0 {name=R6
W=1u
L=3u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 830 -460 0 0 {name=R7
W=1u
L=3u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 830 -380 0 0 {name=R8
W=1u
L=3u
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 640 -660 0 0 {name=p11 sig_type=std_logic lab=opL
}
C {lab_wire.sym} 640 -580 0 0 {name=p12 sig_type=std_logic lab=op1
}
C {lab_wire.sym} 640 -500 0 0 {name=p13 sig_type=std_logic lab=op2

}
C {lab_wire.sym} 640 -420 0 0 {name=p14 sig_type=std_logic lab=op3
}
C {lab_wire.sym} 640 -340 0 0 {name=p15 sig_type=std_logic lab=opR
}
C {lab_wire.sym} 830 -660 0 0 {name=p16 sig_type=std_logic lab=onL
}
C {lab_wire.sym} 830 -580 0 0 {name=p17 sig_type=std_logic lab=on1
}
C {lab_wire.sym} 830 -500 0 0 {name=p18 sig_type=std_logic lab=on2
}
C {lab_wire.sym} 830 -420 0 0 {name=p19 sig_type=std_logic lab=on3
}
C {lab_wire.sym} 830 -340 0 0 {name=p20 sig_type=std_logic lab=onR
}
C {iopin.sym} 390 -500 0 0 {name=p21 lab=vss}
C {lab_wire.sym} 620 -620 0 0 {name=p22 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 620 -540 0 0 {name=p23 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 620 -460 0 0 {name=p24 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 620 -380 0 0 {name=p25 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 810 -380 0 0 {name=p26 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 810 -460 0 0 {name=p27 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 810 -540 0 0 {name=p28 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 810 -620 0 0 {name=p29 sig_type=std_logic lab=vss
}
