package decoder_pkg;
    /* define enum */
    typedef enum logic[3:0]{
        R, I, S, B, U, J
    } imm_type_t;
    typedef enum logic[7:0]{
        LUI, AUIPC, JAL, JALR, BEQ, BNE, BLT, BGE, BLTU, BGEU,
        LB, LH, LW, LBU, LHU, SB, SH, SW, ADDI, SLTI,
        SLTIU, XORI, ORI, ANDI, ADD, SUB, SLL, SLT, SLTU, XOR,
        SRL, SRA, OR, AND, LWU, LD, SD, SLLI, SRLI, SRAI,
        ADDIW, SLLIW, SRLIW, SRAIW, ADDW, SUBW, SLLW, SRLW, SRAW, FENCE,
        ECALL, EBREAK, MRET, SRET, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI,
        MUL, MULH, MULHSU, MULHU, DIV, DIVU, REM, REMU, MULW, DIVW,
        DIVUW, REMW, REMUW
    } uop_t;
endpackage
