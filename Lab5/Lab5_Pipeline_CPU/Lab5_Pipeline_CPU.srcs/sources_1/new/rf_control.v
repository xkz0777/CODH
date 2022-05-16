`timescale 1ns / 1ps

module rf_control(
        input io_rd,
        input [31:0] io_din,
        input [1:0] mem_to_reg,
        input [31:0] alu_out,
        input [31:0] pc,
        input [31:0] dm_rd0,
        input [31:0] extended_imm,
        output reg [31:0] rf_wd
    );
    always@(*) begin
        if(io_rd)
            rf_wd = io_din;
        else begin
            case (mem_to_reg)
                0:
                    rf_wd = alu_out;
                1:
                    rf_wd = pc + 4;
                2:
                    rf_wd = dm_rd0;
                3:
                    rf_wd = pc + extended_imm;
            endcase
        end
    end
endmodule
