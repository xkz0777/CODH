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
        output reg busy,	   // 1—正在排序，0—排序结束
        output reg [15:0] cnt  // 排序耗费时钟周期数
    );


    // 输入部分

    wire del_p, addr_p, data_p, chk_p;
    reg [7:0] a, dpra;
    wire [15:0] spo, dpo;

    reg s;
    reg [15:0] d;
    wire p;
    wire [3:0] h;

    // 模块例化
    dist_mem_gen_1 dm(.a(a), .clk(clk), .d(d), .spo(spo), .dpo(dpo), .we(data_p));
    dpe dpe_inst(clk, rstn, x, p, h);
    dp dp_inst(clk, rstn, chk, del, data, addr, chk_p, del_p, data_p, addr_p);

    always@(posedge clk) begin
        if (~rstn) begin
            a <= 0;
            d <= 0;
            s <= 0;
            busy <= 0;
        end

        else if (chk_p) begin
            a <= a + 1;
            s <= 0;
        end

        else if (p) begin
            d <= {d[11:0], h};
            s <= 1;
        end

        else if (del_p) begin
            d = d[15:4];
            s <= 1;
        end

        else if (data_p) begin
            d <= 0;
            a <= a + 1;
            s <= 0;
        end

        else if (addr_p) begin
            a <= d[7:0];
            d <= 0;
            s <= 0;
        end
    end

    // 输出部分
    wire [15:0] seg_data;
    assign seg_data = s ? d : spo;
    display display_inst(clk, a, seg_data, an, seg);

    // 排序部分
    parameter S0 = 0;

endmodule
