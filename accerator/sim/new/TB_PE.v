`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/11 21:27:58
// Design Name: 
// Module Name: tb_PE
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
module TB_PE;

parameter 	N = 8;
parameter	CLK_PERIOD = 20;
reg		       [N-1:0] F;
reg		       [N-1:0] W;
reg            [N*2-1:0] C;
reg		        Sclr;

wire		   [N-1:0] Next_F;
wire            [N*2-1:0]P;   
 
reg		Clk;
reg		Rst_n;
reg compute_SA;


initial
Clk=0;
always # (CLK_PERIOD/2) Clk=~Clk;

initial begin
Rst_n=1'b0;
Sclr = 1'b1;
compute_SA = 1'b1;
F=0;
W=0;
C=0;
#40;
Rst_n = 1'b1;
W  = 1;
# 100
compute_SA = 1'b0;
# 100
compute_SA = 1'b1;
end
always @(posedge Clk) begin
    F <= F +1 ;
end
 PE uut
    (
    .Clk(Clk),
    .Rst_n(Rst_n),
    .Sclr(Sclr),
    .compute_SA(compute_SA),
    .F(F),
    .W(W),
    .C(C),
    .Next_F(Next_F),
    .P(P)
    );
endmodule
