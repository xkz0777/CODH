## Questions

1. 随机数怎么生成的？

   种子固定，伪随机数，用一个固定算法生成序列。但加速下落会影响随机数从而影响形状，因此随机的效果尚可。

2. 怎么判断方块消掉？

   用一个大小为 500 的寄存器存储游戏界面，每行都对应一个寄存器。这个寄存器的值用 cpu 维护。

3. vga 显示？

   用 vga driver

1. 开场动画？

