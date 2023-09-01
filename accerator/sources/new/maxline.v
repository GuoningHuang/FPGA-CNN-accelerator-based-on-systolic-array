`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/11 18:01:35
// Design Name: 
// Module Name: maxline
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
module maxline #(
    parameter M = 16 //data width
    )
    (
    input clk,
    input Rst_n,
    input [M-1:0] din,
    input valid_in,
    output reg [M-1:0] result,
    output reg valid_out
    );
    reg count;
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            count <= 0;
        end
        else if (valid_in)
            if (count == 1) begin
                count <= 0;
            end
            else begin
                count <= count + 1;
            end    
    end
    reg [M-1:0] data_before;
    always @(posedge clk ) begin
        if (!Rst_n) begin
            data_before <= 0;
        end
        else if (valid_in) begin
            data_before <= din;
        end
    end
    
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            result <= 0;
            valid_out <= 0;
        end
        else if (count == 1 && valid_in) 
            if (data_before >din) begin
                result <= data_before;
                valid_out <= 1;
            end
            else begin
                result <= din;
                valid_out <= 1;
            end    
        else begin 
            result <= 0;
            valid_out <= 0;
        end
    end
    
endmodule
