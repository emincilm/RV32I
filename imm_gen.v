module imm_gen (
    input       [31:0] IR,
    input       [2:0]  select_i,
    output reg  [31:0] Imm
);

//Gelen buyruğun immediate bölümlerini ayırmak için yapıldı.
    wire [11:0] imm_11_0    = IR[31:20];
    wire [19:0] imm_31_12   = IR[31:12];
    wire [4:0]  imm_4_0     = IR[11:7];
    wire [6:0]  imm_11_5    = IR[31:25];
    wire        imm_11_B    = IR[7];
    wire [3:0]  imm_4_1     = IR[11:8];
    wire [5:0]  imm_10_5    = IR[30:25];
    wire        imm_12      = IR[31];
    wire [7:0]  imm_19_12   = IR[19:12];
    wire        imm_11_J    = IR[20];
    wire [9:0]  imm_10_1    = IR[30:21];
    wire        imm_20      = IR[31];

    
    wire signed [31:0] imm_I  = { {32{imm_11_0[11]}}, imm_11_0 };                     // I tipi için anlık değer genişletme.
    wire signed [31:0] imm_U  = { {32{imm_31_12[19]}}, imm_31_12, 12'h000 };          // U tipi için anlık değer genişletme.
    wire signed [31:0] imm_B  = { {32{imm_12}}, imm_11_B, imm_10_5, imm_4_1, 1'b0 };  // B tipi için anlık değer genişletme.
    wire signed [31:0] imm_S  = { {32{imm_11_5[6]}}, imm_11_5, imm_4_0 };             // S tipi için anlık değer genişletme.
    wire signed [31:0] imm_J =  { {32{imm_20}}, imm_19_12, imm_11_J, imm_10_1, 1'b0 };// J tipi için anlık değer genişletme.

    initial begin
        Imm <= 0;
    end
    
    always @(*) begin
        case (select_i)// Seçilen duruma göre istenilen buyruk dışarı çıkartılır.
            3'b001: Imm = imm_I;
            3'b010: Imm = imm_U;
            3'b011: Imm = imm_S;
            3'b100: Imm = imm_B;
            3'b101: Imm = imm_J;
        endcase
    end
    
endmodule