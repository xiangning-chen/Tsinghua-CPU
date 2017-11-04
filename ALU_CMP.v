module ALU_CMP(Z,V,N,op,Result);

//Z为0标志，V为溢出标志，N为结果为负标志，op为ALUFun[3:1]，Result为32位输出

input Z,V,N;
input [2:0] op;
output reg [31:0] Result;

always @(*)
begin
	case(op)
		3'b001: Result <= {31'b0,Z}; 			//EQ
		3'b000: Result <= {31'b0,~Z};			//NEQ
		3'b010: Result <= {31'b0,N};			//LT
		3'b110: Result <= {31'b0,N|Z};			//LEZ
		3'b101: Result <= {31'b0,N};			//LTZ
		3'b111: Result <= {31'b0,(~N)&(~Z)};	//GTZ
		default: Result <= 0;
	endcase
end
endmodule