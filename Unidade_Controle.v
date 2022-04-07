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
    input wire [15:0]   IMEDIATO,
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
    output reg LoWrite
    // output reg reset_out
);
    
    //reg variáveis internas
    reg [4:0] CONTADOR;
    reg [5:0] ESTADO;

    //Principais ESTADO de Máquina
    parameter fetch             = 6'b000001;
    parameter decoder           = 6'b000010;
    parameter Overflow          = 6'b000011;
    parameter OPCode404         = 6'b000100;
    parameter Div0              = 6'b000101;
    //-------------- Formato R ----------------//
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
    //----------------------------------------//

    //--------------- Formato I -------------------//
    parameter ESTADO_ADDI        =       6'b010111;
    parameter ESTADO_ADDIU       =       6'b011000;
    parameter ESTADO_BEQ         =       6'b011001;
    parameter ESTADO_BNE         =       6'b011010;
    parameter ESTADO_BLE         =       6'b011011;
    parameter ESTADO_BGT         =       6'b011100;
    parameter ESTADO_SLLM        =       6'b011101;
    parameter ESTADO_LB          =       6'b011110;
    parameter ESTADO_LH          =       6'b011111;
    parameter ESTADO_LUI         =       6'b100000;
    parameter ESTADO_LW          =       6'b100001;
    parameter ESTADO_SB          =       6'b100010;
    parameter ESTADO_SH          =       6'b100011;
    parameter ESTADO_SLTI        =       6'b100100;
    parameter ESTADO_SW          =       6'b100101;
    parameter ESTADO_RESET       =       6'b111111;
    //--------------------------------------------//

    // ----------------- formato J -----------------//
    parameter ESTADO_J           =       6'b100110;
    parameter ESTADO_JAL         =       6'b100111;
    // ---------------------------------------------//
    

    // ------ OPCODE DA INSTRUÇÃO R, DADA NA ESPECIFICAÇÃO 0x0----//
    parameter OPCODE_TYPE_R      =       6'b000000; // 0x0
    //------------------------------------------------------------//   
    // CAMPO FUNCT PARA AS DIFERENCIAÇÃO NAS INSTRUÇÕES (R's), DE ACORDO COM O VALOR HEXADECIMAL DADO NA ESPECIFICAÇÃO
    parameter FUNCT_ADD         =       6'b100000; // 0x20
    parameter FUNCT_AND         =       6'b100100; // 0x24
    parameter FUNCT_DIV         =       6'b011010; // 0x1a
    parameter FUNCT_MULT        =       6'b011000; // 0x18
    parameter FUNCT_JR          =       6'b001000; // 0x8
    parameter FUNCT_MFHI        =       6'b010000; // 0x10
    parameter FUNCT_MFLO        =       6'b010010; // 0x12
    parameter FUNCT_SLL         =       6'b000000; // 0x0
    parameter FUNCT_SLLV        =       6'b000100; // 0x4
    parameter FUNCT_SLT         =       6'b101010; // 0x2a
    parameter FUNCT_SRA         =       6'b000011; // 0x3
    parameter FUNCT_SRAV        =       6'b000111; // 0x7
    parameter FUNCT_SRL         =       6'b000010; // 0x2
    parameter FUNCT_SUB         =       6'b100010; // 0x22
    parameter FUNCT_BREAK       =       6'b001101; // 0xd
    parameter FUNCT_RTE         =       6'b010011; // 0x13
    parameter FUNCT_ADDM        =       6'b000101; // 0x5
    //------------------------------------------------------------------------------------------------------------------
    
    // ---------- OPCODE DAS INSTRUÇÕES FORMATO I (DADO NA ESPECIFICAÇÃO)-----------------//
    parameter OPCODE_ADDI           =       6'b001000; // 0x8
    parameter OPCODE_ADDIU          =       6'b001001; // 0x9
    parameter OPCODE_BEQ            =       6'b000100; // 0x4
    parameter OPCODE_BNE            =       6'b000101; // 0x5
    parameter OPCODE_BLE            =       6'b000110; // 0x6
    parameter OPCODE_BGT            =       6'b000111; // 0x7
    parameter OPCODE_SLLM           =       6'b000001; // 0x1
    parameter OPCODE_LB             =       6'b100000; // 0x20
    parameter OPCODE_LH             =       6'b100001; // 0x21
    parameter OPCODE_LUI            =       6'b001111; // 0xf
    parameter OPCODE_LW             =       6'b100011; // 0x23
    parameter OPCODE_SB             =       6'b101000; // 0x28
    parameter OPCODE_SH             =       6'b101001; // 0x29
    parameter OPCODE_SLTI           =       6'b001010; // 0xa
    parameter OPCODE_SW             =       6'b101011; // 0x2b
    // ------------------------------------------------------------------------------------//

    // ----- OPCODE DAS INSTRUÇÕES FORMATO J (DADO NA ESPECIFICAÇÃO) ----------------//
    parameter OPCODE_J              =       6'b000010; // 0x2
    parameter OPCODE_JAL            =       6'b000011; // 0x3
    //----------------------------------------------------------------------------------//
    
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
    */
        
    
    
    initial begin
        ESTADO = ESTADO_RESET;
    end


    always @(posedge clk) begin
        if (reset == 1'b1) begin
            // if (ESTADO != ESTADO_RESET) begin
                
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

                CONTADOR = 5'b00000;
                ESTADO = fetch;

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
                        // 

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
                        // 

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
                        // 
                    
                        CONTADOR = 5'b00000;
                    
                        case (OPCODE)
                            OPCODE_TYPE_R: begin
                    
                                case(IMEDIATO[5:0]) // PEGA OS 6 BITS PARA IDENTIFICAR O CAMPO FUNCT DA INSTRUCT R

                                    FUNCT_ADD: begin
                                        ESTADO = ESTADO_ADD;
                                    end
                                    FUNCT_AND: begin
                                        ESTADO = ESTADO_JR;
                                    end
                                    FUNCT_DIV: begin
                                        ESTADO = ESTADO_DIV;
                                    end
                                    FUNCT_MULT: begin
                                        ESTADO = ESTADO_MULT;
                                    end

                                    FUNCT_JR: begin
                                        ESTADO = ESTADO_JR;
                                    end

                                    FUNCT_MFHI: begin
                                        ESTADO = ESTADO_MFHI;
                                    end

                                    FUNCT_MFLO: begin
                                        ESTADO = ESTADO_MFLO;
                                    end

                                    FUNCT_SLL: begin
                                        ESTADO = ESTADO_SLL;
                                    end
                                    
                                    FUNCT_SLLV: begin
                                        ESTADO = ESTADO_SLLV;
                                    end

                                    FUNCT_SLT: begin
                                        ESTADO = ESTADO_SLT;
                                    end

                                    FUNCT_SRA: begin
                                        ESTADO = ESTADO_SRA;
                                    end

                                    FUNCT_SRAV: begin
                                        ESTADO = ESTADO_SRAV;
                                    end

                                    FUNCT_SRL: begin
                                        ESTADO = ESTADO_SRL;
                                    end

                                    FUNCT_SUB: begin
                                        ESTADO = ESTADO_SUB;
                                    end

                                    FUNCT_BREAK: begin
                                        ESTADO = ESTADO_BREAK;
                                    end

                                    FUNCT_RTE: begin
                                        ESTADO = ESTADO_RTE;
                                    end

                                    FUNCT_ADDM: begin
                                        ESTADO = ESTADO_ADDM;
                                    end
                                    
                                    // RESET: begin
                                    //     ESTADO = ESTADO_RESET;
                                    // end
                                endcase
                            end
                            OPCODE_ADDI: begin
                                ESTADO = ESTADO_ADDI;
                            end

                            OPCODE_ADDIU: begin
                                ESTADO = ESTADO_ADDIU;
                            end

                            OPCODE_BEQ: begin
                                ESTADO = ESTADO_BEQ;
                            end

                            OPCODE_BNE: begin
                                ESTADO = ESTADO_BNE;
                            end

                            OPCODE_BLE: begin
                                ESTADO = ESTADO_BLE;
                            end

                            OPCODE_BGT: begin
                                ESTADO = ESTADO_BGT;
                            end

                            OPCODE_SLLM: begin
                                ESTADO = ESTADO_SLLM;
                            end

                            OPCODE_LB: begin
                                ESTADO = ESTADO_LB;
                            end

                            OPCODE_LH: begin
                                ESTADO = ESTADO_LH;
                            end

                            OPCODE_LUI: begin
                                ESTADO = ESTADO_LUI;
                            end

                            OPCODE_LW: begin
                                ESTADO = ESTADO_LW;
                            end

                            OPCODE_SB: begin
                                ESTADO = ESTADO_SB;
                            end

                            OPCODE_SH: begin
                                ESTADO = ESTADO_SH;
                            end

                            OPCODE_SLTI: begin
                                ESTADO = ESTADO_SLTI;
                            end

                            OPCODE_SW: begin
                                ESTADO = ESTADO_SW;
                            end

                            OPCODE_J: begin
                                ESTADO = ESTADO_J;
                            end

                            OPCODE_JAL: begin
                                ESTADO = ESTADO_JAL;
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
                        // 

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
                        // 

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
                        // 
                        
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
                        // 

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
                    

                    CONTADOR = 5'b00000;
                end
                ESTADO_SUB: begin
                    if (CONTADOR == 5'b00000) begin
                        // Colocando Estado Futuro
                        ESTADO = ESTADO_SUB;
                        
                        PCWrite = 1'b0;
                        MEMWrite = 1'b0;
                        IRWrite = 1'b0;
                        RegWrite = 1'b0;
                        AWrite = 1'b0;
                        BWrite = 1'b0;
                        AluSrcA = 1'b1; // <-
                        AluSrcB = 2'b00; // <-
                        ULA_c = 3'b010; // <-  010 == subtracao
                        ALU_w = 1'b1;  // <-
                        EPCWrite = 1'b0;
                        HiWrite = 1'b0;
                        LoWrite = 1'b0;
                        // 

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
                        // 

                        CONTADOR = 5'b00000;
                    end
                end
                
                // ESTADO_RESET: begin
                //     if (CONTADOR == 5'b00000) begin
                //         //Colocando estado futuro
                //         ESTADO = fetch;
                        
                //         PCWrite = 1'b0;
                //         IorD = 3'b000;
                //         MEMWrite = 1'b0;
                //         IRWrite = 1'b0;
                //         RegDst = 2'b00;
                //         MemtoReg = 3'b000;
                //         RegWrite = 1'b0;
                //         AWrite = 1'b0;
                //         BWrite = 1'b0;
                //         AluSrcA = 1'b0;
                //         AluSrcB = 2'b00;
                //         ULA_c = 3'b000;
                //         ALU_w = 1'b0;
                //         PCSource = 3'b000;
                //         reset_out = 1'b1;

                //         CONTADOR = 5'b00000;
                //     end
                // end
            endcase
        end
    end
endmodule
