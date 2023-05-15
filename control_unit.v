module control_unit (
        input [31:0]          buyruk_i,
        output reg [4:0]      alu_src,              // aluda yapılacak işlemi belirler  
        output reg            reg_en,               //* regwrite olarak geçiyor     registere yazıldığı durumda olacak
        output reg            mux_src,              //* alu src olarak ımm den gelen mi rs2 den gelen mi girecek onu belirliyor 
        output reg  [2:0]     imm_src,             // buyruk tiği seçicez imm generatorden kullanılmayanda önemlii değil
        output reg            mem_read,           //*   lw ve sw de kullanılacak    
        output reg            mem_write,         // *   lw ve sw de kullanılacak
        output reg  [1:0]     memtoreg,         //*     hepsinde olmalı lw ve sw hariç  
        output reg            mux_select3,      //* pc counterin nasıl artacağını belirleyen mux 
        output reg            muc4_ctrl,        // alunun rs1 girişinin önündeki mux
        output reg            branch            //*     zero çıkışıyla birlikte 1 olduğu durumda pc jalda kullanılacak sanırım             
);
wire [6:0] opcode;
wire [2:0] func3;
wire [6:0] func7;

assign opcode = buyruk_i[6:0];
assign func3  = buyruk_i[14:12];
assign func7  = buyruk_i[31:25];
always @(buyruk_i)begin
    case(opcode)
    7'b0010011: begin   //I type buyruklar 
                case(func3)     //func3 bölümü 
                3'b000: begin
//                        ADDI
                alu_src     <=  5'b00010;
                reg_en      <=  1'b1;
                mux_src     <=  1'b1;
                imm_src     <=  3'b001;
                memtoreg    <=  2'b00;
                branch      <=  1'b0;
                mem_read    <=  1'b0;
                mem_write   <=  1'b0;
                mux_select3 <=  1'b0;
                muc4_ctrl   <=  1'b0;
                        end
                3'b010: begin
//                       SLTI
                alu_src     <=  5'b01000;
                reg_en      <=  1'b1;
                mux_src     <=  1'b1;
                imm_src     <=  3'b001; 
                memtoreg    <=  1'b1;   
                branch      <=  1'b0; 
                mux_select3 <=  1'b0; 
                muc4_ctrl   <=  1'b0; 
                        end
                3'b011: begin
//                       SLTIU
                alu_src     <=  5'b00110;
                reg_en      <=  1'b1;
                mux_src     <=  1'b1;
                imm_src     <=  3'b001;  
                memtoreg    <=  1'b1; 
                branch      <=  1'b0;   
                mux_select3 <=  1'b0;
                muc4_ctrl   <=  1'b0; 
                        end
                3'b100: begin
//                       XORI
                alu_src     <=  5'b00111;
                reg_en      <=  1'b1;
                mux_src     <=  1'b1;
                imm_src     <=  3'b0001;  
                memtoreg    <=  1'b1;  
                branch      <=  1'b0;
                mux_select3 <=  1'b0;   
                muc4_ctrl   <=  1'b0; 
                        end
                3'b110: begin
//                       ORI
                alu_src     <=  5'b00001;
                reg_en      <=  1'b1;
                mux_src     <=  1'b1;
                imm_src     <=  3'b001;
                memtoreg    <=  1'b1;  
                branch      <=  1'b0;
                mux_select3 <=  1'b0; 
                muc4_ctrl   <=  1'b0;     
                        end                                              
                 3'b111: begin
//                       ANDI
                alu_src     <=  5'b00000;
                reg_en      <=  1'b1;
                mux_src     <=  1'b1;
                imm_src     <=  3'b001;  
                memtoreg    <=  1'b1;  
                branch      <=  1'b0;
                mux_select3 <=  1'b0;  
                muc4_ctrl   <=  1'b0;  
                        end  
                 3'b001: begin
//                      SLLI 
                alu_src     <=  5'b00011;
                reg_en      <=  1'b1;
                mux_src     <=  1'b1;
                imm_src     <=  3'b001;  
                memtoreg    <=  1'b1;  
                branch      <=  1'b0; 
                mux_select3 <=  1'b0;
                muc4_ctrl   <=  1'b0;   
                        end   
                 3'b101: begin
