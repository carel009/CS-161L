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

// ------------------------------------------------------------------------
// This file does not need any changes, other than your information above
// ------------------------------------------------------------------------

`timescale 1ns / 1ps

module fixedFloatConversion(
  input wire clk, 
  input wire rst , 
  input wire[31:0] targetnumber, 
  input wire[4:0] fixpointpos , 
  input wire opcode , // 1 is float to fix, 0 is fix to float
  output reg[31:0] result );

wire [31:0] floatresult ; 
wire [31:0] fixresult ; 

// -------------------------------------------
// From fix to float (Part 1)
// -------------------------------------------
fixedToFloat fixToFloat(.clk(clk),.rst(rst),
    .targetnumber(targetnumber),.fixpointpos(fixpointpos),
    .result(floatresult));

// -------------------------------------------	
// From float to fix (Part 2)
// -------------------------------------------
floatToFixed floatToFix(.clk(clk),.rst(rst),
    .float(targetnumber),.fixpointpos(fixpointpos),
    .result(fixresult));

// -------------------------------------------	
// Register the results 
// -------------------------------------------

always @ ( posedge clk ) begin 
    // Implement your synchronous reset
    result <= opcode == 1 ?  fixresult : floatresult ;

end 
endmodule
