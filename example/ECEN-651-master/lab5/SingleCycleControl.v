`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2019 09:11:31 AM
// Design Name: 
// Module Name: SingleCycleControl
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
`define RTYPEOPCODE 6'b000000
`define LWOPCODE        6'b100011
`define SWOPCODE        6'b101011
`define BEQOPCODE       6'b000100
`define JOPCODE     6'b000010
`define ORIOPCODE       6'b001101
`define ADDIOPCODE  6'b001000
`define ADDIUOPCODE 6'b001001
`define ANDIOPCODE  6'b001100
`define LUIOPCODE       6'b001111
`define SLTIOPCODE  6'b001010
`define SLTIUOPCODE 6'b001011
`define XORIOPCODE  6'b001110
`define SLLFunc 6'b000000
`define SRLFunc 6'b000010
`define SRAFunc 6'b000011

`define AND     4'b0000
`define OR      4'b0001
`define ADD     4'b0010
`define SLL     4'b0011
`define SRL     4'b0100
`define SUB     4'b0110
`define SLT     4'b0111
`define ADDU    4'b1000
`define SUBU    4'b1001
`define XOR     4'b1010
`define SLTU    4'b1011
`define NOR     4'b1100
`define SRA     4'b1101
`define LUI     4'b1110
`define FUNC    4'b1111

