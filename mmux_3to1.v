`timescale 1ns / 1ps


module mux_3to1(
    input   [31:0]      mux_i1,
    input   [31:0]      mux_i2,
    input   [31:0]      mux_i3,
    input   [1:0]       mux_select,
    output [31:0]       mux_o
    );
    
    assign mux_o =      (mux_select==01)? mux_i1:
                        (mux_select==00)? mux_i2:
                        (mux_select==11)? mux_i3:32'b0;
endmodule
