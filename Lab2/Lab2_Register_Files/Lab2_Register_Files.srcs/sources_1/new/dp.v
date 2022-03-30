`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/30 10:11:49
// Design Name:
// Module Name: dp
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


module dp #(parameter CYCLE=16)(
        input clk, rstn, chk, del, data, addr,
        output chk_p, del_p, data_p, addr_p
    );

    wire r1, r2, r3, r4;
    db db_inst1(clk, chk, rstn, r1);
    btn_edge edge_inst1(clk, r1, chk_p);

    db db_inst2(clk, del, rstn, r2);
    btn_edge edge_inst2(clk, r2, del_p);

    db db_inst3(clk, data, rstn, r3);
    btn_edge edge_inst3(clk, r3, data_p);

    db db_inst4(clk, addr, rstn, r4);
    btn_edge edge_inst4(clk, r4, addr_p);

endmodule
