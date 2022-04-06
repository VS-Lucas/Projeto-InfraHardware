//asdasdasfasd


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
    output reg EPCWrite,
    output reg HiSel,
    output reg HiWrite,
    output reg LoSel,
    output reg LoWrite,
    output reg reset_out
);
    
    //reg variáveis internas
    reg [4:0] CONTADOR;
    reg [5:0] ESTADO;

    //Principais Estados de Máquina
    parameter ESTADO_RESET      = 6'b000000;
    parameter fetch             = 6'b000001;
    parameter decoder           = 6'b000010;
    parameter Overflow          = 6'b000011;
    parameter OPCode404         = 6'b000100;
    parameter Div0              = 6'b000101;

    parameter ESTADO_ADD         = 6'b000110;
    parameter ESTADO_AND         = 6'b000111;
    parameter ESTADO_DIV         = 6'b001000;
    parameter ESTADO_MULT        = 6'b001001;
    parameter ESTADO_JR          = 6'b001010;
    parameter ESTADO_MFHI        = 6'b001011;
    parameter ESTADO_MFLO        = 6'b001100;
    parameter ESTADO_SLL         = 6'b001101;
    parameter ESTADO_SLLV        = 6'b001110;
    parameter ESTADO_SLT         = 6'b001111;
    parameter ESTADO_SRA         = 6'b010000;
    parameter ESTADO_SRAV        = 6'b010001;
    parameter ESTADO_SRL         = 6'b010010;
    parameter ESTADO_SUB         = 6'b010011;
    parameter ESTADO_BREAK       = 6'b010100;
    parameter ESTADO_RTE         = 6'b010101;
    parameter ESTADO_ADDM        = 6'b010110;
    
    /*
        PCWrite = 1'b0;
        RegWrite = 1'b0;
        MEMWrite = 1'b0;
        IRWrite = 1'b0;
        AWrite = 1'b0;
        BWrite = 1'b0;
        ALU_w = 1'b0;
        EPCWrite = 1'b0;
        HiWrite = 1'b0;
        LoWrite = 1'b0;
        reset_out = 1'b0;
    */
        
    
    
    
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
                // up --------
                RegDst = 2'b01;      // *
                MemtoReg = 3'b111;     // *
                RegWrite = 1'b1;     // *
                //-------------
                PCWrite = 1'b0;
                MEMWrite = 1'b0;
                IRWrite = 1'b0;
                AWrite = 1'b0;
                BWrite = 1'b0;
                ALU_w = 1'b0;
                EPCWrite = 1'b0;
                HiWrite = 1'b0;
                LoWrite = 1'b0;

                reset_out = 1'b1;
                CONTADOR = 5'b00000;
            end else begin
                ESTADO = fetch;
                // up --------
                RegDst = 2'b01;      // *
                MemtoReg = 3'b111;     // *
                RegWrite = 1'b1;     // *
                //-------------
                PCWrite = 1'b0;
                MEMWrite = 1'b0;
                IRWrite = 1'b0;
                AWrite = 1'b0;
                BWrite = 1'b0;
                ALU_w = 1'b0;
                EPCWrite = 1'b0;
                HiWrite = 1'b0;
                LoWrite = 1'b0;

                reset_out = 1'b0;
                CONTADOR = 5'b00000;
            end
        end else begin
            case (ESTADO)
                fetch: begin
                    if (CONTADOR == 5'b00000 || CONTADOR == 5'b00001 || CONTADOR == 5'b00010) begin
                        ESTADO = fetch;
                        
                        PCWrite = 1'b0;
                        IorD = 3'b000;   // <-
                        MEMWrite = 1'b0;  // <-
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        AluSrcA = 1'b0; // <-
                        AluSrcB = 2'b01;  // <-
                        ULA_c = 3'b001;   // <-
                        ALU_w = 1'b1;
                        PCSource = 3'b000;  // <-
                        reset_out = 1'b0;
                        EPCWrite = 1'b0;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;

                        CONTADOR = CONTADOR + 5'b00001;
                    end else begin
                        ESTADO = decoder;
                        
                        PCSource = 3'b000;  // <-
                        PCWrite = 1'b1;   // <-
                        MEMWrite = 1'b0;
                        IRWrite = 1'b1;   // <-
                        RegWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        ALU_w = 1'b0;
                        EPCWrite = 1'b0;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        reset_out = 1'b0;

                        CONTADOR = 5'b00000;
                    end
                end
                decoder: begin
                    if (CONTADOR == 5'b00000) begin
                        // Resetando todos os sinais:
                        PCWrite = 1'b0;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        AWrite = 1'b0;  
                        BWrite = 1'b0;
                        AluSrcA = 1'b0;  // <-
                        AluSrcB = 2'b11; // <-
                        ULA_c = 3'b001;   // <-
                        ALU_w = 1'b1; // <-
                        EPCWrite = 1'b0;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        reset_out = 1'b0;

                        CONTADOR = CONTADOR + 5'b00001;
                    end else if (CONTADOR == 5'b00001) begin
                       
                        PCWrite = 1'b0;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        AWrite = 1'b1;  // <-
                        BWrite = 1'b1; // <-
                        ALU_w = 1'b0; 
                        EPCWrite = 1'b0;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        reset_out = 1'b0;
                    
                        CONTADOR = 5'b00000;
                        //else if (CONTADOR == 3'b101) begin
                        case (OPCODE)
                            ADD: begin
                                ESTADO = ESTADO_ADD;
                            end
                            // AND: begin
                            //     ESTADO = ESTADO_AND;
                            // end

                            // ADDI: begin
                            //     ESTADO = ESTADO_ADDI;
                            // end
                            RESET: begin
                                ESTADO = ESTADO_RESET;
                            end
                        endcase
                    end
                end
                ESTADO_ADD: begin
                    if (CONTADOR == 5'b00000) begin
                        // Colocando Estado Futuro
                        ESTADO = ESTADO_ADD;
                        
                        PCWrite = 1'b0;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        AluSrcA = 1'b1; // <-
                        AluSrcB = 2'b00; // <-
                        ULA_c = 3'b001; // <-
                        ALU_w = 1'b1;  // <-
                        EPCWrite = 1'b0;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        reset_out = 1'b0;

                        CONTADOR = CONTADOR + 5'b00001;
                    end

                    //DOIS CICLOS PARA ESCREVER NO BANCO DE REGISTRADORES
                    else if (CONTADOR == 5'b00001) begin
                        // Colocando Estado Futuro
                        ESTADO = fetch;
                        PCWrite = 1'b0;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegDst = 2'b11;   // <-
                        MemtoReg = 3'b000;  // <-
                        RegWrite = 1'b1;   // <-
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        ALU_w = 1'b0;
                        EPCWrite = 1'b0;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        reset_out = 1'b0;

                        CONTADOR = 5'b00000;
                    end
                end
                ESTADO_AND: begin
                    if(CONTADOR == 5'b000000)begin
                        AluSrcA = 1'b1; // <--
                        AluSrcB = 2'b00; //<-
                        ULA_c   = 3'b011; // <-
                        ALU_w = 1'b1; // <-

                        PCWrite = 1'b0;
                        RegWrite = 1'b0;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        EPCWrite = 1'b0;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        reset_out = 1'b0;
                        
                        ESTADO = ESTADO_AND;
                        CONTADOR = CONTADOR + 5'b00001;

                    end else begin
                        ESTADO = fetch;
                        PCWrite = 1'b0;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegDst = 2'b11;   // <-
                        MemtoReg = 3'b000;  // <-
                        RegWrite = 1'b1;   // <-
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        ALU_w = 1'b0;
                        EPCWrite = 1'b0;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        reset_out = 1'b0;

                        CONTADOR = 5'b00000;
                    end
                end
                // ESTADO_DIV: begin
                    
                // end

                // ESTADO_MULT: begin
                    
                // end
                ESTADO_JR: begin
                    ESTADO = fetch;
                    AluSrcA = 1'b1; // <--
                    AluSrcB = 2'b00; //<-
                    ULA_c   = 3'b000; // <-
                    PCSource = 3'b000; // <-
                    PCWrite = 1'b1; // <-
                    RegWrite = 1'b0;
                    MEMWrite = 1'b0;
                    IRWrite = 1'b0;
                    AWrite = 1'b0;
                    BWrite = 1'b0;
                    ALU_w = 1'b0;
                    EPCWrite = 1'b0;
                    HiWrite = 1'b0;
                    LoWrite = 1'b0;
                    reset_out = 1'b0;
                    
                    CONTADOR = 5'b00000;
                end

                ESTADO_MFHI: begin
                    ESTADO = fetch;
                    PCWrite = 1'b0;
                    MEMWrite = 1'b0;
                    IRWrite = 1'b0;
                    RegDst = 2'b11;   // <-
                    MemtoReg = 3'b010;  // <-
                    RegWrite = 1'b1;   // <-
                    AWrite = 1'b0;
                    BWrite = 1'b0;
                    ALU_w = 1'b0;
                    EPCWrite = 1'b0;
                    HiWrite = 1'b0;
                    LoWrite = 1'b0;
                    reset_out = 1'b0;

                    CONTADOR = 5'b00000;
                end
                ESTADO_MFLO: begin
                    ESTADO = fetch;
                    PCWrite = 1'b0;
                    MEMWrite = 1'b0;
                    IRWrite = 1'b0;
                    RegDst = 2'b11;   // <-
                    MemtoReg = 3'b011;  // <-
                    RegWrite = 1'b1;   // <-
                    AWrite = 1'b0;
                    BWrite = 1'b0;
                    ALU_w = 1'b0;
                    EPCWrite = 1'b0;
                    HiWrite = 1'b0;
                    LoWrite = 1'b0;
                    reset_out = 1'b0;

                    CONTADOR = 5'b00000;
                end
                
                ESTADO_RESET: begin
                    if (CONTADOR == 5'b00000) begin
                        //Colocando estado futuro
                        ESTADO = fetch;
                        
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

                        CONTADOR = 5'b00000;
                    end
                end
            endcase
        end
    end
endmodule