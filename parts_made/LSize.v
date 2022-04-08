module LSize (
    input wire [1:0] sel,
    input wire [31:0] mdr_out,
    output reg [31:0] data_out
);
    
    always @(*) begin
        case(sel)
            2'b11: data_out = mdr_out;
        endcase
    end
    
endmodule