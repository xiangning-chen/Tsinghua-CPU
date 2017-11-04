module CPU(reset,sysclk,switch,UART_RX,UART_TX,digi1,digi2,digi3,digi4,led);

//the top level cpu

input reset,sysclk,UART_RX;
input [7:0] switch;
output UART_TX;
output [6:0] digi1,digi2,digi3,digi4;
output [7:0] led;

//deal with rom
wire [31:0] Instruction;
ROM rom(PC,Instruction);

//deal with control
wire [25:0] JT;
wire [15:0] Imm16;
wire [4:0] Shamt, Rd, Rt, Rs;
wire IRQ,RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
wire [1:0] RegDst,MemToReg;
wire [2:0] PCSrc;
wire [5:0] ALUFun;
Control control(Instruction,IRQ,JT,Imm16,Shamt,Rd,Rt,Rs,PCSrc,RegDst,
	RegWr,ALUSrc1,ALUSrc2,ALUFun,Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);

//deal with RegFile
//R_Type : Rd; I_Type :Rt; jal/jalr : Ra; Interruption or abnormal : 26
wire [4:0] register_write_num;
wire [31:0] data1,data2,data3;
assign register_write_num = (RegDst == 2'b00) ? Rd : 
	(RegDst == 2'b01) ? Rt : (RegDst == 2'b10) ? 5'd31 : 5'd26;
RegFile regfile(reset,sysclk,Rs,data1,Rt,data2,RegWr,register_write_num,data3);

//deal with ALU
//DatabusA&B are 32-bits input, ALU_Out is 32-bits ouput
wire [31:0] DatabusA, DatabusB, ALU_Out;
//sll,srl,sra
assign DatabusA = ALUSrc1 ? {27'b0, Shamt} : data1;

//EXT output 
wire [31:0] Imm32;
assign Imm32 = {{16{Imm16[15] & EXTOp}},Imm16};

//LUOp output
wire [31:0] LUOp_output;
assign LUOp_output = LUOp ? {Imm16,16'b0} : Imm32;
assign DatabusB = ALUSrc2 ? LUOp_output : data2;
ALU alu(DatabusA,DatabusB,ALUFun,Sign,ALU_Out);

//deal with DataMem
//devide the data in DataMem and outer space
//Read_data1 is the output of DataMem
wire [31:0] Read_data, Read_data1, Read_data2;
assign Read_data = ALU_Out[30] ? Read_data2 : Read_data1;
wire MemWr1 = ALU_Out[30] ? 0 : MemWr;
wire MemWr2 = ALU_Out[30] ? MemWr : 0;
DataMem datamem(reset,sysclk,MemRd,MemWr1,ALU_out,data2,Read_data1);


//deal with Peripheral
Peripheral peripheral(reset,sysclk,)

//deal with PC
PC pc(sysclk,reset,PCSrc,ALU_Out[0],JT,ConBA,A,PC);

//deal with digitube_scan
digitube_scan scan(digi,digi1,digi2,digi3,digi4)


endmodule
































