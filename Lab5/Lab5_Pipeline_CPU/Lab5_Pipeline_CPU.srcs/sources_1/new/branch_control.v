`timescale 1ns / 1ps

module branch_control(
        input is_branch,
        input [2:0] cc,
        input [2:0] funct3,
        output reg branch
    );
    always @(*) begin
        if(!is_branch)
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
