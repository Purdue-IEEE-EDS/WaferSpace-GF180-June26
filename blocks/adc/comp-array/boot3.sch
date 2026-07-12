v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 120 230 150 230 {lab=tp}
N 120 230 120 260 {lab=tp}
N 120 260 150 260 {lab=tp}
N 150 190 150 230 {lab=tp}
N 120 190 150 190 {lab=tp}
N 120 160 120 190 {lab=tp}
N 120 160 150 160 {lab=tp}
N 150 110 150 130 {lab=#net1}
N 150 110 250 110 {lab=#net1}
N 250 110 250 260 {lab=#net1}
N 190 260 250 260 {lab=#net1}
N 190 160 280 160 {lab=ckb}
N 250 110 320 110 {lab=#net1}
N 320 110 320 130 {lab=#net1}
N 320 190 320 200 {lab=vss}
N 320 200 340 200 {lab=vss}
N 340 160 340 200 {lab=vss}
N 320 160 340 160 {lab=vss}
N 480 180 480 190 {lab=vss}
N 480 190 500 190 {lab=vss}
N 500 150 500 190 {lab=vss}
N 480 150 500 150 {lab=vss}
N 250 260 440 260 {lab=#net1}
N 250 260 250 320 {lab=#net1}
N 250 320 290 320 {lab=#net1}
C {title.sym} -110 -70 0 0 {name=l2 author="Pranav Vadde"}
C {iopin.sym} -90 80 0 0 {name=p1 lab=vdd}
C {ipin.sym} -40 110 0 0 {name=p8 lab=in}
C {iopin.sym} -90 230 0 0 {name=p12 lab=ckb}
C {iopin.sym} -100 260 0 0 {name=p13 lab=vss}
C {opin.sym} -80 140 0 0 {name=p18 lab=out}
C {symbols/pfet_03v3.sym} 170 260 0 1 {name=Mchg
L=0.5u
W=32u
nf=8
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
C {lab_wire.sym} 150 290 2 1 {name=p20 sig_type=std_logic lab=vdd
}
C {symbols/cap_mim_analog.sym} 40 60 0 0 {name=Cb
W=31.62u
L=31.62u
model=cap_mim_2f0_m4m5_noshield
spiceprefix=X
m=1}
C {lab_wire.sym} 40 30 0 0 {name=p2 sig_type=std_logic lab=tp
}
C {lab_wire.sym} 40 90 2 1 {name=p3 sig_type=std_logic lab=bot
}
C {lab_wire.sym} 120 230 0 0 {name=p4 sig_type=std_logic lab=tp
}
C {symbols/pfet_03v3.sym} 170 160 0 1 {name=Mcon
L=0.5u
W=32u
nf=8
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
C {lab_wire.sym} 210 160 0 1 {name=p5 sig_type=std_logic lab=ckb
}
C {symbols/nfet_03v3.sym} 300 160 0 0 {name=Mglo
L=0.5u
W=32u
nf=8
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
C {lab_wire.sym} 320 200 2 1 {name=p6 sig_type=std_logic lab=vss
}
C {symbols/nfet_03v3.sym} 460 150 0 0 {name=Mblo
L=0.5u
W=16u
nf=4
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
C {lab_wire.sym} 480 190 2 1 {name=Mblo1 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 440 150 0 0 {name=p7 sig_type=std_logic lab=ckb
}
C {lab_wire.sym} 480 120 0 0 {name=p9 sig_type=std_logic lab=bot
}
C {symbols/nfet_03v3.sym} 460 260 0 0 {name=Mbin
L=0.5u
W=24u
nf=4
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
C {lab_wire.sym} 480 230 0 0 {name=p10 sig_type=std_logic lab=bot
}
C {lab_wire.sym} 480 260 2 0 {name=Mblo2 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 480 290 2 0 {name=Mblo3 sig_type=std_logic lab=in
}
C {symbols/nfet_03v3.sym} 310 320 0 0 {name=Msw
L=0.28u
W=80u
nf=8
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
C {lab_wire.sym} 330 320 2 0 {name=Mblo4 sig_type=std_logic lab=vss
}
C {lab_wire.sym} 330 350 2 0 {name=Mblo5 sig_type=std_logic lab=in
}
C {lab_wire.sym} 330 290 0 0 {name=p11 sig_type=std_logic lab=out}
