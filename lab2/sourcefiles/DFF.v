`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas A&M Univ
// Engineer: Zhenlei Song
// 
// Create Date: 2020/09/14 23:08:48
// Design Name: 
// Module Name: dff
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


module dff(
    q,d,clk,reset
    );
    //pins declarations
    input d, clk, reset;
    output q;
    reg q;
    
    always@(posedge clk or posedge reset)
    begin
        if(reset==1)
        begin
            //default value
            q = 1'b0;
        end
        else 
        begin
            q = d;
        end
    end
endmodule
