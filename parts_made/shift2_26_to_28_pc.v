module shift2_26_to_28_pc (
    input wire [4:0] rs,
    input wire [4:0] rt,
    input wire [15:0] imediato,
    input wire [31:28] pc,
    output wire [31:0] data_out
);
    reg [27:0] data_aux;
    reg [9:0] aux;
    reg [25:0] aux2;

    assign aux = {rs, rt};
    assign aux2 = {aux, imediato};

    assign data_aux = {aux2, 2'b0};
    assign data_out = {pc, data_aux};
    
endmodule
