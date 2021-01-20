`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/02/2019 08:17:42 AM
// Design Name: 
// Module Name: mips1
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
//case definition
`define AND 4'b0000
`define OR 4'b0001
`define ADD 4'b0010
`define SLL 4'b0011
`define SRL 4'b0100
`define SUB 4'b0110
`define SLT 4'b0111
`define ADDU 4'b1000
`define SUBU 4'b1001
`define XOR 4'b1010
`define SLTU 4'b1011
`define NOR 4'b1100
`define SRA 4'b1101
`define LUI 4'b1110

module mips1(BusW, Zero, BusA, BusB, ALUCtrl);//module initialization
input wire [31:0] BusA, BusB;//inputs
output reg [31:0] BusW;//output
//reg [31:0] temp;
input wire [3:0] ALUCtrl ; //input
output wire Zero ; //output 
//reg MSB;

wire less;
//reg [63:0] Bus64;
assign Zero = {{BusW==0} ? 1'b1 :1'b0}; //only when the output is zero, this will be high
assign less = ({1'b0,BusA} < {1'b0,BusB}  ? 1'b1 : 1'b0);
//assign Bus64 = 
always@(*)begin
	
	case (ALUCtrl)
	`AND:  BusW <= BusA & BusB; //logical AND
	       
	`OR:    BusW <= BusA | BusB; //logical OR
	       
	`ADD:   BusW <= BusA +BusB; //addition	
	
	`ADDU:  BusW <= BusA +BusB; //addition without overflow
	
	`SLL:   BusW <= BusB<<BusA; //shift logical left

	`SRL:   BusW <= BusB>>BusA; //shift logical right
	
	`SUB:begin 
	/*if(less==1)   
	BusW <= BusB- BusA;
	else
	BusW<=BusA-BusB;
	end
	*/
	BusW<=BusA-BusB; //subtraction
                      end
	`SUBU:begin 
                   BusW<=BusA-BusB;//subtraction with overflow
                   end
    `XOR:   BusW <= BusA ^BusB; //logical XOR
	 
	
	`NOR:   BusW <= ~(BusA | BusB); //logical NOR
	
	
	`SLT:begin  //set less than 
	 
	if(BusA[31]!=BusB[31])
	begin
	      if (BusA[31]>BusB[31])
	           begin
	           BusW<=1;
	           end
	      else
	          begin
	           BusW<=0;
	           end
	end           
	else if(BusA > BusB && BusA[31]==BusB[31])
	begin
	       BusW<=0;
	       end
	       else
	       begin
	       BusW<=1;
	       end
	       //BusW<=((BusA && 32'h7fffffff)<(BusB && 32'h7fffffff))? 32'd1 : 32'd0;
	  end     
	`SLTU:begin //set less than
               if(BusA>BusB || BusA==BusB)
                      BusW<=0;
                      else
                      BusW<=1;
	end
		`SRA: //shift arithmetic right

	BusW <= $signed(BusB)>>>(BusA);
	 
	
	
`LUI:   //BusW <= BusB << 16;
BusW <={BusB[15:0],16'd0}; //load upper immediate
//`LUI:   BusW <= BusB;	
	
	default:BusW <= 0; //default case
	endcase
end
endmodule
