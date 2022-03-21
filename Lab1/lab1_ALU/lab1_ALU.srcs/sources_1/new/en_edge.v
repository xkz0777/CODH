`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/20 18:54:24
// Design Name:
// Module Name: en_edge
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


module en_edge(
        input en, clk,
        output out
    );
    reg [15:0] cnt;

    always@(posedge clk) begin
        if (en == 0)
            cnt <= 0;
        else if (cnt < 16'h8000)
            cnt <= cnt + 1;
        else
            cnt <= cnt;
    end

    reg en1, en2;
    always@(posedge clk) begin
        en1 <= cnt[15];
        en2 <= en1;
    end

    assign out = en1 & ~en2;

endmodule
