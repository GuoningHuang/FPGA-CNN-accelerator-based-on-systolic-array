`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/02 20:35:01
// Design Name: 
// Module Name: LineBuffer
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
module LineBuffer #(
    parameter WIDTH = 8,
    parameter COL_NUM = 482,
    parameter ROW_NUM = 256,
    parameter LINE_NUM =3
    )
    (
    input clk,
    input rst_n,
    //外部信号输入 写数据使能输入和数据输入
    input valid_in,
    input [WIDTH-1:0] din,
    //输出 三个行缓存模块的数据输出和第三行数据输出
    output[WIDTH-1:0] dout,
    output[WIDTH-1:0] dout_0,
    output[WIDTH-1:0] dout_1,
    output[WIDTH-1:0] dout_2,
    //标志位 开始流水线操作的开始
    output flag
);
// 寄存器 行缓存数据的传递   
reg   [WIDTH-1:0] line[2:0];
reg   valid_in_r  [2:0];
wire  valid_out_r [2:0];
//行缓存数据的输出寄存
wire  [WIDTH-1:0] dout_r[2:0];

assign dout_0 = dout_r[0];
assign dout_1 = dout_r[1];
assign dout_2 = dout_r[2];

assign dout = dout_r[2];
//  行和列的计数器
reg      [10:0]  c_cnt ;
reg      [10:0]  r_cnt ;
// 例化行缓存模块，并将模块之间的信号进行关联。通过generate简化代码
genvar i;
generate
    begin:HDL1
    for (i = 0;i < LINE_NUM;i = i +1)
        begin : buffer           
            if(i == 0) begin
                always @(*)begin
                    line[i]<=din;
                    valid_in_r[i]<= valid_in;
                end
            end      
            if(~(i == 0)) begin
                always @(* ) begin                
                    line[i] <= dout_r[i-1];               
                    valid_in_r[i] <= valid_out_r[i-1];
                end
            end
         //  例化行缓存模块
        linebuffer1
            line_buffe(
                .clk (clk),
                .rst_n (rst_n),
                .din (line[i]),
                .dout (dout_r[i]),
                .valid_in(valid_in_r[i]),
                .valid_out (valid_out_r[i])
                );
        end
    end
endgenerate

assign  flag  =r_cnt >= 11'd3 ? valid_in : 1'b0;

//行和列信号的计数更新
always @(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
        c_cnt <=  11'd0;
    else if(c_cnt == COL_NUM-1 && valid_in == 1'b1)
        c_cnt <=  11'd0;
    else if(valid_in == 1'b1)
        c_cnt <= c_cnt + 1'b1;
    else
        c_cnt <= c_cnt;

always @(posedge clk or negedge rst_n)
    if(rst_n == 1'b0)
        r_cnt  <=     11'd0;
    else if(r_cnt == ROW_NUM-1 && c_cnt == COL_NUM-1 && valid_in == 1'b1)
        r_cnt  <=     11'd0;
    else if(c_cnt == COL_NUM-1 && valid_in == 1'b1) 
        r_cnt    <=     r_cnt + 1'b1;
endmodule

