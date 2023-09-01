`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/07/16 11:33:41
// Design Name: 
// Module Name: conv_tb
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


module conv_tb;
    reg clk;
    reg Rst_n;
    reg [7:0] s_data;
    wire valid_in;
    wire repeat_in;
    wire [16-1:0] o1;
    wire [16-1:0] o2;
//    wire [7:0] dout;
    reg [17:0] addra;
    wire valid_out1;
    wire valid_out2;


    
initial
begin
clk=0;
Rst_n = 0;
//valid_in = 0;
addra = 256*580-1;
s_data = 0;
# 40
Rst_n = 1;
//# 200
//valid_in = 1;
end
always # (10) clk=~clk;
assign din = dout >>1;
reg  [15:0] cycle_cnt;
always @(posedge clk) begin
    if (!Rst_n ) begin
        cycle_cnt <=0;
        end

     else if(cycle_cnt=='d5760) begin
        cycle_cnt <=0; 
     end
     else begin
        cycle_cnt <=1+cycle_cnt; 
     end
end
assign valid_in = (cycle_cnt>1437 && cycle_cnt<1920)?'d1:'d0;
assign repeat_in = (cycle_cnt >= 1940 && cycle_cnt < 5300 )? 1'b1 : 1'b0;//3860
//assign repeat_in = 1'b0;
always @(posedge clk) begin
    if (!Rst_n || !valid_in ) begin
//        addra <= 256*480-1;
        s_data = 0;
        end
    else if(valid_in) begin
//        addra <= addra -1;
        s_data <=  s_data + 1;
    end 
end

convolution #(8,482) conv_temp(clk,Rst_n,s_data,valid_in,repeat_in,o1,o2,valid_out1,valid_out2);
//blk_mem_gen_inputmap smb1(.clka(clk),.addra(addra),.dina(1'b0),.wea(1'b0),.douta(dout));
endmodule
