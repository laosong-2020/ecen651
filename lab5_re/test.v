`timescale 1ns / 1ps
//`default_nettype none
// ******************************************************

//		SINGLE CYCLE PROCESSOR MODULE

// ******************************************************

module SingleCycleProc(input CLK, input Reset_L, input [31:0] startPC, output [31:0] dMemOut);

// PC
	wire 		Branch,Zero,Jump,SignExtend;
	reg  [31:0] currentPC;
	wire [31:0] nextPC,PC4,InsSignExtd,Instruction,BranchAddr,JumpAddr;

    assign PC4 		   = currentPC+32'd4;
	assign InsSignExtd = SignExtend?{{16{Instruction[15]}},Instruction[15:0]}:{16'b0,Instruction[15:0]};
	assign BranchAddr  = (Branch&Zero)?(PC4+(InsSignExtd<<2)):PC4;
	assign JumpAddr    = {PC4[31:28],{Instruction[25:0],2'b0}};
	assign nextPC      = Jump?JumpAddr:BranchAddr;

	always @(negedge CLK or negedge Reset_L) begin 
		if(~Reset_L) begin
			currentPC <= startPC;
		end else begin
			currentPC <= nextPC;
		end
	end

// IMEM
	InstructionMemory IMEM(.Data(Instruction),.Address(currentPC));

// RF
	wire        RegWrite;
	wire [4:0]  ReadReg1,ReadReg2,WriteReg;
	wire [31:0] ReadData1,ReadData2,WriteData;
	assign WriteReg = RegDst?Instruction[15:11]:Instruction[20:16];
	rf registerFiles(.BusA(ReadData1),.BusB(ReadData2),.Clk(CLK),.RegWr(RegWrite),.RA(Instruction[25:21]),.RB(Instruction[20:16]),.RW(WriteReg),.BusW(WriteData));

// CTRL
	wire       RegDst,ALUSrc,MemToReg,MemRead,MemWrite;
	wire [3:0] ALUCtrl,ALUOp;
    ALUControl aluctrl(ALUCtrl,ALUOp,Instruction[5:0]);
	SingleCycleControl ctrl(RegDst,ALUSrc,MemToReg,RegWrite,MemRead,MemWrite,Branch,Jump,SignExtend,ALUOp,Instruction[31:26]);

//ALU
	wire [31:0] BusA,ALU_port2,ALUresult;
	assign BusA = (ALUCtrl==4'b0011)||(ALUCtrl==4'b0100)||(ALUCtrl==4'b1101)?Instruction[10:6]:ReadData1;
	assign ALU_port2 = ALUSrc?InsSignExtd:ReadData2;
	ALU alu(.BusW(ALUresult),.Zero(Zero),.BusA(BusA),.BusB(ALU_port2),.ALUCtrl(ALUCtrl));

//DMEM
	assign WriteData = MemToReg?dMemOut:ALUresult;
	DataMemory DMEM(.ReadData(dMemOut),.Address(ALUresult[5:0]),.WriteData(ReadData2),.Clock(CLK),.MemoryRead(MemRead),.MemoryWrite(MemWrite));

endmodule