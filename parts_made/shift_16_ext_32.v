module shift_16_ext_32 (
    input wire [15:0] imediato,
    output wire [31:0] data_out
);
    
    assign data_out = {imediato, 16'b0};

endmodule
