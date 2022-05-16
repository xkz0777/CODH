`timescale 1ns / 1ps

module io_control(
        input [31:0] dm_wd, alu_out,
        input [6:0] opcode,
        output [7:0] io_addr,
        output io_we, io_rd,
        output [31:0] io_dout
    );

    parameter I_LOAD = 7'b0000011; // LW
    parameter S_TYPE = 7'b0100011; // SW

    assign io_dout = dm_wd;
    parameter MMIO_START = 32'h0000ff00;
    wire [31:0] offset;
    assign offset = alu_out - MMIO_START;
    assign io_addr = offset[7:0];

    reg mmio;
    always@(*) begin
        if((io_addr <= 8'h18) && (offset[31] == 0))
            mmio = 1;
        else
            mmio = 0;
    end

    assign io_rd = ((opcode == I_LOAD) && (mmio == 1)) ? 1 : 0;
    assign io_we = ((opcode == S_TYPE) && (mmio == 1)) ? 1 : 0;
endmodule
