v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 670 -1160 1470 -760 {flags=graph
y1=0.20833333
y2=2.2083333
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=10e-6
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node=""
color=""
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 670 -760 1470 -360 {flags=graph
y1=-0.11516564
y2=1.8848342
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=0
x2=10e-6
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node=""
color=""
dataset=-1
unitx=1
logx=0
logy=0
}
N 120 -440 170 -440 {lab=RST}
N 120 -420 170 -420 {lab=VDD}
N 120 -400 170 -400 {lab=GND}
N 120 -380 170 -380 {lab=CLK}
N 470 -440 510 -440 {lab=out0}
N 470 -420 510 -420 {lab=out1}
N 470 -400 510 -400 {lab=out2}
N 470 -380 510 -380 {lab=out3}
C {code_shown.sym} 725 -275 0 0 {name=MODELS only_toplevel=true
format="tcleval( @value )"
value="
.include $::180MCU_MODELS/design.ngspice
.lib $::180MCU_MODELS/sm141064.ngspice typical
"}
C {code_shown.sym} 725 -155 0 0 {name=SPICE only_toplevel=false value="

V_VDD VDD 0 3.3
V_CLK CLK 0 pulse(0 3.3 0s 20p 20p 0.78n 1.5625n)
V_RST RST 0 pwl(0 0 2n 0 2.02n 3.3 20n 3.3)

.control
  save CLK RST out
  tran 10p 50n
  write ring_counter_test.raw
.endc
.tran 10p 50n

"}
C {ipin.sym} 120 -420 0 0 {name=p4 lab=VDD}
C {ipin.sym} 120 -440 0 0 {name=p5 lab=RST}
C {ipin.sym} 120 -400 0 0 {name=p7 lab=GND}
C {ipin.sym} 120 -380 0 0 {name=p1 lab=CLK}
C {opin.sym} 510 -440 0 0 {name=p10 lab=out0}
C {launcher.sym} 1540 -710 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/j_counter_tb.raw tran"
}
C {shift_reg.sym} 320 -410 0 0 {name=x1}
C {opin.sym} 510 -420 0 0 {name=p2 lab=out1}
C {opin.sym} 510 -400 0 0 {name=p3 lab=out2}
C {opin.sym} 510 -380 0 0 {name=p6 lab=out3}
