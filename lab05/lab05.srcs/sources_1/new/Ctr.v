`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 22:10:21
// Design Name: 
// Module Name: Ctr
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


module Ctr(
    input [5:0] OpCode,
    output reg RegDest,
    output reg [1:0] AluSrc,
    output reg MemToReg,
    output reg RegWrite,
    output reg MemRead,
    output reg MemWrite,
    output reg Branch,
    output reg [2:0] AluOp,
    output reg Jump,
    output reg JumpTarget,
    output reg Call
    );
    always @(OpCode)
    begin
        case(OpCode)
            6'b000000://add,sub,and,or,slt,jr
            begin
                RegDest=1;
                AluSrc=0;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                Jump=0;
                JumpTarget=0;
                Call=0;
                AluOp=3'b101; 
            end
            6'b000010://jump
            begin
                RegDest=0;
                AluSrc=0;
                MemToReg=0;
                RegWrite=0;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                Jump=1;
                JumpTarget=1;
                Call=0;
                AluOp=3'b110;   
            end
            6'b000011://jal
            begin
                RegDest=0;
                AluSrc=0;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                Jump=1;
                JumpTarget=1;
                Call=1;
                AluOp=3'b110;
            end
            6'b001000://addi
            begin
                RegDest=0;
                AluSrc=1;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                Jump=0;
                JumpTarget=0;
                Call=0;
                AluOp=3'b010;   
            end
            6'b001100://andi
            begin
                RegDest=0;
                AluSrc=1;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                Jump=0;
                JumpTarget=0;
                Call=0;
                AluOp=3'b011; 
            end
            6'b001101://ori
            begin
                RegDest=0;
                AluSrc=1;
                MemToReg=0;
                RegWrite=1;
                MemRead=0;
                MemWrite=0;
                Branch=0;
                Jump=0;
                JumpTarget=0;
                Call=0;
                AluOp=3'b100;   
            end
            6'b100011://lw
            begin
                RegDest=0;
                AluSrc=1;
                MemToReg=1;
                RegWrite=1;
                MemRead=1;
                MemWrite=0;
                Branch=0;
                Jump=0;
                JumpTarget=0;
                Call=0;
                AluOp=3'b000;
            end
            6'b101011://sw
            begin
                AluSrc=1;
                RegWrite=0;
                MemRead=0;
                MemWrite=1;
                Branch=0;
                Jump=0;
                JumpTarget=0;
                Call=0;
                AluOp=3'b000;
            end
            6'b000100://beq
            begin
                AluSrc=0;
                RegWrite=0;
                MemRead=0;
                MemWrite=0;
                Branch=1;
                Jump=0;
                JumpTarget=0;
                Call=0;
                AluOp[0]=3'b001;
            end
            
            
        endcase
    end
endmodule