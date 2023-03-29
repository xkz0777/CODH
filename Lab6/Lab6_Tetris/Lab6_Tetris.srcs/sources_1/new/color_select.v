`timescale 1ns / 1ps
// 选择器，根据状态机状态选择需要输出到 vga 的信号
module color_select(
        input clk,
        input rst_n,
        input gameready_sig,
        input start_sig,
        input over_sig,
        input [3:0] red,
        input [3:0] green,
        input [3:0] blue,
        input ready_red_sig,
        input ready_green_sig,
        input ready_blue_sig,
        input over_red_sig,
        input over_green_sig,
        input over_blue_sig,
        // 输出到顶层模块
        output reg [3:0] red_out,
        output reg [3:0] green_out,
        output reg [3:0] blue_out);

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            red_out <= {ready_red_sig, 3'b0};
            green_out <= {ready_green_sig, 3'b0};
            blue_out <= {ready_blue_sig, 3'b0};
        end
        else if({ gameready_sig, start_sig, over_sig } == 3'b010) begin
            red_out <= red;
            green_out <= green;
            blue_out <= blue;
        end
        else if({ gameready_sig, start_sig, over_sig } == 3'b001) begin
            red_out <= {over_red_sig, 3'b0};
            green_out <= {over_green_sig, 3'b0};
            blue_out <= {over_blue_sig, 3'b0};
        end
        else begin
            red_out <= {ready_red_sig, 3'b0};
            green_out <= {ready_green_sig, 3'b0};
            blue_out <= {ready_blue_sig, 3'b0};
        end
    end

endmodule

