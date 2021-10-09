`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/19 09:47:50
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
    input [31:0] WriteData,
    input [31:0] Address,
    input MemRead,
    input MemWrite,
    input clk,

    output reg [31:0] ReadData

    );

    reg [31:0] memFile[0:1023];

    always @ (MemRead or Address)
    begin
        if(MemRead)
        begin
            if(Address <= 1023)
                ReadData = memFile[Address];
            else
                ReadData = 0;

        end 
        else
            ReadData = 0;

    end

    always @ (negedge clk)
    begin
        if (MemWrite && Address <= 1023)
            memFile[Address] = WriteData;

    end

endmodule
