module shift2_26_to_28_pc (
    input wire [25:0] data_0,
    input wire [31:28] pc,
    output wire [27:0] data_out
);
    wire [27:0] data_aux;

    assign data_aux = {data_0, 2'b0};
    assign data_out = {pc, data_aux};
    
endmodule