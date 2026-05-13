v {xschem version=3.4.8RC file_version=1.3}
G {}
K {}
V {}
S {}
F {}
E {}
N 350 -950 380 -950 {lab=GND}
N 350 -990 380 -990 {lab=VDD}
N 1160 -1630 1230 -1630 {lab=B0}
N 1160 -1610 1230 -1610 {lab=B3}
N 1160 -1590 1230 -1590 {lab=B1}
N 1160 -1570 1230 -1570 {lab=B4}
N 1160 -1550 1230 -1550 {lab=B2}
N 1160 -1530 1230 -1530 {lab=B5}
N 1010 -1690 1010 -1660 {lab=VDD}
N 1010 -280 1010 -260 {lab=GND}
N 820 -1610 860 -1610 {lab=CLK_PRE}
N 720 -1580 720 -330 {lab=wl[62:0]
bus=true}
N 680 -990 720 -990 {lab=wl[62:0]
bus=true}
N 730 -1590 860 -1590 {lab=wl[0]}
N 700 -1610 820 -1610 {lab=CLK_PRE}
N 730 -1570 860 -1570 {lab=wl[1]}
N 730 -1550 860 -1550 {lab=wl[2]}
N 730 -1530 860 -1530 {lab=wl[3]}
N 730 -1510 860 -1510 {lab=wl[4]}
N 730 -1490 860 -1490 {lab=wl[5]}
N 730 -1470 860 -1470 {lab=wl[6]}
N 730 -1450 860 -1450 {lab=wl[7]}
N 730 -1430 860 -1430 {lab=wl[8]}
N 730 -1410 860 -1410 {lab=wl[9]}
N 730 -1390 860 -1390 {lab=wl[10]}
N 730 -1370 860 -1370 {lab=wl[11]}
N 730 -1350 860 -1350 {lab=wl[12]}
N 730 -1330 860 -1330 {lab=wl[13]}
N 730 -1310 860 -1310 {lab=wl[14]}
N 730 -1290 860 -1290 {lab=wl[15]}
N 730 -1270 860 -1270 {lab=wl[16]}
N 730 -1250 860 -1250 {lab=wl[17]}
N 730 -1230 860 -1230 {lab=wl[18]}
N 730 -1210 860 -1210 {lab=wl[19]}
N 730 -1190 860 -1190 {lab=wl[20]}
N 730 -1170 860 -1170 {lab=wl[21]}
N 730 -1150 860 -1150 {lab=wl[22]}
N 730 -1130 860 -1130 {lab=wl[23]}
N 730 -1110 860 -1110 {lab=wl[24]}
N 730 -1090 860 -1090 {lab=wl[25]}
N 730 -1070 860 -1070 {lab=wl[26]}
N 730 -1050 860 -1050 {lab=wl[27]}
N 730 -1030 860 -1030 {lab=wl[28]}
N 730 -1010 860 -1010 {lab=wl[29]}
N 730 -990 860 -990 {lab=wl[30]}
N 730 -970 860 -970 {lab=wl[31]}
N 730 -950 860 -950 {lab=wl[32]}
N 730 -930 860 -930 {lab=wl[33]}
N 730 -910 860 -910 {lab=wl[34]}
N 730 -890 860 -890 {lab=wl[35]}
N 730 -870 860 -870 {lab=wl[36]}
N 730 -850 860 -850 {lab=wl[37]}
N 730 -830 860 -830 {lab=wl[38]}
N 730 -810 860 -810 {lab=wl[39]}
N 730 -790 860 -790 {lab=wl[40]}
N 730 -770 860 -770 {lab=wl[41]}
N 730 -750 860 -750 {lab=wl[42]}
N 730 -730 860 -730 {lab=wl[43]}
N 730 -710 860 -710 {lab=wl[44]}
N 730 -690 860 -690 {lab=wl[45]}
N 730 -670 860 -670 {lab=wl[46]}
N 730 -650 860 -650 {lab=wl[47]}
N 730 -630 860 -630 {lab=wl[48]}
N 730 -610 860 -610 {lab=wl[49]}
N 730 -590 860 -590 {lab=wl[50]}
N 730 -570 860 -570 {lab=wl[51]}
N 730 -550 860 -550 {lab=wl[52]}
N 730 -530 860 -530 {lab=wl[53]}
N 730 -510 860 -510 {lab=wl[54]}
N 730 -490 860 -490 {lab=wl[55]}
N 730 -470 860 -470 {lab=wl[56]}
N 730 -450 860 -450 {lab=wl[57]}
N 730 -430 860 -430 {lab=wl[58]}
N 730 -410 860 -410 {lab=wl[59]}
N 730 -390 860 -390 {lab=wl[60]}
N 730 -370 860 -370 {lab=wl[61]}
N 730 -350 860 -350 {lab=wl[62]}
N 270 -970 380 -970 {lab=comp[0:62]
bus=true}
N 800 -310 860 -310 {lab=CLK_EVAL}
C {tm_to_bin2.sym} 530 -970 0 0 {name=x1}
C {ROM2.sym} 1010 -970 0 0 {name=x2}
C {bus_connect_nolab.sym} 720 -1580 0 0 {name=r2}
C {ipin.sym} 277.5 -969.7436562655409 0 0 {name=p1 lab=comp[0:62]}
C {lab_wire.sym} 360 -990 0 0 {name=p3 sig_type=std_logic lab=VDD}
C {lab_wire.sym} 360 -950 0 0 {name=p5 sig_type=std_logic lab=GND}
C {opin.sym} 1230 -1630 0 0 {name=p421 lab=B0}
C {opin.sym} 1230 -1590 0 0 {name=p6 lab=B1}
C {opin.sym} 1230 -1550 0 0 {name=p7 lab=B2}
C {opin.sym} 1230 -1610 0 0 {name=p9 lab=B3}
C {opin.sym} 1230 -1570 0 0 {name=p10 lab=B4}
C {opin.sym} 1230 -1530 0 0 {name=p11 lab=B5}
C {lab_wire.sym} 720 -1040 0 0 {name=p16 sig_type=std_logic lab=wl[62:0]}
C {lab_wire.sym} 800 -1590 0 0 {name=p17 sig_type=std_logic lab=wl[0]}
C {bus_connect_nolab.sym} 720 -1560 0 0 {name=r8}
C {lab_wire.sym} 800 -1570 0 0 {name=p18 sig_type=std_logic lab=wl[1]}
C {bus_connect_nolab.sym} 720 -1540 0 0 {name=r9}
C {lab_wire.sym} 800 -1550 0 0 {name=p19 sig_type=std_logic lab=wl[2]}
C {bus_connect_nolab.sym} 720 -1520 0 0 {name=r10}
C {lab_wire.sym} 800 -1530 0 0 {name=p20 sig_type=std_logic lab=wl[3]}
C {bus_connect_nolab.sym} 720 -1500 0 0 {name=r11}
C {lab_wire.sym} 800 -1510 0 0 {name=p21 sig_type=std_logic lab=wl[4]}
C {bus_connect_nolab.sym} 720 -1480 0 0 {name=r12}
C {lab_wire.sym} 800 -1490 0 0 {name=p22 sig_type=std_logic lab=wl[5]}
C {bus_connect_nolab.sym} 720 -1460 0 0 {name=r13}
C {lab_wire.sym} 800 -1470 0 0 {name=p23 sig_type=std_logic lab=wl[6]}
C {bus_connect_nolab.sym} 720 -1440 0 0 {name=r14}
C {lab_wire.sym} 800 -1450 0 0 {name=p24 sig_type=std_logic lab=wl[7]}
C {bus_connect_nolab.sym} 720 -1420 0 0 {name=r15}
C {lab_wire.sym} 800 -1430 0 0 {name=p25 sig_type=std_logic lab=wl[8]}
C {bus_connect_nolab.sym} 720 -1400 0 0 {name=r16}
C {lab_wire.sym} 800 -1410 0 0 {name=p26 sig_type=std_logic lab=wl[9]}
C {bus_connect_nolab.sym} 720 -1380 0 0 {name=r17}
C {bus_connect_nolab.sym} 720 -1360 0 0 {name=r18}
C {bus_connect_nolab.sym} 720 -1340 0 0 {name=r19}
C {bus_connect_nolab.sym} 720 -1320 0 0 {name=r20}
C {bus_connect_nolab.sym} 720 -1300 0 0 {name=r21}
C {bus_connect_nolab.sym} 720 -1280 0 0 {name=r22}
C {bus_connect_nolab.sym} 720 -1260 0 0 {name=r23}
C {bus_connect_nolab.sym} 720 -1240 0 0 {name=r24}
C {bus_connect_nolab.sym} 720 -1220 0 0 {name=r25}
C {bus_connect_nolab.sym} 720 -1200 0 0 {name=r26}
C {bus_connect_nolab.sym} 720 -1180 0 0 {name=r27}
C {bus_connect_nolab.sym} 720 -1160 0 0 {name=r28}
C {bus_connect_nolab.sym} 720 -1140 0 0 {name=r29}
C {bus_connect_nolab.sym} 720 -1120 0 0 {name=r30}
C {bus_connect_nolab.sym} 720 -1100 0 0 {name=r31}
C {bus_connect_nolab.sym} 720 -1080 0 0 {name=r32}
C {bus_connect_nolab.sym} 720 -1060 0 0 {name=r33}
C {bus_connect_nolab.sym} 720 -1040 0 0 {name=r34}
C {bus_connect_nolab.sym} 720 -1020 0 0 {name=r35}
C {bus_connect_nolab.sym} 720 -1000 0 0 {name=r36}
C {bus_connect_nolab.sym} 720 -980 0 0 {name=r37}
C {bus_connect_nolab.sym} 720 -960 0 0 {name=r38}
C {bus_connect_nolab.sym} 720 -940 0 0 {name=r39}
C {bus_connect_nolab.sym} 720 -920 0 0 {name=r40}
C {bus_connect_nolab.sym} 720 -900 0 0 {name=r41}
C {bus_connect_nolab.sym} 720 -880 0 0 {name=r42}
C {bus_connect_nolab.sym} 720 -860 0 0 {name=r43}
C {bus_connect_nolab.sym} 720 -840 0 0 {name=r44}
C {bus_connect_nolab.sym} 720 -820 0 0 {name=r45}
C {bus_connect_nolab.sym} 720 -800 0 0 {name=r46}
C {bus_connect_nolab.sym} 720 -780 0 0 {name=r47}
C {bus_connect_nolab.sym} 720 -760 0 0 {name=r48}
C {bus_connect_nolab.sym} 720 -740 0 0 {name=r49}
C {bus_connect_nolab.sym} 720 -720 0 0 {name=r50}
C {bus_connect_nolab.sym} 720 -700 0 0 {name=r51}
C {bus_connect_nolab.sym} 720 -680 0 0 {name=r52}
C {bus_connect_nolab.sym} 720 -660 0 0 {name=r53}
C {bus_connect_nolab.sym} 720 -640 0 0 {name=r54}
C {bus_connect_nolab.sym} 720 -620 0 0 {name=r55}
C {bus_connect_nolab.sym} 720 -600 0 0 {name=r56}
C {bus_connect_nolab.sym} 720 -580 0 0 {name=r57}
C {bus_connect_nolab.sym} 720 -560 0 0 {name=r58}
C {bus_connect_nolab.sym} 720 -540 0 0 {name=r59}
C {bus_connect_nolab.sym} 720 -520 0 0 {name=r60}
C {bus_connect_nolab.sym} 720 -500 0 0 {name=r61}
C {bus_connect_nolab.sym} 720 -480 0 0 {name=r62}
C {bus_connect_nolab.sym} 720 -460 0 0 {name=r63}
C {bus_connect_nolab.sym} 720 -440 0 0 {name=r64}
C {bus_connect_nolab.sym} 720 -420 0 0 {name=r65}
C {bus_connect_nolab.sym} 720 -400 0 0 {name=r66}
C {bus_connect_nolab.sym} 720 -380 0 0 {name=r67}
C {bus_connect_nolab.sym} 720 -360 0 0 {name=r68}
C {bus_connect_nolab.sym} 720 -340 0 0 {name=r69}
C {lab_wire.sym} 800 -1390 0 0 {name=p2 sig_type=std_logic lab=wl[10]}
C {lab_wire.sym} 800 -1370 0 0 {name=p4 sig_type=std_logic lab=wl[11]}
C {lab_wire.sym} 800 -1350 0 0 {name=p8 sig_type=std_logic lab=wl[12]}
C {lab_wire.sym} 800 -1330 0 0 {name=p27 sig_type=std_logic lab=wl[13]}
C {lab_wire.sym} 800 -1310 0 0 {name=p28 sig_type=std_logic lab=wl[14]}
C {lab_wire.sym} 800 -1290 0 0 {name=p29 sig_type=std_logic lab=wl[15]}
C {lab_wire.sym} 800 -1270 0 0 {name=p30 sig_type=std_logic lab=wl[16]}
C {lab_wire.sym} 800 -1250 0 0 {name=p31 sig_type=std_logic lab=wl[17]}
C {lab_wire.sym} 800 -1230 0 0 {name=p32 sig_type=std_logic lab=wl[18]}
C {lab_wire.sym} 800 -1210 0 0 {name=p33 sig_type=std_logic lab=wl[19]}
C {lab_wire.sym} 800 -1190 0 0 {name=p34 sig_type=std_logic lab=wl[20]}
C {lab_wire.sym} 800 -1170 0 0 {name=p35 sig_type=std_logic lab=wl[21]}
C {lab_wire.sym} 800 -1150 0 0 {name=p36 sig_type=std_logic lab=wl[22]}
C {lab_wire.sym} 800 -1130 0 0 {name=p37 sig_type=std_logic lab=wl[23]}
C {lab_wire.sym} 800 -1110 0 0 {name=p38 sig_type=std_logic lab=wl[24]}
C {lab_wire.sym} 800 -1090 0 0 {name=p39 sig_type=std_logic lab=wl[25]}
C {lab_wire.sym} 800 -1070 0 0 {name=p40 sig_type=std_logic lab=wl[26]}
C {lab_wire.sym} 800 -1050 0 0 {name=p41 sig_type=std_logic lab=wl[27]}
C {lab_wire.sym} 800 -1030 0 0 {name=p42 sig_type=std_logic lab=wl[28]}
C {lab_wire.sym} 800 -1010 0 0 {name=p43 sig_type=std_logic lab=wl[29]}
C {lab_wire.sym} 800 -990 0 0 {name=p44 sig_type=std_logic lab=wl[30]}
C {lab_wire.sym} 800 -970 0 0 {name=p45 sig_type=std_logic lab=wl[31]}
C {lab_wire.sym} 800 -950 0 0 {name=p46 sig_type=std_logic lab=wl[32]}
C {lab_wire.sym} 800 -930 0 0 {name=p47 sig_type=std_logic lab=wl[33]}
C {lab_wire.sym} 800 -910 0 0 {name=p48 sig_type=std_logic lab=wl[34]}
C {lab_wire.sym} 800 -890 0 0 {name=p49 sig_type=std_logic lab=wl[35]}
C {lab_wire.sym} 800 -870 0 0 {name=p50 sig_type=std_logic lab=wl[36]}
C {lab_wire.sym} 800 -850 0 0 {name=p51 sig_type=std_logic lab=wl[37]}
C {lab_wire.sym} 800 -830 0 0 {name=p52 sig_type=std_logic lab=wl[38]}
C {lab_wire.sym} 800 -810 0 0 {name=p53 sig_type=std_logic lab=wl[39]}
C {lab_wire.sym} 800 -790 0 0 {name=p54 sig_type=std_logic lab=wl[40]}
C {lab_wire.sym} 800 -770 0 0 {name=p55 sig_type=std_logic lab=wl[41]}
C {lab_wire.sym} 800 -750 0 0 {name=p56 sig_type=std_logic lab=wl[42]}
C {lab_wire.sym} 800 -730 0 0 {name=p57 sig_type=std_logic lab=wl[43]}
C {lab_wire.sym} 800 -710 0 0 {name=p58 sig_type=std_logic lab=wl[44]}
C {lab_wire.sym} 800 -690 0 0 {name=p59 sig_type=std_logic lab=wl[45]}
C {lab_wire.sym} 800 -670 0 0 {name=p60 sig_type=std_logic lab=wl[46]}
C {lab_wire.sym} 800 -650 0 0 {name=p61 sig_type=std_logic lab=wl[47]}
C {lab_wire.sym} 800 -630 0 0 {name=p62 sig_type=std_logic lab=wl[48]}
C {lab_wire.sym} 800 -610 0 0 {name=p63 sig_type=std_logic lab=wl[49]}
C {lab_wire.sym} 800 -590 0 0 {name=p64 sig_type=std_logic lab=wl[50]}
C {lab_wire.sym} 800 -570 0 0 {name=p65 sig_type=std_logic lab=wl[51]}
C {lab_wire.sym} 800 -550 0 0 {name=p66 sig_type=std_logic lab=wl[52]}
C {lab_wire.sym} 800 -530 0 0 {name=p67 sig_type=std_logic lab=wl[53]}
C {lab_wire.sym} 800 -510 0 0 {name=p68 sig_type=std_logic lab=wl[54]}
C {lab_wire.sym} 800 -490 0 0 {name=p69 sig_type=std_logic lab=wl[55]}
C {lab_wire.sym} 800 -470 0 0 {name=p70 sig_type=std_logic lab=wl[56]}
C {lab_wire.sym} 800 -450 0 0 {name=p71 sig_type=std_logic lab=wl[57]}
C {lab_wire.sym} 800 -430 0 0 {name=p72 sig_type=std_logic lab=wl[58]}
C {lab_wire.sym} 800 -410 0 0 {name=p73 sig_type=std_logic lab=wl[59]}
C {lab_wire.sym} 800 -390 0 0 {name=p74 sig_type=std_logic lab=wl[60]}
C {lab_wire.sym} 800 -370 0 0 {name=p75 sig_type=std_logic lab=wl[61]}
C {lab_wire.sym} 800 -350 0 0 {name=p76 sig_type=std_logic lab=wl[62]}
C {lab_wire.sym} 350 -970 0 0 {name=p77 sig_type=std_logic lab=comp[0:62]}
C {ipin.sym} 700 -1610 0 0 {name=p443 lab=CLK_PRE}
C {ipin.sym} 820 -310 0 0 {name=p14 lab=CLK_EVAL}
C {ipin.sym} 1010 -1690 0 0 {name=p12 lab=VDD}
C {ipin.sym} 1010 -260 0 0 {name=p13 lab=GND}
