module ALU_Logic(A,B,op,Result);

//A,B为两个32位输入，op为ALUFun[3:0]，Result为输出结果

input [31:0] A,B;
input [3:0] op;
output reg [31:0] Result;

always @(*)
begin
	case(op)
		4'b1000: Result <= A&B;		//AND
		4'b1110: Result <= A|B;		//OR
		4'b0110: Result <= A^B;		//XOR
		4'b0001: Result <= ~(A|B);	//NOR
		4'b1010: Result <= A;		//"A"
		default: Result <= 0;
	endcase
end
endmodule