//module initialization
module SingleCycleControl(
RegDst,ALUSrc1,ALUSrc2,MemToReg,RegWrite,MemRead,MemWrite,Branch,Jump,SignExtend,ALUOp,Opcode,Func);
input wire [5:0] Opcode; //inputs
   	output reg RegDst; //outputs
   	output reg ALUSrc1;//use shamt
   	output reg ALUSrc2;//use immed
   	output reg MemToReg;
   	output reg RegWrite;
   	output reg MemRead;
   	output reg MemWrite;
   	output reg Branch;
   	output reg Jump;
   	output reg SignExtend;
   	output reg[3:0] ALUOp;
   	input wire [5:0] Func;
 always @(Opcode or Func)begin //whenever the opcode changes, the following case is executed
              case(Opcode)
			  //for Rtype instructions
            `RTYPEOPCODE: begin
            
            
            if(Func==`SLLFunc || Func==`SRLFunc || Func==`SRAFunc) 
            begin
                RegDst <= 1'b1;
                ALUSrc1 <=  1'b1;
                ALUSrc2 <=  1'b0;
                                
                MemToReg <= 1'b0;
                RegWrite <=  1'b1;
                MemRead <=  1'b0;
                MemWrite <=  1'b0;
                Branch <=  1'b0;
                
                Jump <=  1'b0;
                SignExtend <=  1'b0;
                ALUOp <=  `FUNC;
            end
            else
            begin
            RegDst <= 1'b1;
            ALUSrc1 <=  1'b0;
                            ALUSrc2 <=  1'b0;
                                            
                            MemToReg <= 1'b0;
                            RegWrite <=  1'b1;
                            MemRead <=  1'b0;
                            MemWrite <=  1'b0;
                            Branch <=  1'b0;
                            
                            Jump <=  1'b0;
                            SignExtend <=  1'b0;
                            ALUOp <=  `FUNC;
                            end
                            end
            //for Load word instructions
            `LWOPCODE: begin
                            RegDst <= 1'b0;
                            ALUSrc1 <= 1'b0;
                            ALUSrc2 <=  1'b1;
                            MemToReg <=  1'b1;
                            RegWrite <= 1'b1;
                            MemRead <=  1'b1;
                            MemWrite <=  1'b0;
                            Branch <=  1'b0;
                            Jump <= 1'b0;
                            ALUOp <= `ADD;
                            
                            SignExtend <= 1'b1;
                            
             end
             //for store word instructions
             `SWOPCODE: begin
                             RegDst <= 1'b0;
                             ALUSrc1 <= 1'b0;
                            ALUSrc2 <=  1'b1;
                             MemToReg <= 1'b1;
                             RegWrite <= 1'b0;
                             MemRead <= 1'b0;
                             MemWrite <= 1'b1;
                             Branch <= 1'b0; 
                             Jump <=  1'b0;
                             ALUOp <=  `ADD;
                             SignExtend <=  1'b1;
                            
               end
            //for branch if equal instructions
             `BEQOPCODE: begin
                               RegDst <=  1'b0;
                               ALUSrc1 <=  1'b0;
                               ALUSrc2 <=  1'b0;
                               MemToReg <=  1'b0;
                               RegWrite <=  1'b0;
                               MemRead <=  1'b0;
                               MemWrite <=  1'b0;
                               Branch <=  1'b1;  
                               Jump <=  1'b0;
                               ALUOp <=  `SUB;
                               SignExtend <=  1'b1; 
                               
                 end    
              //for jump instructions
             `JOPCODE: begin
                                   RegDst <=  1'b0;
                                   ALUSrc1 <=  1'b0;
                                   ALUSrc2 <=  1'b0;
                                   MemToReg <=  1'b0;
                                   RegWrite <=  1'b0;
                                   MemRead <=  1'b0;
                                   MemWrite <=  1'b0;
                                   Branch <=  1'b0;
                                   Jump <=  1'b1;
                                   SignExtend <=  1'b1;
                                   ALUOp <=  `AND;
                     end 
             //for logical OR instructions
             `ORIOPCODE: begin
                                   RegDst <=  1'b0;
                                   ALUSrc1 <=  1'b0;
                                   ALUSrc2 <=  1'b1;
                                   MemToReg <=  1'b0;
                                   RegWrite <=  1'b1;
                                   MemRead <=  1'b0;
                                   MemWrite <=  1'b0;
                                   Branch <=  1'b0;
                                   Jump <=  1'b0;
                                   SignExtend <=  1'b0;
                                   ALUOp <= `OR;
                         end
              //for addition
             `ADDIOPCODE: begin
                                   RegDst <=  1'b0;
                                   ALUSrc1 <=  1'b0;
                                   ALUSrc2 <=  1'b1;
                                   MemToReg <=  1'b0;
                                   RegWrite <=  1'b1;
                                   MemRead <=  1'b0;
                                   MemWrite <=  1'b0;
                                   Branch <=  1'b0;
                                   Jump <=  1'b0;
                                   SignExtend <=  1'b1;
                                   ALUOp <=  `ADD;
                         end             
             //for addition without overflow         
             `ADDIUOPCODE: begin
                                   RegDst <=  1'b0;
                                   ALUSrc1 <=  1'b0;
                                   ALUSrc2 <=  1'b1;
                                   MemToReg <=  1'b0;
                                   RegWrite <=  1'b1;
                                   MemRead <=  1'b0;
                                   MemWrite <=  1'b0;
                                   Branch <=  1'b0;
                                   Jump <=  1'b0;
                                   SignExtend <=  1'b0; //changed later
                                   ALUOp <= `ADDU;
                           end   
              //for logical AND
             `ANDIOPCODE: begin
                                     RegDst <=  1'b0;
                                     ALUSrc1 <=  1'b0;
                                     ALUSrc2 <=  1'b1;
                                     MemToReg <=  1'b0;
                                     RegWrite <=  1'b1;
                                     MemRead <=  1'b0;
                                     MemWrite <=  1'b0;
                                     Branch <=  1'b0;
                                     Jump <=  1'b0;
                                     SignExtend <=  1'b0;
                                     ALUOp <=  `AND;
                             end  
              //for load upper immediate          
             `LUIOPCODE: begin
                                   RegDst <=  1'b0;//changed
                                   ALUSrc1 <=  1'b0;
                                   ALUSrc2 <=  1'b1;
                                   MemToReg <=  1'b0;
                                   RegWrite <=  1'b1;
                                   MemRead <=  1'b0;
                                   MemWrite <=  1'b0;
                                   Branch <=  1'b0;
                                   Jump <=  1'b0;
                                   SignExtend <= 1'b0;//changed
                                   ALUOp <=  `LUI;
                           end  
              //for shift less than			  
             `SLTIOPCODE: begin
                                 RegDst <=  1'b0;
                                 ALUSrc1 <=  1'b0;
                                 ALUSrc2 <=  1'b1;
                                 MemToReg <=  1'b0;
                                 RegWrite <=  1'b1;
                                 MemRead <=  1'b0;
                                 MemWrite <=  1'b0;
                                 Branch <=  1'b0;
                                 Jump <=  1'b0;
                                 SignExtend <= 1'b1;
                                 ALUOp <= `SLT;
                         end  
             `SLTIUOPCODE: begin
                                   RegDst <= 1'b0;
                                   ALUSrc1 <=  1'b0;
                                   ALUSrc2 <=  1'b1;
                                   MemToReg <=  1'b0;
                                   RegWrite <=  1'b1;
                                   MemRead <=  1'b0;
                                   MemWrite <=  1'b0;
                                   Branch <=  1'b0;
                                   Jump <=  1'b0;
                                   SignExtend <=  1'b1;
                                   ALUOp <=  `SLTU;
                           end
			//for logical XOR
             `XORIOPCODE: begin
                                     RegDst <=  1'b0;
                                     ALUSrc1 <=  1'b0;
                                     ALUSrc2 <=  1'b1;
                                     MemToReg <=  1'b0;
                                     RegWrite <=  1'b1;
                                     MemRead <=  1'b0;
                                     MemWrite <=  1'b0;
                                     Branch <=  1'b0;
                                     Jump <=  1'b0;
                                     SignExtend <=  1'b0; 
                                     ALUOp <= `XOR;
                             end                                                                                                                                                                                                                                                                                                                                                                                       
			//default case
            default: begin
                RegDst <=  1'bx;
                ALUSrc1 <=  1'bx;
                ALUSrc2 <=  1'b0;
                MemToReg <=  1'bx;
                RegWrite <=  1'bx;
                MemRead <=  1'bx;
                MemWrite <=  1'bx;
                Branch <=  1'bx;
                Jump <=  1'bx;
                SignExtend <= 1'bx;
                ALUOp <=  4'bxxxx;
            end
        endcase
    end
endmodule