`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/11 14:32:13
// Design Name: 
// Module Name: pooling
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
module pooling #(
    parameter M = 16, //data width
    parameter COL_NUM =  1920,
    parameter ROW_NUM =  128
    )
    (
    input clk,
    input Rst_n,
    input [M-1:0] din,
    input valid_in,
    output reg [M-1:0] result,
    output reg valid_out
    );
    wire [M-1:0] maxline_data;
    wire valid_line;
    wire [M-1:0] dout1,dout2;
    wire valid_o1,valid_o2;

    wire flag;
        //行和列信号的计数更新
    //  行和列的计数器
    reg      [10:0]  c_cnt ;
    reg      [10:0]  r_cnt ;
    always @(posedge clk or negedge Rst_n)
        if(Rst_n == 1'b0)
            c_cnt <=  11'd0;
        else if(c_cnt == COL_NUM-1 && valid_line == 1'b1)
            c_cnt <=  11'd0;
        else if(valid_line == 1'b1)
            c_cnt <= c_cnt + 1'b1;
        else
            c_cnt <= c_cnt;
    
    always @(posedge clk or negedge Rst_n)
        if(Rst_n == 1'b0)
            r_cnt  <=     11'd0;
        else if(r_cnt == ROW_NUM-1 && c_cnt == COL_NUM-1 && valid_line == 1'b1)
            r_cnt  <=     11'd0;
        else if(c_cnt == COL_NUM-1 && valid_line == 1'b1) 
            r_cnt    <=     r_cnt + 1'b1;
            
    reg even;
    always @(posedge clk or negedge Rst_n)
        if(Rst_n == 1'b0)
            even  <=  1'b1;
        else if(c_cnt == 1 && valid_o1)
            even <= even + 1;
 

//    assign even = (c_cnt == 1 && valid_o2) ? 1'b1 :1'b0;
  
    assign flag = (valid_o2 ) ? 1'b1:1'b0;
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            result <= 0;
            valid_out <= 0;
        end
        else if(flag && even) 
            if (dout1>dout2) begin
                result <= dout1;
                valid_out <= 1;
            end
            else begin
                result <= dout2;
                valid_out <= 1;
            end
        else begin
            result <= 0;
            valid_out <= 0;
        end
    end
        
        
    maxline #(16) maxline_temp(clk,Rst_n,din,valid_in,maxline_data,valid_line);
    linebuffer240 #(16,1920) lb_pooling1(clk,Rst_n,maxline_data,dout1,valid_line,valid_o1);
    linebuffer240 #(16,1920) lb_pooling2(clk,Rst_n,dout1,dout2,valid_o1,valid_o2);

    
endmodule
