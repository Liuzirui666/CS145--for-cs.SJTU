`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 22:14:30
// Design Name: 
// Module Name: lab5_tb
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


module top_tb();
    reg clk;
    reg reset;
    
    always #20 clk=~clk;
    
    Top top(.clk(clk),.reset(reset));

    initial begin
        $readmemh("E:/Archlabs/lab05/inst_data2.txt",top.instruction_memory.InstFile);
        
        $readmemh("E:/Archlabs/lab05/mem_data2.txt",top.data_memory.MemFile);
        
        clk=0;
        reset=1;
        #40
        reset=0;
        #1000;
    end
endmodule


