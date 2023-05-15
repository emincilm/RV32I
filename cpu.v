module cpu (
    input clk,rst
    output [31:0] data_o
);

wire [31:0] pc_o;

pc p(.clk(clk), .rst(rst),  .pc_o(pc_o));
inst_memory inst(.addr(pc_o),   .data_o(data_o));
endmodule