module SSize (
    input wire [1:0] sel,
    input wire [31:0] mem_out,
    input wire [31:0] b_out,
    output reg [31:0] data_out
);
    
    always @(*) begin
        case(sel)
            2'b00: data_out = {mem_out[31:16], b_out[15:0]};
            2'b01: data_out = {mem_out[31:8], b_out[7:0]};
            2'b10: data_out = b_out;
        endcase
    end
    
endmodule
