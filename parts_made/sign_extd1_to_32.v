module sign_extd1_to_32 (
    input wire data_0,
    output wire [31:0] data_out
);
    assign data_out = {31'b0, data_0};

endmodule