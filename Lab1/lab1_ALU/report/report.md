<div style="text-align:center;font-size:2em;font-weight:bold">中国科学技术大学计算机学院</div>

<div style="text-align:center;font-size:2em;font-weight:bold">《数字电路实验报告》</div>







<img src="logo.png" style="zoom: 50%;" />





<div style="display: flex;flex-direction: column;align-items: center;font-size:1.5em">
<div>
<p>实验题目：运算器及其应用</p>
<p>学生姓名：许坤钊</p>
<p>学生学号：PB20111714</p>
<p>完成时间：2022.03.21</p>
</div>
</div>


<div style="page-break-after:always"></div>

## 实验题目

运算器及其应用

## 实验目的

- 熟练掌握算术逻辑单元 (ALU) 的功能
- 掌握数据通路和控制器的设计方法
- 掌握组合电路和时序电路, 以及参数化和结构化的 Verilog 描述方法
- 了解查看电路性能和资源使用情况

## 实验环境

+ vlab.ustc.edu.cn

+ Vivado 2019.1

+ Nexys4 xc7a100tcsg324-1 开发板

## 实验过程

### ALU 模块的设计和仿真

#### 模块设计

ALU 模块只是一个简单的组合逻辑, 核心代码如下:

```verilog
module alu #(parameter WIDTH = 32) // 数据宽度
    (
        input [WIDTH-1:0] a, b, // 两操作数
        input [2:0] s, // 功能选择
        output reg [WIDTH-1:0] y, // 运算结果
        output reg [2:0] f); // 标志

    wire sign_a, sign_b;
    assign sign_a = a[WIDTH-1];
    assign sign_b = b[WIDTH-1];

    always@(*) begin
        f = 0;
        case (s)
            3'o0: begin
                y = a - b;
                f[0] = (a == b) ? 1 : 0;
                f[1] = (((sign_a == sign_b) && (a < b)) || (sign_a && ~sign_b)) ? 1 : 0;
                f[2] = (a < b) ? 1 : 0;
            end
            3'o1:
                y = a + b;
            3'o2:
                y = a & b;
            3'o3:
                y = a | b;
            3'o4:
                y = a ^ b;
            3'o5:
                y = a >> b;
            3'o6:
                y = a << b;
            default:
                y = $signed(a) >>> b; // 注意这里要把 a 转换成 signed, 否则默认是无符号

        endcase
    end
endmodule
```

重点在减法时标志 f 的设定, 在有符号小于时需要分两种情况: a 和 b 符号位相同时, 只要用 a < b 判断即可, 符号位不同时, 当且仅当 a 负 b 正时小于.

#### 模块仿真

仿真时可以直接对 32 位的 ALU 仿真, 用系统的 `$random` 函数生成随机的 a 和 b, 编写 testbench 如下:

```verilog
```



### 逻辑设计 (数据通路和状态图)

### 核心代码

### 仿真, 下载结果及其分析

## 总结与建议