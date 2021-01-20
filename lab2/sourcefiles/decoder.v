`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas A&M Univ
// Engineer: Zhenlei Song
// 
// Create Date: 2020/09/14 23:26:40
// Design Name: 
// Module Name: decode2_4
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


module decode2_5(
    out, in
    );
    //pins declarations
    input [1:0]in;
    output [3:0]out;
    //dataflow using assignments
    assign out[3:0] = {in[1] & in[0], 
                       in[1] & ~in[0], 
                       ~in[1] & in[0],  
                       ~in[1] & ~in[0]};
endmodule
