`timescale 1ns / 1ps
//`default_nettype none
// ******************************************************

//		SINGLE CYCLE PROCESSOR MODULE

// ******************************************************

module SingleCycleProc(input CLK, input Reset_L, input [31:0] startPC, output [31:0] dMemOut);

// PC
	reg [31:0] CurrentPC;
	wire [31:0] nextPC, PC4, InsSignExtd, BranchAddr, JumpAddr, Instruction;
	wire SignExtend, Jump;
	
	assign PC4 		   = CurrentPC + 32'd4;
	assign InsSignExtd = SignExtend?{{16{Instruction[15]}},Instruction[15:0]}:{16'b0,Instruction[15:0]};
    assign BranchAddr = (Branch&Zero)?(PC4+(InsSignExtd<<2)):PC4;
    assign JumpAddr = {PC4[31:28], {Instruction[25:0],2'b0}};
    assign nextPC = Jump?JumpAddr:BranchAddr;
    
    always @(negedge CLK or negedge Reset_L) begin
        if(~Reset_L) begin
            CurrentPC <= startPC;
        end else begin
            CurrentPC <= nextPC;
        end
    end
// IMEM
    
    
	InstructionMemory IMEM(.Data(Instruction), .Address(CurrentPC));

// RF
    wire RegWrite;
    wire [4:0] ReadRegister1, ReadRegister2, WriteRegister;
    wire [31:0] ReadData1, ReadData2, WriteData;
    assign WriteRegister = RegDst?Instruction[15:11]:Instruction[20:16];
    assign ReadRegister1 = Instruction[25:21];
    assign ReadRegister2 = Instruction[20:16];
	rf RegisterFile(.BusA(ReadData1) , .BusB(ReadData2) , .BusW(WriteData), .RA(ReadRegister1), .RB(ReadRegister2), .RW(WriteRegister), .RegWr(RegWrite), .Clk(CLK));
	
// CTRL
    wire RegDst, Branch, MemRead, MemtoReg, MemWrite, ALUSrc;
    wire [3:0] ALUCtrl, ALUOp;
	ALUControl ALUC(.ALUCtrl(ALUCtrl), .ALUop(ALUOp), .FuncCode(Instruction[5:0]));
	SingleCycleControl MainControl(.RegDst(RegDst),.ALUSrc(ALUSrc),.MemToReg(MemtoReg),.RegWrite(RegWrite),.MemRead(MemRead),
						  .MemWrite(MemWrite),.Branch(Branch),.Jump(Jump),.SignExtend(SignExtend),.ALUOp(ALUOp),.Opcode(Instruction[31:26]));
//ALU
    wire Zero;
    wire [31:0] ALUResult, ALUBusA, ALUBusB;
    assign ALUBusA = (ALUCtrl==4'b0011)||(ALUCtrl==4'b0100)||(ALUCtrl==4'b1101)?Instruction[10:6]:ReadData1;
	assign ALUBusB = ALUSrc?InsSignExtd:ReadData2;
	ALU alu(.BusW(ALUResult), .Zero(Zero), .BusA(ALUBusA), .BusB(ALUBusB), .ALUCtrl(ALUCtrl));
//DMEM
	DataMemory DMEM(.ReadData(dMemOut) , .Address(ALUResult[5:0]) , .WriteData(ReadData2) , .MemoryRead(MemRead) , .MemoryWrite(MemWrite) , .Clock(CLK));
	assign WriteData = MemtoReg?dMemOut:ALUResult;
endmodule