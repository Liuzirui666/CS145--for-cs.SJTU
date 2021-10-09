`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/18 00:16:49
// Design Name: 
// Module Name: ALU
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


module ALU(input1,input2,aluCtrOut,zero,aluRes);
    input [31 : 0] input1;
    input [31 : 0] input2;
    input [3 : 0] aluCtrOut;
    output zero;
    output [31 : 0] aluRes;
    reg Zero;
    reg [31 : 0] ALURes;
    
    always @ (input1 or input2 or aluCtrOut)
    begin
        case (aluCtrOut)
            4'b0000:    // and
                ALURes = input1 & input2;
            4'b0001:    // or
                ALURes = input1 | input2;
            4'b0010:    // add
                ALURes = input1 + input2;
            4'b0110:    // sub
                ALURes = input1 - input2;
            4'b0111:    // set on less than
                ALURes = ($signed(input1) < $signed(input2));
            4'b1100:    // nor
                ALURes = ~(input1 | input2);
            default:
                ALURes = 0;
        endcase
        if (ALURes == 0)
            Zero = 1;
        else 
            Zero = 0;
    end
    
    assign zero = Zero;
    assign aluRes = ALURes;
endmodule

