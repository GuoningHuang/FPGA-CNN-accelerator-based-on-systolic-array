`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/11 20:13:41
// Design Name: 
// Module Name: pooling_tb
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


module pooling_tb;
    reg clk;
    reg Rst_n;
    wire [15:0] result;
    wire valid_out;

initial
begin
clk=0;
Rst_n = 0;
# 40
Rst_n = 1;
end
always # (10) clk=~clk;

reg  [15:0] cycle_cnt;
always @(posedge clk) begin
    if (!Rst_n ) begin
        cycle_cnt <=0;
        end
     else if(cycle_cnt=='d1000) begin
        cycle_cnt <=0; 
     end
     else begin
        cycle_cnt <=1+cycle_cnt; 
     end
end
assign valid_in = (cycle_cnt>=400 && cycle_cnt<880)?'d1:'d0;
reg [15:0] s_data;
always @(posedge clk) begin
    if (!Rst_n) begin
        s_data <= 0;
        end
    else if(valid_in) begin
        s_data <=  s_data + 1;
    end 
end

    pooling temp(clk,Rst_n,s_data,valid_in,result,valid_out);
endmodule
