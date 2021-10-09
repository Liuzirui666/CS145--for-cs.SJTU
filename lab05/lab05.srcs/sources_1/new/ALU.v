`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 21:54:36
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] input1,
    input [31:0] input2,
    input [3:0] AluCtr,
    output reg zero,
    output reg [31:0] AluRes
    );
    always @(input1 or input2 or AluCtr)
    begin
        case(AluCtr)
            4'b0000:
                begin
                    AluRes=input1 & input2;
                    if(AluRes==0) zero=1;
                    else zero=0;
                end
            4'b0001:
                begin
                    AluRes=input1 | input2;
                    if(AluRes==0) zero=1;
                    else zero=0;
                end
            4'b0010:
                begin
                    AluRes=input1+input2;
                    if(AluRes==0) zero=1;
                    else zero=0;
                end
            4'b0011:
                begin
                    AluRes=input2<<input1;
                    if(AluRes==0) zero=1;
                    else zero=0;
                end
            4'b0100:
                begin
                    AluRes=input2>>input1;
                    if(AluRes==0) zero=1;
                    else zero=0;
                end
            4'b0110:
                begin
                    AluRes=input1-input2;
                    if(AluRes==0) zero=1;
                    else zero=0;
                end
            4'b0111:
                begin
                    if(input1<input2) AluRes=1;
                    else AluRes=0;
                end
            4'b1100:
                begin
                    AluRes=~(input1|input2);
                    if(AluRes==0) zero=1;
                    else zero=0;
                end
        endcase
    end
endmodule
