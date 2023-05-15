module adder (
    input [31:0]    ad_i1,
    input [31:0]    ad_i2,
    output reg [31:0]   ad_o
);
    
 always @(*) begin
    ad_o <= ad_i1 + ad_i2;
 end


endmodule