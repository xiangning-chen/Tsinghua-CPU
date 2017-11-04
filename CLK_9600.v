module CLK_9600(sysclk,clk_9600);

input sysclk;
output reg clk_9600;

reg [9:0] count;

initial
begin
	count <= 0;
	clk_9600 <= 0;
end

always @(posedge sysclk)
begin
	if(count == 10'd2604)
	begin	
		count <= 0;
		clk_9600 <= ~clk_9600;
	end
	else begin
		count <= count + 1;
	end
end
endmodule