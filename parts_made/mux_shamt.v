module mux_shamt(
    input wire [1:0] selector,
    input wire [31:0] data_0,
    input wire [31:0] data_1,
    output wire [31:0] data_out
);



    wire [31:0] A1;


    assign A1 = (selector[0]) ? ;
    assign data_out = (selector[1]) ? data_1 : A1;