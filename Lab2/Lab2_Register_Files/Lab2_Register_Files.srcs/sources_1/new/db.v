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


module db #(parameter CYCLE=16) (
        input clk, btn, rstn,
        output out
    );

    reg [CYCLE-1:0] cnt;

    always@(posedge clk) begin
        if (~rstn | ~btn)
            cnt <= 0;
        else if (cnt < {1'b1, {(CYCLE-1){1'b0}}})
            cnt <= cnt + 1;
    end

    assign out = cnt[CYCLE-1];
endmodule
