`timescale 1ns / 1ps
module btn_edge(
        input clk, btn, rstn,
        output single_edge
    );
    reg btn1, btn2;

    always@(posedge clk) begin
        if (!rstn) begin
            btn1 <= 0;
            btn2 <= 0;
        end
        else begin
            btn1 <= btn;
            btn2 <= btn1;
        end

    end

    assign single_edge = btn1 & ~btn2;
endmodule
