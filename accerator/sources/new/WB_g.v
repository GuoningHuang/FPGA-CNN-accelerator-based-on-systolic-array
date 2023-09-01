`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/19 21:13:34
// Design Name: 
// Module Name: WB
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


module WB_g #
    (
    parameter M=8
    )
    (
    input clk,
    input Rst_n,
    input fmap_finish,
    output reg filter_finish,
    output reg [7:0] filter_count,
    output reg [M-1:0] W00,
    output reg [M-1:0] W01,
    output reg [M-1:0] W02,
    output reg [M-1:0] W03,
    output reg [M-1:0] W04,
    output reg [M-1:0] W05,
    output reg [M-1:0] W06,
    output reg [M-1:0] W07,
    output reg [M-1:0] W08,
    output reg [M-1:0] W10,
    output reg [M-1:0] W11,
    output reg [M-1:0] W12,
    output reg [M-1:0] W13,
    output reg [M-1:0] W14,
    output reg [M-1:0] W15,
    output reg [M-1:0] W16,
    output reg [M-1:0] W17,
    output reg [M-1:0] W18
    );
    wire [M*18-1:0] input_filter;
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n ) begin
            filter_count <=0;
            filter_finish <=0;
        end
        else if (fmap_finish) 
            if (filter_count < 7 ) begin
                filter_count = filter_count +1;
                filter_finish <=0;
            end
            else begin
                filter_count <=0;
            end
    end
    
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            W00 <= 0;
            W01 <= 0;
            W02 <= 0;
            W03 <= 0;
            W04 <= 0;
            W05 <= 0;
            W06 <= 0;
            W07 <= 0;
            W08 <= 0;
            W10 <= 0;
            W11 <= 0;
            W12 <= 0;
            W13 <= 0;
            W14 <= 0;
            W15 <= 0;
            W16 <= 0;
            W17 <= 0;
            W18 <= 0;
       end
       else begin
            W18 <= input_filter[M*1-1:0];
            W17 <= input_filter[M*2-1:M*1];
            W16 <= input_filter[M*3-1:M*2];
            W15 <= input_filter[M*4-1:M*3];
            W14 <= input_filter[M*5-1:M*4];
            W13 <= input_filter[M*6-1:M*5];
            W12 <= input_filter[M*7-1:M*6];
            W11 <= input_filter[M*8-1:M*7];
            W10 <= input_filter[M*9-1:M*8];
            W08 <= input_filter[M*10-1:M*9];
            W07 <= input_filter[M*11-1:M*10];
            W06 <= input_filter[M*12-1:M*11];
            W05 <= input_filter[M*13-1:M*12];
            W04 <= input_filter[M*14-1:M*13];
            W03 <= input_filter[M*15-1:M*14];
            W02 <= input_filter[M*16-1:M*15];
            W01 <= input_filter[M*17-1:M*16];
            W00 <= input_filter[M*18-1:M*17];  
//            W00 <= 1;
//            W01 <= 0;
//            W02 <= 0;
//            W03 <= 0;
//            W04 <= 0;
//            W05 <= 0;
//            W06 <= 0;
//            W07 <= 0;
//            W08 <= 0;
//            W10 <= 1;
//            W11 <= 0;
//            W12 <= 0;
//            W13 <= 0;
//            W14 <= 0;
//            W15 <= 0;
//            W16 <= 0;
//            W17 <= 0;
//            W18 <= 0;
        end
    end        
    blk_mem_gen_g input_weightg(.clka(clk),.addra(filter_count),.douta(input_filter));
    
endmodule
