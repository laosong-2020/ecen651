`timescale 1ns / 1ps
module ForwardingUnit(UseShamt , UseImmed , ID_Rs , ID_Rt , EX_Rw , MEM_Rw,
EX_RegWrite ,
MEM_RegWrite , ALUOpCtrlA , ALUOpCtrlB , DataMemForwardCtrl_EX ,
DataMemForwardCtrl_MEM);
// Define inputs and outputs
input UseShamt , UseImmed ;
input [4:0] ID_Rs , ID_Rt , EX_Rw , MEM_Rw;
input EX_RegWrite , MEM_RegWrite ;
output reg [1:0] ALUOpCtrlA ;
output reg [1:0] ALUOpCtrlB ;
output reg DataMemForwardCtrl_EX , DataMemForwardCtrl_MEM ;
// This is a cmbinational block
always @(*)
begin
// Control Signal definitions:
if(UseShamt == 1)
ALUOpCtrlA <= 2'b00;
else if (ID_Rs == EX_Rw & EX_RegWrite == 1 & EX_Rw != 0)
ALUOpCtrlA <= 2'b10;
else if(ID_Rs == MEM_Rw & MEM_RegWrite == 1 & MEM_Rw != 0)
ALUOpCtrlA <= 2'b01;
else
ALUOpCtrlA <= 2'b11;
// I-type instruction
if(UseImmed == 1)
ALUOpCtrlB <= 2'b00;
else if (ID_Rt == EX_Rw & EX_RegWrite == 1 & EX_Rw != 0)
ALUOpCtrlB <= 2'b10;
else if(ID_Rt == MEM_Rw & MEM_RegWrite == 1 & MEM_Rw != 0)
ALUOpCtrlB <= 2'b01;
else
ALUOpCtrlB <= 2'b11;
// load value is used by previous instruction
if (EX_RegWrite == 1 & ID_Rt == EX_Rw & EX_Rw != 0)
begin
DataMemForwardCtrl_EX <= 1'b0;
DataMemForwardCtrl_MEM <= 1'b1;
end
// if load value before the previous instruction
else if(MEM_RegWrite == 1 & ID_Rt == MEM_Rw & MEM_Rw != 0)
begin
DataMemForwardCtrl_EX <= 1'b1;
DataMemForwardCtrl_MEM <= 1'b0;
end
else
// If no data dependancy
begin
DataMemForwardCtrl_EX <= 1'b0;
DataMemForwardCtrl_MEM <= 1'b0;
end
end
endmodule