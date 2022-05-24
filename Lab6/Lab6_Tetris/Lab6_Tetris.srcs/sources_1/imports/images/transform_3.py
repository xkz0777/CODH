from PIL import Image
import sys

if (len(sys.argv) == 2):
    logo = Image.open(sys.argv[1])
    logo = logo.convert('L')
    w, h = logo.size
    with open(sys.argv[1][:-4] + '.coe', 'w') as f:
        f.write('memory_initialization_radix=2;\nmemory_initialization_vector =\n')
        for i in range(h):
            for j in range(w):
                pixel = logo.getpixel((j, i))
                if pixel < 125:
                    f.write("111,\n")
                else:
                    f.write("000,\n")
