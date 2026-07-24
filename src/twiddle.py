import numpy as np
import matplotlib.pyplot as plt 

tw_re = np.zeros(128, dtype=int)
tw_im = np.zeros(128, dtype=int)

<<<<<<< HEAD
for i in [256, 64, 16]:
    for n in range(1,4):
        print(f"if ((DEPTH == {i//4}) && (BRANCH == {n})) begin : rom_{i}_{n}k")
        print("\talways_ff @(posedge clk) begin")
        print("\t\tcase(addr_re)")
        for k in range(i//4):
            tw_re = int(np.cos(-2*np.pi*n*k/i)*2**15)
            if (tw_re == 2**15):
                tw_re -= 1
=======
# for i in range(128):
#     tw_re[i] = int(np.cos(-2*np.pi*i/512)*2**8)
#     tw_im[i] = int(np.sin(-2*np.pi*i/512)*2**8)
#     if (tw_re[i] < 0):
#         tw_re[i] += tw_re + 2**16
#     if (tw_im[i] < 0):
#         tw_im[i] += tw_im[i] + 2**16 

# for i in range (1,7):
#     filename = "twiddle"+str(1<<(i+1))+".mem"
#     with open(filename, 'w', encoding='utf-8') as file:
#         for k in range(1<<(i+1)):
#             print(f"{tw_re[k*(1<<(6-i))]:04x}"+f"{tw_im[k*(1<<(6-i))]:04x}", file=file)

# for i in [256, 64, 16]:
#     for n in range(1,4):
#         filename = "twiddle"+str(i)+"_"+str(n)+".mem"
#         with open(filename, 'w', encoding='utf-8') as file:
#             for k in range(i//4):
#                 tw_re = int(np.cos(-2*np.pi*n*k/i)*2**12)
#                 tw_im = int(np.sin(-2*np.pi*n*k/i)*2**12)
#                 if (tw_re < 0):
#                     tw_re += tw_re + 2**16
#                 if (tw_im < 0):
#                     tw_im += tw_im + 2**16 
#                 print(f"{tw_re:04x}"+f"{tw_im:04x}", file=file)

for i in [256, 64, 16]:
    for n in range(1,4):
        print(f"if ((DEPTH == {i}) && (BRANCH == {n})) begin : rom_{i}_{n}k")
        print("\talways_ff @(posedge clk) begin")
        print("\t\tcase(addr_re)")
        for k in range(i//4):
            tw_re = int(np.cos(-2*np.pi*n*k/i)*2**14)
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
            if (tw_re < 0):
                tw_re += 2**16
            print("\t\t\t" + f"{int(np.log2(i//4))}'d{k}: tw_re <= 16'h{tw_re:04x};")

        print("\t\tendcase")
        print("\n")
        
        print("\t\tcase(addr_im)")
        for k in range(i//4):
<<<<<<< HEAD
            tw_im = int(np.sin(-2*np.pi*n*k/i)*2**15)
            if (tw_im == 2**15):
                tw_im -= 1
=======
            tw_im = int(np.sin(-2*np.pi*n*k/i)*2**14)
>>>>>>> 6d726b62fe8734cec27e3098c2b8928a68ea5b9d
            if (tw_im < 0):
                tw_im += 2**16 
            print("\t\t\t" + f"{int(np.log2(i//4))}'d{k}: tw_im <= 16'h{tw_im:04x};")
        
        print("\t\tendcase")

        print("\tend")
        print("end")