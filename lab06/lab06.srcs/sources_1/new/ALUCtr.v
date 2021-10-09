`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 20:24:00
// Design Name: 
// Module Name: ALUCtr
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


module ALUCtr(
    input [3 : 0] AluOp,
    input [5 : 0] funct,
    output reg [3 : 0] AluCtrOut,
    output reg ShamtSign
    );
    
    always @ (AluOp or funct)
    begin
        if (AluOp == 4'b1101 || AluOp == 4'b1110) begin
            case (funct)
                6'b100000:      // add
                    AluCtrOut = 4'b0000;
                6'b100001:      // addu
                    AluCtrOut = 4'b0001;
                6'b100010:      // sub
                    AluCtrOut = 4'b0010;
                6'b100011:      // subu
                    AluCtrOut = 4'b0011;
                6'b100100:      // and
                    AluCtrOut = 4'b0100;
                6'b100101:      // or
                    AluCtrOut = 4'b0101;
                6'b100110:      // xor
                    AluCtrOut = 4'b0110;
                6'b100111:      // nor
                    AluCtrOut = 4'b0111;
                6'b101010:      // slt
                    AluCtrOut = 4'b1000;
                6'b101011:      // sltu
                    AluCtrOut = 4'b1001;
                6'b000000:      // sll
                    AluCtrOut = 4'b1010;
                6'b000010:      // srl
                    AluCtrOut = 4'b1011;
                6'b000011:      // sra
                    AluCtrOut = 4'b1100;
                6'b000100:      // sllv
                    AluCtrOut = 4'b1010;
                6'b000110:      // srlv
                    AluCtrOut = 4'b1011;
                6'b000111:      // srav
                    AluCtrOut = 4'b1100;
                6'b001000:      // jr
                    AluCtrOut = 4'b1111;
                default:
                    AluCtrOut = 4'b1111;
            endcase
            
            if (funct == 6'b000000 || funct == 6'b000010 || funct == 6'b000011)
                ShamtSign = 1;
            else
                ShamtSign = 0;
        end else begin
            AluCtrOut = AluOp;
            ShamtSign = 0;
        end
    end
endmodule

