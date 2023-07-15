//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: Christopher Arellano
// Email: carel009@ucr.edu
// 
// Assignment name: Lab 04
// Lab section: 021
// TA: Quan Fan
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

`timescale 1ns / 1ps
`include "cpu_constant_library.v"

module processor #(parameter WORD_SIZE=32,MEM_FILE="init.coe") (
    input clk,
    input rst,   
	 // Debug signals 
    output [WORD_SIZE-1:0] prog_count, 
    output [5:0] instr_opcode,
    output [4:0] reg1_addr,
    output [WORD_SIZE-1:0] reg1_data,
    output [4:0] reg2_addr,
    output [WORD_SIZE-1:0] reg2_data,
    output [4:0] write_reg_addr,
    output [WORD_SIZE-1:0] write_reg_data 
);

// ----------------------------------------------
// Insert solution below here
// ----------------------------------------------

wire [31:0] next_pc;
wire [31:0] incr_pc;
wire [31:0] curr_pc;
wire [31:0] instruction;
wire [31:0] read_data_1;
wire [31:0] read_data_2;
wire [31:0] read_data;
wire [31:0] write_data;
wire [31:0] channel_b;
wire [31:0] alu_result;
wire [31:0] branch_addr;
wire [4:0] write_register;
wire [3:0] alu_out;
wire [1:0] alu_op;
wire reg_dst;
wire reg_write;
wire alu_src;
wire mem_read;
wire mem_write;
wire mem_to_reg;
wire zero;
wire branch;

gen_register PC (
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in(next_pc),
    .data_out(curr_pc)
);

alu pc_incr (
    .alu_control_in(`ALU_ADD),
    .channel_a_in(curr_pc),
    .channel_b_in(32'h4),
    .alu_result_out(incr_pc)
);

cpumemory #(.FILENAME(MEM_FILE)) RAM (
    .clk(clk),
    .rst(rst),
    .instr_read_address(curr_pc[9:2]),
    .instr_instruction(instruction),
    .data_address(alu_result[9:2]),
    .data_mem_write(mem_write),
    .data_read_data(read_data),
    .data_write_data(reg2_data)
);

control_unit control (
    .instr_op(instruction[31:26]),
    .reg_dst(reg_dst),
    .reg_write(reg_write),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .branch(branch)
);

mux_2_1 #(.WORD_SIZE(5)) write_reg_src (
    .select_in(reg_dst),
    .datain1(instruction[20:16]),
    .datain2(instruction[15:11]),
    .data_out(write_register)
);

cpu_registers resgister_file (
    .clk(clk),
    .rst(rst),
    .reg_write(reg_write),
    .read_register_1(instruction[25:21]),
    .read_data_1(reg1_data),
    .read_register_2(instruction[20:16]),
    .read_data_2(reg2_data),
    .write_register(write_register),
    .write_data(write_data)
);

mux_2_1 #(.WORD_SIZE(32)) alu_b_src (
    .select_in(alu_src),
    .datain1(reg2_data),
    .datain2({{16{instruction[15]}}, instruction[15:0]}),
    .data_out(channel_b)
);

alu_control alu_control (
    .alu_op(alu_op),
    .instruction_5_0(instruction[5:0]),
    .alu_out(alu_out)
);

alu alu (
    .alu_control_in(alu_out),
    .channel_a_in(reg1_data),
    .channel_b_in(channel_b),
    .alu_result_out(alu_result),
    .zero_out(zero)
);

mux_2_1 #(.WORD_SIZE(32)) write_data_src (
    .select_in(mem_to_reg),
    .datain1(alu_result),
    .datain2(read_data),
    .data_out(write_data)
);

alu branch_alu (
    .alu_control_in(`ALU_ADD),
    .channel_a_in(incr_pc),
    .channel_b_in({{16{instruction[15]}}, instruction[15:0]}),
    .alu_result_out(branch_addr)
);

mux_2_1 #(.WORD_SIZE(32)) pc_src (
    .select_in(branch & zero),
    .datain1(incr_pc),
    .datain2(branch_addr),
    .data_out(next_pc)
);

assign prog_count = curr_pc;
assign instr_opcode = instruction[31:26];
assign reg1_addr = instruction[25:21];
assign reg2_addr = instruction[20:16];
assign write_reg_addr = write_register;
assign write_reg_data = write_data;

endmodule
