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
module linebuffer240 #(
    parameter WIDTH = 16,
    parameter IMG_WIDTH = 1920
    )
    (
    input  clk,
    input  rst_n,
    input  [WIDTH-1:0] din,
    output [WIDTH-1:0] dout,
    input  valid_in,
    output reg valid_out //输出给下一级的valid_in，也即上一级开始读的同时下一级就可以开始写入
);
wire   rd_en;//读使能
reg    [10:0] cnt;//这里的宽度注意要根据IMG_WIDTH的值来设置，需要满足cnt的范围≥图像宽度
reg    valid_in_d1;
reg   [WIDTH-1:0] din_d1;
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        valid_in_d1<='d0;
        din_d1<='d0;   
    end
    else begin
           valid_in_d1<=valid_in;  
           din_d1<=din;
    end
 end
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt <= {10{1'b0}};
    else if(valid_in)
    if(cnt == IMG_WIDTH)
        cnt <= IMG_WIDTH;
    else
        cnt <= cnt +1'b1;
else
    cnt <= cnt;
end
//一行数据写完之后，该级fifo就可以开始读出，下一级也可以开始写入了
assign rd_en = ((cnt == IMG_WIDTH) && (valid_in)) ? 1'b1:1'b0;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        valid_out <= 0;
    end
    else if (rd_en) begin
        valid_out <= 1;
    end
    else begin
        valid_out <= 0;
    end 
    end

fifo_generator_16bit u_line_fifo(
.clk (clk),
.rst (!rst_n),
.din (din_d1),
.dout(dout),
.wr_en (valid_in_d1),
.rd_en (rd_en), 
.wr_rst_busy(),  
.rd_rst_busy()
);


endmodule


