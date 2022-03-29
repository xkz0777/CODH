`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/29 20:55:26
// Design Name:
// Module Name: db
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


module db(
        input clk, btn, rstn,
        output out
    );

    reg [15:0] cnt;

    always@(posedge clk) begin
        if (~rstn)
            cnt <= 0;
        else if (cnt < 16'h8fff)
            cnt <= cnt + 1;
    end

    assign out = cnt[15];
endmodule
