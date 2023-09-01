`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/19 10:14:48
// Design Name: 
// Module Name: SMB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 输入单个数据，输出脉动阵列需要的9个输入值
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module SMB #
    (
    parameter M=8,
    parameter SP = 480+2
    )
    (
    input clk,
    input Rst_n,
    input [M-1:0] din,
    input valid_in,
    input repeat_in,
    output reg [M-1:0] d1,
    output reg [M-1:0] d2,
    output reg [M-1:0] d3,
    output reg [M-1:0] d4,
    output reg [M-1:0] d5,
    output reg [M-1:0] d6,
    output reg [M-1:0] d7,
    output reg [M-1:0] d8,
    output reg [M-1:0] d9,
    output reg fmap_finish,
    output reg  [8:0] count_x,          //index of row 0-415
    output reg  [8:0] count_y,           //index of column 0-415
    output reg  valid_out1,
    output reg  valid_out2,
    output compute_SA
    );

    reg [10:0] addr_r1,addr_r2,addr_r3; //卷积核对应的行坐标
    // 延时寄存器
    reg [M-1:0] d2_reg1,d3_reg1,d3_reg2,d4_reg1,d4_reg2,d4_reg3,d5_reg1,d5_reg2,d5_reg3,d5_reg4;
    reg [M-1:0] d6_reg1,d6_reg2,d6_reg3,d6_reg4,d6_reg5;
    reg [M-1:0] d7_reg1,d7_reg2,d7_reg3,d7_reg4,d7_reg5,d7_reg6;
    reg [M-1:0] d8_reg1,d8_reg2,d8_reg3,d8_reg4,d8_reg5,d8_reg6,d8_reg7;
    reg [M-1:0] d9_reg1,d9_reg2,d9_reg3,d9_reg4,d9_reg5,d9_reg6,d9_reg7,d9_reg8;
    
    wire [M-1:0] dout,dout_0,dout_1,dout_2;//行缓冲输出的三个值
    wire flag; //行缓冲准备完成
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n ) begin
            count_x <=0;
            count_y <=0;
            fmap_finish <= 0;
        end
        else if(valid_in && flag)
        if (count_y < SP-1) begin   //0-415
            count_y <= count_y + 1;
        end
        else if (count_x < 255+2)begin
            count_y <= 0;
            count_x <= count_x +1;
        end
        else begin
            count_x <= 0;
            count_y <= 0;
        end
    else begin
        count_x <= count_x;
        count_y <= count_y;
    end
    end
    
    reg enb;
        
      wire [8:0] addr_w;
      assign addr_w = count_y;
    
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            enb <= 0;
        end
        else if ((count_y <2 ) && valid_in) begin
            enb <= 0;
        end
        else if ((count_y < SP && valid_in) || repeat_in) begin
            enb <= 1;
        end
        else begin
            enb <= 0;
        end
    end
    
    assign wea = valid_in;
    
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            addr_r1 <= 0;
            addr_r2 <= 1;
            addr_r3 <= 2;
        end
        else if (enb)
            if (addr_r1 ==479) begin 
                addr_r1 <= 0;
                addr_r2 <= 1;
                addr_r3 <= 2;
                end
            else begin
                addr_r1 <= addr_r1+1;
                addr_r2 <= addr_r2+1;
                addr_r3 <= addr_r3+1;
            end 
    end
    reg f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15;
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            f1 <= 0;
        end
        else  if (addr_r1 ==479) begin 
            f1 <= 1;
        end
        else begin
            f1 <= 0;
        end
    end    
    
    always @(posedge clk)begin
       if (!Rst_n) begin
            f2 <= 0;
            f3 <= 0;
            f4 <= 0;
            f5 <= 0;
            f6 <= 0;
            f7 <= 0;
            f8 <= 0;
            f9 <= 0;
            f10 <= 0;
            f11 <= 0;
            f12 <= 0;
            f13 <= 0;
            f14 <= 0;
            f15 <= 0;
            fmap_finish <= 0;
         end
         else begin
            f2 <= f1;
            f3 <= f2;
            f4 <= f3;
            f5 <= f4;
            f6 <= f5;
            f7 <= f6;
            f8 <= f7;
            f9 <= f8;
            f10 <= f9;
            f11 <= f10;
            f12 <= f11;
            f13 <= f12;
            f14 <= f13;
            f15 <= f14;
            fmap_finish <= f15;
        end
    end  

    //对enb信号延时11拍得到valid_out信号。
    reg v_reg1,v_reg2,v_reg3,v_reg4,v_reg5,v_reg6,v_reg7,v_reg8,v_reg9,v_reg10,v_reg11,v_reg12;
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            valid_out1 <= 0;
            valid_out2 <= 0;
        end
        else begin
            v_reg1 <= enb; 
            v_reg2 <= v_reg1;
            v_reg3 <= v_reg2;
            v_reg4 <= v_reg3;
            v_reg5 <= v_reg4;
            v_reg6 <= v_reg5;
            v_reg7 <= v_reg6;
            v_reg8 <= v_reg7;
            v_reg9 <= v_reg8;
            v_reg10 <= v_reg9;
            v_reg11 <= v_reg10;
            v_reg12 <= v_reg11;
            valid_out1 <= v_reg11;
            valid_out2 <= v_reg11;
        end
    end
    
    assign compute_SA = (enb || valid_out2) ? 1'b1:1'b0;
	wire [M-1:0] data1_in,data2_in,data3_in,data4_in,data5_in,data6_in,data7_in,data8_in,data9_in;
	
    always @(posedge clk or negedge Rst_n) begin
        if (!Rst_n) begin
            d1 <= 0;
            d2_reg1 <= 0;
            d3_reg1 <= 0;
            d4_reg1 <= 0;
            d5_reg1 <= 0;
            d6_reg1 <= 0;
            d7_reg1 <= 0;
            d8_reg1 <= 0;
            d9_reg1 <= 0;
        end
        else if (compute_SA)begin
            d1 <= data1_in;
            d2_reg1 <= data2_in;
            d3_reg1 <= data3_in;
            d4_reg1 <= data4_in;
            d5_reg1 <= data5_in;
            d6_reg1 <= data6_in;
            d7_reg1 <= data7_in;
            d8_reg1 <= data8_in;
            d9_reg1 <= data9_in;
        end
    end
    
    always @(posedge clk) begin
        if(compute_SA) 
            d2 <= d2_reg1;
    end
    always @(posedge clk) begin
        if(compute_SA) begin
        d3_reg2 <= d3_reg1;
        d3 <= d3_reg2;
    end
    end
    always @(posedge clk) begin
        if(compute_SA) begin
        d4_reg2 <= d4_reg1;
        d4_reg3 <= d4_reg2;
        d4 <= d4_reg3;
        end
    end
    always @(posedge clk) begin
        if(compute_SA) begin
            d5_reg2 <= d5_reg1;
            d5_reg3 <= d5_reg2;
            d5_reg4 <= d5_reg3;
            d5 <= d5_reg4;
        end
    end     
    
    always @(posedge clk) begin
        if(compute_SA) begin
            d6_reg2 <= d6_reg1;
            d6_reg3 <= d6_reg2;
            d6_reg4 <= d6_reg3;
            d6_reg5 <= d6_reg4;
            d6 <= d6_reg5;
        end
    end  
    always @(posedge clk) begin
        if(compute_SA) begin
            d7_reg2 <= d7_reg1;
            d7_reg3 <= d7_reg2;
            d7_reg4 <= d7_reg3;
            d7_reg5 <= d7_reg4;
            d7_reg6 <= d7_reg5;
            d7 <= d7_reg6;
         end
    end  
    always @(posedge clk)begin
        if(compute_SA) begin 
            d8_reg2 <= d8_reg1;
            d8_reg3 <= d8_reg2;
            d8_reg4 <= d8_reg3;
            d8_reg5 <= d8_reg4;
            d8_reg6 <= d8_reg5;
            d8_reg7 <= d8_reg6;
            d8 <= d8_reg7;
        end
    end  
    always @(posedge clk) begin
        if(compute_SA) begin
            d9_reg2 <= d9_reg1;
            d9_reg3 <= d9_reg2;
            d9_reg4 <= d9_reg3;
            d9_reg5 <= d9_reg4;
            d9_reg6 <= d9_reg5;
            d9_reg7 <= d9_reg6;
            d9_reg8 <= d9_reg7;
            d9 <= d9_reg8;
        end
    end  
    LineBuffer #(M,SP,256,3)  lb(clk,Rst_n,valid_in,din,dout,dout_0,dout_1,dout_2,flag);
    blk_mem_gen_1 smb1(.clka(clk),.addra(addr_w),.dina(dout_2),.wea(wea),.clkb(clk),.addrb(addr_r1),.doutb(data1_in),.enb(enb));
    blk_mem_gen_1 smb2(.clka(clk),.addra(addr_w),.dina(dout_2),.wea(wea),.clkb(clk),.addrb(addr_r2),.doutb(data2_in),.enb(enb));
    blk_mem_gen_1 smb3(.clka(clk),.addra(addr_w),.dina(dout_2),.wea(wea),.clkb(clk),.addrb(addr_r3),.doutb(data3_in),.enb(enb));
    blk_mem_gen_1 smb4(.clka(clk),.addra(addr_w),.dina(dout_1),.wea(wea),.clkb(clk),.addrb(addr_r1),.doutb(data4_in),.enb(enb));
    blk_mem_gen_1 smb5(.clka(clk),.addra(addr_w),.dina(dout_1),.wea(wea),.clkb(clk),.addrb(addr_r2),.doutb(data5_in),.enb(enb));
    blk_mem_gen_1 smb6(.clka(clk),.addra(addr_w),.dina(dout_1),.wea(wea),.clkb(clk),.addrb(addr_r3),.doutb(data6_in),.enb(enb));
    blk_mem_gen_1 smb7(.clka(clk),.addra(addr_w),.dina(dout_0),.wea(wea),.clkb(clk),.addrb(addr_r1),.doutb(data7_in),.enb(enb));
    blk_mem_gen_1 smb8(.clka(clk),.addra(addr_w),.dina(dout_0),.wea(wea),.clkb(clk),.addrb(addr_r2),.doutb(data8_in),.enb(enb));
    blk_mem_gen_1 smb9(.clka(clk),.addra(addr_w),.dina(dout_0),.wea(wea),.clkb(clk),.addrb(addr_r3),.doutb(data9_in),.enb(enb));
endmodule
