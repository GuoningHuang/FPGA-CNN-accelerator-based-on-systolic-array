`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/19 10:46:27
// Design Name: 
// Module Name: convolution
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


module convolution_b #(
    parameter M = 8, //data width
    parameter S = 480+2   //feture_map size
    )
    (
    input clk,
    input Rst_n,
    input [M-1:0] din,
    input valid_in,
    input repeat_in,
    output  [M*2-1:0] out1,
    output  [M*2-1:0] out2,
    output valid_out1,
    output valid_out2
    );
//    wire [M*(S+2)*(S+2)-1:0] pad_map;o
    reg [8:0] row_index; // data ready to compute in SA
    wire [M-1:0] d1,d2,d3,d4,d5,d6,d7,d8,d9;
    wire [M-1:0] W00,W01,W02,W03,W04,W05,W06,W07,W08;
    wire [M-1:0] W10,W11,W12,W13,W14,W15,W16,W17,W18;
    wire filter_finish;
    wire [7:0] filter_count;
    wire fmap_finish;
    wire [8:0] count_x,count_y;
    wire compute_SA;
//    padding padding_tmp(clk,Rst_n,input_map,padding_map);
    
    WB_b #(M) WB_b_tmp(clk,Rst_n,fmap_finish,filter_finish,filter_count,W00,W01,W02,W03,W04,W05,W06,W07,W08,W10,W11,W12,W13,W14,W15,W16,W17,W18);
    
    SMB #(M,S)  SMB_tmp(clk,Rst_n,din,valid_in,repeat_in,d1,d2,d3,d4,d5,d6,d7,d8,d9,fmap_finish,count_x,count_y,valid_out1,valid_out2,compute_SA);
    
    convfixew #(M)  SA_tmp(clk,Rst_n,compute_SA,d1,d2,d3,d4,d5,d6,d7,d8,d9,W00,W01,W02,W03,W04,W05,W06,W07,W08,W10,W11,W12,W13,W14,W15,W16,W17,W18,out1,out2);
    
//    wire [M-1:0] r1,r2;
//    AB AB_tmp(clk,r1,r2);
//    wire [M*2-1:0] out1,out2;
//    always@(posedge clk or negedge Rst_n)begin
//        if (!Rst_n ) begin //|| out1[M*2-1]
//            o1 <= 0;
//        end
//        else begin
//            o1 <= out1;
//        end  
//    end
//        always@(posedge clk or negedge Rst_n)begin
//        if (!Rst_n ) begin  //|| out2[M*2-1]
//            o2 <= 0;
//        end
//        else begin
//            o2 <= out2;
//        end  
//    end

endmodule
