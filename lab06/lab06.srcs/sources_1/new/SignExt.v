`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 20:28:03
// Design Name: 
// Module Name: SignExt
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


module SignExt(
    input ExtSign,
    input [15 : 0] inst,
    output [31 : 0] data
    );
    assign data = (ExtSign ? { {16 {inst[15]}}, inst[15 : 0] } : { 16'h0000, inst[15 : 0] });
endmodule
