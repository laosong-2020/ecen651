module forwardingunit(UseShamt,UseImmed,ID_Rs,ID_Rt,EX_Rw,MEM_Rw,EX_RegWrite,MEM_RegWrite,
					  AluOpCtrlA,AluOpCtrlB,DataMemForwardCtrl_EX,DataMemForwardCtrl_MEM);

	input 			UseShamt;				// For shift
	input			UseImmed;				// For immediate
	input 		    EX_RegWrite;			// Register Write in EX stage	
	input 			MEM_RegWrite;			// Register Write in MEM stage	
	input[4:0] 		ID_Rs;					// Rs in Decode stage
	input[4:0] 		ID_Rt;					// Rt in Decode stage
	input[4:0] 		EX_Rw;					// Rw in Execute stage
	input[4:0] 		MEM_Rw;					// Rw in Memory stage

	output 		DataMemForwardCtrl_EX;	// Memory Forwarding in Execute stage
	output 		DataMemForwardCtrl_MEM; // Memory Forwarding in Memory stage
	output reg[1:0] AluOpCtrlA; 			// Alu busA select
	output reg[1:0] AluOpCtrlB;				// Alu busB select

	always @(*)
        begin
            if(UseShamt)
	           AluOpCtrlA<=2'b00;
	        else if((ID_Rs==EX_Rw) && EX_RegWrite && (EX_Rw!=0))
		       AluOpCtrlA<=2'b10;
		    else if ((MEM_Rw==ID_Rs) && MEM_RegWrite && (MEM_Rw!=0))
		       AluOpCtrlA<=2'b01;
			else
			   AluOpCtrlA<=2'b11;
end
//ALU Control Bus B -> AluOpCtrlB
/*1. If ID_Rt==EX_Rw, then assign ALU_B=EX_Rw****
2. check UseImmed, assign immediate to Bus B
3. default : Bus B= ALU_B
4.If ID_Rt == MEM_Rw, then assign ALU_B= MEM_Rw 
*/
always @(*)
    begin
        if(UseImmed)
	       AluOpCtrlB<=2'b00;
	    else if(EX_Rw==ID_Rt && EX_RegWrite && (EX_Rw!=0))
		   AluOpCtrlB<=2'b10;
		else if (MEM_Rw==ID_Rt && MEM_RegWrite && (MEM_Rw!=0))
		   AluOpCtrlB<=2'b01;
		else
			AluOpCtrlB<=2'b11;		
end
//Execution Buffer Control
/*if Ex*/
assign DataMemForwardCtrl_EX = (MEM_Rw==ID_Rt) && MEM_RegWrite && (MEM_Rw!=0);
assign DataMemForwardCtrl_MEM = (EX_Rw==ID_Rt) && EX_RegWrite && (EX_Rw!=0);

endmodule
 	