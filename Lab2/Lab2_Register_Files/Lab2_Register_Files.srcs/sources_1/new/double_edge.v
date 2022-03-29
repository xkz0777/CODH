`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/29 23:37:18
// Design Name:
// Module Name: double_edge
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


module double_edge(
        input clk, btn,
        output double_edge
    );
    wire edge_pos, edge_neg;
    btn_edge pos_inst(clk, btn, edge_pos);
    btn_edge neg_inst(clk, ~btn, edge_neg);
    assign double_edge = edge_pos | edge_neg;

endmodule
