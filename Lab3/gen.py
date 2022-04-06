import random
for _ in range(256):
    print(hex(random.randint(0, 0xffff)), end=", ")