`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/12 20:22:11
// Design Name: 
// Module Name: ConvLayer
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


//////////////////////////////////////////////////////////////////////////////////
module convLayer #(
    parameter M = 8, //data width
    parameter S = 480+2   //feture_map size
    )
    (
    input clk,
    input Rst_n,
    input [M-1:0] din_r,
    input [M-1:0] din_g,
    input [M-1:0] din_b,
    input valid_in,
    input repeat_in,
    output  [M*2-1:0] result1,
    output  [M*2-1:0] result2,
    output  valid_out1,
    output  valid_out2
    );
    wire [M*2-1:0] conv_o1,conv_o2;
    wire conv_valid_o1,conv_valid_o2;
    convolution3 #(8,482) conv3_temp(clk,Rst_n,din_r,din_g,din_b,valid_in,repeat_in,conv_o1,conv_o2,conv_valid_o1,conv_valid_o2);
    pooling  pooling1_temp(clk,Rst_n,conv_o1,conv_valid_o1,result1,valid_out1);
    pooling  pooling2_temp(clk,Rst_n,conv_o2,conv_valid_o2,result2,valid_out2);
endmodule
