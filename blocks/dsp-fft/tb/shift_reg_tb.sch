v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
B 2 720 -1150 1520 -750 {flags=graph
y1=0
y2=3.3
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=2.3913819e-10
x2=1.5338632e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="clk
s_in"
color="4 12"
dataset=-1
unitx=1
logx=0
logy=0
}
B 2 720 -750 1520 -350 {flags=graph
y1=-0.13
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=2.3913819e-10
x2=1.5338632e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
dataset=-1
unitx=1
logx=0
logy=0
autoload=1
color="4 17 6 7"
node="out3
out2
out1
out0"}
B 2 1510 -750 2310 -350 {flags=graph
y1=-0.13
y2=3.4
ypos1=0
ypos2=2
divy=5
subdivy=1
unity=1
x1=2.3913819e-10
x2=1.5338632e-08
divx=5
subdivx=1
xlabmag=1.0
ylabmag=1.0
node="out1
out0"
color="4 10"
dataset=-1
unitx=1
logx=0
logy=0
autoload=1}
N 120 -450 170 -450 {lab=RST}
N 120 -430 170 -430 {lab=VDD}
N 120 -390 170 -390 {lab=GND}
N 120 -370 170 -370 {lab=CLK}
N 470 -440 510 -440 {lab=out0}
N 470 -420 510 -420 {lab=out1}
N 470 -400 510 -400 {lab=out2}
N 470 -380 510 -380 {lab=out3}
N 120 -410 170 -410 {lab=s_in}
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
V_SIN s_in 0 pwl(0 0 4n 0 4.02n 3.3 5n 3.3 5.02n 0)
.control
  V_CLK CLK 0 pulse(0 3.3 0s 20p 20p 0.78n 1.5625n)
  tran 10p 50n
  write shift_test.raw
.endc
.tran 10p 50n

"}
C {ipin.sym} 120 -430 0 0 {name=p4 lab=VDD}
C {ipin.sym} 120 -450 0 0 {name=p5 lab=RST}
C {ipin.sym} 120 -390 0 0 {name=p7 lab=GND}
C {ipin.sym} 120 -370 0 0 {name=p1 lab=CLK}
C {opin.sym} 510 -440 0 0 {name=p10 lab=out0}
C {opin.sym} 510 -420 0 0 {name=p2 lab=out1}
C {opin.sym} 510 -400 0 0 {name=p3 lab=out2}
C {opin.sym} 510 -380 0 0 {name=p6 lab=out3}
C {shift_reg.sym} 320 -410 0 0 {name=x1}
C {ipin.sym} 120 -410 0 0 {name=p8 lab=s_in}
C {launcher.sym} 1480 -270 0 0 {name=h5
descr="load waves"
tclcommand="xschem raw_read $netlist_dir/shift_reg_tb.raw tran"
}
