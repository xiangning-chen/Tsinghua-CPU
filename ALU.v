module ALU(A,B,ALUFun,Sign,ALU_Out);

//A&B are two 32-bits input, ALUFun is 6-bits Op
//Sign = 0 means unsigned
//ALU_Out is 32-bits output

input [31:0] A,B;
input [5:0] ALUFun;
input Sign;
output reg [31:0] ALU_Out;

wire [31:0] R1,R2,R3,R4;
wire Z,V,N;
wire [1:0] op;
assign op = ALUFun[5:4];

ALU_add_sub alu_add_sub(A,B,ALUFun[0],Sign,R1,Z,V,N);
ALU_CMP alu_cmp(Z,V,N,ALUFun[3:1],R2);
ALU_Logic alu_logic(A,B,ALUFun[3:0],R3);
ALU_Shift alu_shift(A,B,ALUFun[1:0],R4);

always @(*)
begin
	case(op)
	2'b00: ALU_Out = R1;
	2'b11: ALU_Out = R2;
	2'b10: ALU_Out = R3;
	2'b01: ALU_Out = R4;
	endcase
end
endmodule