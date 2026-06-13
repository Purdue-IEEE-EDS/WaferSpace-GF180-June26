v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 400 -270 400 -170 {lab=Vctrl[5:0]
bus=true}
N 340 -270 400 -270 {lab=Vctrl[5:0]
bus=true}
N 410 -280 500 -280 {lab=Vctrl[5]}
N 410 -260 500 -260 {lab=Vctrl[4]}
N 410 -240 500 -240 {lab=Vctrl[3]}
N 410 -220 500 -220 {lab=Vctrl[2]}
N 410 -200 500 -200 {lab=Vctrl[1]}
N 410 -180 500 -180 {lab=Vctrl[0]}
N 460 -60 1180 -60 {lab=#net1}
N 480 -40 1180 -40 {lab=#net2}
N 1480 -360 1700 -360 {lab=#net3}
C {blocks/adc/vga/vga.sym} 650 -240 0 0 {name=x1}
C {bus_connect_nolab.sym} 400 -170 0 0 {name=r5}
C {bus_connect_nolab.sym} 400 -190 0 0 {name=r1}
C {bus_connect_nolab.sym} 400 -210 0 0 {name=r2}
C {bus_connect_nolab.sym} 400 -230 0 0 {name=r3}
C {bus_connect_nolab.sym} 400 -250 0 0 {name=r4}
C {bus_connect_nolab.sym} 400 -270 0 0 {name=r6}
C {ipin.sym} 340 -270 0 0 {name=p1 lab=Vctrl[5:0]}
C {lab_wire.sym} 470 -280 0 0 {name=p2 sig_type=std_logic lab=Vctrl[5]}
C {lab_wire.sym} 470 -260 0 0 {name=p3 sig_type=std_logic lab=Vctrl[4]}
C {lab_wire.sym} 470 -240 0 0 {name=p4 sig_type=std_logic lab=Vctrl[3]}
C {lab_wire.sym} 470 -220 0 0 {name=p5 sig_type=std_logic lab=Vctrl[2]}
C {lab_wire.sym} 470 -200 0 0 {name=p6 sig_type=std_logic lab=Vctrl[1]}
C {lab_wire.sym} 470 -180 0 0 {name=p7 sig_type=std_logic lab=Vctrl[0]}
C {blocks/adc/lvds/lvds_v4.sym} 1330 -50 0 0 {name=x3}
C {blocks/adc/encoder/sym/encoder_final.sym} 1330 -320 0 0 {name=x2}
