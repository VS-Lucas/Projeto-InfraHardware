module mux_ALUOut(
    input wire [2:0] selector,
    input wire [31:0] data_0,
    input wire [31:0] data_1,
    input wire [31:0] ext26_to_28,
    input wire [31:0] EPCOut,
    input wire [31:0] sign_ext_out,
    input wire [31:0] mux_mem_out,
    output wire [31:0] data_out
);

    always @(data_0, or data_1 or ext26_to_28 or EPCOut or sign_ext_out or mux_mem_out or data_out) begin
        case(selector)
            3'b000 : data_out = data_0
            3'b001 : data_out = data_1
            3'b010 : data_out = ext26_to_28
            3'b011 : data_out = EPCOut
            3'b100 : data_out = sign_ext_out
            3'b101 : data_out = mux_mem_out
        endcase
    end

endmodule