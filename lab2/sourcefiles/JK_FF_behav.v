`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Texas A&M Univ
// Engineer: Zhenlei Song
// 
// Create Date: 2020/09/14 22:51:24
// Design Name: 
// Module Name: JK_dataflow
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


module JK_FF(
    J,K,clk,R,Q,Qbar
    );
    //pins declarations
    output Q, Qbar;
    input J,K,clk,R;
    reg Q,Qbar;
    //due to sequencial structure, using non-blocking assignments.
    always @(posedge clk or posedge R)
    begin
        if(R==1) 
        begin
            Q <= 1'b0;
            Qbar<=1'b0;
        end
        else if(J==0 & K==0) 
        begin
            Q<= Q;
            Qbar<=Qbar;
        end
        else if(J==1 & K==0)
        begin
            Q<=1'b1;
            Qbar<=1'b0;
        end
        else if(J==0 & K==1)
        begin
            Q<=1'b0;
            Qbar<=1'b1;
        end
        else if(J==1 & K==1)
        begin
            Q<=~Q;
            Qbar<=~Qbar;
        end
    end
endmodule
