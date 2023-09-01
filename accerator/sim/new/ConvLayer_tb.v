`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/11 14:19:00
// Design Name: 
// Module Name: conv3_tb
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
module ConvLayer_tb;
    reg clk;
    reg Rst_n;
    reg [7:0] s_data;
    wire valid_in;
    wire repeat_in;
    wire [16-1:0] o1;
    wire [16-1:0] o2;
    wire valid_out1;
    wire valid_out2;
initial
begin
clk=0;
Rst_n = 0;
s_data = 0;
# 40
Rst_n = 1;
end
always # (10) clk=~clk;
reg  [15:0] cycle_cnt;
reg  [10:0] line;
always @(posedge clk) begin
    if (!Rst_n ) begin
        cycle_cnt <=0;
        line <= 0;
        end
     else if(cycle_cnt=='d5760) begin
        cycle_cnt <=0; 
        line <= line + 1;
     end
     else begin
        cycle_cnt <=1+cycle_cnt; 
     end
end
assign repeat_in = (cycle_cnt >= 1940 && cycle_cnt < 5300 && line>2)? 1'b1 : 1'b0;//3860
assign valid_in = (cycle_cnt>1437 && cycle_cnt<1920)?'d1:'d0;
assign wea = (cycle_cnt > 1436 && cycle_cnt < 1919)? 1'b1 : 1'b0;//3860
reg [8-1:0] zero = 8'b0;
reg [16:0] addr;
wire [7:0] data_r,data_g,data_b;
always @(posedge clk) begin
    if (!Rst_n ) begin
        addr <= 0;
        end
    else if(wea) begin
        addr <=  addr + 1;
    end 
end

convLayer #(8,482) conv3_temp(clk,Rst_n,data_r,data_g,data_b,valid_in,repeat_in,o1,o2,valid_out1,valid_out2);
    blk_mem_gen_r       r_tmp(.clka(clk),.addra(addr),.douta(data_r));
    blk_mem_gen_input_g g_tmp(.clka(clk),.addra(addr),.douta(data_g));
    blk_mem_gen_b       b_tmp(.clka(clk),.addra(addr),.douta(data_b));
endmodule

