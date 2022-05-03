`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/04/12 22:23:35
// Design Name:
// Module Name: branch_control
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


module branch_control(
        input b,
        input [2:0] cc,
        input [2:0] funct3,
        output reg branch
    );
    always @(*) begin
        if(!b)
            branch = 0;
        else begin
            case(funct3)
                0:
                    branch = cc[0]; // BEQ
                1:
                    branch = ~cc[0]; // BNE
                4:
                    branch = cc[1]; // BLT
                default:
                    branch = 0;
            endcase
        end
    end
endmodule
