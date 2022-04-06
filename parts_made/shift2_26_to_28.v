module shift2_26_to_28 (
    input wire [25:0] data_0,
    output wire [27:0] data_out
);
    wire [27:0] data_aux;

    assign data_aux = {data_0, 2'b0};
    assign data_out = data_aux << 2;
    
endmodule