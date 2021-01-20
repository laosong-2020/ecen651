`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/22 00:36:58
// Design Name: 
// Module Name: DataMem
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


module DataMemory ( ReadData , Address , WriteData , MemoryRead , MemoryWrite , Clock ) ;

input [5:0] Address; // defining address bus to be 6 bits wide to access 64 memory locations
input Clock, MemoryRead, MemoryWrite; //defining clock, memoryread and memorywrite signals
input [31:0] WriteData; // defining WriteData bus to be of 32 bits wide
output [31:0] ReadData; // defining ReadData bus to be of 32 bits wide

reg [31:0] ReadData;
reg [31:0] Datamem [0:63]; //defining DataMemory to be of 64 registers deep and 32 bits wide

always @(posedge Clock) begin // at postive clock edge
    if (MemoryRead == 1'b1) //memory read signal is high
        ReadData <= Datamem[Address]; // content of register put on read data bus
    else
        ReadData <= ReadData; //if signal low retain previous value
    end

always @(negedge Clock) begin //at negative lock edge
    if (MemoryWrite == 1'b1) //if memory write signal is high
        Datamem[Address] <= WriteData; //transfer contents from write data bus into register
    end
endmodule //module definition end

