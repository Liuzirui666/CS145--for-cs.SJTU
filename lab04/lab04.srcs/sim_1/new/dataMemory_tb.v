`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 09:48:32
// Design Name: 
// Module Name: dataMemory_tb
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


module dataMemory_tb(
    );
    
    reg [31 : 0] Address;
    reg [31 : 0] WriteData;
    reg MemWrite;
    reg MemRead;
    reg Clk;
    wire [31 : 0] ReadData;

    dataMemory u0 (
        .Address(Address),
        .WriteData(WriteData),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .clk(Clk),
        .ReadData(ReadData));

    always #100 Clk = ~Clk;

    initial begin
        // Initialize Inputs
        Address = 0;
        WriteData = 0;
        MemWrite = 0;
        MemRead = 0;
        Clk = 0;

        #185;
        MemWrite = 1'b1;
        Address = 32'b00000000000000000000000000000111;
        WriteData = 32'b11100000000000000000000000000000;
        
        #100;
        MemWrite = 1'b1;
        WriteData = 32'hffffffff;
        Address = 32'b00000000000000000000000000000110;
        
        #185;
        MemRead = 1'b1;
        MemWrite = 1'b0;
        Address = 32'b00000000000000000000000000000111;
        
        #80;
        MemWrite = 1;
        Address = 8;
        WriteData = 32'haaaaaaaa;
        
        #80;
        MemWrite = 0;
        MemRead = 1;
        Address = 32'b00000000000000000000000000000110;

    end
 
endmodule
