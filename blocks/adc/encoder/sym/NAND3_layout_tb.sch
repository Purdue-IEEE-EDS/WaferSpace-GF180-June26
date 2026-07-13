v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 1170 -610 1970 -210 {flags=graph
y1=0
y2=3.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=2e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
color="7 10 11"
node="a
b
c"}
B 2 1170 -210 1970 190 {flags=graph
y1=-0.064
y2=3.6
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=2e-09
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node=out
color=11
dataset=-1
unitx=1
logx=0
logy=0
}
N 910 -520 910 -490 {lab=VDD}
N 910 -430 910 -410 {lab=GND}
N 320 -440 380 -440 {lab=a}
N 320 -420 380 -420 {lab=b}
N 320 -400 380 -400 {lab=C}
N 680 -460 710 -460 {lab=out}
N 530 -350 530 -335 {lab=GND}
N 530 -505 530 -490 {lab=VDD}
C {code_shown.sym} 200 -745 0 0 {name=SPICE only_toplevel=false value=" 
.include /foss/designs/encoder/layout/nand3/NAND3.spice
VA A 0 PULSE(0 3.3 250p 10p 10p 240p 500p)
VB B 0 PULSE(0 3.3 500p 10p 10p 490p 1n)
VC C 0 PULSE(0 3.3 1n 10p 10p 990p 2n)
.tran 1p 2n
.control
run

write nand.raw
.endc
"
}
C {code_shown.sym} 780 -745 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {vsource.sym} 910 -460 0 0 {name=V1 value=3.3 savecurrent=false}
C {vdd.sym} 910 -520 0 0 {name=l3 lab=VDD}
C {gnd.sym} 910 -410 0 1 {name=l4 lab=GND
}
C {ipin.sym} 320 -440 0 0 {name=p21 lab=a}
C {opin.sym} 710 -460 0 0 {name=p22 lab=out}
C {ipin.sym} 320 -400 0 0 {name=p9 lab=C}
C {ipin.sym} 320 -420 0 0 {name=p46 lab=b}
C {NAND3.sym} 530 -420 0 0 {name=x1}
C {lab_wire.sym} 530 -500 0 0 {name=p6 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 530 -335 0 0 {name=p1 sig_type=std_logic lab=GND}
C {launcher.sym} 1250 -650 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/NAND3_layout_tb.raw tran"
}
