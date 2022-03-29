`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/29 20:47:55
// Design Name:
// Module Name: edge
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


module btn_edge(
        input clk, btn,
        output single_edge
    );
    reg btn1, btn2;

    always@(posedge clk) begin
        btn1 <= btn;
        btn2 <= btn1;
    end

    assign single_edge = btn1 & ~btn2;
endmodule
