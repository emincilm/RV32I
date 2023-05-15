module registerfile(
            input         clk,
            input  [4:0]  read_register_addr1, read_register_addr2, 
            input  [31:0] register_write_data,
            input  [4:0]  register_write_addr,
            input         RegWrite_i,
            output [31:0] read_register_data1,read_register_data2
    );
integer i=0;
reg [31:0] reg_memory [0:31];
initial begin
    for(i=0;i<32;i=i+1)
        begin
            reg_memory[i]<=32'b0;
        end
    end
assign read_register_data1=reg_memory[read_register_addr1];
assign read_register_data2=reg_memory[read_register_addr2];

always @(posedge clk)begin
    
    if(RegWrite_i)begin
             reg_memory[register_write_addr]<=register_write_data;
    end
end

endmodule