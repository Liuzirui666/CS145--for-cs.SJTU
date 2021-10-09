`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 22:13:41
// Design Name: 
// Module Name: top
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


module Top(input clk,input reset);
    reg [31:0] PC;
    wire REG_DST,JUMP,JUMP1,BRANCH,MEM_READ,MEM_TO_REG,MEM_WRITE,JUMPTARGET,CALL;
    wire [2:0] ALU_OP;
    wire ALU_SRC,REG_WRITE;
    
    wire [3:0] ALUCTR;
    
	wire [31:0] INST;//PC and inst memory
	
	wire [4:0] WRITEREG;
	wire [4:0] READREG1;
	wire [4:0] READREG2;
	wire [31:0] REGREADDATA1;
	wire [31:0] REGREADDATA2;
	wire [31:0] REGWRITEDATA;//register file
	
	wire [31:0] INSTSHIFTED;
    wire [31:0] SIGNEXTENDED;
	wire [31:0] EXTENDSHIFTED;
	
	wire [31:0] ALUSRC1;
	wire [31:0] ALUSRC2;
    wire ZERO;
    wire BRANCHOPERAND;
	wire [31:0] ALURSLT;//main ALU
	
	wire [31:0] MEM_DATA;
	wire [31:0] PC_PLUS_4;
	instrMemory instruction_memory(
	    .ReadAddress(PC),
	    .inst(INST)
	);
	
	Ctr ctr(
	    .OpCode(INST[31:26]),
	    .RegDest(REG_DST),
	    .AluSrc(ALU_SRC),
	    .MemToReg(MEM_TO_REG),
	    .RegWrite(REG_WRITE),
	    .MemRead(MEM_READ),
	    .MemWrite(MEM_WRITE),
	    .Branch(BRANCH),
	    .AluOp(ALU_OP),
	    .Jump(JUMP),
	    .Call(CALL),
	    .JumpTarget(JUMPTARGET)
	);
	ALUCtr aluctr(
	    .AluOp(ALU_OP),
	    .FunctField(INST[5:0]),
	    .Operation(ALUCTR),
	    .Jump(JUMP1)
	);
	Registers registers(
	    .clk(clk),
	    .reset(reset),
	    .ReadReg1(INST[25:21]),
	    .ReadReg2(INST[20:16]),
	    .WriteReg(CALL?5'b11111:(REG_DST?INST[15:11]:INST[20:16])),
	    .WriteData(CALL?PC_PLUS_4:(MEM_TO_REG?MEM_DATA:ALURSLT)),// to be improved
	    .RegWrite(REG_WRITE),
	    .ReadData1(REGREADDATA1),
	    .ReadData2(REGREADDATA2)
	);
	
	ALU alu(
	    .input1((ALUCTR==4'b0011||ALUCTR==4'b0100)?INST[10:6]:REGREADDATA1),
	    .input2(ALU_SRC?SIGNEXTENDED:REGREADDATA2),// to be improved
	    .AluCtr(ALUCTR),
	    .zero(ZERO),
	    .AluRes(ALURSLT)
	);
	signext signext(
	    .inst(INST[15:0]),
	    .data(SIGNEXTENDED)
	);
	dataMemory data_memory(
	    .clk(clk),
	    .MemWrite(MEM_WRITE),
	    .MemRead(MEM_READ),
	    .address(ALURSLT),
	    .WriteData(REGREADDATA2),
	    .ReadData(MEM_DATA)
	);
	wire [31:0] NEXTPC;
	assign PC_PLUS_4=PC+4;
	assign NEXTPC=(BRANCH&ZERO)?(PC_PLUS_4+(SIGNEXTENDED<<2)):((JUMP||JUMP1)?(JUMPTARGET?{PC_PLUS_4[31:28],INST[25:0]<<2}:ALURSLT):PC_PLUS_4);
	always @(posedge clk)
	begin
	    if(reset) PC<=0;
	    else PC<=NEXTPC;
	end
	
endmodule