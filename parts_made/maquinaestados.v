// MÁQUINA DE ESTADOS
module unidade_controle(
    input wire       clk,
    input wire       reset,
    
    input wire       Of,
    input wire       Ng,
    input wire       Zr,
    input wire       Eq,
    input wire       Gt,
    input wire       Lt,

    input wire [5:0] OPCODE,
    
    output reg       PC_w,
    output reg [2:0] M_selector_Memory,
    output reg       MEM_w,
    output reg       IR_w,
    output reg [1:0] M_selector_writereg,
    output reg [2:0] M_selector_WDATA,
    output reg       RB_w,
    output reg       AB_w,
    output reg       M_selector_A,
    output reg [1:0] M_selector_B,
    output reg [2:0] ULA_c,
    output reg       ALU_w,
    output reg [2:0] M_selector_ALUOut,
    output reg reset_out
);


    reg [1:0] state; // estados
    reg [2:0] counter; // contador

    // se referir aos estados por nomes (parametros)
        parameter ST_COMMON = 2'b00;
        parameter ST_ADD = 2'b01;
        parameter ST_ADDI = 2'b10;
        parameter ST_RESET= 2'b11;

    // parametriza os opcodes
        parameter ADD = 6'b000000;
        parameter ADDI = 6'b001000;
        parameter RESET = 6'b111111;

    initial begin
        // dá o reset inicial da máquina, coloca no estado de reset
        reset_out = 1'b1;
    end

    always @(posedge clk) begin
        if (reset == 1'b1) begin
            // se o estado for diferente do estado de reset, coloca o estado atual no estado de reset
            if (state != ST_RESET) begin
                state = ST_RESET;
                // zera os sinais de saída (pq nada pode ser escrito)
                PC_w = 1'b0;
                MEM_w = 1'b0;
                IR_w = 1'b0;
                RB_w = 1'b0;
                AB_w = 1'b0;
                ULA_c = 3'b000;
                M_selector_writereg = 1'b0;
                M_selector_A = 1'b0;
                M_selector_B = 2'b00;
                M_selector_Memory = 3'b000;
                M_selector_ALUOut = 3'b000;
                M_selector_WDATA = 3'b000;
                ALU_w = 1'b0;
                reset_out = 1'b1;
                // setar counter para a proxima operação
                counter = 3'b000;
            end
        end
    end
endmodule
