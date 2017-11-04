module PC(clk,reset,PCSrc,ALUOut,JT,ConBA,DatabusA,PC,PC_31);

//deal with PC
input ALUOut, clk, reset;
input [2:0] PCSrc;
input [25:0] JT;
input [31:0] DatabusA,ConBA;
output reg [31:0] PC;
output reg PC_31;

parameter RESET = 32'h80000000;
parameter ILLOP = 32'h80000004;
parameter XADR = 32'h80000008;

always @(posedge clk or posedge reset) begin
 	if (reset) begin
 		PC <= RESET;
 	end
 	else begin
 		case(PCSrc)
 			3'b000 : PC <= {PC[31],PC[30:0] + 31'd4};
 			3'b001 : PC <= ALUOut ? ConBA : {PC[31],PC[30:0] + 31'd4};
 			3'b010 : PC <= {PC[31:28],JT,2'b0};
 			3'b011 : PC <= DatabusA;
 			3'b100 : PC <= ILLOP;
 			3'b101 : PC <= XADR;
 		endcase
 	end
	PC_31 <= PC[31];
 end 
 endmodule