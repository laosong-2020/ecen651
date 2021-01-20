`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2019 10:10:11 AM
// Design Name: 
// Module Name: PipelinedProc
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
module PipelinedProc(
CLK, Reset_L , startPC , dMemOut
    );
input CLK,Reset_L;
            input wire [31:0] startPC;
           // wire [31:0] nextPC;
            output wire [31:0] dMemOut;
//instruction memory inputs
wire [31:0] Data;
reg [31:0] updated_PC_address;
wire [31:0] Address;
 //PC Updation
 
 
 //Hazard Detection Unit
 wire IF_write, PC_write, bubble;
 wire [1:0] addrSel ;
 
 //scc inputs and outputs
 //wire[5:0] Opcode; //inputs
        wire RegDst; //outputs
        wire ALUSrc1;//use shamt
        wire ALUSrc2;//use immed
        wire MemToReg;
        wire RegWrite;
        wire MemRead;
        wire MemWrite;
        wire Branch;
        wire Jump;
        wire SignExtend;
        wire[3:0] ALUOp;
        wire [5:0] Func;
        //wire UseShamt;
        //wire UseImmed;
        wire [3:0] ALUOp_IF_ID;

 //forwarding unit inputs and outputs
 wire [1:0] AluOpCtrlA_ID;
 wire [1:0] AluOpCtrlB_ID;
 wire DataMemForwardCtrl_EX_IF_ID;
 wire DataMemForwardCtrl_MEM_IF_ID;
 
 //signextended data
 wire [31:0] sign_extension_data;
 
 //IF_ID stage
 wire [31:0] Register_file_A_IF_ID, Register_file_B_IF_ID;
 wire [31:0] BusW_WB;
 wire [4:0] RA_IF_ID, RB_IF_ID, RW_WB;
 wire RegWr_WB;
 wire Clk;
 wire[4:0] write_register_select_IF_ID;
 wire [31:0] write_register_data_IF_ID;
 wire [5:0] Opcode_IF_ID;
 wire [4:0] RS_IF_ID;
 wire [4:0] RT_IF_ID;
 wire [4:0] RD_IF_ID;
 wire [5:0] FUNC_IF_ID;
 reg [31:0] IM_IF_ID;
 wire [25:0] Jump_IF_ID;
 wire [15:0] Immedi_IF_ID;
 reg [31:0] Normal_PC_IF_ID;
 
 //stage 3 ID -> Execute
 reg RegDst_ID_EX;
 reg MemToReg_ID_EX;
 reg RegWrite_ID_EX;
 reg MemRead_ID_EX;
 reg MemWrite_ID_EX;
 reg [3:0]ALUOp_ID_EX;
 reg [1:0] AluOpCtrlA_ID_EX;
 reg [1:0] AluOpCtrlB_ID_EX;
 reg DataMemForwardCtrl_EX_ID_EX;
 reg DataMemForwardCtrl_MEM_ID_EX;
 reg [20:0] IM_20_0_ID_EX;
 reg [31:0] Sign_Extended_ID_EX;
 reg [31:0] Registers_A_ID_EX;
 reg [31:0] Registers_B_ID_EX;
 
 wire [5:0] Funccode_ID_EX;
 wire [4:0] RT_ID_EX;
 wire [4:0] RD_ID_EX;
 wire [4:0] Shamt_ID_EX;
 wire [4:0] RW_ID_EX;
 wire [31:0] Data_Memory_Input_ID_EX;
 
 //ALU Control
 wire [31:0] ALU_OUT;
 reg [31:0] ALU_IN1;
 reg [31:0] ALU_IN2;
 wire ALU_Zero;
 wire [3:0] ALU_control;
 
 //Stage 4_ DATA Memory 
 wire [31:0] Data_memory_out;
 reg [31:0] Data_Memory_Input_EX_MEM;
 reg [31:0] ALU_OUT_EX_MEM;
 reg [4:0] RW_EX_MEM; 
 wire [31:0] Data_Memory_actual_in;
 
 reg MemToReg_EX_MEM;
 reg RegWrite_EX_MEM;
 reg MemRead_EX_MEM;
 reg MemWrite_EX_MEM;
 
 reg DataMemForwardCtrl_MEM_EX_MEM;
 
 //stage 5 mem-wb
 reg MemToReg_MEM_WB;
 reg RegWrite_MEM_WB;
 reg [4:0] RW_MEM_WB;
 reg [31:0] DataOut_MEM_WB;
 reg [31:0] ALU_OUT_MEM_WB;
 wire [31:0] Register_W_MEM_WB;
 
 //wire Branch , ALUZero ;
 wire memReadEX, Rst ;
 wire UseShamt , UseImmed ;
 wire [4:0] currRs , currRt , prevRt ; 
 
assign Address= (addrSel==2'b00) ? (updated_PC_Address+4) :(addrSel == 2'b01) ? {Normal_PC_IF_ID [31:28], Jump_IF_ID, 2'b0} : (Normal_PC_IF_ID + (Sign_Extended_ID_EX[30:0] << 2));
 
 always @(negedge CLK or negedge Reset_L)
    begin
    if(~Reset_L)
    updated_PC_address<=startPC;    
    else if (PC_write==1)
    updated_PC_address<=Address;
    end

 
InstructionMemory imem (.Data(Data), .Address(updated_PC_Address));
//InstructionMemory(Data, Address);
//address updation from HazardUnit  
   
//PC Initialization
//Instruction memory instance


// stage 2 register file IF to ID stage
always @ (negedge CLK or negedge Reset_L) begin
if(~Reset_L) begin
IM_IF_ID <= 32'b0;
Normal_PC_IF_ID <= 32'b0;
end
else if(IF_write) begin
IM_IF_ID <= Data;
	Normal_PC_IF_ID <= updated_PC_Address + 4;
end
end

assign Opcode_IF_ID = IM_IF_ID[31:26];
assign FUNC_IF_ID = IM_IF_ID [5:0];
assign RS_IF_ID = IM_IF_ID[25:21];
assign	RT_IF_ID =	IM_IF_ID[20:16];
assign Jump_IF_ID =	IM_IF_ID[25:0];
assign Immedi_IF_ID =	IM_IF_ID[15:0];

SingleCycleControl scc (.RegDst(RegDst), .ALUSrc1(UseShamt),.ALUSrc2(UseImmed), .MemToReg(MemToReg), .RegWrite(RegWrite), 
.MemRead(MemRead), .MemWrite(MemWrite), .Branch(Branch), .Jump(Jump), .SignExtend(SignExtend), 
.ALUOp(ALUOp_IF_ID), .Opcode(Opcode_IF_ID), .Func(FUNC_IF_ID));

//sign extension

assign sign_extension_data = SignExtend ? {{16{IM_IF_ID[15]}},IM_IF_ID[15:0]} : {{16{1'b0}},IM_IF_ID[15:0]}  ;


HazardUnit hu (.IF_write(IF_write), .PC_write(PC_write), .bubble(bubble), .addrSel(addrSel), .Jump(Jump), .Branch(Branch), .ALUZero(ALU_Zero),
.memReadEX(MemRead_ID_EX), .currRs(RS_IF_ID), .currRt(RT_IF_ID), .prevRt(RT_ID_EX), .UseShamt(UseShamt), .UseImmed(UseImmed), .Clk(CLK), .Rst(Reset_L));

//register file instance
RegisterFile RF1 (.BusA(Register_file_A_IF_ID), .BusB(Register_file_B_IF_ID), .BusW(Register_W_MEM_WB), 
.RA(RS_IF_ID), .RB(RT_IF_ID), .RW( RW_MEM_WB ), .RegWr(RegWrite_MEM_WB), .Clk(CLK));

ForwardingUnit fu( .UseShamt(UseShamt), .UseImmed(UseImmed), .ID_Rs(RS_IF_ID),.ID_Rt(RT_IF_ID), 
.EX_Rw(RW_ID_EX),.MEM_Rw(RW_EX_MEM), .EX_RegWrite(RegWrite_ID_EX), .MEM_RegWrite(RegWrite_EX_MEM), 
.AluOpCtrlA(AluOpCtrlA_ID), .AluOpCtrlB(AluOpCtrlB_ID),
.DataMemForwardCtrl_EX(DataMemForwardCtrl_EX_IF_ID), .DataMemForwardCtrl_MEM(DataMemForwardCtrl_MEM_IF_ID) );

//Stage 2 ID -->EX
always @ (negedge CLK or negedge Reset_L) begin
if(~Reset_L) begin
RegDst_ID_EX<=1'b0;
MemToReg_ID_EX<=1'b0;
RegWrite_ID_EX<=1'b0;
MemRead_ID_EX<=1'b0;
MemWrite_ID_EX<=1'b0;
ALUOp_ID_EX<=4'b0;
AluOpCtrlA_ID_EX<=2'b0;
AluOpCtrlB_ID_EX<=2'b0;
DataMemForwardCtrl_EX_ID_EX<=1'b0;
DataMemForwardCtrl_MEM_ID_EX<=1'b0;
IM_20_0_ID_EX<=21'b0;
Sign_Extended_ID_EX<=32'b0;
Registers_A_ID_EX<=32'b0;
Registers_B_ID_EX<=32'b0;
end

else if(bubble) begin		// in case of bubble stop all the execution. 
RegDst_ID_EX<=1'b0;
MemToReg_ID_EX<=1'b0;
RegWrite_ID_EX<=1'b0;
MemRead_ID_EX<=1'b0;
MemWrite_ID_EX<=1'b0;
ALUOp_ID_EX<=4'b0;
AluOpCtrlA_ID_EX<=2'b0;
AluOpCtrlB_ID_EX<=2'b0;
DataMemForwardCtrl_EX_ID_EX<=1'b0;
DataMemForwardCtrl_MEM_ID_EX<=1'b0;
IM_20_0_ID_EX<=21'b0;
Sign_Extended_ID_EX<=32'b0;
Registers_A_ID_EX<=32'b0;
Registers_B_ID_EX<=32'b0;
end 
else begin
RegDst_ID_EX<=RegDst;
MemToReg_ID_EX<=MemToReg;
RegWrite_ID_EX<=RegWrite;
MemRead_ID_EX<=MemRead;
MemWrite_ID_EX<=MemWrite;
ALUOp_ID_EX<=ALUOp_IF_ID;
AluOpCtrlA_ID_EX<=AluOpCtrlA_ID;
AluOpCtrlB_ID_EX<=AluOpCtrlB_ID;
DataMemForwardCtrl_EX_ID_EX<=DataMemForwardCtrl_EX_IF_ID;
DataMemForwardCtrl_MEM_ID_EX<=DataMemForwardCtrl_MEM_IF_ID;
IM_20_0_ID_EX<=IM_IF_ID[20:0];
Sign_Extended_ID_EX<=sign_extension_data;
Registers_A_ID_EX<=Register_file_A_IF_ID;
Registers_B_ID_EX<=Register_file_B_IF_ID;
end 
end 

//stage 3
assign RT_ID_EX = IM_20_0_ID_EX[20:16];
assign RD_ID_EX = IM_20_0_ID_EX[15:11];
assign Shamt_ID_EX = IM_20_0_ID_EX[10:6];
assign Funccode_ID_EX = IM_20_0_ID_EX [5:0];

// input 1 
always @(*)begin 
case (AluOpCtrlA_ID_EX)
2'b00: ALU_IN1 = {27'b0, Shamt_ID_EX};
2'b01: ALU_IN1 = Register_W_MEM_WB;
2'b10: ALU_IN1 = ALU_OUT_EX_MEM;
2'b11: ALU_IN1 = Registers_A_ID_EX;
endcase
end 
//input 2 
always @(*)begin 
case (AluOpCtrlB_ID_EX)
2'b00: ALU_IN2 = Sign_Extended_ID_EX;
2'b01: ALU_IN2 = Register_W_MEM_WB;
2'b10: ALU_IN2 = ALU_OUT_EX_MEM;
2'b11: ALU_IN2 = Registers_B_ID_EX;
endcase
end 
 
 //ALU 
mips1 ALU1 (.BusW(ALU_OUT), .Zero(ALU_Zero), .BusA(ALU_IN1), .BusB(ALU_IN2), .ALUCtrl(ALU_control));

//ALU Control Unit. 
ALUControl AC1 (.ALUCtrl(ALU_control), .ALUop(ALUOp_ID_EX), .FuncCode(Funccode_ID_EX));       
        
assign RW_ID_EX = RegDst_ID_EX ? RD_ID_EX : RT_ID_EX;
assign Data_Memory_Input_ID_EX = DataMemForwardCtrl_EX_ID_EX ?  Register_W_MEM_WB : Registers_B_ID_EX;

//EX to MEM
always @ (negedge CLK or negedge Reset_L) begin
if (~Reset_L)begin 

Data_Memory_Input_EX_MEM <= 32'b0;
ALU_OUT_EX_MEM	<=32'b0;
RW_EX_MEM		<=5'b0;
MemToReg_EX_MEM	<=1'b0;
RegWrite_EX_MEM	<=1'b0;
MemRead_EX_MEM	<=1'b0;
MemWrite_EX_MEM	<=1'b0;
DataMemForwardCtrl_MEM_EX_MEM<=1'b0;
end 

else 
begin 
Data_Memory_Input_EX_MEM<= 	 Data_Memory_Input_ID_EX;
ALU_OUT_EX_MEM	<=	 ALU_OUT;
RW_EX_MEM		<=	 RW_ID_EX;
MemToReg_EX_MEM	<=	 MemToReg_ID_EX;
RegWrite_EX_MEM	<=	 RegWrite_ID_EX;
MemRead_EX_MEM	<=	 MemRead_ID_EX;
MemWrite_EX_MEM	<=	 MemWrite_ID_EX;
DataMemForwardCtrl_MEM_EX_MEM <=DataMemForwardCtrl_MEM_ID_EX;
end 
end 
 
//stage 4 -memory 
assign Data_Memory_actual_in = DataMemForwardCtrl_MEM_EX_MEM ? Register_W_MEM_WB: Data_Memory_Input_EX_MEM;
        
// DATA MEMORY MODULE Instantiation:
data_memory DM1 (.read_data(Data_memory_out), .addr(ALU_OUT_EX_MEM), .write_data(Data_Memory_actual_in), .memread(MemRead_EX_MEM), .memwrite(MemWrite_EX_MEM), .clk(CLK));


//MEMORY ---> WB 
always @(negedge CLK or negedge Reset_L)begin 
if (~Reset_L)begin
MemToReg_MEM_WB<=1'b0;
RegWrite_MEM_WB<=1'b0;
RW_MEM_WB<=5'b0;
DataOut_MEM_WB<=32'b0;
ALU_OUT_MEM_WB<=32'b0; 
end 

else begin 
MemToReg_MEM_WB<=MemToReg_EX_MEM;
RegWrite_MEM_WB<=RegWrite_EX_MEM;
RW_MEM_WB<=RW_EX_MEM;
DataOut_MEM_WB<=Data_memory_out;
ALU_OUT_MEM_WB<=ALU_OUT_EX_MEM; 
end 

end 


// stage 5 Write back

assign Register_W_MEM_WB = MemToReg_MEM_WB ? DataOut_MEM_WB : ALU_OUT_MEM_WB;


// actual output 
assign dMemOut = DataOut_MEM_WB;
endmodule