module alu (
    input  signed     [31:0]    alu_i1,alu_i2,
    input             [4:0]     alu_control,
    output        reg [31:0]    alu_o,
    output        reg           zero_flag
);

wire [31:0] tmp1,tmp2;
reg branch_o;
assign tmp1 =  alu_i1;
assign tmp2 =  alu_i2;
    always @(*) begin
        
        case (alu_control)
            5'b00000:    alu_o   <=      alu_i1 & alu_i2;                // AND
            5'b00001:    alu_o   <=      alu_i1 | alu_i2;               // OR
            5'b00010:    alu_o   <=      alu_i1 + alu_i2;              // ADD 
            5'b00011:    alu_o   <=      alu_i1 << alu_i2[4:0];       // SLL   
            5'b00100:    alu_o   <=      alu_i1 - alu_i2;            // SUBB
            5'b00101:    alu_o   <=      alu_i1 >> alu_i2[4:0];           // SRL 
            5'b00110:    begin                                       //SLTU
                            if (tmp1 < tmp2) begin
                                alu_o <= 1;
                            end else begin
                                alu_o <= 0;
                            end
                        end  //   
            5'b00111:    alu_o   <=      alu_i1 ^  alu_i2;          // XOR
            5'b01000:    begin                                      //SLT
                            if (alu_i1 < alu_i2) begin
                                alu_o <= 1;
                            end else begin
                                alu_o <= 0;
                            end
                        end
            5'b01001:    alu_o   <=     alu_i1 >>> alu_i2[4:0];           //SRA 
            5'b01010:    alu_o   <=     alu_i2;                          // LUI
            5'b01011:    branch_o   <=     (alu_i1 == alu_i2);             //BEQ
            5'b01100:    branch_o   <=     !(alu_i1 == alu_i2);            //BNE
            5'b01110:    branch_o   <=     (alu_i1 < alu_i2);             //BLT
            5'b01111:    branch_o   <=     (alu_i1 >= alu_i2);            //BGE
            5'b10000:    branch_o   <=     (tmp1 < tmp2);                 //BLTU
            5'b10001:    branch_o   <=     (tmp1 >= tmp2);                 //BGEU
            5'b10010:    branch_o   <=     1'b1;                            //JAL
            
            
            
           
            
        endcase
    end

    always @(*) begin
        if (!branch_o) begin
            zero_flag <= 1'b0;
        end else begin
            zero_flag <= 1'b1;
        end
    end
endmodule