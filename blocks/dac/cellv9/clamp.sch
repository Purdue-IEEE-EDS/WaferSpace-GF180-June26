v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 490 122.5 490 137.5 {lab=VH}
N 490 310 490 325 {lab=VL}
N 490 230 490 235 {lab=FB}
N 490 325 490 347.5 {lab=VL}
N 485 72.5 490 72.5 {lab=Vdd}
N 490 102.5 490 122.5 {lab=VH}
N 490 215 490 225 {lab=FB}
N 450 72.5 450 117.5 {lab=FB}
N 450 117.5 450 195 {lab=FB}
N 490 202.5 490 210 {lab=FB}
N 450 210 450 377.5 {lab=FB}
N 490 197.5 490 202.5 {lab=FB}
N 450 72.5 452.5 72.5 {lab=FB}
N 490 225 490 230 {lab=FB}
N 450 225 490 225 {lab=FB}
N 755 256.25 785 256.25 {lab=VL}
N 785 256.25 825 256.25 {lab=VL}
N 752.5 225 775 225 {lab=VH}
N 723.75 165 773.75 165 {lab=Vdd}
N 775 225 825 225 {lab=VH}
N 825 256.25 865 256.25 {lab=VL}
N 450 195 450 210 {lab=FB}
N 825 225 862.5 225 {lab=VH}
N 773.75 165 818.75 165 {lab=Vdd}
N 490 210 490 215 {lab=FB}
N 720 256.25 755 256.25 {lab=VL}
N 818.75 165 856.25 165 {lab=Vdd}
N 718.75 165 723.75 165 {lab=Vdd}
N 720 225 752.5 225 {lab=VH}
N 490 325 530 325 {lab=VL}
N 490 25 490 40 {lab=Vdd}
N 490 120 530 120 {lab=VH}
N 490 235 490 250 {lab=FB}
N 490 40 490 42.5 {lab=Vdd}
N 490 250 490 252.5 {lab=FB}
N 752.5 316.25 775 316.25 {lab=0}
N 775 316.25 825 316.25 {lab=0}
N 825 316.25 862.5 316.25 {lab=0}
N 720 316.25 752.5 316.25 {lab=0}
N 862.5 316.25 862.5 317.5 {lab=0}
N 720 165 720 167.5 {lab=Vdd}
N 770 165 770 167.5 {lab=Vdd}
N 820 165 820 167.5 {lab=Vdd}
C {opin.sym} 45 -352.5 0 0 {name=p80 lab=VH}
C {opin.sym} 47.5 -330 0 0 {name=p81 lab=VL}
C {ipin.sym} 15 -352.5 0 0 {name=p129 lab=Vdd}
C {gnd.sym} 490 377.5 3 0 {name=l13 lab=0}
C {symbols/nfet_03v3.sym} 470 377.5 0 0 {name=M49
L=0.28u
W=2u
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
C {symbols/pfet_03v3.sym} 470 72.5 0 0 {name=M50
L=0.28u
W=4u
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
C {lab_pin.sym} 490 72.5 0 1 {name=p111 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 530 325 0 1 {name=p112 sig_type=std_logic lab=VL}
C {lab_pin.sym} 862.5 225 0 1 {name=p3 sig_type=std_logic lab=VH}
C {lab_pin.sym} 450 225 2 1 {name=p115 sig_type=std_logic lab=FB}
C {lab_pin.sym} 865 256.25 0 1 {name=p5 sig_type=std_logic lab=VL}
C {lab_pin.sym} 856.25 165 0 1 {name=p7 sig_type=std_logic lab=Vdd}
C {lab_pin.sym} 530 120 0 1 {name=p17 sig_type=std_logic lab=VH}
C {lab_pin.sym} 490 25 0 1 {name=p18 sig_type=std_logic lab=Vdd}
C {gnd.sym} 490 407.5 0 0 {name=Data9 lab=0
value="PULSE(3.3 0 \{clk*0.5\} 30ps 30ps \{clk*1\} \{clk*2\})"
}
C {symbols/ppolyf_u_1k.sym} 490 282.5 0 0 {name=R3
W=1e-6
L=1e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {symbols/ppolyf_u_1k.sym} 490 167.5 0 0 {name=R1
W=1e-6
L=15e-6
model=ppolyf_u_1k
spiceprefix=X
m=1}
C {lab_wire.sym} 470 167.5 0 0 {name=p102 sig_type=std_logic lab=Vdd}
C {lab_wire.sym} 470 282.5 0 0 {name=p1 sig_type=std_logic lab=Vdd}
C {symbols/cap_mim_analog.sym} 720 195 0 0 {name=C2
W=25e-6
L=20e-6
model=cap_mim_2f0_m3m4_noshield
spiceprefix=X
m=1
C=1pF}
C {symbols/cap_mim_analog.sym} 770 195 0 0 {name=C1
W=10e-6
L=5e-6
model=cap_mim_2f0_m3m4_noshield
spiceprefix=X
m=1
C=100fF}
C {symbols/cap_mim_analog.sym} 820 195 0 0 {name=C3
W=5e-6
L=5e-6
model=cap_mim_2f0_m3m4_noshield
spiceprefix=X
m=1
C=50fF}
C {symbols/cap_mim_analog.sym} 720 286.25 0 0 {name=C4
W=25e-6
L=20e-6
model=cap_mim_2f0_m3m4_noshield
spiceprefix=X
m=1
C=1pF}
C {symbols/cap_mim_analog.sym} 770 286.25 0 0 {name=C5
W=10e-6
L=5e-6
model=cap_mim_2f0_m3m4_noshield
spiceprefix=X
m=1
C=100fF}
C {symbols/cap_mim_analog.sym} 820 286.25 0 0 {name=C6
W=5e-6
L=5e-6
model=cap_mim_2f0_m3m4_noshield
spiceprefix=X
m=1
C=50fF}
C {gnd.sym} 862.5 316.25 0 0 {name=Data1 lab=0
value="PULSE(3.3 0 \{clk*0.5\} 30ps 30ps \{clk*1\} \{clk*2\})"
}
C {lab_pin.sym} 597.5 2.5 0 1 {name=p4 sig_type=std_logic lab=Vdd}
C {symbols/cap_mim_analog.sym} 597.5 32.5 0 0 {name=C7
W=25e-6
L=20e-6
model=cap_mim_2f0_m3m4_noshield
spiceprefix=X
m=1
C=1pF}
C {gnd.sym} 597.5 62.5 0 0 {name=Data2 lab=0
value="PULSE(3.3 0 \{clk*0.5\} 30ps 30ps \{clk*1\} \{clk*2\})"
}
