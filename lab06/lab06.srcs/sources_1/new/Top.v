`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 20:28:21
// Design Name: 
// Module Name: Top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top(
    input clk,
    input reset
    );
    
    // Instruction Fetch Stage
    reg [31 : 0] IF_PC;
    wire [31 : 0] IF_INST;
     
    InstMemory inst_memory(.address(IF_PC), .inst(IF_INST));
    
    // Segment Registers (IF - ID)
    reg [31 : 0] IF2ID_INST;
    reg [31 : 0] IF2ID_PC;
    
    // Instruction Decode Stage
    wire [12 : 0] ID_CTR_SIGNALS;
    wire [3 : 0] ID_CTR_SIGNAL_ALUOP;
    Ctr main_controller(.OpCode(IF2ID_INST[31 : 26]), .funct(IF2ID_INST[5 : 0]), .nop(IF2ID_INST == 0),
                        .jump(ID_CTR_SIGNALS[12]), .JrSign(ID_CTR_SIGNALS[11]), .ExtSign(ID_CTR_SIGNALS[10]),
                        .RegDst(ID_CTR_SIGNALS[9]), .JalSign(ID_CTR_SIGNALS[8]), .AluOp(ID_CTR_SIGNAL_ALUOP), 
                        .AluSrc(ID_CTR_SIGNALS[7]), .LuiSign(ID_CTR_SIGNALS[6]), .BeqSign(ID_CTR_SIGNALS[5]), 
                        .BneSign(ID_CTR_SIGNALS[4]), .MemWrite(ID_CTR_SIGNALS[3]), .MemRead(ID_CTR_SIGNALS[2]),
                        .MemToReg(ID_CTR_SIGNALS[1]), .RegWrite(ID_CTR_SIGNALS[0]));
    
    wire [31 : 0] ID_REG_READ_DATA_1;
    wire [31 : 0] ID_REG_READ_DATA_2;
    wire [4 : 0] WB_WRITE_REG;
    wire [31 : 0] WB_REG_WRITE_DATA;
    wire WB_CTR_SIGNAL_REG_WRITE;
    Registers registers(.ReadReg1(IF2ID_INST[25 : 21]), .ReadReg2(IF2ID_INST[20 : 16]),
                        .WriteReg(WB_WRITE_REG), .WriteData(WB_REG_WRITE_DATA), 
                        .RegWrite(WB_CTR_SIGNAL_REG_WRITE), .clk(clk), .reset(reset),
                        .JalSign(ID_CTR_SIGNALS[8]), .JalData(IF2ID_PC + 4),
                        .ReadData1(ID_REG_READ_DATA_1), .ReadData2(ID_REG_READ_DATA_2));
    
    wire [31 : 0] ID_EXT_RES;
    SignExt signext(.ExtSign(ID_CTR_SIGNALS[10]), .inst(IF2ID_INST[15 : 0]), .data(ID_EXT_RES));
    
    wire [4 : 0] ID_REG_DEST;
    Mux5 rt_rd_selector(.SelectSignal(ID_CTR_SIGNALS[9]), 
                        .input1(IF2ID_INST[15 : 11]),
                        .input2(IF2ID_INST[20 : 16]),
                        .out(ID_REG_DEST));
    
    // Segment Registers (ID - EX)
    reg [3 : 0] ID2EX_CTR_SIGNAL_ALUOP;
    reg [7 : 0] ID2EX_CTR_SIGNALS;
    reg [31 : 0] ID2EX_EXT_RES;
    reg [4 : 0] ID2EX_INST_RS;
    reg [4 : 0] ID2EX_INST_RT;
    reg [31 : 0] ID2EX_REG_READ_DATA_1;
    reg [31 : 0] ID2EX_REG_READ_DATA_2;
    reg [5 : 0] ID2EX_INST_FUNCT;
    reg [4 : 0] ID2EX_INST_SHAMT;
    reg [4 : 0] ID2EX_REG_DEST;
    reg [31 : 0] ID2EX_PC;
    
    // Execution stage
    wire [3 : 0] EX_ALU_CTR_OUT;
    wire EX_SHAMT_SIGNAL;
    ALUCtr alu_controller(.AluOp(ID2EX_CTR_SIGNAL_ALUOP), .funct(ID2EX_INST_FUNCT),
                          .AluCtrOut(EX_ALU_CTR_OUT), .ShamtSign(EX_SHAMT_SIGNAL));
    
    //  DEFINITION: FORWARDING // 
    wire [31 : 0] EX_ALU_INPUT_A_AFTER_FORWARDING;
    wire [31 : 0] EX_ALU_INPUT_B_AFTER_FORWARDING;
    //  FORWARDING DEFINITIONS END //
    
    wire [31 : 0] EX_ALU_INPUT_B;
    Mux rt_ext_selector(.SelectSignal(ID2EX_CTR_SIGNALS[7]),
                        .input1(ID2EX_EXT_RES),
                        .input2(EX_ALU_INPUT_B_AFTER_FORWARDING),
                        .out(EX_ALU_INPUT_B));
    
    wire [31 : 0] EX_ALU_INPUT_A;
    wire [31 : 0] EX_ALU_INPUT_A_TEMP;             
    Mux rs_shamt_selector(.SelectSignal(EX_SHAMT_SIGNAL),
                          .input1({27'b00000000000000000000000000, ID2EX_INST_SHAMT}),
                          .input2(EX_ALU_INPUT_A_AFTER_FORWARDING),
                          .out(EX_ALU_INPUT_A_TEMP));
    
    Mux lui_selector(.SelectSignal(ID2EX_CTR_SIGNALS[6]),
                     .input1(32'h00000010),
                     .input2(EX_ALU_INPUT_A_TEMP),
                     .out(EX_ALU_INPUT_A));          
     
    wire EX_ALU_ZERO;
    wire EX_ALU_OVERFLOW;          //ignore ALU_OVERFLOW temporarily.
    wire [31 : 0] EX_ALU_RES;
    ALU alu(.inputA(EX_ALU_INPUT_A), .inputB(EX_ALU_INPUT_B), 
            .AluCtrOut(EX_ALU_CTR_OUT), .zero(EX_ALU_ZERO), 
            .overflow(EX_ALU_OVERFLOW), .AluRes(EX_ALU_RES));
    
    wire [31 : 0] BRANCH_DEST = ID2EX_PC + 4 + (ID2EX_EXT_RES << 2);
    
    // Segment Registers (EX - MA)
    reg [3 : 0] EX2MA_CTR_SIGNALS;
    reg [31 : 0] EX2MA_ALU_RES;
    reg [31 : 0] EX2MA_REG_READ_DATA_2;
    reg [4 : 0] EX2MA_REG_DEST;
    
    // Memory Access stage
    wire [31 : 0] MA_MEM_READ_DATA;
    DataMemory data_memory(.clk(clk), .address(EX2MA_ALU_RES), .WriteData(EX2MA_REG_READ_DATA_2),
                           .MemWrite(EX2MA_CTR_SIGNALS[3]), .MemRead(EX2MA_CTR_SIGNALS[2]),
                           .ReadData(MA_MEM_READ_DATA));
    
    wire [31 : 0] MA_FINAL_DATA;
    Mux reg_mem_selector(.SelectSignal(EX2MA_CTR_SIGNALS[1]),
                         .input1(MA_MEM_READ_DATA),
                         .input2(EX2MA_ALU_RES),
                         .out(MA_FINAL_DATA));
    
    // Segment Registers (MA-WB)
    reg MA2WB_CTR_SIGNALS;
    reg [31 : 0] MA2WB_FINAL_DATA;
    reg [4 : 0] MA2WB_REG_DEST;
    
    // Write Back stage
    assign WB_WRITE_REG = MA2WB_REG_DEST;
    assign WB_REG_WRITE_DATA = MA2WB_FINAL_DATA;
    assign WB_CTR_SIGNAL_REG_WRITE = MA2WB_CTR_SIGNALS;
    
    
    // PC updates
    //   [12] jump ;     [11] jr      [5] beq     [4] bne 
    //   jump  jr processed in ID
    wire [31 : 0] PC_JUMP_END;
    Mux jump_selector(.SelectSignal(ID_CTR_SIGNALS[12]), 
                      .input1(((IF2ID_PC + 4) & 32'hf0000000) + (IF2ID_INST [25 : 0] << 2)), 
                      .input2(IF_PC + 4),
                      .out(PC_JUMP_END));
    
    wire [31 : 0] PC_JR_END;
    Mux jr_selector(.SelectSignal(ID_CTR_SIGNALS[11]),
                    .input1(ID_REG_READ_DATA_1),
                    .input2(PC_JUMP_END),
                    .out(PC_JR_END));
    
    wire BEQ_BRANCH = ID2EX_CTR_SIGNALS[5] & EX_ALU_ZERO;
    wire [31 : 0] PC_BEQ_END;
    Mux beq_selector(.SelectSignal(BEQ_BRANCH),
                     .input1(BRANCH_DEST),
                     .input2(PC_JR_END),
                     .out(PC_BEQ_END));
    
    wire BNE_BRANCH = ID2EX_CTR_SIGNALS[4] & (~ EX_ALU_ZERO);
    wire [31 : 0] PC_BNE_END;
    Mux bne_selector(.SelectSignal(BNE_BRANCH),
                     .input1(BRANCH_DEST),
                     .input2(PC_BEQ_END),
                     .out(PC_BNE_END));
    
    // predict-not-taken
    wire BRANCH = BEQ_BRANCH | BNE_BRANCH;   //  [5] beq     [4] bne 
    
    
    
    // forwarding   存储器 & ALU运算结果  -> 下一条指令EX阶段  rs  rt
    //  MA2WB_CTR_SIGNALS     EX2MA_CTR_SIGNALS[0]     :      RegWrite
    wire [31 : 0] EX_ALU_INPUT_A_FORWARDING_TEMP;
    wire [31 : 0] EX_ALU_INPUT_B_FORWARDING_TEMP;
    Mux forward_A_selector1(.SelectSignal(MA2WB_CTR_SIGNALS & (MA2WB_REG_DEST == ID2EX_INST_RS)),
                            .input1(MA2WB_FINAL_DATA),
                            .input2(ID2EX_REG_READ_DATA_1),
                            .out(EX_ALU_INPUT_A_FORWARDING_TEMP));
    Mux forward_A_selector2(.SelectSignal(EX2MA_CTR_SIGNALS[0] & (EX2MA_REG_DEST == ID2EX_INST_RS)),
                            .input1(EX2MA_ALU_RES),
                            .input2(EX_ALU_INPUT_A_FORWARDING_TEMP),
                            .out(EX_ALU_INPUT_A_AFTER_FORWARDING));
    
    Mux forward_B_selector1(.SelectSignal(MA2WB_CTR_SIGNALS & (MA2WB_REG_DEST == ID2EX_INST_RT)),
                            .input1(MA2WB_FINAL_DATA),
                            .input2(ID2EX_REG_READ_DATA_2),
                            .out(EX_ALU_INPUT_B_FORWARDING_TEMP));
    Mux forward_B_selector2(.SelectSignal(EX2MA_CTR_SIGNALS[0] & (EX2MA_REG_DEST == ID2EX_INST_RT)),
                            .input1(EX2MA_ALU_RES),
                            .input2(EX_ALU_INPUT_B_FORWARDING_TEMP),
                            .out(EX_ALU_INPUT_B_AFTER_FORWARDING));
                  
                         
    // stall   访存-使用
    wire STALL = ID2EX_CTR_SIGNALS[2] & 
                 ((ID2EX_INST_RT == IF2ID_INST [25 : 21]) | (ID2EX_INST_RT == IF2ID_INST [20 : 16]));
    //   ID2EX_CTR_SIGNALS[2]  : MemRead 
    //   [25:21]  rs ; [20:16]  rt ;
    //
    
    initial IF_PC = 0;
    
    always @(reset)
    begin
        if (reset) begin
            IF_PC = 0;
            IF2ID_INST = 0;
            IF2ID_PC = 0;
            ID2EX_CTR_SIGNAL_ALUOP = 0;
            ID2EX_CTR_SIGNALS = 0;
            ID2EX_EXT_RES = 0;
            ID2EX_INST_RS = 0;
            ID2EX_INST_RT = 0;
            ID2EX_REG_READ_DATA_1 = 0;
            ID2EX_REG_READ_DATA_2 = 0;
            ID2EX_INST_FUNCT = 0;
            ID2EX_INST_SHAMT = 0;
            ID2EX_REG_DEST = 0;
            EX2MA_CTR_SIGNALS = 0;
            EX2MA_ALU_RES = 0;
            EX2MA_REG_READ_DATA_2 = 0;
            EX2MA_REG_DEST = 0;
            MA2WB_CTR_SIGNALS = 0;
            MA2WB_FINAL_DATA = 0;
            MA2WB_REG_DEST = 0;
        end
    end
    
    always @(posedge clk) 
    begin
           
        // MA - WB
        MA2WB_CTR_SIGNALS <= EX2MA_CTR_SIGNALS [0];  // RegWrite
        MA2WB_FINAL_DATA <= MA_FINAL_DATA;
        MA2WB_REG_DEST <= EX2MA_REG_DEST;
                
        // EX - MA
        EX2MA_CTR_SIGNALS <= ID2EX_CTR_SIGNALS [3 : 0];
        EX2MA_ALU_RES <= EX_ALU_RES;
        EX2MA_REG_READ_DATA_2 <= EX_ALU_INPUT_B_AFTER_FORWARDING;
        EX2MA_REG_DEST <= ID2EX_REG_DEST;
             
        // ID - EX    访存-使用 或者 预测错误
        if (STALL || BRANCH) begin
            // clean up
            ID2EX_PC <= IF2ID_PC;
            ID2EX_CTR_SIGNAL_ALUOP <= 4'hf;
            ID2EX_CTR_SIGNALS <= 0;
            ID2EX_EXT_RES <= 0;
            ID2EX_INST_RS <= 0;
            ID2EX_INST_RT <= 0;
            ID2EX_REG_READ_DATA_1 <= 0;
            ID2EX_REG_READ_DATA_2 <= 0;
            ID2EX_INST_FUNCT <= 0;
            ID2EX_INST_SHAMT <= 0;
            ID2EX_REG_DEST <= 0;
        end else begin
            ID2EX_PC <= IF2ID_PC;
            ID2EX_CTR_SIGNAL_ALUOP <= ID_CTR_SIGNAL_ALUOP;
            ID2EX_CTR_SIGNALS <= ID_CTR_SIGNALS [7 : 0];
            ID2EX_EXT_RES <= ID_EXT_RES;
            ID2EX_INST_RS <= IF2ID_INST [25 : 21];
            ID2EX_INST_RT <= IF2ID_INST [20 : 16];
            ID2EX_REG_READ_DATA_1 <= ID_REG_READ_DATA_1;
            ID2EX_REG_READ_DATA_2 <= ID_REG_READ_DATA_2;
            ID2EX_INST_FUNCT <= IF2ID_INST [5 : 0];
            ID2EX_INST_SHAMT <= IF2ID_INST [10 : 6];
            ID2EX_REG_DEST <= ID_REG_DEST;
        end
              
        // IF - ID
        if (! STALL)
            IF_PC <= PC_BNE_END;
        if (BRANCH || ID_CTR_SIGNALS[12] || ID_CTR_SIGNALS[11]) begin
            IF2ID_INST <= 0;  //  jump[12]   jr[11] 
            IF2ID_PC <= 0;
        end else if (!STALL) begin
            IF2ID_INST <= IF_INST;
            IF2ID_PC <= IF_PC;
        end
        
    end
    
endmodule
