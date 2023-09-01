`timescale 1ns / 1ps
module convfixew #
	(
	parameter N = 8
	)
	(
	input		Clk,
	input		Rst_n,
	input       compute_SA,
	input signed [N-1:0] F1,
	input signed [N-1:0] F2,
	input signed [N-1:0] F3,
	input signed [N-1:0] F4,
	input signed [N-1:0] F5,
	input signed [N-1:0] F6,
	input signed [N-1:0] F7,
	input signed [N-1:0] F8,
	input signed [N-1:0] F9,
	input signed [N-1:0] W00,
	input signed [N-1:0] W01,
	input signed [N-1:0] W02,
	input signed [N-1:0] W03,
	input signed [N-1:0] W10,
	input signed [N-1:0] W11,
	input signed [N-1:0] W12,
	input signed [N-1:0] W13,
	input signed [N-1:0] W14,
	input signed [N-1:0] G00,
	input signed [N-1:0] G01,
	input signed [N-1:0] G02,
	input signed [N-1:0] G03,
	input signed [N-1:0] G10,
	input signed [N-1:0] G11,
	input signed [N-1:0] G12,
	input signed [N-1:0] G13,
	input signed [N-1:0] G14,
	output  reg signed [N*2-1:0] C1,
	output  reg signed [N*2-1:0] C2
    );
    
    wire 		signed [N*2-1:0]	P11_C,P21_C;	
    wire		signed [N*2-1:0]	P12_C,P22_C;	
    wire		signed [N*2-1:0]	P13_C,P23_C;
    wire		signed [N*2-1:0]	P14_C,P24_C;
    wire		signed [N*2-1:0]	P15_C,P25_C;
    wire		signed [N*2-1:0]	P16_C,P26_C;
    wire		signed [N*2-1:0]	P17_C,P27_C;
    wire		signed [N*2-1:0]	P18_C,P28_C;	
    wire		signed [N*2-1:0]	P19_C,P29_C;
    wire        signed [N-1:0]  P11_F,P12_F,P13_F,P14_F,P15_F,P16_F,P17_F,P18_F,P19_F;
    reg         signed [N*2-1:0] zero = 0;
    reg         Sclr = 1;
    always@(posedge Clk or negedge Rst_n)begin
    	if(!Rst_n)begin
    		C1 <=0;
    		C2 <=0;
    	end
    	else  begin
    		C1 <=P19_C;
    		C2 <=P29_C;
    	end
    end

   ///First PE
    PE  PE_11(Clk,Rst_n,Sclr,compute_SA,F1,W00,zero,P11_F,P11_C);
    PE  PE_12(Clk,Rst_n,Sclr,compute_SA,F2,W01,P11_C,P12_F,P12_C);
    PE  PE_13(Clk,Rst_n,Sclr,compute_SA,F3,W02,P12_C,P13_F,P13_C);
    PE  PE_14(Clk,Rst_n,Sclr,compute_SA,F4,W03,P13_C,P14_F,P14_C);
    PE  PE_15(Clk,Rst_n,Sclr,compute_SA,F5,W10,P14_C,P15_F,P15_C);
    PE  PE_16(Clk,Rst_n,Sclr,compute_SA,F6,W11,P15_C,P16_F,P16_C);
    PE  PE_17(Clk,Rst_n,Sclr,compute_SA,F7,W12,P16_C,P17_F,P17_C);
    PE  PE_18(Clk,Rst_n,Sclr,compute_SA,F8,W13,P17_C,P18_F,P18_C);
    PE  PE_19(Clk,Rst_n,Sclr,compute_SA,F9,W14,P18_C,P19_F,P19_C);
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////
    PE  PE_21(Clk,Rst_n,Sclr,compute_SA,F1,G00,zero,,P21_C);
    PE  PE_22(Clk,Rst_n,Sclr,compute_SA,F2,G01,P21_C,,P22_C);
    PE  PE_23(Clk,Rst_n,Sclr,compute_SA,F3,G02,P22_C,,P23_C);
    PE  PE_24(Clk,Rst_n,Sclr,compute_SA,F4,G03,P23_C,,P24_C);
    PE  PE_25(Clk,Rst_n,Sclr,compute_SA,F5,G10,P24_C,,P25_C);
    PE  PE_26(Clk,Rst_n,Sclr,compute_SA,F6,G11,P25_C,,P26_C);
    PE  PE_27(Clk,Rst_n,Sclr,compute_SA,F7,G12,P26_C,,P27_C);
    PE  PE_28(Clk,Rst_n,Sclr,compute_SA,F8,G13,P27_C,,P28_C);
    PE  PE_29(Clk,Rst_n,Sclr,compute_SA,F9,G14,P28_C,,P29_C);
endmodule

