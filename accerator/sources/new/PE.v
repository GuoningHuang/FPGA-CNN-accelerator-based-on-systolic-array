`timescale 1ns / 1ps
module PE #(parameter	N = 8)
	 (
	input		Clk,
	input		Rst_n,
	input		Sclr,
	input       compute_SA,
	input		[N-1:0]F,
	input		[N-1:0]W,
	input       [N*2-1:0]C,
	output	reg	[N-1:0]Next_F,
	output	reg [N*2-1:0]P
    );
    
    wire    [N*2-1:0] P_net;
    always@(posedge Clk or negedge Rst_n)begin
    	if(!Rst_n || !Sclr) begin
    		Next_F <=0;
    		P <=0;
    	end
    	else if(compute_SA )begin
            Next_F <=F;
    		P <=P_net;
    	end
    	else begin
    		Next_F <= Next_F;
    		P <= P;
    	end
    end
    reg [15:0] zero = 16'b1;
    xbip_multadd_0 MultAccumIP (
      .A(F),                // input wire [7 : 0] A
      .B(W),                // input wire [7 : 0] B
      .C(C),                // input wire [15 : 0] C
      .SUBTRACT(1'b0),  // input wire SUBTRACT
      .P(P_net),                // output wire [15 : 0] P
      .PCOUT()        // output wire [47 : 0] PCOUT
    );


endmodule

