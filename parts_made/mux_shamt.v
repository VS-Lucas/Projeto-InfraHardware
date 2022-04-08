module mux_shamt (
    input wire [1:0] selector,
    input wire [31:0] data_0,
    input wire [15:0] data_1,
    input wire [31:0] data_2,
    output reg [4:0] data_out
);

    always @(*) begin
        case(selector)
            2'b00 : data_out = data_0[4:0];
            2'b01 : data_out = data_1[10:6];
            2'b10 : data_out = data_2[4:0]; //VERIFICAR COM ANTONIO
        endcase
    end


    // assign out1 = (selector[0]) ? data_1[10:6] : data_0[4:0];
    // assign data_out = (selector[1]) ? data_2[4:0] : out1; // PRECISA SER REVISADO A SAÍDA DO MDR QUE ENTRA NESSE MUX

endmodule
