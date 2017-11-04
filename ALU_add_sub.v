module ALU_add_sub(A,B,op,Sign,Result,Z,V,N);

//A,B为两个32位输入，op为ALUFun[0]（1为sub，0为add）
//Sign为符号位标志（1为有符号，0为无符号）
//Result为32位输出，Z为0标志，V为溢出标志，N为结果为负标志

input [31:0] A,B;
input op,Sign;
output [31:0] Result;
output Z,V,N;

reg [31:0] NB;			//B或B的补码
reg [32:0] T_Result;	//真实结果
wire Sign_V;

always @(*)
begin
NB = B;
	if(Sign)
	begin
		if(op)
		begin
			NB = ~B + 1;
		end
		else begin
			NB = B;
		end
	end
	T_Result = A + NB;
end

assign Result = T_Result[31:0];
//判断是否为0只需按位取或再取反
assign Z = ~(|Result);

//只有符号位都为1，且输出高位为0才溢出
assign Sign_V = (A[31 && NB[31]]) ? ~Result[31]: 0;			
//如为无符号数，直接判断T_Result高位即可
assign V = (~Sign) ? T_Result[32] : Sign_V;		

//如为无符号数，则必为正数，否则由高位判断
assign N = (~Sign) ? 0 : T_Result[31];
endmodule

module Test_add_sub;
reg [31:0]A,B;
reg op,Sign;
initial 
begin
	A=32'd3;
	B=32'd5;
	Sign=1;
	op=1;
end
ALU_add_sub ZY(A,B,op,Sign,S,Z,V,N);
endmodule