//                      SRLI 
                alu_src     <=  5'b00101;
                reg_en      <=  1'b1;
                mux_src     <=  1'b1;
                imm_src     <=  3'b001;  
                memtoreg    <=  1'b1;  
                branch      <=  1'b0;
                mux_select3 <=  1'b0; 
                muc4_ctrl   <=  1'b0;   
                        end    
                 3'b101: begin
//                     SRAI  
                alu_src     <=  5'b01001;
                reg_en      <=  1'b1;
                mux_src     <=  1'b1;
                imm_src     <=  3'b001;  
                memtoreg    <=  1'b1;  
                branch      <=  1'b0;
                mux_select3 <=  1'b0;  
                muc4_ctrl   <=  1'b0;  
                        end               
                endcase
                end
    7'b0110011: begin   // R- type buyruklar
                case(func3) 
                3'b000: begin
                            if(func7 == 7'b0000000)begin                //ADD
                            alu_src     <=  5'b00010;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b0;
                            imm_src     <=  3'b000;
                            memtoreg    <=  1'b1;   
                            branch      <=  1'b0; 
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0;
                            end else if(func7 == 7'b0100000) begin      //SUB
                            alu_src     <=  5'b00100;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b0;
                            imm_src     <=  3'b000;
                            memtoreg    <=  1'b1;   
                            branch      <=  1'b0; 
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0;
                            end
                        end
                3'b001: begin                                           //SLL
                            alu_src     <=  5'b00011;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b0;
                            imm_src     <=  3'b000;
                            memtoreg    <=  1'b1;
                            branch      <=  1'b0; 
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0;
                        end
                3'b010: begin                                           //SLT
                            alu_src     <=  5'b01000;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b0;
                            imm_src     <=  3'b000;
                            memtoreg    <=  1'b1;
                            branch      <=  1'b0; 
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0;
                        end
                3'b011: begin                                           //SLTU
                            alu_src     <=  5'b00110;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b0;
                            imm_src     <=  3'b000;
                            memtoreg    <=  1'b1;
                            branch      <=  1'b0; 
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0;
                        end
                3'b100: begin                                           //XOR
                            alu_src     <=  5'b00111;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b0;
                            imm_src     <=  3'b000;
                            memtoreg    <=  1'b1;
                            branch      <=  1'b0; 
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0;
                        end
                3'b101: begin                                              
                            if(func7 == 7'b0000000) begin                             //SRL
                            alu_src     <=  5'b00101;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b0;
                            imm_src     <=  3'b000;
                            memtoreg    <=  1'b1;
                            branch      <=  1'b0; 
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0;
                            end else if(func7 == 7'b0100000 ) begin                   //SRA  
                            alu_src     <=  5'b01001;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b0;
                            imm_src     <=  3'b000;
                            memtoreg    <=  1'b1;
                            branch      <=  1'b0; 
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0;
                            end
                        end
                3'b110: begin                                           //OR
                            alu_src     <=  5'b00001;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b0;
                            imm_src     <=  3'b000;
                            memtoreg    <=  1'b1;
                            branch      <=  1'b0;
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0; 
                        end
                3'b111: begin                                           //AND       
                             
                        end
                
                endcase
                end
    7'b0110111: begin       //LUI 
                            alu_src     <=  5'b01010;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b1;
                            imm_src     <=  3'b010;
                            memtoreg    <=  2'b00;
                            branch      <=  1'b0;
                            mem_read    <=  1'b0;
                            mem_write   <=  1'b0;
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b0;
                end
    7'b0010111: begin       //AUIPC
                            alu_src     <=  5'b00010;
                            reg_en      <=  1'b1;
                            mux_src     <=  1'b1;
                            imm_src     <=  3'b010;
                            memtoreg    <=  2'b00;
                            branch      <=  1'b0;
                            mem_read    <=  1'b0;
                            mem_write   <=  1'b0;
                            mux_select3 <=  1'b0;
                            muc4_ctrl   <=  1'b1;
                end            
    7'b1100011: begin           // B- type buyruklar 
                    case(func3)
                    3'b000: begin                                                 //BEQ
                                alu_src     <=  5'b01011;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b100;
                                memtoreg    <=  2'b00;
                                branch      <=  1'b1;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0;        
                            end
                    3'b001: begin                                               // BNE
                                alu_src     <=  5'b01100;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b100;
                                memtoreg    <=  2'b00;
                                branch      <=  1'b1;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0; 
                            end
                    3'b100: begin                                               //BLT
                                alu_src     <=  5'b01110;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b100;
                                memtoreg    <=  2'b00;
                                branch      <=  1'b1;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0; 
                            end
                    3'b100: begin                                               //BGE
                                alu_src     <=  5'b01111;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b100;
                                memtoreg    <=  2'b00;
                                branch      <=  1'b1;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0; 
                            end
                    3'b110: begin                                               //BLTU
                                alu_src     <=  5'b10000;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b100;
                                memtoreg    <=  2'b00;
                                branch      <=  1'b1;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0; 
                            end
                    3'b111: begin                                               //BGEU
                                alu_src     <=  5'b10001;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b100;
                                memtoreg    <=  2'b00;
                                branch      <=  1'b1;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0; 
                            end
                    endcase
                end
    7'b0000011: begin            //I type
                    case(func3)
                    3'b000: begin       //LB
                                alu_src     <=  5'b00010;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b001;
                                memtoreg    <=  2'b10;
                                branch      <=  1'b0;
                                mem_read    <=  1'b1;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0; 
                            end
                    3'b001: begin       //LH
                                alu_src     <=  5'b00010;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b001;
                                memtoreg    <=  2'b10;
                                branch      <=  1'b0;
                                mem_read    <=  1'b1;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0;
                            end
                    3'b010: begin       //LW
                                alu_src     <=  5'b00010;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b001;
                                memtoreg    <=  2'b10;
                                branch      <=  1'b0;
                                mem_read    <=  1'b1;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0;
                            end
                    3'b100: begin       //LBU
                                alu_src     <=  5'b00010;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b001;
                                memtoreg    <=  2'b10;
                                branch      <=  1'b0;
                                mem_read    <=  1'b1;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0;
                            end
                    3'b101: begin       //LHU
                                alu_src     <=  5'b00010;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b001;
                                memtoreg    <=  2'b10;
                                branch      <=  1'b0;
                                mem_read    <=  1'b1;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0;
                            end
                    endcase
                end
    7'b0100011: begin                               // S- Type
                    case(func3)
                    3'b000: begin           //SB
                                alu_src     <=  5'b00010;
                                reg_en      <=  1'b0;
                                mux_src     <=  1'b1;
                                imm_src     <=  3'b011;
                                memtoreg    <=  2'b00;
                                branch      <=  1'b0;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b1;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b1;   
                            end
                    3'b001: begin           //SH
                                alu_src     <=  5'b00010;
                                reg_en      <=  1'b0;
                                mux_src     <=  1'b1;
                                imm_src     <=  3'b011;
                                memtoreg    <=  2'b00;
                                branch      <=  1'b0;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b1;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b1; 
                            end
                    3'b010: begin           //SW
                                alu_src     <=  5'b00010;
                                reg_en      <=  1'b0;
                                mux_src     <=  1'b1;
                                imm_src     <=  3'b011;
                                memtoreg    <=  2'b00;
                                branch      <=  1'b0;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b1;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b1; 
                            end
                    endcase
                end
    7'b1100111: begin       // JALR
                                alu_src     <=  5'b10010;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b100;
                                memtoreg    <=  2'b01;
                                branch      <=  1'b1;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0;
                end
    7'b1101111: begin       //JAL
                                alu_src     <=  5'b10010;
                                reg_en      <=  1'b1;
                                mux_src     <=  1'b0;
                                imm_src     <=  3'b001;
                                memtoreg    <=  2'b01;
                                branch      <=  1'b1;
                                mem_read    <=  1'b0;
                                mem_write   <=  1'b0;
                                mux_select3 <=  1'b0;
                                muc4_ctrl   <=  1'b0;
                end
    default: begin
             begin   
                alu_src     <=  5'b0000;
                reg_en      <=  1'b0;
                mux_src     <=  1'b0;
                imm_src     <=  3'b000;
                memtoreg    <=  1'b0;
                branch      <=  1'b0; 
                end
             end
    endcase
end

endmodule

//ADDI 
//SLTI 
//SLTIU
//XORI 
//ORI  
//ANDI 
//ADD  
//SUB  
//SLL  
//SLT  
//SLTU 
//XOR  
//SRL  
//SRA  
//OR   
//AND  



















