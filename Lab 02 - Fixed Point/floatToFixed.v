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

module floatToFixed(
  input wire clk, 
  input wire rst , 
  input wire[31:0] float, 
  input wire[4:0] fixpointpos , 
  output reg[31:0] result );

// Your  Implementation 

`define Bias 127
`define Matissa_Size 23

reg[7:0] shift;

// -------------------------------------------	
// Register the results 
// -------------------------------------------

always @(*) begin
	// Replace the following code with your implmentation
  result = 0;
  if (float !== 32'h00000000) begin
	  result[23] = 1'b1;
    result[22:0] = float[22:0];
    shift = $signed(`Matissa_Size - $signed(float[30:23] - `Bias + fixpointpos));
    
    if ($signed(shift) >= 0) begin
      result = result >> shift;
    end

    else begin
      result = result << -$signed(shift);
    end

    if(float[31]) begin
      result = ~result + 32'h00000001;
    end
  end
end 
endmodule
