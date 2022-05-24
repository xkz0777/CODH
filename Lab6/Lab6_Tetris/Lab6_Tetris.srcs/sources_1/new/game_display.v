// 根据各模块状态决定 RGB 输出

`timescale 1ns / 1ps
module game_display(
        input clk,
        input rst_n,
        input ready_sig,                        // RGB 输出使能信号的输入
        input enable_black_border,                // 显示边界的使能信号
        input enable_blue_moving,               // 正在下落的小方块显示使能信号
        input enable_blue_little_flag,          // 静止小方块显示使能信号
        input next_yellow_display,              // 下一个小方块的显示使能信号
        input next_c,                           // NEXT 字符显示使能信号
        input score_out_c,                      // SCORE 字符显示使能信号
        input score,                            // 分数显示使能信号
        output reg [3:0] red,                             // R 信号输出
        output reg [3:0] green,                           // G 信号输出
        output reg [3:0] blue);                           // B 信号输出


    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            red <= 4'b0;
            green <= 4'b0;
            blue <= 4'b0;
        end
        else if(ready_sig) begin
            red <= {score || next_yellow_display || enable_blue_little_flag || score_out_c || next_c, 3'b0};
            blue <= {next_yellow_display || next_c || enable_black_border || score_out_c, 3'b0};
            green <= {enable_blue_little_flag || enable_blue_moving || enable_black_border || score_out_c || next_c, 3'b0};
        end
    end

endmodule
