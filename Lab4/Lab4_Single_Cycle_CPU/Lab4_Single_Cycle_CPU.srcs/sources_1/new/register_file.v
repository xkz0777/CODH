`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/12 16:06:12
// Design Name:
// Module Name: register_file
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


module register_file#(
        parameter AW = 5, // 地址宽度
        parameter DW = 32) // 数据宽度
    (input clk, // 时钟
     input [AW-1:0] ra0, ra1, ra2, // 读地址
     output [DW-1:0] rd0, rd1, rd2, // 读数据
     input [AW-1:0] wa, // 写地址
     input [DW-1:0] wd,	// 写数据
     input we			// 写使能
    );
    reg [DW-1:0] rf [0:(1<<AW)-1]; // 寄存器堆

    initial begin
        rf[0] = 0;
    end

    always@(posedge clk)
        if (we && (wa != 0))
            rf[wa] <= wd; // 写操作

    assign rd0 = rf[ra0];
    assign rd1 = rf[ra1];
    assign rd2 = rf[ra2];
endmodule
