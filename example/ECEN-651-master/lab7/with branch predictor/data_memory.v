`timescale 1ns / 1ps
module DataMemory( ReadData, Address, WriteData, MemoryRead, MemoryWrite,
Clock);
// Define Inputs and output
input MemoryRead, MemoryWrite, Clock;
input [5:0]Address;
input [31:0]WriteData;
output reg [31:0]ReadData;
// Define DataMemory
reg [31:0] DataMemory[63:0];
// Read
always @(posedge Clock)
if (MemoryRead == 1)
ReadData <= DataMemory[Address];
// Write
always @(negedge Clock)
if (MemoryWrite == 1)
DataMemory[Address] <= WriteData;
endmodule