`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/11 13:54:50
// Design Name: 
// Module Name: convolution3
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
module convolution3 #(
    parameter M = 8, //data width
    parameter S = 480+2   //feture_map size
    )
    (
    input clk,
    input Rst_n,
    input [M-1:0] din_r,
    input [M-1:0] din_g,
    input [M-1:0] din_b,
    input valid_in,
    input repeat_in,
    output reg [M*2-1:0] act1,
    output reg [M*2-1:0] act2,
    output reg valid_out1,
    output reg valid_out2
    );
    wire signed [M*2-1:0] o1_r,o2_r,o1_g,o2_g,o1_b,o2_b;
    wire valid_out1_r,valid_out2_r,valid_out1_g,valid_out2_g,valid_out1_b,valid_out2_b;
    reg signed [M*2-1:0] qm1,qm2;
    reg valid_qm;
    wire [7:0] filter_count;
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            qm1 <= 0;
            qm2 <= 0;
            valid_qm <= 0;
        end
        else if (valid_out1_r && valid_out1_g && valid_out1_b) begin //valid_out2_r && valid_out2_g && valid_out2_b
            qm1 <= o1_r + o1_g + o1_b -3845;
            qm2 <= o2_r + o2_g + o2_b;
            valid_qm <= 1;
        end
        else begin
            valid_qm <= 0;
        end
    end
   reg [M*2-1:0] qmf1 ,qmf2;
   reg [15:0] M01 = 31316; 
   reg [15:0] zero = 0;
   wire [47:0] r1_net,r2_net;
   reg valid_qmf;
   always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            qmf1 <= 0;
            qmf2 <= 0;
            valid_qmf <= 0;
        end
        else if (valid_qm) begin 
            qmf1 <= {r1_net[47],r1_net[39:25]};
            qmf2 <= {r2_net[47],r2_net[39:25]};
            valid_qmf <= 1;
        end
        else begin
            valid_qmf <= 0;
        end
    end
    ma16 ma_temp1(.A(qm1),.B(M01),.C(zero),.SUBTRACT(1'b0),.P(r1_net)); 
    ma16 ma_temp2(.A(qm2),.B(M01),.C(zero),.SUBTRACT(1'b0),.P(r2_net));  
    
    reg [15:0] M_positive = 30419;
    reg [15:0] M_negetive = 24335;
    wire [47:0] r1_net_positive,r1_net_negetive,r2_net_positive,r2_net_negetive;
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            act1 <= 0;
            valid_out1 <= 0;
        end
        else if (valid_qmf == 1)
            if (qmf1[15] == 0)begin 
                act1 <= {r1_net_positive[47],r1_net_positive[28:14]}+12;
                valid_out1 <= 1;
            end
            else begin 
                act1 <= {r1_net_negetive[47],r1_net_negetive[31:17]}+12;
                valid_out1 <= 1;
            end
         else begin
                valid_out1 <= 0;
         end         
    end
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            act2 <= 0;
            valid_out2 <= 0;
        end
        else if (valid_qmf == 1)
            if (qmf2[15] == 0)begin 
                act2 <= {r2_net_positive[47],r2_net_positive[28:14]}+12;
                valid_out2 <= 1;
            end
            else begin 
                act2 <= {r2_net_negetive[47],r2_net_negetive[31:17]}+12;
                valid_out2 <= 1;
            end
         else begin
            valid_out2 <= 0;
         end
    end
    ma16 ma_temp3(.A(qmf1),.B(M_positive),.C(zero),.SUBTRACT(1'b0),.P(r1_net_positive)); 
    ma16 ma_temp4(.A(qmf1),.B(M_negetive),.C(zero),.SUBTRACT(1'b0),.P(r1_net_negetive));  
    ma16 ma_temp5(.A(qmf2),.B(M_positive),.C(zero),.SUBTRACT(1'b0),.P(r2_net_positive)); 
    ma16 ma_temp6(.A(qmf2),.B(M_negetive),.C(zero),.SUBTRACT(1'b0),.P(r2_net_negetive));  
    convolution_r #(8,482) conv_r(clk,Rst_n,din_r,valid_in,repeat_in,o1_r,o2_r,valid_out1_r,valid_out2_r,filter_count);
    convolution_g #(8,482) conv_g(clk,Rst_n,din_g,valid_in,repeat_in,o1_g,o2_g,valid_out1_g,valid_out2_g);
    convolution_b #(8,482) conv_b(clk,Rst_n,din_b,valid_in,repeat_in,o1_b,o2_b,valid_out1_b,valid_out2_b);

endmodule