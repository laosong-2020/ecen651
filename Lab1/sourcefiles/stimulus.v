`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas A&M Univ
// Engineer: Zhenlei Song
// 
// Create Date: 2020/09/08 02:10:40
// Design Name: Ripple Carry Counter
// Module Name: stimulus
// Project Name: ECEN651 Lab1
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


module stimulus;
reg clk;
reg reset;
wire [3:0] q;
// instantiate the design block
RCC r1(q, clk, reset);
// control the clock signal that drives the design block. Cycle time = 10
initial
clk = 1'b0;
always
#5 clk=~clk; // togle clk every 5 time units
// control the reset signal that drives the design block
// reset is asserted from 0 to 20 and from 200 to 220
initial
begin
reset = 1'b1;
#15 reset = 1'b0;
#180 reset = 1'b1;
#10 reset = 1'b0;
#20 $finish; // teriminate the simulation
end
// Monitor the outputs
initial
$monitor($time, " Clk %b, Output q = %d",clk,q);
endmodule
