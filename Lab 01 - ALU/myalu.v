//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Christopher Arellano
// Email: carel009@ucr.edu
// 
// Assignment name: Lab 01 - ALU
// Lab section: 021
// TA: Quan Fan
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

//  Constant definitions 

module myalu # ( parameter NUMBITS = 16 ) (
    input wire clk, 
    input wire reset ,  
    input  wire[NUMBITS-1:0] A, 
    input  wire[NUMBITS-1:0] B, 
    input wire [2:0]opcode, 
    output reg [NUMBITS-1:0] result,  
    output reg carryout ,
    output reg overflow , 
    output reg zero  );

// ------------------------------
// Insert your solution below
// ------------------------------ 
    wire A_sign;
    wire B_sign;
    assign A_sign = A[NUMBITS-1];
    assign B_sign = B[NUMBITS-1];
    always @(posedge clk) begin
        carryout = 0;
        overflow = 0;
        zero = 1;
        if(reset) begin
            result = 0;
        end
        else begin
            case(opcode)
                3'b000: {carryout, result} = A + B; //unsigned add
                3'b001: begin //signed add
                    result = A + B;
                    overflow = (~A_sign & ~B_sign & result[NUMBITS-1]) | (A_sign & B_sign & ~result[NUMBITS-1]);
                end
                3'b010: begin //unsigned sub
                    result = A - B;
                    carryout = B > A;
                end
                3'b011: begin //signed sub
                    result = A - B;
                    overflow = (~A_sign & B_sign & result[NUMBITS-1]) | (A_sign & ~B_sign & ~result[NUMBITS-1]);
                end
                3'b100: result = A & B; //bitwise AND
                3'b101: result = A | B; //bitwise OR
                3'b110: result = A ^ B; //bitwise XOR
                3'b111: result = A >> 1; //divide A by 2
            endcase
            zero = result == 0;
        end
    end
endmodule