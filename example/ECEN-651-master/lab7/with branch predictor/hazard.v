// 00 - Normal State, 01 - Branch, 11 - Jump
`timescale 1ns / 1ps
module HazardUnit(IF_write, PC_write, bubble, addrSel, Jump, Branch,
ALUZero, memReadEX, currRs, currRt, prevRt, UseShamt, UseImmed , Clk , Rst,
Jr, EX_RegWrite, MEM_RegWrite, EX_Rw, MEM_Rw);
// Input and output ports
output reg IF_write, PC_write, bubble;
output reg [1:0] addrSel;
input Jump , Branch , ALUZero , memReadEX , Clk , Rst, Jr,
EX_RegWrite, MEM_RegWrite ;
input [4:0] EX_Rw, MEM_Rw;
input UseShamt , UseImmed ;
input [4:0] currRs, currRt, prevRt;
wire LdHazard, JrHazard;
reg [1:0] state, Next_State;
// Logic for detecting load hazard
assign LdHazard = (memReadEX == 1) & (prevRt != 0) & (((currRs == prevRt ||
currRt == prevRt) & UseShamt == 0 & UseImmed == 0) || (UseShamt == 1 & currRs
== prevRt) ||(UseImmed == 1 & currRs == prevRt ))?1:0 ;
// Check Jr_hazard
assign JrHazard = ((Jr == 1) && ((EX_Rw == currRs && EX_RegWrite ==
1)||(MEM_Rw == currRs && MEM_RegWrite == 1))) ? 1:0;
always @(*) begin
// Check for hazard
case(state)
2'b00: begin
// Load Hazard
if ((LdHazard == 1) || (JrHazard == 1)) begin
Next_State <= 2'b00;
{IF_write, PC_write, bubble} <= 3'b001;
addrSel <= 2'b00;
end
// Branch
else if (Branch == 1) begin
if (ALUZero == 1) begin
Next_State <= 2'b01;
{IF_write, PC_write, bubble} <=
3'b011;
addrSel <= 2'b10;
end
else begin
// Branch NOT taken
Next_State <= 2'b00;
{IF_write, PC_write, bubble} <=
3'b110;
addrSel <= 2'b00;
end
end
// Jump Hazard
else if (Jump == 1) begin
Next_State <= 2'b11;
{IF_write, PC_write, bubble} <= 3'b010;
addrSel <= 2'b01;
end
// NO Hazard
else begin
Next_State <= 2'b00;
{IF_write, PC_write, bubble} <= 3'b110;
addrSel <= 2'b00;
end
end
// Branch
2'b01: begin
Next_State <= 2'b00;
{IF_write, PC_write, bubble} <= 3'b110;
addrSel <= 2'b00;
end
// Jump
2'b11: begin
Next_State <= 2'b00;
{IF_write, PC_write, bubble} <= 3'b111;
addrSel <= 2'b00;
end
default: begin
Next_State <= 2'b00;
{IF_write, PC_write, bubble} <= 3'b110;
addrSel <= 2'b00;
end
endcase
end
// State is changed in negedge of the clock
always @(negedge Clk) begin
// If reset = 0, then keep state at 0
if(Rst == 0)
state <= 2'b00;
else
state <= Next_State;
end
endmodule