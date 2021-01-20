`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/08 22:09:01
// Design Name: 
// Module Name: SignExtender
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


module SignExtender(BusImm, Imm16, Ctrl);
    output [31:0] BusImm;
    input [15:0] Imm16;
    input Ctrl;
    
    wire extBit;
    assign extBit = (Ctrl ? 1'b0: Imm16[15]);
    
    assign BusImm = {{16{extBit}}, Imm16};
endmodule
