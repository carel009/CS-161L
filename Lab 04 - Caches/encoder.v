`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/18/2021 11:31:41 AM
// Design Name: 
// Module Name: encoder
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


module encoder #(
    parameter IN_SIZE = 4,
    parameter OUT_SIZE = 4
) (
    output reg [OUT_SIZE-1:0] out,
    input wire [IN_SIZE-1:0] in
);
    
    always @(in) 
        for (out = 0; out < IN_SIZE && in[out] !== 1; out = out + 1) begin
        end
    
endmodule
