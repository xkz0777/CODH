with open("./sort.coe", "r") as f:
    f.readline()
    f.readline()
    s = f.readline()
    s = s[:-2]
    arr = s.split()
    cnt = 0
    for i in range(1, 256):
        for j in range(0, 256 - i):
            if arr[j] > arr[j + 1]:
                cnt += 2
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
            cnt += 1
        cnt += 1
    print("Sorted array:", end=" ")
    for i in range(10):
        print(arr[i], end=" ")
    print("...", end=" ")
    print(arr[254], arr[255])
    print(f"Using cycles: {hex(cnt)[2:]}")
