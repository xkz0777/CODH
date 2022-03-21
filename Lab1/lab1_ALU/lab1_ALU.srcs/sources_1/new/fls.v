`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2022/03/21 16:39:49
// Design Name:
// Module Name: fls
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


module fls (
        input clk,
        input rstn,
        input en,
        input [15:0] d,
        output reg [15:0] f
    );

    reg [1:0] cur_state, next_state;

    reg [15:0] a, b;
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;

    wire [15:0] sum;
    alu #(.WIDTH(16)) alu_inst(a, b, 3'b001, sum);

    always@(*) begin
        case(cur_state)
            S0:
                next_state = en ? S1 : S0;
            S1:
                next_state = en ? S2 : S1;
            S2:
                next_state = en ? S3 : S2;
            default:
                next_state = en ? S3 : S2;
        endcase
    end

    always@(posedge clk)
        cur_state = (rstn) ? next_state : S0;

    always@(posedge clk) begin
        case(cur_state)
            S0: begin
                a <= 0;
                b <= 0;
            end
            S1: begin
                a <= (a) ? a : d;
            end
            S2: begin
                b <= (b) ? b : a;
                a <= (b) ? a : d;
            end
            default: begin
                a <= sum;
                b <= a;
            end
        endcase
    end

    always@(*)
        f = a;
endmodule
