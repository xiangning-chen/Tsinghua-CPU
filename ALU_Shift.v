module ALU_Shift(A,B,op,Result);

//A&B are 32-bits input, op is ALUFun[1:0], Result is 32-bits output

input [31:0] A,B;
input [1:0] op;
output [31:0] Result;

wire [4:0] move;
assign move = A[4:0];
reg [31:0] Shift_16,Shift_8,Shift_4,Shift_2,Shift_1;

always @(*)
begin
	case(op)
		2'b00: 				//SLL
		begin
			if(A[4]) 
				Shift_16 = {B[15:0],16'b0};
          	else 
          		Shift_16 = B;
          	if(A[3]) 
          		Shift_8 = {Shift_16[23:0],8'b0};
          	else 
          		Shift_8 = Shift_16;
          	if(A[2]) 
          		Shift_4 = {Shift_8[27:0],4'b0};
          	else 
          		Shift_4 = Shift_8;
          	if(A[1]) 
          		Shift_2 = {Shift_4[29:0],2'b0};
          	else 
          		Shift_2 = Shift_4;
          	if(A[0]) 
          		Shift_1 = {Shift_2[30:0],1'b0};
         	else 
         		Shift_1 = Shift_2;
		end
		2'b01:				//SRL
		begin
			if(A[4]) 
				Shift_16 = {16'b0,B[31:16]};
          	else 
          		Shift_16 = B;
          	if(A[3]) 
          		Shift_8 = {8'b0,Shift_16[31:8]};
          	else 
          		Shift_8 = Shift_16;
          	if(A[2]) 
          		Shift_4 = {4'b0,Shift_8[31:4]};
          	else 
          		Shift_4 = Shift_8;
          	if(A[1]) 
          		Shift_2 = {2'b0,Shift_4[31:2]};
          	else 
          		Shift_2 = Shift_4;
          	if(A[0]) 
          		Shift_1 = {1'b0,Shift_2[31:1]};
         	else 
         		Shift_1 = Shift_2;
		end
		2'b11:				//SRA
		begin
			if(A[4] && B[31] == 0) 
				Shift_16 = {16'b0,B[31:16]};
          	else if(A[4] && B[31] == 1) 
          		Shift_16 = {16'b1111_1111_1111_1111,B[31:16]};
          	else 
          		Shift_16 = B;
          	if(A[3] && B[31] == 0) 
          		Shift_8 = {8'b0,Shift_16[31:8]};
          	else if(A[3] && B[31] == 1) 
          		Shift_8 = {8'b1111_1111,Shift_16[31:8]};
          	else 
          		Shift_8 = Shift_16;
          	if(A[2] && B[31] == 0) 
          		Shift_4 = {4'b0,Shift_8[31:4]};
          	else if(A[2] && B[31] == 1) 
          		Shift_4 = {4'b1111,Shift_8[31:4]};
          	else 
          		Shift_4 = Shift_8;
          	if(A[1] && B[31] == 0) 
          		Shift_2 = {2'b0,Shift_4[31:2]};
          	else if(A[1] && B[31] == 1) 
          		Shift_2 = {2'b11,Shift_4[31:2]};
          	else 
          		Shift_2 = Shift_4;
          	if(A[0] && B[31] == 0) 
          		Shift_1 = {1'b0,Shift_2[31:1]};
          	else if(A[0] && B[31] == 1) 
          		Shift_1 = {1'b1,Shift_2[31:1]};
          	else 
          		Shift_1 = Shift_2;
		end
	endcase
end
assign Result = Shift_1;
endmodule





