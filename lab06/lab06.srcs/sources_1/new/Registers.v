`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 20:27:25
// Design Name: 
// Module Name: Registers
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


module Registers(
    input clk,
    input reset,
    input RegWrite,
    input JalSign,
    input [4 : 0] ReadReg1,
    input [4 : 0] ReadReg2,
    input [4 : 0] WriteReg,
    input [31 : 0] WriteData,
    input [31 : 0] JalData,
    output [31 : 0] ReadData1,
    output [31 : 0] ReadData2
    );
    
    reg [31 : 0] RegFile [31 : 0];
    integer i;
    
    assign ReadData1 = RegFile[ReadReg1];
    assign ReadData2 = RegFile[ReadReg2];
    
    always @ (ReadReg1 or ReadReg2)
    begin
       $display("Register Reading Activated :\n    Reg[%d] = %d\n    Reg[%d] = %d\n", ReadReg1, ReadData1, ReadReg2, ReadData2);        
    end
    
    always @ (negedge clk)
    begin
        if (RegWrite) begin
            RegFile[WriteReg] = WriteData;
            $display("Register Writing Activated :\n    Reg[%d] = %d\n", WriteReg, WriteData);
        end
        if (JalSign) begin
            RegFile[31] = JalData;
            $display("Register Writing Activated :\n    Reg[%d] = %d\n", 31, JalData);
        end
    end
    
    always @ (reset)
    begin
        for (i = 0; i <= 31; i = i + 1)
            RegFile[i] = 0;
    end
endmodule
