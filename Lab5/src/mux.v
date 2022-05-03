module mux#(
        parameter DATA_WIDTH=32,
        parameter SEL_WIDTH=2)(
            input [DATA_WIDTH-1:0] in [(1<<SEL_WIDTH)-1:0],
            input [SEL_WIDTH-1:0] sel,
            output [DATA_WIDTH-1:0] out
        );
    assign out = in[sel];
endmodule
