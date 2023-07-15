//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Christopher Arellano
// Email: carel009@ucr.edu
// 
// Assignment name: Lab 05
// Lab section: 021
// TA: Quan Fan
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps

module processor_tb;

// Inputs
reg clk;
reg rst;

// Outputs
wire [31:0] prog_count;
wire [5:0] instr_opcode;
wire [4:0] reg1_addr;
wire [31:0] reg1_data;
wire [4:0] reg2_addr;
wire [31:0] reg2_data;
wire [4:0] write_reg_addr;
wire [31:0] write_reg_data;

processor #(.MEM_FILE("inidividualInstructions.coe")) uut (
    .clk(clk),
    .rst(rst),
    .prog_count(prog_count),
    .instr_opcode(instr_opcode),
    .reg1_addr(reg1_addr),
    .reg1_data(reg1_data),
    .reg2_addr(reg2_addr),
    .reg2_data(reg2_data),
    .write_reg_addr(write_reg_addr),
    .write_reg_data(write_reg_data)
);
  
initial begin 
    clk = 0; rst = 1; #50; 
    clk = 1; rst = 1; #50; 
    clk = 0; rst = 0; 
         
    forever begin 
        #5 clk = ~clk;
    end 
end 

reg[31:0] result;
reg[31:0] expected;
integer last_instruction; 
integer passedTests = 0;
integer totalTests = 0;
integer f = 0;
initial begin
    f = $fopen("test_results.txt","w");
   /* Individual tests... Check the result after each instruction */
    $fwrite(f,"Test Group 1: Individual tests...\n");
    @(negedge rst); // Wait for reset

    @(posedge clk); #1; 
    totalTests = totalTests + 1;
    $fwrite(f,"Test Case 1.%0d: (Instruction 1)...",totalTests);
    if (write_reg_addr === 4 && write_reg_data === 535) begin
        passedTests = passedTests + 1;
        $fwrite(f,"passed.\n");
    end else begin
        $fwrite(f,"failed.\n");
    end

    @(posedge clk); #1;
    totalTests = totalTests + 1;
    $fwrite(f,"Test Case 1.%0d: (Instruction 2)...",totalTests);
    if (write_reg_addr === 4 && write_reg_data === 461) begin
        passedTests = passedTests + 1;
        $fwrite(f,"passed.\n");
    end else begin
        $fwrite(f,"failed.\n");
    end

    /* Testing an entire program... last_instruction is the PC of the last instruction to execute */
    /*wait (prog_count == last_instruction)
    result = write_reg_addr;
    $fwrite(f,"Test Case 1: (init.coe)...");
    totalTests = totalTests + 1;
    expected = 172;
    if (result == expected) begin
        passedTests = passedTests + 1;
        $fwrite(f,"passed.\n");
    end else begin
        $fwrite("failed. Expected %0d but got %0d\n",expected,result);
    end*/

    $fwrite(f,"------------------------------------------------------------------\n");
    $fwrite(f,"Testing complete\nPassed %0d / %0d tests.\n",passedTests,totalTests);
    $fwrite(f,"------------------------------------------------------------------\n");
end
endmodule
