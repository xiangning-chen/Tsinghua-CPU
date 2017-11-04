// UART_sender.v

module UART_sender(UART_TX, TX_DATA, TX_EN, TX_STATUS, sysclk, resetb);
output reg UART_TX;
output TX_STATUS;
input [7:0] TX_DATA;
input TX_EN, sysclk, resetb;

reg [7:0] DATA;
reg [3:0] label; // F means send forbidden
reg data_sending;

always @ (negedge resetb or posedge sysclk) begin
    if (~resetb) begin
        DATA <= 0;
        UART_TX <= 1;
        label <= 4'hf;
        data_sending <= 0;
    end
    else if (~data_sending && TX_EN) begin
        data_sending <= 1;
        DATA [7:0] <= TX_DATA;
        UART_TX <= 0;
        label <= 4'h0;
    end
    else if (data_sending) begin
        if (label == 8) begin
            UART_TX <= 1;
            label <= 4'hf;
            data_sending <= 0;
        end
        else if (label == 4'hf);
        else begin
            UART_TX <= DATA[label];
            label <= label + 1;
        end
    end
end

assign TX_STATUS = (label == 4'hf);  

endmodule