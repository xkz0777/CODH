`timescale 1ns / 1ps

module forwarding(
        input [4:0] ex_rs1, ex_rs2, mem_rd, wb_rd,
        input mem_reg_write, wb_reg_write,
        input [31:0] ex_a, ex_b, mem_alu_out, wb_rf_wd,
        output reg [31:0] alu_in0, alu_in1
    );

    reg [1:0] sel_a, sel_b;
    // 0 为 ex_a / ex_b，1 为 mem_alu_out，2 为 wb_rf_wd

    always@(*) begin
        if (mem_rd == ex_rs1 && (mem_rd != 0) && mem_reg_write)
            sel_a = 1;
        else if (wb_rd == ex_rs1 && (wb_rd != 0) && wb_reg_write)
            sel_a = 2;
        else
            sel_a = 0;

        if (mem_rd == ex_rs2 && (mem_rd != 0) && mem_reg_write)
            sel_b = 1;
        else if (wb_rd == ex_rs2 && (wb_rd != 0) && wb_reg_write)
            sel_b = 2;
        else
            sel_b = 0;
    end

    always@(*) begin
        case (sel_a)
            0:
                alu_in0 = ex_a;
            1:
                alu_in0 = mem_alu_out;
            2:
                alu_in0 = wb_rf_wd;
        endcase

        case (sel_b)
            0:
                alu_in1 = ex_b;
            1:
                alu_in1 = mem_alu_out;
            2:
                alu_in1 = wb_rf_wd;
        endcase
    end
endmodule
