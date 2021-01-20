`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2019 02:43:14 PM
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit ( UseShamt , UseImmed , ID_Rs, ID_Rt, EX_Rw, MEM_Rw,
EX_RegWrite, MEM_RegWrite, AluOpCtrlA, AluOpCtrlB, DataMemForwardCtrl_EX ,
DataMemForwardCtrl_MEM ) ;
input UseShamt , UseImmed ;
input [4:0] ID_Rs, ID_Rt, EX_Rw, MEM_Rw;
input EX_RegWrite, MEM_RegWrite ;
output reg [1:0] AluOpCtrlA, AluOpCtrlB ;
output DataMemForwardCtrl_EX, DataMemForwardCtrl_MEM ;

//ALU Control Bus A ->AluOpCtrlA
/* Avoiding Read-after-write
1. check shamt, if 1 Bus A=shamt
2. If ID_Rs==EX_Rw, then assign ALU_A=EX_Rw ---PREFERENCE TO EX_RegWrite 
3. default: BusA=Alua
4. Id ID_Rs= MEM_Rw then 
*/
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
