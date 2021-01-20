`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/09/14 23:27:57
// Design Name: 
// Module Name: decode2_4_tb
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
module decode2_4_tb();
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
	reg [1:0] in;
	//reg enable;
	reg [7:0] passed;
	// Outputs
	wire [3:0] out;
	// Instantiate the Unit Under Test (UUT)
	decode2_5 uut (
		.out(out), 
		.in(in)
	);

	initial begin
		// Initialize Inputs
		in = 0;
		//enable = 0;
		passed = 0;
		  //#50 enable=1;
		// Add stimulus here

#90; in=0; #10;
passTest (out, 1, "Input0", passed);
#90; in=1; #10;
passTest (out, 2, "Input1", passed);
#90; in=2 ; #10;
passTest (out,4, "Input2", passed);
#90; in=3; #10;
passTest (out,8, "Input3", passed);
allPassed (passed,4);
end 

initial begin 
$monitor ($time, " in=%b, out=%b", in, out);
end  
endmodule
