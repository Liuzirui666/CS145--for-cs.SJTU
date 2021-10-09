`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 22:11:11
// Design Name: 
// Module Name: dataMemory
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


module dataMemory(
    input clk,
    input [31:0] address,
    input [31:0] WriteData,
    input MemWrite,
    input MemRead,
    output reg [31:0] ReadData
    );
    reg [31:0] MemFile [0:31];
    always @ (address or MemRead)
    begin
        if(MemRead)
        ReadData=MemFile[address];   
    end
    always @ (negedge clk)
    begin
        if(MemWrite==1) MemFile[address]=WriteData;  
    end
    
endmodule
