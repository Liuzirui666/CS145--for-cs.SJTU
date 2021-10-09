`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 20:29:12
// Design Name: 
// Module Name: lab06_tb
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


module lab06_tb(
    );
    reg clk;
    reg reset;
        
    Top processor(.clk(clk), .reset(reset));
    
    initial begin
        $readmemb("E:/Archlabs/lab06/inst_data.txt", processor.inst_memory.InstFile);
        $readmemh("E:/Archlabs/lab06/mem_data.txt", processor.data_memory.MemFile);         
        reset = 1;
        clk = 0;   
    end
    
    always #20 clk = ~clk;
    
    initial begin
        #40 reset = 0;
        #1500;
        $finish;
    end
endmodule
