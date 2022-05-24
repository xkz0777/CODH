while True:
    color_16 = input('输入 24 位颜色')
    red = color_16[0:2]
    green = color_16[2:4]
    blue = color_16[4:6]
    red_4 = hex((int(red, 16) >> 4))
    green_4 = hex((int(green, 16) >> 4))
    blue_4 = hex((int(blue, 16) >> 4))
    print(f'{red_4[2:]}{green_4[2:]}{blue_4[2:]}')