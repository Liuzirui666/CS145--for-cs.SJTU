`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/08 20:23:23
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


module ALU(
    input [31 : 0] inputA,
    input [31 : 0] inputB,
    input [3 : 0] AluCtrOut,
    output reg zero,
    output reg overflow,
    output reg [31 : 0] AluRes
    );
    
    always @ (inputA or inputB or AluCtrOut)
    begin
        case (AluCtrOut)
            4'b0000:        // add with overflow check
            begin
                AluRes = inputA + inputB;
                if ((inputA >> 31) == (inputB >> 31) && (inputA >> 31) != (AluRes >> 31))
                    overflow = 1;
                else
                    overflow = 0;
            end
            4'b0001:        // add simple
                AluRes = inputA + inputB;
            4'b0010:        // sub with overflow check
            begin
                AluRes = inputA - inputB;
            end
            4'b0011:        // sub simple
                AluRes = inputA - inputB;
            4'b0100:        // and
                AluRes = inputA & inputB;
            4'b0101:        // or
                AluRes = inputA | inputB;
            4'b0110:        // xor
                AluRes = inputA ^ inputB;
            4'b0111:        // nor
                AluRes = ~(inputA | inputB);
            4'b1000:        // slt (signed)
                AluRes = ($signed(inputA) < $signed(inputB));
            4'b1001:        // slt (unsigned)
                AluRes = (inputA < inputB);
            4'b1010:        // left-shift (logical)
                AluRes = (inputB << inputA);
            4'b1011:        // right-shift (logical)
                AluRes = (inputB >> inputA);
            4'b1100:        // right-shift (arithmetic)
                AluRes = ($signed(inputB) >>> inputA);
            default:        // default
                AluRes = 0;
        endcase
        if (AluRes == 0)
            zero = 1;
        else 
            zero = 0;
    end
endmodule
