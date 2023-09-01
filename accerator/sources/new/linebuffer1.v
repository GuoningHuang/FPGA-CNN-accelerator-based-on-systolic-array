`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 20:11:44
// Design Name: 
// Module Name: linebuffer1
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
module linebuffer1 #(
    parameter WIDTH = 8,
    parameter IMG_WIDTH = 482
    )
    (
    input  clk,
    input  rst_n,
    input  [WIDTH-1:0] din,
    output [WIDTH-1:0] dout,
    input  valid_in,
    output valid_out //输出给下一级的valid_in，也即上一级开始读的同时下一级就可以开始写入
);
wire   rd_en;//读使能
reg    [8:0] cnt;//这里的宽度注意要根据IMG_WIDTH的值来设置，需要满足cnt的范围≥图像宽度

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt <= {9{1'b0}};
    else if(valid_in)
    if(cnt == IMG_WIDTH-1)
        cnt <= IMG_WIDTH-1;
    else
        cnt <= cnt +1'b1;
else
    cnt <= cnt;
end
//一行数据写完之后，该级fifo就可以开始读出，下一级也可以开始写入了
assign rd_en = ((cnt == IMG_WIDTH-1) && (valid_in)) ? 1'b1:1'b0;
assign valid_out = rd_en;

fifo_generator_0 u_line_fifo(
.clk (clk),
.rst (!rst_n),
.din (din),
.dout(dout),
.wr_en (valid_in),
.rd_en (rd_en), 
.wr_rst_busy(),  
.rd_rst_busy()
);


endmodule


