module mux_writeData(
    input wire [2:0] selector,
    input wire [31:0] data_0,
    input wire [31:0] data_1,
    input wire [31:0] data_2,
    input wire [31:0] data_3,
    input wire [31:0] data_4,
    input wire [31:0] data_5,
    input wire [31:0] data_6,
    output reg [31:0] data_out
);
    
    // wire [31:0] out1, out2, out3, out4, out5, out6;


    // assign out1 = (selector[0]) ? data_1 : data_0;
    // assign out2 =  (selector[0]) ? data_3 : data_2;
    // assign out3 = (selector[1]) ? out2 : out1;
    // assign out4 =  (selector[0]) ? data_5 : data_4;
    // assign out5 = (selector[0]) ? 32'd227 : data_6;
    // assign out6 = (selector[1]) ? out5 : out4;
    // assign data_out  = (selector[2]) ? out6 : out3;

    always @(*)begin
        case(selector)
            3'b000 : data_out = data_0;
            3'b001 : data_out = data_1;
            3'b010 : data_out = data_2;
            3'b011 : data_out = data_3;
            3'b100 : data_out = data_4;
            3'b101 : data_out = data_5;
            3'b110 : data_out = data_6;
            3'b111 : data_out = 32'd227;
        endcase
    end

endmodule
