`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas A&M Univ
// Engineer: Zhenlei Song
// 
// Create Date: 2020/09/14 22:12:56
// Design Name: 
// Module Name: JK_Stru
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


module JK_FF(J, K, clk, R, Q, Qbar);
    //pins declaration
    input J, K, clk, R;
    output Q, Qbar;
    wire a, b, c,d;
    //using gates to implement
    nand #2 N1 (a, clk, J, d);
    nand #2 N2 (b, clk, K, c);
    nand #2 N3 (c, a, d);
    nand #2 N4 (d, b, c, ~R); 
    
    assign Q = c;
    assign Qbar = d;
    //assign Q = ~Q_Bar;
endmodule
