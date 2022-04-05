module Unidade_Controle(
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
    output reg       PCWrite,
    output reg [2:0] IorD,
    output reg       MEMWrite,
    output reg       IRWrite,
    output reg [1:0] RegDst,
    output reg [2:0] MemtoReg,
    output reg       RegWrite,
    output reg       AWrite,
    output reg       BWrite,
    output reg       AluSrcA,
    output reg [1:0] AluSrcB,
    output reg [2:0] ULA_c,
    output reg       ALU_w,
    output reg [2:0] PCSource,
    output reg reset_out

);

    // PCWrite = 1'b0;
    // IorD = 3'b000;
    // MEMWrite = 1'b0;
    // IRWrite = 1'b0;
    // RegDst = 2'b00;
    // MemtoReg = 3'b000;
    // RegWrite = 1'b0;
    // AWrite = 1'b0;
    // BWrite = 1'b0;
    // AluSrcA = 1'b0;
    // AluSrcB = 2'b00;
    // ULA_c = 3'b000;
    // ALU_w = 1'b0;
    // PCSource = 3'b000;


    //reg variáveis internas
    reg [2:0] CONTADOR;
    reg [1:0] ESTADO;

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
        reset_out = 1'b1; //Faz o reset inicial da máquina
    end


    always @(posedge clk) begin
        if (reset == 1'b1) begin
            if (ESTADO != ESTADO_RESET) begin
                ESTADO = ESTADO_RESET;
                // Resetando todos os sinais:
                PCWrite = 1'b0;
                IorD = 3'b000;
                MEMWrite = 1'b0;
                IRWrite = 1'b0;
                RegDst = 2'b00;
                MemtoReg = 3'b000;
                RegWrite = 1'b0;
                AWrite = 1'b0;
                BWrite = 1'b0;
                AluSrcA = 1'b0;
                AluSrcB = 2'b00;
                ULA_c = 3'b000;
                ALU_w = 1'b0;
                PCSource = 3'b000;
                reset_out = 1'b1;
                // Colocando o contador para a próxima operação
                CONTADOR = 3'b000;
            end
            else begin
                ESTADO = ESTADO_COMUM;
                PCWrite = 1'b0;
                IorD = 3'b000;
                MEMWrite = 1'b0;
                IRWrite = 1'b0;
                RegDst = 2'b00;
                MemtoReg = 3'b000;
                RegWrite = 1'b0;
                AWrite = 1'b0;
                BWrite = 1'b0;
                AluSrcA = 1'b0;
                AluSrcB = 2'b00;
                ULA_c = 3'b000;
                ALU_w = 1'b0;
                PCSource = 3'b000;
                reset_out = 1'b0;
                // Resetando todos os sinais:
                // PCWrite        = 1'b0;
                // MEMWrite       = 1'b0;
                // IRWrite        = 1'b0;
                // RegWrite        = 1'b0;
                // AB_w        = 1'b0;
                // ULA_c       = 3'b000;
                // M_WREG      = 1'b0;
                // M_ULAA      = 1'b0;
                // M_ULAB     = 2'b00;
                // rst_out     = 1'b0; //// Modificando aqui
                // Colocando o contador para a próxima operação
                CONTADOR = 3'b000;
            end
        end
        else begin
            case (ESTADO)
                ESTADO_COMUM: begin
                    if (CONTADOR == 3'b000 || CONTADOR == 3'b001 || CONTADOR == 3'b010) begin
                        ESTADO = ESTADO_COMUM;
                        PCWrite = 1'b0;
                        IorD = 3'b000;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegDst = 2'b00;
                        MemtoReg = 3'b000;
                        RegWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        AluSrcA = 1'b0;
                        AluSrcB = 2'b01;
                        ULA_c = 3'b001;
                        ALU_w = 1'b0;
                        PCSource = 3'b000;
                        reset_out = 0;
                        // Resetando todos os sinais:
                        // PCWrite        = 1'b0;
                        // MEMWrite       = 1'b0;     //// Continua 0
                        // IRWrite        = 1'b0;
                        // RegWrite        = 1'b0;
                        // AB_w        = 1'b0;
                        // ULA_c       = 3'b001;     //// Modificando aqui
                        // M_WREG      = 1'b0;
                        // M_ULAA      = 1'b0;     //// Continua 0
                        // M_ULAB     = 2'b01;     //// Modificando aqui
                        // rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = CONTADOR + 1;
                    end
                    else if (CONTADOR == 3'b011) begin
                        ESTADO = ESTADO_COMUM;
                        PCWrite = 1'b1;
                        IorD = 3'b000;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b1;
                        RegDst = 2'b00;
                        MemtoReg = 3'b000;
                        RegWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        AluSrcA = 1'b0;
                        AluSrcB = 2'b01;
                        ULA_c = 3'b001;
                        ALU_w = 1'b0;
                        PCSource = 3'b000;
                        reset_out = 0;
                        // Resetando todos os sinais:
                        // PCWrite        = 1'b1;     //// Modificado aqui
                        // MEMWrite       = 1'b0;     //// Continua 0
                        // IRWrite        = 1'b1;     //// Modificado aqui
                        // RegWrite        = 1'b0;
                        // AB_w        = 1'b0;
                        // ULA_c       = 3'b001;     //// Continua 001
                        // M_WREG      = 1'b0;
                        // M_ULAA      = 1'b0;     //// Continua 0
                        // M_ULAB     = 2'b01;     //// Continua 1
                        // rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = CONTADOR + 1;
                    end
                    else if (CONTADOR == 3'b100) begin
                        // Resetando todos os sinais:
                        PCWrite = 1'b0;
                        IorD = 3'b000;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegDst = 2'b00;
                        MemtoReg = 3'b000;
                        RegWrite = 1'b0;
                        AWrite = 1'b1;
                        BWrite = 1'b1;
                        AluSrcA = 1'b0;
                        AluSrcB = 2'b00;
                        ULA_c = 3'b000;
                        ALU_w = 1'b0;
                        PCSource = 3'b000;
                        reset_out = 0;
                        // PCWrite        = 1'b0;         //// Modificado aqui
                        // MEMWrite       = 1'b0;         //// Continua 0
                        // IRWrite        = 1'b0;         //// Modificado aqui
                        // RegWrite        = 1'b0;
                        // AB_w        = 1'b1;         //// Modificado aqui
                        // ULA_c       = 3'b000;       //// Modificado aqui
                        // M_WREG      = 1'b0;
                        // M_ULAA      = 1'b0;         //// Continua 0
                        // M_ULAB     = 2'b00;        //// Modificado aqui
                        // rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = CONTADOR + 3'b001;
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
                        PCWrite = 1'b0;
                        IorD = 3'b000;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegDst = 2'b00;
                        MemtoReg = 3'b000;
                        RegWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        AluSrcA = 1'b0;
                        AluSrcB = 2'b00;
                        ULA_c = 3'b000;
                        ALU_w = 1'b0;
                        PCSource = 3'b000;
                        reset_out = 0;
                      
                        CONTADOR = 3'b000;
                    end
                end

                ESTADO_ADD: begin
                    if (CONTADOR == 3'b000) begin
                        // Colocando Estado Futuro
                        ESTADO = ESTADO_ADD;
                        
                        PCWrite = 1'b0;
                        IorD = 3'b000;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegDst = 2'b00;
                        MemtoReg = 3'b000;
                        RegWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        AluSrcA = 1'b1;
                        AluSrcB = 2'b00;
                        ULA_c = 3'b001;
                        ALU_w = 1'b1;
                        PCSource = 3'b000;
                        reset_out = 0;
                        // Colocando todos os sinais
                        // PCWrite        = 1'b0;
                        // MEMWrite       = 1'b0;
                        // IRWrite        = 1'b0;
                        // RegWrite        = 1'b1;
                        // AB_w        = 1'b0;
                        // ULA_c       = 3'b001;
                        // M_WREG      = 1'b1;
                        // M_ULAA      = 1'b1;
                        // M_ULAB      = 2'b00;
                        // rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = CONTADOR + 1;
                    end

                    //DOIS CICLOS PARA ESCREVER NO BANCO DE REGISTRADORES
                    else if (CONTADOR == 3'b001) begin
                        // Colocando Estado Futuro
                        ESTADO = ESTADO_COMUM;
                        PCWrite = 1'b0;
                        IorD = 3'b000;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegDst = 2'b11;
                        MemtoReg = 3'b000;
                        RegWrite = 1'b1;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        AluSrcA = 1'b0;
                        AluSrcB = 2'b00;
                        ULA_c = 3'b000;
                        ALU_w = 1'b0;
                        PCSource = 3'b000;
                        reset_out = 0;
                        // Colocando todos os sinais
                        // PCWrite        = 1'b0;
                        // MEMWrite       = 1'b0;
                        // IRWrite        = 1'b0;
                        // RegWrite        = 1'b1;
                        // AB_w        = 1'b0;
                        // ULA_c       = 3'b001;
                        // M_WREG      = 1'b1;
                        // M_ULAA      = 1'b1;
                        // M_ULAB      = 2'b00;
                        // rst_out     = 1'b0;
                        // Colocando o contador para a próxima operação
                        CONTADOR = 3'b000;
                    end
                end
                // ESTADO_ADDI: begin
                //     if (CONTADOR = 3'b000) begin
                //         // Colocando Estado Futuro
                //         ESTADO = ESTADO_ADD;
                //         PCWrite = 1'b0;
                //         MEMWrite = 1'b0;
                //         IRWrite = 1'b0;
                //         RegWrite = 1'b1;
                //         AB_w = 1'b0;
                //         ULA_c = 3'b001;
                //         IorD = 1'b0;
                //         AluSrcA = 1'b0;
                //         AluSrcB = 2'b00;
                //         M_selector_Memory = 3'b000;
                //         AluSrcALUOut = 3'b000;
                //         MemtoReg = 3'b000;
                //         ALU_w = 1'b0;
                //         reset_out = 1'b1;
                //         // Colocando todos os sinais
                //         // PCWrite        = 1'b0;
                //         // MEMWrite       = 1'b0;
                //         // IRWrite        = 1'b0;
                //         // RegWrite        = 1'b1;
                //         // AB_w        = 1'b0;
                //         // ULA_c       = 3'b001;
                //         // M_WREG      = 1'b0;
                //         // M_ULAA      = 1'b1;
                //         // M_ULAB      = 2'b10;
                //         // rst_out     = 1'b0;
                //         // Colocando o contador para a próxima operação
                //         CONTADOR = CONTADOR + 1;
                //     end
                //     else if (CONTADOR == 3'b001) begin
                //         // Colocando Estado Futuro
                //         ESTADO = ESTADO_COMUM;
                //         // Colocando todos os sinais
                //         PCWrite        = 1'b0;
                //         MEMWrite       = 1'b0;
                //         IRWrite        = 1'b0;
                //         RegWrite        = 1'b1;
                //         AB_w        = 1'b0;
                //         ULA_c       = 3'b001;
                //         M_WREG      = 1'b0;
                //         M_ULAA      = 1'b1;
                //         M_ULAB      = 2'b10;
                //         rst_out     = 1'b0;
                //         // Colocando o contador para a próxima operação
                //         CONTADOR = 3'b000;
                //     end
                // end
                ESTADO_RESET: begin
                    if (CONTADOR == 3'b000) begin
                        //Colocando estado futuro
                        ESTADO = ESTADO_RESET;
                        PCWrite = 1'b0;
                        IorD = 3'b000;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegDst = 2'b00;
                        MemtoReg = 3'b000;
                        RegWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        AluSrcA = 1'b0;
                        AluSrcB = 2'b00;
                        ULA_c = 3'b000;
                        ALU_w = 1'b0;
                        PCSource = 3'b000;
                        reset_out = 1'b1;
                        // Colocando todos os sinais
                        // PCWrite        = 1'b0;
                        // MEMWrite       = 1'b0;
                        // IRWrite        = 1'b0;
                        // RegWrite        = 1'b0;
                        // AB_w        = 1'b0;
                        // ULA_c       = 3'b000;
                        // M_WREG      = 1'b0;
                        // M_ULAA      = 1'b0;
                        // M_ULAB      = 2'b00;
                        // rst_out     = 1'b1;
                        // Colocando o contador para a próxima operação
                        CONTADOR = 3'b000;
                    end
                end
            endcase
        end
    end

endmodule