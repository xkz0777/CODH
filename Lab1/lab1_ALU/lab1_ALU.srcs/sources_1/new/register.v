`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/20 18:14:41
// Design Name:
// Module Name: register
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


module register #(parameter WIDTH = 6)
    (
        input [WIDTH-1:0] s,
        input en, rstn, clk,
        output reg [WIDTH-1:0] q);
    always@(posedge clk) begin
        if (~rstn)
            q <= 0;
        else
            if (en)
                q <= s;
            else
                q <= q;
    end

endmodule
