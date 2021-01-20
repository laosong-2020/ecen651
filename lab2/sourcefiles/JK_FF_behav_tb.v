`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/14 22:59:15
// Design Name: 
// Module Name: JK_bhv
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


`define STRLEN 15
module JK_FF_tb;
 
 task passTest;
 input actualOut, expectedOut;
 input [`STRLEN*8:0] testType;
 inout [7:0] passed;
 
 if (actualOut == expectedOut)
 begin
$display ("%s passed", testType);
passed = passed + 1;
end
else $display ("%s failed: %d should be %d",testType,actualOut,expectedOut);
endtask

task allPassed;
input [7:0] passed;
input [7:0] numTests;
if (passed == numTests)
	$display ("All tests passed");
	else
	$display ("Some tests failed");
	endtask
	
	// Inputs
	reg J;
	reg K;
	reg clk;
	reg R;
	reg [7:0] passed;

	// Outputs
	wire Q;
	wire Qbar;
	
	// Instantiate the Unit Under Test (UUT)
	JK_FF uut (
		.Q(Q), 
		.Qbar(Qbar), 
		.J(J), 
		.K(K), 
		.clk(clk), 
		.R(R)
	);
initial begin
		// Initialize Inputs
		J = 0;
		K = 0;
		clk =0;
		R=1;
		passed = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		R = 0;
		
		#90; J=1; K=0; #7; clk = 1;
		#3; clk = 0; #90;
		passTest (Q, 1, "Set", passed);
		
		#90; J=1; K=1; #7; clk = 1;
		#3; clk = 0; #90;
		passTest (Q, 0, "Toggle 1", passed);
		
		#90; J=0; K=0; #7; clk = 1;
		#3; clk = 0; #90;
		passTest (Q, 0, "Hold 1", passed);
		
		#90; J=1; K=1; #7; clk = 1;
		#3; clk = 0; #90;
		passTest (Q, 1, "Toggle 2", passed);
		
		#90; J=0; K=0; #7; clk = 1;
		#3; clk = 0; #90;
		passTest (Q, 1, "Hold 2", passed);
		
		#90; J=0; K=1; #7; clk = 1;
		#3; clk = 0; #90;
		passTest (Q, 0, "Reset", passed);
      #90; allPassed (passed, 6 );
	end   
initial begin 
$monitor ($time, " Reset=%b, J=%b, K=%b, Q=%b", R,J,K,Q);
end  
endmodule