import numpy as np
import matplotlib.pyplot as plt 

tw_re = np.zeros(128, dtype=int)
tw_im = np.zeros(128, dtype=int)

for i in range(128):
    tw_re[i] = int(np.cos(-2*np.pi*i/512)*2**8)
    tw_im[i] = int(np.sin(-2*np.pi*i/512)*2**8)
    if (tw_re[i] < 0):
        tw_re[i] += tw_re + 2**16
    if (tw_im[i] < 0):
        tw_im[i] += tw_im[i] + 2**16 

for i in range (1,7):
    filename = "twiddle"+str(1<<(i+1))+".mem"
    with open(filename, 'w', encoding='utf-8') as file:
        for k in range(1<<(i+1)):
            print(f"{tw_re[k*(1<<(6-i))]:04x}"+f"{tw_im[k*(1<<(6-i))]:04x}", file=file)