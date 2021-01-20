module JK( out,j,k,clk,reset); // module definition
output out;						 // defining outputs
input j,k, clk, reset ;
reg Qbar; 				//defining inputs
reg out; 						//declaring outputs as reg type
always @ (posedge clk or posedge reset) 	//output changes if either clock edge is thereor reset is high
begin
if (reset == 1) begin 					// if reset is high then Q+ =0 irrespective of clock
out <= 1'b0;
Qbar <= 1'b1;
end

else if ( j==0 & k==0) begin // J=0,K=0 => Q+ =Q
out <= out;
Qbar <= Qbar;
end

else if ( j==1 & k==0) begin // J=1,K=0 => Q+ =1
out <= 1'b1;
Qbar <= 1'b0;
end

else if ( j==0 & k==1) begin // J=0,K=1 => Q+ =0
out <= 1'b0;
Qbar <= 1'b1;
end

else if ( j==1 & k==1) begin // J=1,K=1 => Q+ =Qbar
out <= Qbar;
Qbar <= out;
end
end
endmodule //module definition ends
