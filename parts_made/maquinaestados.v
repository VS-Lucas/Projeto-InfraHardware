
// MÁQUINA DE ESTADOS

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
    rst_out = 1'b1;
end

always @(posedge clk) begin
    if (reset == 1'b1) begin
        // se o estado for diferente do estado de reset, coloca o estado atual no estado de reset
        if (state != ST_RESET) begin
            state = ST_RESET
            // zera os sinais de saída (pq nada pode ser escrito)
            PC_W = 1'b0;]
            MEM_W = 1'b0;
            IR_W = 1'b0;
            RB_W = 1'b0;
            AB_W = 1'b0;
            ULA_c = 3'b000;
            M_WREG = 1'b0;
            M_ULAA = 1'b0;
            M_ULAB = 2'b00;
            rst_out = 1'b1;
            // setar counter para a proxima operação
            counter = 3'b000;
        end
    end
end

