v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 220 -40 220 -20 {lab=vrefp}
N 220 40 220 60 {lab=tap17}
N 220 140 220 160 {lab=tap16}
N 220 240 220 260 {lab=tap15}
N 220 340 220 360 {lab=tap14}
N 220 440 220 460 {lab=tap13}
N 220 540 220 560 {lab=tap12}
N 220 640 220 660 {lab=tap11}
N 220 740 220 760 {lab=tap10}
N 220 840 220 860 {lab=tap9}
N 220 940 220 960 {lab=tap8}
N 220 1040 220 1060 {lab=tap7}
N 220 1140 220 1160 {lab=tap6}
N 220 1240 220 1260 {lab=tap5}
N 220 1340 220 1360 {lab=tap4}
N 220 1440 220 1460 {lab=tap3}
N 220 1540 220 1560 {lab=tap2}
N 220 1640 220 1660 {lab=tap1}
N 220 1740 220 1760 {lab=vrefn}
N 220 1660 220 1680 {lab=tap1}
N 220 1560 220 1580 {lab=tap2}
N 220 1460 220 1480 {lab=tap3}
N 220 1360 220 1380 {lab=tap4}
N 220 1260 220 1280 {lab=tap5}
N 220 1160 220 1180 {lab=tap6}
N 220 1060 220 1080 {lab=tap7}
N 220 960 220 980 {lab=tap8}
N 220 860 220 880 {lab=tap9}
N 220 760 220 780 {lab=tap10}
N 220 660 220 680 {lab=tap11}
N 220 560 220 580 {lab=tap12}
N 220 460 220 480 {lab=tap13}
N 220 360 220 380 {lab=tap14}
N 220 260 220 280 {lab=tap15}
N 220 160 220 180 {lab=tap16}
N 220 60 220 80 {lab=tap17}
C {title.sym} -230 -200 0 0 {name=l2 author="Pranav Vadde"}
C {ipin.sym} 0 -40 0 0 {name=pvrp lab=vrefp}
C {ipin.sym} 0 -10 0 0 {name=pvrn lab=vrefn}
C {opin.sym} -80 20 0 0 {name=po1 lab=tap1}
C {opin.sym} -80 40 0 0 {name=po2 lab=tap2}
C {opin.sym} -80 60 0 0 {name=po3 lab=tap3}
C {opin.sym} -80 80 0 0 {name=po4 lab=tap4}
C {opin.sym} -80 100 0 0 {name=po5 lab=tap5}
C {opin.sym} -80 120 0 0 {name=po6 lab=tap6}
C {opin.sym} -80 140 0 0 {name=po7 lab=tap7}
C {opin.sym} -80 160 0 0 {name=po8 lab=tap8}
C {opin.sym} -80 180 0 0 {name=po9 lab=tap9}
C {opin.sym} -80 200 0 0 {name=po10 lab=tap10}
C {opin.sym} -80 220 0 0 {name=po11 lab=tap11}
C {opin.sym} -80 240 0 0 {name=po12 lab=tap12}
C {opin.sym} -80 260 0 0 {name=po13 lab=tap13}
C {opin.sym} -80 280 0 0 {name=po14 lab=tap14}
C {opin.sym} -80 300 0 0 {name=po15 lab=tap15}
C {opin.sym} -80 320 0 0 {name=po16 lab=tap16}
C {opin.sym} -80 340 0 0 {name=po17 lab=tap17}
C {symbols/ppolyf_u_1k.sym} 220 10 0 0 {name=R1
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 10 0 0 {name=pb1 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 110 0 0 {name=R2
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 110 0 0 {name=pb2 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 210 0 0 {name=R3
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 210 0 0 {name=pb3 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 310 0 0 {name=R4
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 310 0 0 {name=pb4 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 410 0 0 {name=R5
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 410 0 0 {name=pb5 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 510 0 0 {name=R6
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 510 0 0 {name=pb6 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 610 0 0 {name=R7
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 610 0 0 {name=pb7 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 710 0 0 {name=R8
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 710 0 0 {name=pb8 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 810 0 0 {name=R9
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 810 0 0 {name=pb9 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 910 0 0 {name=R10
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 910 0 0 {name=pb10 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 1010 0 0 {name=R11
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 1010 0 0 {name=pb11 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 1110 0 0 {name=R12
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 1110 0 0 {name=pb12 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 1210 0 0 {name=R13
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 1210 0 0 {name=pb13 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 1310 0 0 {name=R14
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 1310 0 0 {name=pb14 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 1410 0 0 {name=R15
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 1410 0 0 {name=pb15 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 1510 0 0 {name=R16
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 1510 0 0 {name=pb16 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 1610 0 0 {name=R17
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 1610 0 0 {name=pb17 sig_type=std_logic lab=vss}
C {symbols/ppolyf_u_1k.sym} 220 1710 0 0 {name=R18
W=2e-6
L=3.5e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 200 1710 0 0 {name=pb18 sig_type=std_logic lab=vss}
C {lab_wire.sym} 220 -40 0 0 {name=lw_vrefp sig_type=std_logic lab=vrefp}
C {lab_wire.sym} 220 60 0 0 {name=lw_tap17 sig_type=std_logic lab=tap17}
C {lab_wire.sym} 220 160 0 0 {name=lw_tap16 sig_type=std_logic lab=tap16}
C {lab_wire.sym} 220 260 0 0 {name=lw_tap15 sig_type=std_logic lab=tap15}
C {lab_wire.sym} 220 360 0 0 {name=lw_tap14 sig_type=std_logic lab=tap14}
C {lab_wire.sym} 220 460 0 0 {name=lw_tap13 sig_type=std_logic lab=tap13}
C {lab_wire.sym} 220 560 0 0 {name=lw_tap12 sig_type=std_logic lab=tap12}
C {lab_wire.sym} 220 660 0 0 {name=lw_tap11 sig_type=std_logic lab=tap11}
C {lab_wire.sym} 220 760 0 0 {name=lw_tap10 sig_type=std_logic lab=tap10}
C {lab_wire.sym} 220 860 0 0 {name=lw_tap9 sig_type=std_logic lab=tap9}
C {lab_wire.sym} 220 960 0 0 {name=lw_tap8 sig_type=std_logic lab=tap8}
C {lab_wire.sym} 220 1060 0 0 {name=lw_tap7 sig_type=std_logic lab=tap7}
C {lab_wire.sym} 220 1160 0 0 {name=lw_tap6 sig_type=std_logic lab=tap6}
C {lab_wire.sym} 220 1260 0 0 {name=lw_tap5 sig_type=std_logic lab=tap5}
C {lab_wire.sym} 220 1360 0 0 {name=lw_tap4 sig_type=std_logic lab=tap4}
C {lab_wire.sym} 220 1460 0 0 {name=lw_tap3 sig_type=std_logic lab=tap3}
C {lab_wire.sym} 220 1560 0 0 {name=lw_tap2 sig_type=std_logic lab=tap2}
C {lab_wire.sym} 220 1660 0 0 {name=lw_tap1 sig_type=std_logic lab=tap1}
C {lab_wire.sym} 220 1760 0 0 {name=lw_vrefn sig_type=std_logic lab=vrefn}
C {iopin.sym} -70 410 0 0 {name=pvss lab=vss}
