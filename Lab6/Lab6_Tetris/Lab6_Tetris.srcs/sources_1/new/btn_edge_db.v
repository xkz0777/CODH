`timescale 1ns / 1ps

module btn_edge_db #(parameter CYCLE=20)(
        input clk, btn, rstn,
        output out
    );
    wire db;
    btn_db #(.CYCLE(CYCLE)) btn_db_inst(clk, btn, rstn, db);
    btn_edge btn_edge_inst(clk, db, rstn, out);
endmodule
