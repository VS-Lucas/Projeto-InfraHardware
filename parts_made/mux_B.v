/*
    MUX_B seleciona a saída:
    - Valor de B
    - 4
    - Sinal extendido 16-32
    - Sinal extendido + shift left 2
*/


module mux_B(
    input wire [2:0] selector,
    input wire [31:0] data_0,
    input wire [31:0] signExt_out,
    input wire [31:0] ext_shift_out,
    input wire [31:0] men_out,
    output reg [31:0] data_out
);
    wire [31:0] out1, out2;


    always @(*) begin
        case(selector)
            3'b000 : assign data_out = data_0; 
            
            3'b001 : assign data_out = 32'd4; 
       
            3'b010 : assign data_out = signExt_out; 
        
            3'b011 : assign data_out = ext_shift_out;

            3'b100 : assign data_out = men_out;
        endcase
    end
endmodule
