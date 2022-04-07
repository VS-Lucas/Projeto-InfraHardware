/*
    MUX_WREG seleciona a saída a partir das entradas de:
    - rt
    - 29
    - 31
    - rd
    
*/


module mux_wreg(
    input wire [1:0] selector,
    input wire [4:0] data_0,
    input wire [15:0] data_3, 
    output reg [4:0] data_out
);


    always @(*) begin
        case(selector)
            2'b00 : data_out = data_0;
            2'b01 : data_out = 5'd29;
            2'b10 : data_out = 5'd31;
            2'b11 : data_out = data_3[15:11];
        endcase 
    end
     
endmodule
