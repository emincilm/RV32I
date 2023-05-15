module datapath1 (
    input       clk,rst
);
wire [31:0] ad_o2pc_i;
wire [31:0] pc_o2x;
wire [31:0] buyruk;
wire [31:0] alu_o;
wire [31:0] read_register_data1;
wire [31:0] read_register_data2;
wire [31:0] Imm;
wire [4:0]  alu_src;
wire mux_src,reg_en,pc_src,branch,zero_flag,mux_select,dm_rdd,muc4_ctrl,mux_select3,branch_o;
wire [2:0] imm_src;
wire [31:0] mux_o1,mux_o5,mux4_o;
wire [4:0] rs1,rs2,rd;
wire [31:0] ad_o2;
wire [31:0] mux3_o;
wire [1:0] memtoreg;
//wire and_o;
assign rs1 = buyruk[19:15];
assign rs2 = buyruk[24:20];
assign rd  = buyruk[11:7] ;
assign mux_select  = branch & zero_flag;
pc          p       (       .clk(clk),     
                            .rst(rst),      
                            .pc_i(mux3_o),    
                            .pc_o(pc_o2x));
inst_memory inst(           .rst(rst),      
                            .read_address(pc_o2x),    
                            .data(buyruk));
adder        ad1     (       .ad_i1(pc_o2x),      
                            .ad_i2(32'd4),      
                            .ad_o(ad_o2pc_i));
registerfile reeg   (       .clk(clk),    
                            .read_register_addr1(rs1),      
                            .read_register_addr2(rs2),      
                            .register_write_data(mux_o5),      
                            .register_write_addr(rd),      
                            .RegWrite_i(reg_en),        
                            .read_register_data1(read_register_data1),      
                            .read_register_data2(read_register_data2));  
imm_gen      img     (      .IR(buyruk),      
                            .select_i(imm_src),
                            .Imm(Imm)); 
alu          alu     (      .alu_i1(mux4_o),
                            .alu_i2(mux_o1),
                            .alu_control(alu_src),  
                            .alu_o(alu_o),
                            .zero_flag(zero_flag));
mux_2to1     mux_alu2rs2     (       .mux_i1(read_register_data2),    
                                     .mux_i2(Imm),    
                                     .mux_select(mux_src),
                                     .mux_o(mux_o1));    
//mux_2to1     m2     (       .mux_i1(dm_rdd),    
//                            .mux_i2(alu_o),    
//                            .mux_select(memtoreg),
//                            .mux_o(mux_o2));   
data_memory  dm     (       .clk(clk),
                            .dm_read(mem_read),
                            .dm_write(mem_write), 
                            .dm_addr(alu_o),                              
                            .dm_wrd(read_register_data2),               
                            .dm_rdd(dm_rdd));     
control_unit cm     (       .buyruk_i(buyruk),
                            .alu_src(alu_src), 
                            .reg_en(reg_en),  
                            .mux_src(mux_src), 
                            .imm_src(imm_src),
                            .mem_read(mem_read),
                            .mem_write(mem_write),
                            .memtoreg(memtoreg),
                            .mux_select3(mux_select3),
                            .muc4_ctrl(muc4_ctrl),
                            .branch(branch));
adder         ad2   (       .ad_i1(pc_o2x),
                            .ad_i2(Imm),
                            .ad_o(ad_o2));
mux_2to1     mux_controlandalu2pc     (         .mux_i1(ad_o2pc_i),    
                                                .mux_i2(ad_o2),    
                                                .mux_select(mux_select),
                                                .mux_o(mux3_o)); 
                                                       
mux_2to1     mux_reg2rs1     (                  .mux_i1(read_register_data1),    
                                                .mux_i2(pc_o2x),    
                                                .mux_select(muc4_ctrl),
                                                .mux_o(mux4_o));                               
mux_3to1    mux_alureaddatatowritedata      (       .mux_i1(pc_o2x + 32'd4),          //pc      en son çıkıştaki
                                                    .mux_i2(alu_o),     
                                                    .mux_i3(dm_rdd),     
                                                    .mux_select(memtoreg), 
                                                    .mux_o(mux_o5));       
endmodule