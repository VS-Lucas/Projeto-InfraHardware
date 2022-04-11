module LSize (
    input wire [1:0] sel,
    input wire [31:0] mdr_out,
    output reg [31:0] data_out
);
    
    always @(*) begin
        case(sel)
            2'b00: data_out = mdr_out;
            2'b01: data_out = {16'b0, mdr_out[15:0]};
            2'b10: data_out = {24'b0, mdr_out[7:0]};
        endcase
    end
    
endmodule
