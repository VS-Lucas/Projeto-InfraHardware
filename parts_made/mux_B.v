/*
    MUX_B seleciona a saída:
    - Valor de B
    - 4
    - Sinal extendido 16-32
    - Sinal extendido + shift left 2
*/


module mux_B(
    input wire [1:0] selector,
    input wire [31:0] data_0,
    input wire [31:0] data_1,
    input wire [31:0] sign_ext_out,
    input wire [31:0] ext_shift_out,
    output wire [31:0] data_out
);

    always @(data_0 or data_1 or sign_ext_out or ext_shift_out or selector) begin
        case(selector)
            3'b00 : data_out = data_0;
            3'b01 : data_out = data_1;
            3'b10 : data_out = sign_ext_out;
            3'b11 : data_out = ext_shift_out;
        endcase

    end
endmodule