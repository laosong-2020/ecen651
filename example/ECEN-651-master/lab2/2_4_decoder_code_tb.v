`define STRLEN 15
module Decode24Test_v;
task passTest;
input actualOut, expectedOut;
input [`STRLEN*8:0] testType;
inout [7:0] passed;

if (actualOut==expectedOut)
begin
	$display ("%s passed", testType);
	passed	= passed + 1;
end

else
	$display ("%s failed : %d should be %d",testType,actualOut,expectedOut );
	
endtask

task allPassed;

input	[7:0] passed;
input	[7:0] numTests;

if (passed==numTests)
	$display ("All tests passed");
else
	$display("Some tests failed");
endtask	
//inputs 

reg [1:0] in;
reg [7:0] passed;

//outputs 
wire [3:0] out;

//Instantiate the Unit Under Test (UUT)

decoder2_4 uut (
			.a(in),
			.x(out)
			
			
);

initial begin 

// initialize inputs 

in = 0;
passed=0;

//Add stimuls here

#90;
in=0;
#10;
passTest(out,1,"input 0",passed);

#90;
in=1;
#10;
passTest(out,2,"input 1",passed);


#90;
in=2;
#10;
passTest(out,4,"input 2",passed);


#90;
in=3;
#10;
passTest(out,8,"input 3",passed);

allPassed(passed,4);

end

endmodule 