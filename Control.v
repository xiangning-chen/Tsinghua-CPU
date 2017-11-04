module Control(Instruction,IRQ,JT,Imm16,Shamt,Rd,Rt,Rs,PCSrc,RegDst,
	RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);

//IRQ means interruption, JT is jump target
input [31:0] Instruction;
input IRQ;
output [25:0] JT;
output [15:0] Imm16;
output [5:0] ALUFun;
output [4:0] Shamt, Rd, Rt, Rs;
output [2:0] PCSrc;
output [1:0] RegDst,MemToReg;
output RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;

wire [5:0] OpCode,Funct;

assign OpCode = Instruction[31:26];
assign Funct = Instruction[5:0];
assign Rs = Instruction[25:21];    
assign Rt = Instruction[20:16];    
assign Rd = Instruction[15:11];    
assign Shamt = Instruction[10:6];  
assign Imm16 = Instruction[15:0];  
assign JT = Instruction[25:0];    

wire OpCode_Undefined;		//judge undefined OpCode
assign OpCode_Undefined = (OpCode == 6'b000000 || OpCode == 6'b000001 || 
	OpCode == 6'b000010 || OpCode == 6'b000011 || OpCode == 6'b000100 || 
	OpCode == 6'b000101 || OpCode == 6'b000110 || OpCode == 6'b000111 || 
	OpCode == 6'b001000 || OpCode == 6'b001001 || OpCode == 6'b001010 || 
	OpCode == 6'b001011 || OpCode == 6'b001100 || OpCode == 6'b001111 || 
	OpCode == 6'b100011 || OpCode == 6'b101011);

//PCSrc(4 means interruption while 5 means abnormal)
assign PCSrc = IRQ ? 3'd4 : OpCode_Undefined ? 3'd5 : (OpCode == 6'b0000001 ||
	OpCode == 6'b000100 || OpCode == 6'b000101 || OpCode == 6'b000110 || 
	OpCode == 6'b000111) ? 3'd1 : (OpCode == 6'b000010 || 
	OpCode == 6'b000011) ? 3'd2 : (OpCode == 6'b000000 && (Funct == 6'b001000 ||
		Funct == 6'b001001)) ? 3'd3 : 3'd0;

//RegDst(3 means interruption or abnormal)
assign RegDst = (IRQ || OpCode_Undefined) ? 2'd3 : (OpCode == 6'b000000) ? 2'd0 :
	(OpCode == 6'b000011) ? 2'd2 : 2'd1;

//RegWr(1 means interruption or abnormal)
assign RegWr = (IRQ || OpCode_Undefined) ? 1'b1 : (OpCode == 6'b101011 ||
	OpCode == 6'b000100 || OpCode == 6'b000101 || OpCode == 6'b000110 ||
	OpCode == 6'b000111 || OpCode == 6'b000001 || OpCode == 6'b000010 ||
	(OpCode == 6'b000000 && Funct == 6'b001000)) ? 1'b0 : 1'b1;

//ALUSrc1
assign ALUSrc1 = ((OpCode == 6'b000000) && (Funct == 6'b000000 ||
	Funct == 6'b000010 || Funct == 6'b000011)) ? 1'b1 : 1'b0;

//ALUSrc2
assign ALUSrc2 = (OpCode == 6'b000000 || OpCode == 6'b000001 || OpCode == 6'b000100 ||
	OpCode == 6'b000101 || OpCode == 6'b000110 || OpCode == 6'b000111) ? 1'b0 : 1'b0;

//Sign
assign Sign = (OpCode == 6'b000100 || OpCode == 6'b000101 
	|| OpCode == 6'b000110 || OpCode == 6'b000111 || 
	OpCode == 6'b000001) ? 1'b1 : (OpCode == 6'b000000) ? ~Funct[0] : ~OpCode[0];

//MemWr
assign MemWr = (OpCode == 6'b101011) ? 1'b1 : 1'b0;

//MemRd
assign MemRd = (OpCode == 6'b100011) ? 1'b1 : 1'b0;

//MemToReg(3 means interruption, while 2 means abnormal)
assign MemToReg = IRQ ? 2'd3 : OpCode_Undefined ? 2'd2 : (OpCode == 6'b000011 ||
	(OpCode == 6'b000000 && Funct == 6'b001001)) ? 2'd2 : (OpCode == 6'b100011) ? 2'b1 : 2'b0;

//EXTOp
assign EXTOp = (OpCode == 6'b001100) ? 1'b0 : 1'b1;

//LUOp
assign LUOp = (OpCode == 6'b001111) ? 1'b1 : 1'b0;

//ALUFun
assign ALUFun = (OpCode == 6'b000000 && (Funct == 6'b100010 || 
	Funct == 6'b100011)) ? 6'b000001 : ((OpCode == 6'b000000 && 
	Funct == 6'b100100) || OpCode == 6'b001100) ? 6'b011000 : (OpCode == 6'b000000 && 
	Funct == 6'b100101) ? 6'b011110 : (OpCode == 6'b000000 && 
	Funct == 6'b100110) ? 6'b010110 : (OpCode == 6'b000000 && 
	Funct == 6'b100111) ? 6'b010001 : (OpCode == 6'b000000 && 
	Funct == 6'b000000) ? 6'b100000 : (OpCode == 6'b000000 && 
	Funct == 6'b000010) ? 6'b100001 : (OpCode == 6'b000000 && 
	Funct == 6'b000011) ? 6'b100011 : ((OpCode == 6'b000000 && 
		(Funct == 6'b101010 || Funct == 6'b101011)) || OpCode == 6'b001010 || OpCode == 6'b001011 || 
	OpCode == 6'b000001) ? 6'b110101 : (OpCode == 6'b000100) ? 6'b110011 : (OpCode == 
	6'b000101) ? 6'b110001 : (OpCode == 6'b000110) ? 6'b111101 : (OpCode == 
	6'b000111) ? 6'b111111 : 6'b000000;

endmodule





















