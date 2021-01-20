`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/14 23:12:50
// Design Name: 
// Module Name: dff_tb
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
module dff_tb;

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
	reg d;
	reg clk;
	reg reset;
   reg [7:0] passed;
	
	// Outputs
	wire q;

	// Instantiate the Unit Under Test (UUT)
	dff uut (
		.q(q), 
		.d(d), 
		.clk(clk), 
		.reset(reset)
	);

	initial begin
		// Initialize Inputs
		d = 0;
		clk = 0;
		reset = 1;
      passed = 0;
		
		// Wait 100 ns for global reset to finish
		#100;
		reset = 0;
        
		// Add stimulus here
#90; d=1; #7; clk =1;
#3; clk =0; #90;
passTest (q,1, "Output = Input", passed);

#90; d=0; #7; clk =1; 	
#3 ; clk = 0; #90;
passTest (q, 0, "Output = 0", passed);
allPassed (passed,2);
	end   
initial begin 
$monitor ($time, " D=%b, Reset=%b, Q=%b", d,reset,q);
end   
endmodule
