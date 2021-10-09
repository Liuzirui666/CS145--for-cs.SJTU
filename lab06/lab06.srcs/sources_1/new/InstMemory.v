`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 20:26:20
// Design Name: 
// Module Name: InstMemory
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


module InstMemory(
    input [31 : 0] address,
    output [31 : 0] inst
    );
    
    reg [31 : 0] InstFile [0 : 1023];
    
    assign inst = (address / 4 <= 1023 ? InstFile[address / 4] : 0);
    
    //if ( address / 4 <= 1023 )
    //    assign inst = InstFile[address / 4];
    //else
    //    assign inst = 0;

endmodule
