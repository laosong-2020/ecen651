`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2019 08:10:42 AM
// Design Name: 
// Module Name: ALUControl
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
//function definition
`define AND		4'b0000
`define OR		4'b0001
`define ADD 	4'b0010
`define SLL 	4'b0011
`define SRL 	4'b0100
`define MULA	4'b0101
`define SUB 	4'b0110
`define SLT 	4'b0111
`define ADDU	4'b1000
`define SUBU	4'b1001
`define XOR		4'b1010
`define SLTU	4'b1011
`define NOR		4'b1100
`define SRA		4'b1101
`define LUI		4'b1110

`define SLLFunc  6'b000000
`define SRLFunc  6'b000010
`define SRAFunc  6'b000011
`define ADDFunc  6'b100000
`define ADDUFunc 6'b100001
`define SUBFunc  6'b100010
`define SUBUFunc 6'b100011
`define ANDFunc  6'b100100
`define ORFunc   6'b100101
`define XORFunc  6'b100110
`define NORFunc  6'b100111
`define SLTFunc  6'b101010
`define SLTUFunc 6'b101011
`define MULAFunc 6'b111000

module ALUControl(ALUCtrl, ALUop, FuncCode); // module initialization
input [3:0]ALUop; //inputs 
input [5:0]FuncCode;
output[3:0] ALUCtrl;//output
reg [3:0]ALUCtrl;
always@(FuncCode or ALUop)
begin
if(ALUop==4'b1111) //only when ALUop is 1111, the ALUCtrl is as per the FuncCode
begin
case(FuncCode)
`SLLFunc: ALUCtrl= `SLL;
`SRLFunc: ALUCtrl= `SRL;
`SRAFunc:ALUCtrl= `SRA;
`ADDFunc:ALUCtrl= `ADD;
`ADDUFunc:ALUCtrl= `ADDU;
`SUBFunc:ALUCtrl= `SUB;
`SUBUFunc:ALUCtrl= `SUBU;
`ANDFunc:ALUCtrl= `AND;
`ORFunc:ALUCtrl= `OR;
`XORFunc:ALUCtrl= `XOR;
`NORFunc:ALUCtrl= `NOR;
`SLTFunc:ALUCtrl= `SLT;
`SLTUFunc:ALUCtrl= `SLTU;
`MULAFunc:ALUCtrl= `MULA;
default: ALUCtrl=4'b0000;
endcase
end
else
ALUCtrl<=ALUop; //else ALUCtrl is same as the ALUop
end
endmodule
