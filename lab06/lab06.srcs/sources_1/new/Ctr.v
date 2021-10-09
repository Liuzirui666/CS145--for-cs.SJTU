`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 20:24:19
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
    input [5 : 0] OpCode,
    input [5 : 0] funct,
    input nop,
    output reg RegDst,
    output reg AluSrc,
    output reg RegWrite,
    output reg MemToReg,
    output reg MemRead,
    output reg MemWrite,
    output reg BeqSign,
    output reg BneSign,
    output reg LuiSign,
    output reg ExtSign,
    output reg JalSign,
    output reg JrSign,
    output reg [3 : 0] AluOp,
    output reg jump
    );
    
    always @(OpCode or funct or nop)
    begin
        if (nop) begin
            RegDst = 0;
            AluSrc = 0;
            RegWrite = 0;
            MemToReg = 0;
            MemRead = 0;
            MemWrite = 0;
            BeqSign = 0;
            BneSign = 0;
            LuiSign = 0;
            ExtSign = 0;
            JalSign = 0;
            JrSign = 0;
            AluOp = 4'b1111;
            jump = 0;
        end else begin
            case(OpCode)
                6'b000000:      // R Type
                begin
                    if (funct == 6'b001000) begin    // jr
                        RegDst = 0;
                        RegWrite = 0;
                        JrSign = 1;
                        AluOp = 4'b1111;
                    end else begin
                        RegDst = 1;
                        RegWrite = 1;
                        JrSign = 0;
                        AluOp = 4'b1101;
                    end
                    AluSrc = 0;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 0;
                    JalSign = 0;
                    jump = 0;
                end
                6'b001000:      // addi
                begin
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 1;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 1;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b0000;
                    jump = 0;
                end
                6'b001001:      // addiu
                begin                
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 1;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 0;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b0001;
                    jump = 0;
                end
                6'b001100:      // andi
                begin                
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 1;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 0;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b0100;
                    jump = 0;
                end
                6'b001101:      // ori
                begin                
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 1;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 0;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b0101;
                    jump = 0;
                end
                6'b001110:      // xori
                begin                
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 1;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 0;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b0110;
                    jump = 0;
                end
                6'b001111:      // lui
                begin                
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 1;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 1;
                    ExtSign = 0;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b1010;
                    jump = 0;
                end
                6'b100011:      // lw
                begin                
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 1;
                    MemToReg = 1;
                    MemRead = 1;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 1;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b0001;
                    jump = 0;
                end
                6'b101011:      // sw
                begin                
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 0;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 1;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 1;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b0001;
                    jump = 0;
                end
                6'b000100:      // beq
                begin                
                    RegDst = 0;
                    AluSrc = 0;
                    RegWrite = 0;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 1;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 1;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b0011;
                    jump = 0;
                end
                6'b000101:      // bne
                begin                
                    RegDst = 0;
                    AluSrc = 0;
                    RegWrite = 0;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 1;
                    LuiSign = 0;
                    ExtSign = 1;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b0011;
                    jump = 0;
                end
                6'b001010:      // slti
                begin                
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 1;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 1;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b1000;
                    jump = 0;
                end
                6'b001011:      // sltiu
                begin                
                    RegDst = 0;
                    AluSrc = 1;
                    RegWrite = 1;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 0;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b1001;
                    jump = 0;
                end
                6'b000010:      // jump
                begin                
                    RegDst = 0;
                    AluSrc = 0;
                    RegWrite = 0;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 0;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b1111;
                    jump = 1;
                end
                6'b000011:      // jal
                begin                
                    RegDst = 0;
                    AluSrc = 0;
                    RegWrite = 0;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 0;
                    JalSign = 1;
                    JrSign = 0;
                    AluOp = 4'b1111;
                    jump = 1;
                end
                default:
                begin                
                    RegDst = 0;
                    AluSrc = 0;
                    RegWrite = 0;
                    MemToReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    BeqSign = 0;
                    BneSign = 0;
                    LuiSign = 0;
                    ExtSign = 0;
                    JalSign = 0;
                    JrSign = 0;
                    AluOp = 4'b1111;
                    jump = 0;
                end
            endcase
        end
    end
endmodule
