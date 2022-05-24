`timescale 1ns / 1ps
module display_next(
        input clk,
        input rst_n,
        input[10:0] col_addr_sig,
        input[10:0] row_addr_sig,
        output reg next_c);

    reg[12:0] addra;
    wire next;


    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            addra<=0;
        end
        else begin
            if(col_addr_sig>=12'd430&&col_addr_sig<12'd530&&row_addr_sig>=12'd10&&row_addr_sig<12'd88) begin
                addra<=(row_addr_sig-12'd10)*100+col_addr_sig-12'd430;
            end
            else
                addra<=0;
        end
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            next_c<=0;
        end
        else begin
            if(col_addr_sig>=12'd430&&col_addr_sig<12'd530&&row_addr_sig>=12'd10&&row_addr_sig<12'd88) begin
                next_c<=next;
            end
            else
                next_c<=0;
        end
    end


    next_rom next_rom (
                 .clka(clk), // input clka
                 .addra(addra), // input [12 : 0] addra
                 .douta(next) // output douta
             );


endmodule
