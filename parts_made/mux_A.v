/*
    MUX_A seleciona a saída:
    - P+4
    - Valor do registrador A 
*/

module mux_A(
    input wire [1:0] selector,
    input wire [31:0] data_0,
    input wire [31:0] data_1,
    input wire [31:0] data_2,
    output reg [31:0] data_out
);

    always @(*) begin
        case(selector)
            2'b00: data_out = data_0;
            2'b01: data_out = data_1;
            2'b10: data_out = data_2;
        endcase
    end

endmodule
