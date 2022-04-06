module mux_shamt (
    input wire [1:0] selector,
    input wire [31:0] data_0,
    input wire [15:0] data_1,
    input wire [31:0] data_2,
    output wire [4:0] data_out
);
    wire [4:0] out1;


    assign out1 = (selector[0]) ? data_1[10:6] : data_0[4:0];
    assign data_out = (selector[1]) ? data_2[4:0] : out1; // PRECISA SER REVISADO A SAÍDA DO MDR QUE ENTRA NESSE MUX

endmodule