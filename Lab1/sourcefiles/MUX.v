`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas A&M Univ 
// Engineer: Zhenlei Song
// 
// Create Date: 2020/09/08 11:54:09
// Design Name: 4:1 Mux
// Module Name: MUX
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


module MUX(
    result, in0, in1, in2, in3, S0, S1
    );
    //pins declaration
    output result;
    input in0, in1, in2, in3, S0, S1;
    //S0    S1  result
    //0     0   in0
    //0     1   in1
    //1     0   in2
    //1     1   in3
    //do assign result value with 2 level select
    assign result = S1?(S0?in3:in2):(S0?in1:in0);
endmodule
