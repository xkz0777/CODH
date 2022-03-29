`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/29 19:09:27
// Design Name:
// Module Name: sort
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module sort(
        input clk,
        input rstn,
        input [15:0] x,	   // 输入 1 位十六进制数字
        input del,		   // 删除 1 位十六进制数字
        input addr,		   // 设置地址
        input data,		   // 修改数据
        input chk,		   // 查看下一项
        input run,		   // 启动排序

        output [7:0] an,   // 数码管显示存储器地址和数据
        output [6:0] seg,
        output busy,	   // 1—正在排序，0—排序结束
        output [15:0] cnt  // 排序耗费时钟周期数
    );

endmodule
