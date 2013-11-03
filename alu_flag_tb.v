`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:32:17 11/03/2013
// Design Name:   alu
// Module Name:   Y:/cpu/alu_flag_tb.v
// Project Name:  cpu
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: alu
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module alu_flag_tb;

	// Inputs
	reg [15:0] A;
	reg [15:0] B;
	reg [2:0] op;
	reg [2:0] lastFlag;
	reg [3:0] imm;
	reg clk;

	// Outputs
	wire [15:0] out;
	wire [2:0] flag;

	// Instantiate the Unit Under Test (UUT)
	alu uut (
		.A(A), 
		.B(B), 
		.op(op), 
		.lastFlag(lastFlag),
		.imm(imm), 
		.clk(clk), 
		.out(out), 
		.flag(flag)
	);
	always #5 clk = ~clk;
	initial begin
		// Initialize Inputs
		A = 0;
		B = 0;
		op = 0;
		imm = 0;
		clk = 0;
		lastFlag = 0;
		
		repeat (20) begin
			#10 {lastFlag, op,imm} = $random;
			 {A, B} = $random;
		end
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

