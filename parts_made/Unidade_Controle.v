module Unidade_Controle (
    input wire                  clk,
    input wire                  reset,
// Flags
    input wire                  Of,
    input wire                  Ng,
    input wire                  Zr,
    input wire                  Eq,
    input wire                  Gt,
    input wire                  Lt,
// Meaningful Part of the Instruction
    input wire [5:0]    OPCODE,
// Controllers with 1 bit
    output reg                  PC_w,
    output reg                  MEM_w,
    output reg                  IR_w,
    output reg                  RB_w,
    output reg                  AB_w,
// Controllers with more than 1 bit
    output reg                  M_WREG,
    output reg                  M_ULAA,
    output reg                  M_ULAB,
// Special Controller for reset instuction
    output reg                  rst_out

);

always @(posedge clk) begin
     
    //reg variáveis internas
    reg [2:0] CONTADOR;
    reg [1:0] ESTADO;

    //Parâmetros (Constantes)
        //Principais Estados de Máquina
        parameter ESTADO_COMUM      = 2'b00;
        parameter ESTADO_ADD        = 2'b01;
        parameter ESTADO_ADDI       = 2'b10;
        parameter ESTADO_RESET      = 2'b11;
        //Códigos de opcode nomeados
        parameter ADD               = 6'b000000;
        parameter ADDI              = 6'b001000;
        parameter RESET             = 6'b111111;

    initial begin
        //valor 227 ou 277 (o monitor esqueceu qual) no registrador 29 ****Lembrar de colocar
        rst_out = 1'b1; //Faz o reset inicial da máquina

    end


    always @(posedge clk) begin
        if (reset == 1'b1) begin
            if (ESTADO != ESTADO_RESET) begin
                ESTADO = ESTADO_RESET;
                // Resetando todos os sinais:
                PC_w        = 1'b0;
                MEM_w       = 1'b0;
                IR_w        = 1'b0;
                RB_w        = 1'b0;
                AB_w        = 1'b0;
                ULA_c       = 3'b000;
                M_WREG      = 1'b0;
                M_ULAA      = 1'b0;
                M_ULAB     = 2'b00;
                rst_out     = 1'b1;
                // Colocando o contador para a próxima operação
                CONTADOR = 3'b000;
            end
            else begin
                ESTADO = ESTADO_COMUM;
                // Resetando todos os sinais:
                PC_w        = 1'b0;
                MEM_w       = 1'b0;
                IR_w        = 1'b0;
                RB_w        = 1'b0;
                AB_w        = 1'b0;
                ULA_c       = 3'b000;
                M_WREG      = 1'b0;
                M_ULAA      = 1'b0;
                M_ULAB     = 2'b00;
                rst_out     = 1'b0; //// Modificando aqui
                // Colocando o contador para a próxima operação
                CONTADOR = 3'b000;
            end
        end
        else begin
            case (ESTADO)
                ESTADO_COMUM: begin
                    if (CONTADOR == 3'b000 || CONTADOR = 3'b001 || CONTADOR = 3'b010) begin
                        ESTADO = ESTADO_COMUM;
                        // Resetando todos os sinais:
                        PC_w        = 1'b0;
                        MEM_w       = 1'b0;     //// Continua 0
                        IR_w        = 1'b0;
                        RB_w        = 1'b0;
                        AB_w        = 1'b0;
                        ULA_c       = 3'b001;     //// Modificando aqui
                        M_WREG      = 1'b0;
                        M_ULAA      = 1'b0;     //// Continua 0
                        M_ULAB     = 2'b01;     //// Modificando aqui
                        rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = CONTADOR + 1;
                    end
                    else if (CONTADOR == 3'b011) begin
                        ESTADO = ESTADO_COMUM;
                        // Resetando todos os sinais:
                        PC_w        = 1'b1;     //// Modificado aqui
                        MEM_w       = 1'b0;     //// Continua 0
                        IR_w        = 1'b1;     //// Modificado aqui
                        RB_w        = 1'b0;
                        AB_w        = 1'b0;
                        ULA_c       = 3'b001;     //// Continua 001
                        M_WREG      = 1'b0;
                        M_ULAA      = 1'b0;     //// Continua 0
                        M_ULAB     = 2'b01;     //// Continua 1
                        rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = CONTADOR + 1;
                    end
                    else if (CONTADOR == 3'b100) begin
                        // Resetando todos os sinais:
                        PC_w        = 1'b0;         //// Modificado aqui
                        MEM_w       = 1'b0;         //// Continua 0
                        IR_w        = 1'b0;         //// Modificado aqui
                        RB_w        = 1'b0;
                        AB_w        = 1'b1;         //// Modificado aqui
                        ULA_c       = 3'b000;       //// Modificado aqui
                        M_WREG      = 1'b0;
                        M_ULAA      = 1'b0;         //// Continua 0
                        M_ULAB     = 2'b00;        //// Modificado aqui
                        rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = CONTADOR + 1;
                    end
                    else if (CONTADOR == 3'b101) begin
                        case (OPCODE)
                            ADD: begin
                                ESTADO = ESTADO_ADD;
                            end
                            ADDI: begin
                                ESTADO = ESTADO_ADDI;
                            end
                            RESET: begin
                                ESTADO = ESTADO_RESET;
                            end
                        endcase
                        // Resetando todos os sinais:
                        PC_w        = 1'b0;         //// Modificado aqui
                        MEM_w       = 1'b0;         //// Continua 0
                        IR_w        = 1'b0;         //// Modificado aqui
                        RB_w        = 1'b0;
                        AB_w        = 1'b0;         //// Modificado aqui
                        ULA_c       = 3'b000;       //// Modificado aqui
                        M_WREG      = 1'b0;
                        M_ULAA      = 1'b0;         //// Continua 0
                        M_ULAB     = 2'b00;        //// Modificado aqui
                        rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = 3'b000;
                    end
                end
                ESTADO_ADD: begin
                    if (CONTADOR = 3'b000) begin
                        // Colocando Estado Futuro
                        ESTADO = ESTADO_ADD;
                        // Colocando todos os sinais
                        PC_w        = 1'b0;
                        MEM_w       = 1'b0;
                        IR_w        = 1'b0;
                        RB_w        = 1'b1;
                        AB_w        = 1'b0;
                        ULA_c       = 3'b001;
                        M_WREG      = 1'b1;
                        M_ULAA      = 1'b1;
                        M_ULAB      = 2'b00;
                        rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = CONTADOR + 1;
                    end
                    else if (CONTADOR == 3'b001) begin
                        // Colocando Estado Futuro
                        ESTADO = ESTADO_COMUM;
                        // Colocando todos os sinais
                        PC_w        = 1'b0;
                        MEM_w       = 1'b0;
                        IR_w        = 1'b0;
                        RB_w        = 1'b1;
                        AB_w        = 1'b0;
                        ULA_c       = 3'b001;
                        M_WREG      = 1'b1;
                        M_ULAA      = 1'b1;
                        M_ULAB      = 2'b00;
                        rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = 3'b000;
                    end
                end
                ESTADO_ADDI: begin
                    if (CONTADOR = 3'b000) begin
                        // Colocando Estado Futuro
                        ESTADO = ESTADO_ADD;
                        // Colocando todos os sinais
                        PC_w        = 1'b0;
                        MEM_w       = 1'b0;
                        IR_w        = 1'b0;
                        RB_w        = 1'b1;
                        AB_w        = 1'b0;
                        ULA_c       = 3'b001;
                        M_WREG      = 1'b0;
                        M_ULAA      = 1'b1;
                        M_ULAB      = 2'b10;
                        rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = CONTADOR + 1;
                    end
                    else if (CONTADOR == 3'b001) begin
                        // Colocando Estado Futuro
                        ESTADO = ESTADO_COMUM;
                        // Colocando todos os sinais
                        PC_w        = 1'b0;
                        MEM_w       = 1'b0;
                        IR_w        = 1'b0;
                        RB_w        = 1'b1;
                        AB_w        = 1'b0;
                        ULA_c       = 3'b001;
                        M_WREG      = 1'b0;
                        M_ULAA      = 1'b1;
                        M_ULAB      = 2'b10;
                        rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = 3'b000;
                    end
                end
                ESTADO_RESET: begin
                    if (CONTADOR = 3'b000) begin
                        //Colocando estado futuro
                        ESTADO = ESTADO_RESET;
                        // Colocando todos os sinais
                        PC_w        = 1'b0;
                        MEM_w       = 1'b0;
                        IR_w        = 1'b0;
                        RB_w        = 1'b0;
                        AB_w        = 1'b0;
                        ULA_c       = 3'b000;
                        M_WREG      = 1'b0;
                        M_ULAA      = 1'b0;
                        M_ULAB      = 2'b00;
                        rst_out     = 1'b1;
                        // Colocando o contador para a próxima operação
                        CONTADOR = 3'b000;
                    end
                end
            endcase
        end
    end
end
endmodule