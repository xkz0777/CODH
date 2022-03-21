`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/20 14:32:54
// Design Name:
// Module Name: alu
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


module alu #(parameter WIDTH = 32) // 数据宽度
    (
        input [WIDTH-1:0] a, b, // 两操作数
        input [2:0] s, // 功能选择
        output reg [WIDTH-1:0] y, // 运算结果
        output reg [2:0] f); // 标志

    always@(*) begin
        f = 0;
        case (s)
            3'o0: begin
                y = a - b;
                f[0] = (a == b) ? 1 : 0;
                f[1] = ($signed(a) < $signed(b)) ? 1 : 0;
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
