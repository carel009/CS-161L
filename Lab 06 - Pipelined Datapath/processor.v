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
`include "cpu_constant_library.v"

module processor #(parameter WORD_SIZE=32,MEM_FILE="init.coe")(
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
wire [31:0] incr_pc_stage_2;
wire [31:0] incr_pc_stage_3;
wire [31:0] curr_pc;
wire [31:0] instruction;
wire [31:0] instruction_stage_2;
wire [31:0] instruction_stage_3;
wire [31:0] read_data_1;
wire [31:0] read_data_2;
wire [31:0] read_data;
wire [31:0] read_data_stage_5;
wire [31:0] write_data;
wire [31:0] channel_b;
wire [31:0] alu_result;
wire [31:0] alu_result_stage_4;
wire [31:0] alu_result_stage_5;
wire [31:0] branch_addr;
wire [31:0] branch_addr_stage_4;
wire [31:0] reg1_data_stage_3;
wire [31:0] reg2_data_stage_3;
wire [31:0] reg2_data_stage_4;
wire [4:0] write_register;
wire [4:0] write_register_stage_4;
wire [4:0] write_register_stage_5;
wire [3:0] alu_out;
wire [1:0] alu_op;
wire [1:0] alu_op_stage_3;

wire reg_dst;
wire reg_dst_stage_3;
wire reg_write;
wire reg_write_stage_3;
wire reg_write_stage_4;
wire reg_write_stage_5;
wire alu_src;
wire alu_src_stage_3;
wire mem_read;
wire mem_read_stage_3;
wire mem_read_stage_4;
wire mem_write;
wire mem_write_stage_3;
wire mem_write_stage_4;
wire mem_to_reg;
wire mem_to_reg_stage_3;
wire mem_to_reg_stage_4;
wire mem_to_reg_stage_5;
wire zero;
wire zero_stage_4;
wire branch;
wire branch_stage_3;
wire branch_stage_4;

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
    .data_address(alu_result_stage_4[9:2]),
    .data_mem_write(mem_write_stage_4),
    .data_read_data(read_data),
    .data_write_data(reg2_data)
);

mux_2_1 #(.WORD_SIZE(32)) pc_src (
    .select_in(branch_stage_4 & zero_stage_4),
    .datain1(incr_pc),
    .datain2(branch_addr_stage_4),
    .data_out(next_pc)
);

gen_register #(.WORD_SIZE(64)) IF_ID_STAGE_1 (
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in({incr_pc, instruction}),
    .data_out({incr_pc_stage_2, instruction_stage_2})
);

control_unit control (
    .instr_op(instruction_stage_2[31:26]),
    .reg_dst(reg_dst),
    .reg_write(reg_write),
    .alu_op(alu_op),
    .alu_src(alu_src),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .branch(branch)
);

cpu_registers resgister_file (
    .clk(clk),
    .rst(rst),
    .reg_write(reg_write_stage_5),
    .read_register_1(instruction_stage_2[25:21]),
    .read_data_1(reg1_data),
    .read_register_2(instruction_stage_2[20:16]),
    .read_data_2(reg2_data),
    .write_register(write_register_stage_5),
    .write_data(write_data)
);

gen_register #(.WORD_SIZE(137)) ID_EX_STAGE_2 (
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in({
        reg_write, mem_to_reg, //WB (1+1)
        branch, mem_read, mem_write, //M (1+1+1)
        reg_dst, alu_op, alu_src, //EX (1+2+1)
        incr_pc_stage_2, reg1_data, reg2_data, // (32+32+32) 
        instruction_stage_2} // (32)
    ),
    .data_out({
        reg_write_stage_3, mem_to_reg_stage_3, //WB
        branch_stage_3, mem_read_stage_3, mem_write_stage_3, //M
        reg_dst_stage_3, alu_op_stage_3, alu_src_stage_3, //EX
        incr_pc_stage_3, reg1_data_stage_3, reg2_data_stage_3, 
        instruction_stage_3}
    )
);

mux_2_1 #(.WORD_SIZE(32)) alu_b_src (
    .select_in(alu_src_stage_3),
    .datain1(reg2_data_stage_3),
    .datain2({{16{instruction_stage_3[15]}}, instruction_stage_3[15:0]}),
    .data_out(channel_b)
);

alu alu (
    .alu_control_in(alu_out),
    .channel_a_in(reg1_data_stage_3),
    .channel_b_in(channel_b),
    .alu_result_out(alu_result),
    .zero_out(zero)
);

alu_control alu_control (
    .alu_op(alu_op_stage_3),
    .instruction_5_0(instruction_stage_3[5:0]),
    .alu_out(alu_out)
);

mux_2_1 #(.WORD_SIZE(5)) write_reg_src (
    .select_in(reg_dst_stage_3),
    .datain1(instruction_stage_3[20:16]),
    .datain2(instruction_stage_3[15:11]),
    .data_out(write_register)
);

alu branch_alu (
    .alu_control_in(`ALU_ADD),
    .channel_a_in(incr_pc_stage_3),
    .channel_b_in({{16{instruction_stage_3[15]}}, instruction_stage_3[15:0]}),
    .alu_result_out(branch_addr)
);

gen_register #(.WORD_SIZE(107)) EX_MEM_STAGE_3 (
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in({
        reg_write_stage_3, mem_to_reg_stage_3, //WB (1+1)
        branch_stage_3, mem_read_stage_3, mem_write_stage_3, //M (1+1+1)
        branch_addr, zero, alu_result, reg2_data_stage_3, // (32+1+32+32) 
        write_register} // (5)
    ),
    .data_out({
        reg_write_stage_4, mem_to_reg_stage_4, //WB
        branch_stage_4, mem_read_stage_4, mem_write_stage_4, //M
        branch_addr_stage_4, zero_stage_4, alu_result_stage_4, reg2_data_stage_4, 
        write_register_stage_4}
    )
);

gen_register #(.WORD_SIZE(71)) MEM_WB_STAGE_4 (
    .clk(clk),
    .rst(rst),
    .write_en(clk),
    .data_in({
        reg_write_stage_4, mem_to_reg_stage_4, //WB
        read_data, alu_result_stage_4, write_register_stage_4}
    ),
    .data_out({
        reg_write_stage_5, mem_to_reg_stage_5, //WB
        read_data_stage_5, alu_result_stage_5, write_register_stage_5}
    )
);

mux_2_1 #(.WORD_SIZE(32)) write_data_src (
    .select_in(mem_to_reg_stage_5),
    .datain1(alu_result_stage_5),
    .datain2(read_data_stage_5),
    .data_out(write_data)
);

assign prog_count = curr_pc;
assign instr_opcode = instruction[31:26];
assign reg1_addr = instruction[25:21];
assign reg2_addr = instruction[20:16];
assign write_reg_addr = write_register;
assign write_reg_data = write_data;

endmodule
