`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 00:17:13
// Design Name: 
// Module Name: ALU_tb
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


module ALU_tb(
    );
    
    wire [31 : 0] ALURes;
    reg [31 : 0] input1;
    reg [31 : 0] input2;
    reg [3 : 0] ALUCtrOut;
    wire Zero;
    
    ALU u0(.input1(input1), .input2(input2),
           .aluCtrOut(ALUCtrOut), .zero(Zero),
           .aluRes(ALURes));
    
    initial begin
        // Initialize Inputs
        input1 = 0;
        input2 = 0;
        ALUCtrOut = 0;
        
        #100;
        
        input1 = 15;
        input2 = 10;
        ALUCtrOut = 4'b0000;
        #100;
        
        input1 = 15;
        input2 = 10;
        ALUCtrOut = 4'b0001;
        #100;
        
        input1 = 15;
        input2 = 10;
        ALUCtrOut = 4'b0010;
        #100;
        
        input1 = 15;
        input2 = 10;
        ALUCtrOut = 4'b0110;
        #100;
        
        input1 = 10;
        input2 = 15;
        ALUCtrOut = 4'b0110;
        #100;
        
        input1 = 15;
        input2 = 10;
        ALUCtrOut = 4'b0111;
        #100;
        
        input1 = 10;
        input2 = 15;
        ALUCtrOut = 4'b0111;
        #100;
        
        input1 = 1;
        input2 = 1;
        ALUCtrOut = 4'b1100;
        #100;
        
        input1 = 16;
        input2 = 1;
        ALUCtrOut = 4'b1100;
        #100;
    end
endmodule

