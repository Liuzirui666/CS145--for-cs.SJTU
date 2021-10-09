`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 22:13:02
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
    input [25:21] ReadReg1,
    input [20:16] ReadReg2,
    input [4:0] WriteReg,
    input [31:0] WriteData,
    input RegWrite,
    output reg [31:0] ReadData1,
    output reg [31:0] ReadData2
    );
    reg [31:0] RegFile[0:31];
    integer i;
    always @ (ReadReg1 or ReadReg2)
    begin
        RegFile[0]=0;
        ReadData1=RegFile[ReadReg1];
        ReadData2=RegFile[ReadReg2];
    end
    always @ (negedge clk)
    begin
        if (reset)
	    begin
            for (i = 0; i <= 31; i = i + 1)
                RegFile[i] = 0;

	    end
        if(RegWrite==1) RegFile[WriteReg]=WriteData;
    end
endmodule

