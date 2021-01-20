`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas A&M Univ
// Engineer: Zhenlei Song
// 
// Create Date: 2020/09/22 00:17:33
// Design Name: 
// Module Name: register
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


module RegisterFile(BusA , BusB , BusW, RA, RB, RW, RegWr, Clk ) ;
input [4:0] RA, RB, RW; //defining RA & RB as read address buses and RW as write address bus each of 5bits wide to access all
input [31:0] BusW; //defining write port to be of 32 bits wide
input Clk, RegWr; //defining clock and write signal
output [31:0] BusA, BusB; //defining output read ports to be of 32 bits wide

reg [31:0] BusA, BusB;
reg [31:0] memory [0:31]; //defining memory to be of 32 registers deep and 32 bits wide

always @(negedge Clk) begin //for negative edge of clock
    memory[0] <= 32'b0; //making 0th register hard wired to value 0
    if ( RegWr ==1 && (RW != 0) ) //if write signal is high and write address bus not corresponding to 0th register
        memory[RW] <= BusW; //write data in destination register
    end

always @(RA or memory[RA])begin // reading data from a register for Bus A
    if (RA == 0)
        BusA <= 32'b0; //if RA signals for 0th register, data at read port is 0
    else
        BusA <= memory[RA]; //else read data from register and put it on Bus A
    end
always @(RB or memory[RB]) begin // reading data from a register for Bus B
    if (RB == 0)
        BusB <= 32'b0; //if RB signals for 0th register, data at read port is 0
    else
        BusB <= memory[RB]; //else read data from register and put it on Bus B
    end

endmodule //module definition ends