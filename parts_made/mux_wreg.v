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
    output wire [4:0] data_out
);
    //    01
    wire [31:0] out1, out2;

    assign out1 = (selector[0]) ? 32'b000000000000000000000000000011101 : data_0;
    assign out2 = (selector[0]) ? data_3[15:11] : 5'd31;
    assign data_out  = (selector[1]) ? out2 : out1;

    // always @(data_0 or data_3 or selector) begin
    //     case(selector)
    //         2'b00 : data_out = data_0;
    //         2'b01 : data_out = 5'd29;
    //         2'b10 : data_out = 5'd31;
    //         2'b11 : data_out = data_3;
    //     endcase 
    // end
     
endmodule