module CPU(

// Res & Clk

    input wire clk,
    input wire reset
);

// Flags
    wire Of;
    wire Ng;
    wire Zr;
    wire Eq;
    wire Gt;
    wire Lt;

// Sinais de controle de 1 bit
    wire PC_w;
    wire MEM_w;
    wire IR_w;
    wire RB_w;
    wire AB_w;

// sinais de controle com mais de 1 bit
    wire [2:0] ULA_c;

// Sinais de controles para o MUX
    wire M_WREG;
    wire M_ULAA;
    wire  [1:0] M_ULAB;
    wire PC_w;


// IR
    wire [5:0] OPCODE;
    wire [4:0] RS;
    wire [4:0] RT;
    wire [15:0] OFFSET;

    wire [31:0] ULA_out;
    wire [31:0] PC_out;
    wire [31:0] MEM_to_IR;

 // data wires with less than 32 bits   
    wire [4:0] WRITEREG_in;

//data wire with 32 bits
    wire [31:0] ULA_out;
    wire [31:0] PC_out;
    wire [31:0] MEM_to_IR;
    wire [31:0] RB_to_A;
    wire [31:0] RB_to_B;
    wire [31:0] A_out;
    wire [31:0] B_out;
    wire [31:0] SXTND_out;
    wire [31:0] ULAA_in;
    wire [31:0] ULAB_in;

Registrador Reg_(
        clk,
        reset,
        PC_w,
        ULA_out,
        PC_out
    );

    Memoria Mem_(
        PC_w,
        clk,
        MEM_w,
        MEM_in,
        MEM_to_IR
    );


    Instr_Reg IR_(
        clk,
        reset,
        IR_w,
        MEM_to_IR,
        OPCODE,
        RS,
        RT,
        IMEDIATO
    );
   
    mux_writereg M_WRREG_(
        M_WREG,
        RT,
        OFFSET,
        WRITEREG_in // ver quais desses precisa instanciar la em cima
    );
           
    Banco_reg REG_BASE_(
        clk,
        reset,
        RB_w,
        RS,
        RT,
        WRITEREG_in,    // checar quais tem que ser instanciados la em cima
        ULA_out,
        RB_to_A,
        RB_to_A,
    );
    Registrador A_(
        clk,
        reset,
        AB_w,      // checar o que deve ser instanciado 
        RB_to_A,
        A_out
    );

    Registrador B_(
        clk,
        reset,
        AB_w,      // checar o que deve ser instanciado 
        RB_to_B,
        B_out
    );


    