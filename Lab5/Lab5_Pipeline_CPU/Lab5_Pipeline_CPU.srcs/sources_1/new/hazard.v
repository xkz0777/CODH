`timescale 1ns /1ps

module hazard(
        input branch,
        input [6:0] opcode,
        input [4:0] ex_rd, id_rs1, id_rs2,
        output reg stall, if_flush, id_flush
    );

    parameter UJ_JAL = 7'b1101111; // JAL
    parameter I_JALR = 7'b1100111; // JALR
    parameter I_LOAD = 7'b0000011; // LW

    always@(*) begin
        if ((opcode == I_LOAD) && ((ex_rd == id_rs1) || (ex_rd == id_rs2)))
            stall = 1;
        else
            stall = 0;

        if (branch || (opcode == UJ_JAL) || (opcode == I_JALR)) begin
            if_flush = 1;
            id_flush = 1;
        end

        else begin
            if_flush = 0;
            id_flush = 0;
        end
    end
endmodule
