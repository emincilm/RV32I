`timescale 1ns / 1ps


module data_memory(
    input                   clk,dm_read,dm_write,
    input [31:0]            dm_addr,
    input [31:0]            dm_wrd,
    output reg [31:0]       dm_rdd
    );
    reg [7:0] memory [0:1023];
    wire [2:0] func3;
    assign func3 = dm_addr[14:12];
    
    always @(posedge clk ) begin
        if(dm_write & ~dm_read)begin
                if (func3 == 3'b010)//SW
            begin
                memory[dm_addr]  <= dm_addr[7:0];
                memory[dm_addr+1]<= dm_addr[15:8];
                memory[dm_addr+2]<= dm_addr[24:16];
                memory[dm_addr+3]<= dm_addr[31:24];
            end

            else if (func3 == 3'b001)//SH
            begin
                memory[dm_addr]         <= dm_wrd[7:0];
                memory[dm_addr+1]       <= dm_wrd[15:8];
            end
            else if (func3==3'b000)// SB
            memory[dm_addr] <= dm_wrd[7:0];       
        end
    end

    always @(*) begin
        if (dm_read & ~dm_wrd) begin
                if (func3 == 3'b010) //LW
                dm_rdd={memory[dm_addr+3],memory[dm_addr+2],memory[dm_addr+1],memory[dm_addr]};

            else if (func3 == 3'b001)//LH
                dm_rdd={{16{memory[dm_addr+1][7]}},memory[dm_addr+1],memory[dm_addr]};

            else if (func3 == 3'b101)//Halfword unsigned
                dm_rdd= {16'b0,memory[dm_addr],memory[dm_addr+1]};

            else if (func3 == 3'b100)//BYTE unsigned
                dm_rdd= {24'b0,memory[dm_addr]};

            else if(func3==3'b000)// LB
                dm_rdd={{24{memory[dm_addr][7]}},memory[dm_addr]};            
        end
    end

    initial
	begin
		$readmemh("code.mem",memory);
	end
endmodule
