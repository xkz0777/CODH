import random

mp = {0xaa: "7ab1", 0xbb: "281b", 0xcc: "13c0", 0xdd: "427d"}

with open("./tb.coe", "w") as f:
    f.write("memory_initialization_radix = 16;\nmemory_initialization_vector =\n")
    for i in range(256):
        if i not in mp.keys():
            f.write("0 ")
        else:
            f.write(f"{mp[i]} ")
    f.write(";")

with open("./sort.coe", "w") as f:
    f.write("memory_initialization_radix = 16;\nmemory_initialization_vector =\n")
    for i in range(256):
        j = random.randrange(0, 0xffff)
        f.write(f"{hex(j)[2:]} ")
    f.write(";")