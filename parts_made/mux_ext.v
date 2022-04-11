module mux_ext (
    input wire sel,
    input wire [15:0] imediato,
    input wire [15:0] mdr_out,
    output wire [15:0] data_out 
);
    
    assign data_out = (sel) ? mdr_out : imediato;  

endmodule