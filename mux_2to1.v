module mux_2to1 (
    input [31:0]    mux_i1,
    input [31:0]    mux_i2,
    input           mux_select,
    output [31:0]   mux_o
);
    

    assign mux_o = (mux_select == 0 )     ?    mux_i1:
                   (mux_select == 1 )     ?    mux_i2: 32'b0;




endmodule