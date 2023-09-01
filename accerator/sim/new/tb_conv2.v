`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/16 11:44:29
// Design Name: 
// Module Name: tb_conv
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


module tb_conv2;

parameter 	N = 32;
parameter	CLK_PERIOD = 20;
	reg		Clk;
	reg		Rst_n;
	reg signed [N-1:0] F1;
	reg signed [N-1:0] F2;
	reg signed [N-1:0] F3;
	reg signed [N-1:0] F4;
	reg signed [N-1:0] F5;
	reg signed [N-1:0] F6;
	reg signed [N-1:0] F7;
	reg signed [N-1:0] F8;
	reg signed [N-1:0] F9;
	
	wire signed [N-1:0] C1;
	wire signed [N-1:0] C2;
	
	reg signed [N-1:0] W00;
	reg signed [N-1:0] W01;
	reg signed [N-1:0] W02;
	reg signed [N-1:0] W03;
	reg signed [N-1:0] W10;
	reg signed [N-1:0] W11;
	reg signed [N-1:0] W12;
	reg signed [N-1:0] W13;
	reg signed [N-1:0] W14;
	
	reg signed [N-1:0] G00;
	reg signed [N-1:0] G01;
	reg signed [N-1:0] G02;
	reg signed [N-1:0] G03;
	reg signed [N-1:0] G10;
	reg signed [N-1:0] G11;
	reg signed [N-1:0] G12;
	reg signed [N-1:0] G13;
	reg signed [N-1:0] G14;
reg Sclr = 1'b1;
	
integer i=0;
initial
Clk=0;
always # (CLK_PERIOD/2) Clk=~Clk;
initial begin
W00=1;
W01=1;
W02=1;
W03=1;
W10=1;
W11=1;
W12=1;
W13=1;
W14=1;
G00=1;
G01=1;
G02=1;
G03=1;
G10=1;
G11=1;
G12=1;
G13=1;
G14=1;
////////////////////////////////
F1=0;
F2=0;
F3=0;
F4=0;
F5=0;
F6=0;
F7=0;
F8=0;
F9=0;
Rst_n=1'b0;
#40
Rst_n=1'b1;
#5
for(i=0;i<25;i=i+1)begin
F1=0;
F2=0;
F3=0;
F4=0;
F5=0;
F6=0;
F7=0;
F8=0;
F9=0;
#20
F1=1+i;
F2=0;
F3=0;
F4=0;
F5=0;
F6=0;
F7=0;
F8=0;
F9=0;
#20
F1=1+i;
F2=1+i;
F3=0;
F4=0;
F5=0;
F6=0;
F7=0;
F8=0;
F9=0;
#20
F1=1+i;
F2=1+i;
F3=1+i;
F4=0;
F5=0;
F6=0;
F7=0;
F8=0;
F9=0;
#20
F1=1+i;
F2=1+i;
F3=1+i;
F4=1+i;
F5=0;
F6=0;
F7=0;
F8=0;
F9=0;
#20
F1=0;
F2=1+i;
F3=1+i;
F4=1+i;
F5=1+i;
F6=0;
F7=0;
F8=0;
F9=0;
#20
F1=0;
F2=0;
F3=1+i;
F4=1+i;
F5=1+i;
F6=1+i;
F7=0;
F8=0;
F9=0;
#20
F1=0;
F2=0;
F3=0;
F4=1+i;
F5=1+i;
F6=1+i;
F7=1+i;
F8=0;
#20
F1=0;
F2=0;
F3=0;
F4=0;
F5=1+i;
F6=1+i;
F7=1+i;
F8=1+i;
#20
F1=0;
F2=0;
F3=0;
F4=0;
F5=0;
F6=1+i;
F7=1+i;
F8=1+i;
#20
F1=0;
F2=0;
F3=0;
F4=0;
F5=0;
F6=0;
F7=1+i;
F8=1+i;
F9=1+i;
#20
F1=0;
F2=0;
F3=0;
F4=0;
F5=0;
F6=0;
F7=0;
F8=1+i;
F9=1+i;
#60;
end
end
convfixew uut
	(
	.Clk(Clk),
	.Rst_n(Rst_n),
	.F1(F1),
	.F2(F2),
	.F3(F3),
	.F4(F4),
	.F5(F5),
	.F6(F6),
	.F7(F7),
	.F8(F8),
	.F9(F9),
	.W00(W00),
	.W01(W01),
	.W02(W02),
	.W03(W03),
	.W10(W10),
	.W11(W11),
	.W12(W12),
	.W13(W13),
	.W14(W14),
	.G00(G00),
	.G01(G01),
	.G02(G02),
	.G03(G03),
	.G10(G10),
	.G11(G11),
	.G12(G12),
	.G13(G13),
	.G14(G14),
	.C1(C1),
	.C2(C2)
    );
endmodule
