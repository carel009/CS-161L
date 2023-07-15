//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Christopher Arellano
// Email: carel009@ucr.edu
// 
// Assignment name: Lab 03
// Lab section: 021
// TA: Quan Fan
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

module aluControlUnit (
    input  wire [1:0] alu_op, 
    input  wire [5:0] instruction_5_0, 
    output wire [3:0] alu_out
    );

// ------------------------------
// Insert your solution below
// ------------------------------

reg [3:0] alu_result;

always @ (alu_op, instruction_5_0) begin
    casex ({alu_op, instruction_5_0})
        8'b1xxx0000: alu_result = 4'b0010;
        8'b00xxxxxx: alu_result = 4'b0010;
        8'bx1xxxxxx: alu_result = 4'b0110;
        8'b1xxx0010: alu_result = 4'b0110;
        8'b1xxx0100: alu_result = 4'b0000;
        8'b1xxx0101: alu_result = 4'b0001;
        8'b1xxx1010: alu_result = 4'b0111;
        8'b1xxx0111: alu_result = 4'b1100;
    endcase
end

assign alu_out = alu_result; 
endmodule
