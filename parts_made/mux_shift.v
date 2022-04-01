// ----------------------------------------------
//     Mux do valor que vai ser shiftado
// ----------------------------------------------

module mux_shift(
    input wire [1:0] selector,
    input wire [31:0] data_0,
    input wire [31:0] data_1,
    output wire [31:0] data_out
);
    
    assign data_out = (selector) ? data_1 : data_0;

endmodule