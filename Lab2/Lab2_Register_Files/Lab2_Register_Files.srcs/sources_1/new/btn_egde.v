`timescale 1ns / 1ps

module btn_edge(
        input clk, btn,
        output single_edge
    );
    reg btn1, btn2;

    always@(posedge clk) begin
        btn1 <= btn;
        btn2 <= btn1;
    end

    assign single_edge = btn1 & ~btn2;
endmodule
