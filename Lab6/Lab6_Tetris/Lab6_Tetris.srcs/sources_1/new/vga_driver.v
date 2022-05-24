`timescale 1ns / 1ps
// 生成游戏时的 VGA 同步信号
module vga_driver(
        input clk,
        input rst_n,
        output[10:0] col_addr_sig,
        output[10:0] row_addr_sig,
        output hsync,
        output vsync,
        output ready_sig);

    parameter H_SYNC_END = 96; // 行同步脉冲结束时间
    parameter V_SYNC_END = 2; // 列同步脉冲结束时间
    parameter H_SYNC_TOTAL = 800; // 行扫描总像素单位
    parameter V_SYNC_TOTAL = 525; // 列扫描总像素单位
    parameter H_SHOW_START = 144; // 显示区行开始像素点
    parameter V_SHOW_START = 35; //显示区列开始像素点

    reg[10:0] cnt_h;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_h <= 11'd0;
        else if(cnt_h == H_SYNC_TOTAL)
            cnt_h <= 11'd0;
        else
            cnt_h <= cnt_h + 1'b1;
    end

    reg[10:0] cnt_v;

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            cnt_v <= 11'd0;
        else if(cnt_v == V_SYNC_TOTAL)
            cnt_v <= 11'd0;
        else if(cnt_h == H_SYNC_TOTAL)
            cnt_v <= cnt_v + 1'b1;
    end

    reg isready; // 确保颜色显示在正确的范围内

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n)
            isready <= 1'b0;
        else if(cnt_h >= H_SHOW_START && cnt_h < 11'd784 && cnt_v >= V_SHOW_START && cnt_v < 11'd515)
            isready <= 1'b1;
        else
            isready <= 1'b0;
    end

    assign hsync = (cnt_h < H_SYNC_END) ? 1'b1 : 1'b0;
    assign vsync = (cnt_v < V_SYNC_END) ? 1'b1 : 1'b0;
    assign col_addr_sig = isready ? (cnt_h - H_SHOW_START) : 11'd0;
    assign row_addr_sig = isready ? (cnt_v - V_SHOW_START) : 11'd0;
    assign ready_sig = isready;

endmodule
