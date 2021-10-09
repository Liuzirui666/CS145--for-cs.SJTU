`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 20:24:43
// Design Name: 
// Module Name: DataMemory
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


module DataMemory(
    input clk,
    input MemRead,
    input MemWrite,
    input [31 : 0] address,
    input [31 : 0] WriteData,
    output reg [31 : 0] ReadData
    );
    
    reg [31 : 0] MemFile [0 : 1023];
    
    
    always @ (MemRead or address)
    begin
        // check if the address is valid
        if (MemRead && ! MemWrite)
        begin
            if(address <= 1023)
                ReadData = MemFile[address];
            else
                ReadData = 0;
            $display("Memory Reading Activated :\n    Mem[%d] = %d\n", address, ReadData);
        end
    end
    
    always @ (negedge clk)
    begin
        if (MemWrite && address <= 1023)
        begin
            MemFile[address] = WriteData;
            $display("Memory Writing Activated :\n    Mem[%d] = %d\n", address, WriteData);
       end
    end
endmodule