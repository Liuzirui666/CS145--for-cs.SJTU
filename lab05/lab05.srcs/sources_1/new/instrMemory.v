`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 22:12:23
// Design Name: 
// Module Name: instrMemory
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


module instrMemory(
    input [31:0] ReadAddress,
    output reg [31:0] inst
    );
    reg [31:0] InstFile[31:0];
    always @ (ReadAddress)
    begin
        inst=InstFile[ReadAddress>>2];
    end
endmodule
