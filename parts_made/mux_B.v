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
    input wire [31:0] sign_ext_out,
    input wire [31:0] ext_shift_out,
    output wire [31:0] data_out
);
    wire [31:0] out1, out2;

    assign out1 = (selector[0]) ? 32'd4 : data_0;
    assign out2 = (selector[0]) ? ext_shift_out : sign_ext_out;
    assign data_out =  (selector[1]) ? out2 : out1;



    // always @(*) begin
    //     case(selector)
    //         3'b00 : assign data_out = data_0; 
            
    //         3'b01 : assign data_out = 32'd4; 
       
    //         3'b10 : assign data_out = sign_ext_out; 
        
    //         3'b11 : assign data_out = ext_shift_out; 
    //     endcase
    // end
endmodule