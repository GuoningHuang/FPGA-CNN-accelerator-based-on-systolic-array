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
    //�ⲿ�ź����� д����ʹ���������������
    input valid_in,
    input [WIDTH-1:0] din,
    //��� �����л���ģ�����������͵������������
    output[WIDTH-1:0] dout,
    output[WIDTH-1:0] dout_0,
    output[WIDTH-1:0] dout_1,
    output[WIDTH-1:0] dout_2,
    //��־λ ��ʼ��ˮ�߲����Ŀ�ʼ
    output flag
);
// �Ĵ��� �л������ݵĴ���   
reg   [WIDTH-1:0] line[2:0];
reg   valid_in_r  [2:0];
wire  valid_out_r [2:0];
//�л������ݵ�����Ĵ�
wire  [WIDTH-1:0] dout_r[2:0];

assign dout_0 = dout_r[0];
assign dout_1 = dout_r[1];
assign dout_2 = dout_r[2];

assign dout = dout_r[2];
//  �к��еļ�����
reg      [10:0]  c_cnt ;
reg      [10:0]  r_cnt ;
// �����л���ģ�飬����ģ��֮����źŽ��й�����ͨ��generate�򻯴���
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
         //  �����л���ģ��
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

//�к����źŵļ�������
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

