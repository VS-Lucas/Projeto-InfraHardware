module SSize (
    input wire sel,
    input wire [31:0] mem_out,
    input wire [31:0] b_out,
    output reg [31:0] data_out
);
    
    always @(*) begin
        case(sel)
            1'b0: data_out = {mem_out[31:16], b[15:0]};
            1'b1: data_out = {mem_out[31:8], b_out[7:0]};
        endcase
    end
    
endmodule
