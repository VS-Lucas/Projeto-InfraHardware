/*
    MUX_A seleciona a saída:
    - P+4
    - Valor do registrador A 
*/

module mux_A(
    input wire [1:0] selector,
    input wire [31:0] data_0,
    input wire [31:0] data_1,
    output wire [31:0] data_out
);

    assign data_out = (selector) ? data_1 : data_0;

endmodule