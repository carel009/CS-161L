//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Christopher Arellano
// Email: carel009@ucr.edu
// 
// Assignment name: Lab 02
// Lab section: 021
// TA: Quan Fan
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module fixedToFloat(
  input wire clk, 
  input wire rst , 
  input wire[31:0] targetnumber, 
  input wire[4:0] fixpointpos , 
  output reg[31:0] result );

// Your  Implementation

`define Bias 127
`define Matissa_Size 23

integer leadingoneindex;

reg[7:0] biasedexponent;
reg[31:0] fixednumber;
reg[22:0] mantissa;
reg sign;

// -------------------------------------------	
// Register the results 
// -------------------------------------------

always @(*) begin 	
	// Replace the following code with your implmentation
  if (targetnumber == 32'h00000000) begin
    result = 32'h00000000;
  end

  else begin
    sign = targetnumber[31];
    fixednumber = (sign == 1'b1 ? ~targetnumber + 32'h00000001 : targetnumber);
    leadingoneindex = 32;
    
    while (leadingoneindex >= 0 && fixednumber[leadingoneindex-1] == 1'b0)
        leadingoneindex = leadingoneindex - 1;

    biasedexponent = `Bias + leadingoneindex - 1 - fixpointpos;
    mantissa = (leadingoneindex <= `Matissa_Size) ? fixednumber << (`Matissa_Size - leadingoneindex + 1) : fixednumber >> (leadingoneindex - 1 - `Matissa_Size);      
	  result = {sign, biasedexponent, mantissa};
  end
end 
endmodule
