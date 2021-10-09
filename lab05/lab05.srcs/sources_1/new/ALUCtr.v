`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 21:55:29
// Design Name: 
// Module Name: ALUCtr
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


module ALUCtr(
    input [2:0] AluOp,
    input [5:0] FunctField,
    output reg [3:0] Operation,
    output reg ShamtSign, //
    output reg Jump
    );
    
    always @ (AluOp or FunctField)
    begin
        casex ({AluOp, FunctField})
            9'b000xxxxxx:  // lw or sw
                Operation = 4'b0010;
            9'b001xxxxxx:  // beq
                Operation = 4'b0110;
            9'b010xxxxxx:  // addi
                Operation = 4'b0010;
            9'b011xxxxxx:  // andi
                Operation = 4'b0000;
            9'b100xxxxxx:  // ori
                Operation = 4'b0001;
            9'b101000000:  // sll: left-shift
                Operation = 4'b0011;
            9'b101000010:  // srl: right-shift
                Operation = 4'b0100;
            9'b101001000:  // jr
                Operation = 4'b0101;
            9'b101100000:  // add
                Operation = 4'b0010;
            9'b101100010:  // sub
                Operation = 4'b0110;
            9'b101100100:  // and
                Operation = 4'b0000;
            9'b101100101:  // or
                Operation = 4'b0001;
            9'b101101010:  // slt:  less than
                Operation = 4'b0111;
            9'b110xxxxxx:  // jump / jal
                Operation = 4'b0101;
        endcase        
        
        if ({AluOp, FunctField} == 9'b101000000 || {AluOp, FunctField} == 9'b101000010)
            ShamtSign = 1;
        else 
            ShamtSign = 0;
        
        if ({AluOp, FunctField} == 9'b101001000)
            Jump = 1;
        else 
            Jump = 0;
            
    end

endmodule