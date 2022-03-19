# Verilog

+ 端口默认被定义为 wire, input 只能是 wire, output 可以是 reg.

+ 使用 always 语句描述的变量, 一定要声明为 reg 类型 (声明为 reg 类型的变量，综合后不一定生成寄存器).
+ 使用 assign 语句描述的变量, 应声明为 wire 类型.
+ 对未声明的端口赋值时会默认生成 net 类型的变量, 他们默认是位宽为 1 的 wire 类型. 可以通过加上 ``default_nettype` 来防止其出现.
+ 单目 `&`, `~`, `|` 可以对向量的每个位做运算.
+ 向量赋值时, 如果位宽不等, 会对进行 zero extension
+ 向量拼接运算符 `{}`, 复制 n 次: `{n{vec}}` (常用于符号拓展); 需要知道拼接对象的位宽, `{1, 2, 3}` 是 illegal 的. 应该声明为`{2'b01, 3'b10, 4'b11}` 这样的形式.
+ 同一进程中尽量在一个 if 或 case 语句块中对一个变量赋值, 否则后边的赋值会覆盖前面的赋值, 可能导致逻辑上的问题 (特例: 组合逻辑描述时, 为避免形成锁存器而在开始给变量赋初值).

组合电路

+ always 描述时避免不完全赋值 (否则出现锁存器).
+ 避免出现反馈. 例如, `y = y + x` 或者 `y = y`.
+ 无需复位, 即组合函数的自变量中无复位信号.
+ `case` 语句可以包含重复或者有部分重叠的 case, 会优先处理之前的. 可以用 `casez` 和 `casex` 进行模糊匹配

时序电路

+ 使用`always @(posedge clk, negedge rstn])` 描述, `<=` 赋值.
+ 边沿敏感变量表中避免出现除时钟和复位外的其他信号.
+ 时钟信号避免出现在语句块内.

## 仿真

+ `#n` 表示时延, 在同一个 `initial` 块内的语句顺序执行, 因此后面的时延要和前面的叠加. 所有时延都根据时间单位定义, ``timescale 1ns / 100ps` 说明时延时间单位为 1ns 并且时间精度为 100ps. 以反引号 "`" 开始的语句是编译器指令.
+ `forever` 循环.
+ `$finish` 结束.

## Reverse Bit

```verilog
module top_module( 
    input [7:0] in,
    output [7:0] out
);
    always @(*) begin	
		for (int i=0; i<8; i++)
			out[i] = in[8-i-1];
	end
    /*
    generate
		genvar i;
		for (i=0; i<8; i = i+1) begin: my_block_name
			assign out[i] = in[8-i-1];
		end
	endgenerate
    */
endmodule
```

