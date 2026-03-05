module alu (
    input  logic [31:0] a,
    input  logic [31:0] b,
    input  logic [3:0]  alu_op,
    output logic [31:0] result,
    output logic        zero
);

    // Only lower 5 bits used for shift amount in RV32
    logic [4:0] shamt;
    assign shamt = b[4:0];

    // ALU op encodings
    localparam logic [3:0]
        ALU_ADD  = 4'd0,
        ALU_SUB  = 4'd1,
        ALU_AND  = 4'd2,
        ALU_OR   = 4'd3,
        ALU_XOR  = 4'd4,
        ALU_SLL  = 4'd5,
        ALU_SRL  = 4'd6,
        ALU_SRA  = 4'd7,
        ALU_SLT  = 4'd8,
        ALU_SLTU = 4'd9;

    // Intermediate results
    logic [31:0] add_r, sub_r, and_r, or_r, xor_r;
    logic [31:0] sll_r, srl_r, sra_r;
    logic [31:0] slt_r, sltu_r;

    // Arithmetic / logic
    assign add_r = a + b;
    assign sub_r = a - b;
    assign and_r = a & b;
    assign or_r  = a | b;
    assign xor_r = a ^ b;

    // Shifts
    assign sll_r = a << shamt;
    assign srl_r = a >> shamt;
    assign sra_r = $signed(a) >>> shamt;

    // Comparisons (RISC-V returns 0 or 1)
    assign slt_r  = ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
    assign sltu_r = (a < b)                   ? 32'd1 : 32'd0;

    // Result mux
    always_comb begin
        case (alu_op)
            ALU_ADD:  result = add_r;
            ALU_SUB:  result = sub_r;
            ALU_AND:  result = and_r;
            ALU_OR:   result = or_r;
            ALU_XOR:  result = xor_r;
            ALU_SLL:  result = sll_r;
            ALU_SRL:  result = srl_r;
            ALU_SRA:  result = sra_r;
            ALU_SLT:  result = slt_r;
            ALU_SLTU: result = sltu_r;
            default:  result = 32'd0;
        endcase
    end

    // Zero flag (used for BEQ in CPUs)
    assign zero = ~(|result);

endmodule
