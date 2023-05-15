module inst_memory (
    input        rst,
    input  [9:0] read_address,
    output reg [31:0] data
);

reg [31:0] memory  [0:1023];
always @(*) begin
    if (rst) begin
        data <= 32'b0;
    end else begin
        data <= memory[read_address>>2]; // 4 e böl yada aynı ikiside
    end
end


    initial
	begin
		$readmemh("code.mem",memory);
	end
endmodule