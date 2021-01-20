`timescale 1ns / 1ps

`define AND  4'b0000
`define OR   4'b0001
`define ADD  4'b0010
`define SLL  4'b0011
`define SRL  4'b0100
`define SUB  4'b0110
`define SLT  4'b0111
`define ADDU 4'b1000
`define SUBU 4'b1001
`define XOR  4'b1010
`define SLTU 4'b1011
`define NOR  4'b1100
`define SRA  4'b1101
`define LUI  4'b1110

module ALU(BusW, Zero, BusA, BusB, ALUCtrl);
input [31:0] BusA, BusB;
input [3:0] ALUCtrl;
output reg[31:0] BusW;
output Zero;

always @(*)
 begin
   case (ALUCtrl)
      `AND   : BusW <= BusA & BusB; //A AND B
      `OR    : BusW <= BusA | BusB; //A OR B
      `ADD   : BusW <= BusA + BusB; //A + B
      `SLL   : BusW <= BusB << BusA; // Left shift B with A bits
      `SRL   : BusW <= BusB >> BusA; // Right shift B with A bits
      `SUB   : BusW <= BusA - BusB; //A-B
      `SLT   : BusW <= (($signed(BusA) < $signed(BusB)) ? 32'd1 : 32'd0); //If A<B ,set W as 1, else set W as 0 (A,B are signed numbers)
      `ADDU  : BusW <= BusA + BusB; //A + B(same as signed)
      `SUBU  : BusW <= BusA - BusB; //A - B(same as signed)
      `XOR   : BusW <= BusA ^ BusB; //A XOR B
      `SLTU  : BusW <= ((BusA < BusB) ? 32'd1 : 32'd0); //If A<B ,set W as 1, else set W as 0 (A,B are unsigned numbers)
      `NOR   : BusW <= ~(BusA | BusB); //A NOR B
      `SRA   : BusW <= $signed(BusB) >>> $signed(BusA); // Arithmic Right shift B with A bits
      `LUI   : BusW <= BusB << 16; //Load unsigned immeidate
      default: BusW <= 32'bx; //Default setting for no latches and flip-flops
    endcase
 end
 
 assign Zero = ((BusW == 32'd0) ? 1'b1 : 1'b0); // If ALUresult BusW equals to '0', the output 'zero' sets to '1'.

endmodule
