module decoder
    import decoder_pkg::*;
(
    /* input signal */
    input       logic[31:0]     instruction,
    /* output signal */
    output      uop_t           uop,
    output      logic[4:0]      rs1,
    output      logic[4:0]      rs2,
    output      logic[4:0]      rs3,
    output      logic[2:0]      rm,
    output      logic           check_frm,
    output      logic[4:0]      rd,
    output      logic           use_rs1,
    output      logic           use_rs2,
    output      logic           use_rs3,
    output      logic[32:0]     imm,
    output      logic           use_pc,
    output      logic           use_imm,
    output      logic           use_uimm,
    output      logic           illigal,
    output      logic           ecall,
    output      logic           ebreak,
    output      logic           mret,
    output      logic           sret,
    output      logic           uret
);
    /* temp signal */
    imm_type_t      imm_type;
    logic[6:0]      opcode;
    logic[2:0]      func3;
    logic[6:0]      func7;
    logic[11:0]     func12;
    logic[0:0]      funct2;
    /* Decode Logic */
    always_comb begin
        /* Signal initialize*/
        uop             = decoder_pkg::ADDI;
        check_frm       = 1'b0;
        use_rs1         = 1'b0;
        use_rs2         = 1'b0;
        use_rs3         = 1'b0;
        use_pc          = 1'b0;
        use_uimm        = 1'b0;
        illigal         = 1'b0;
        ecall           = 1'b0;
        ebreak          = 1'b0;
        mret            = 1'b0;
        sret            = 1'b0;
        uret            = 1'b0;
        imm_type        = decoder_pkg::U;
        /* opcode */
        unique casez(opcode)
            7'b0110111 : begin
                /* LUI */
                uop = decoder_pkg::LUI;
            end
            7'b0010111 : begin
                /* AUIPC */
                uop = decoder_pkg::AUIPC;
                use_pc = 1'b1;
            end
            7'b1101111 : begin
                /* JAL */
                uop = decoder_pkg::JAL;
            end
            7'b1100111 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* JALR */
                        uop = decoder_pkg::JALR;
                        use_rs1  = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b1100011 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* BEQ */
                        uop = decoder_pkg::BEQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'b001 : begin
                        /* BNE */
                        uop = decoder_pkg::BNE;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'b100 : begin
                        /* BLT */
                        uop = decoder_pkg::BLT;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'b101 : begin
                        /* BGE */
                        uop = decoder_pkg::BGE;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'b110 : begin
                        /* BLTU */
                        uop = decoder_pkg::BLTU;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'b111 : begin
                        /* BGEU */
                        uop = decoder_pkg::BGEU;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b0000011 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* LB */
                        uop = decoder_pkg::LB;
                        use_rs1  = 1'b1;
                    end
                    3'b001 : begin
                        /* LH */
                        uop = decoder_pkg::LH;
                        use_rs1  = 1'b1;
                    end
                    3'b010 : begin
                        /* LW */
                        uop = decoder_pkg::LW;
                        use_rs1  = 1'b1;
                    end
                    3'b100 : begin
                        /* LBU */
                        uop = decoder_pkg::LBU;
                        use_rs1  = 1'b1;
                    end
                    3'b101 : begin
                        /* LHU */
                        uop = decoder_pkg::LHU;
                        use_rs1  = 1'b1;
                    end
                    3'b110 : begin
                        /* LWU */
                        uop = decoder_pkg::LWU;
                        use_rs1  = 1'b1;
                    end
                    3'b011 : begin
                        /* LD */
                        uop = decoder_pkg::LD;
                        use_rs1  = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b0100011 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* SB */
                        uop = decoder_pkg::SB;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'b001 : begin
                        /* SH */
                        uop = decoder_pkg::SH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'b010 : begin
                        /* SW */
                        uop = decoder_pkg::SW;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'b011 : begin
                        /* SD */
                        uop = decoder_pkg::SD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b0010011 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* ADDI */
                        uop = decoder_pkg::ADDI;
                        use_rs1  = 1'b1;
                    end
                    3'b010 : begin
                        /* SLTI */
                        uop = decoder_pkg::SLTI;
                        use_rs1  = 1'b1;
                    end
                    3'b011 : begin
                        /* SLTIU */
                        uop = decoder_pkg::SLTIU;
                        use_rs1  = 1'b1;
                    end
                    3'b100 : begin
                        /* XORI */
                        uop = decoder_pkg::XORI;
                        use_rs1  = 1'b1;
                    end
                    3'b110 : begin
                        /* ORI */
                        uop = decoder_pkg::ORI;
                        use_rs1  = 1'b1;
                    end
                    3'b111 : begin
                        /* ANDI */
                        uop = decoder_pkg::ANDI;
                        use_rs1  = 1'b1;
                    end
                    3'b001 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b000000? : begin
                                /* SLLI */
                                uop = decoder_pkg::SLLI;
                                use_rs1  = 1'b1;
                                imm_type = decoder_pkg::I;
                                use_rs2 = 1'b0;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b101 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b000000? : begin
                                /* SRLI */
                                uop = decoder_pkg::SRLI;
                                use_rs1  = 1'b1;
                                imm_type = decoder_pkg::I;
                                use_rs2 = 1'b0;
                            end
                            7'b010000? : begin
                                /* SRAI */
                                uop = decoder_pkg::SRAI;
                                use_rs1  = 1'b1;
                                imm_type = decoder_pkg::I;
                                use_rs2 = 1'b0;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b0110011 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* ADD */
                                uop = decoder_pkg::ADD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0100000 : begin
                                /* SUB */
                                uop = decoder_pkg::SUB;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0000001 : begin
                                /* MUL */
                                uop = decoder_pkg::MUL;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0111011 : begin
                                /* MULW */
                                uop = decoder_pkg::MULW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b001 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* SLL */
                                uop = decoder_pkg::SLL;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0000001 : begin
                                /* MULH */
                                uop = decoder_pkg::MULH;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b010 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* SLT */
                                uop = decoder_pkg::SLT;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0000001 : begin
                                /* MULHSU */
                                uop = decoder_pkg::MULHSU;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b00010?? : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* LRW */
                                        uop = decoder_pkg::LRW;
                                        use_rs1  = 1'b1;
                                        use_rs2  = 1'b1;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            7'b00011?? : begin
                                /* SCW */
                                uop = decoder_pkg::SCW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b00001?? : begin
                                /* AMOSWAPW */
                                uop = decoder_pkg::AMOSWAPW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b00000?? : begin
                                /* AMOADDW */
                                uop = decoder_pkg::AMOADDW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b00100?? : begin
                                /* AMOXORW */
                                uop = decoder_pkg::AMOXORW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b01100?? : begin
                                /* AMOANDW */
                                uop = decoder_pkg::AMOANDW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b01000?? : begin
                                /* AMOORW */
                                uop = decoder_pkg::AMOORW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b10000?? : begin
                                /* AMOMINW */
                                uop = decoder_pkg::AMOMINW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b10100?? : begin
                                /* AMOMAXW */
                                uop = decoder_pkg::AMOMAXW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b11000?? : begin
                                /* AMOMINUW */
                                uop = decoder_pkg::AMOMINUW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b11100?? : begin
                                /* AMOMAXUW */
                                uop = decoder_pkg::AMOMAXUW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b011 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* SLTU */
                                uop = decoder_pkg::SLTU;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0000001 : begin
                                /* MULHU */
                                uop = decoder_pkg::MULHU;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b00010?? : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* LRD */
                                        uop = decoder_pkg::LRD;
                                        use_rs1  = 1'b1;
                                        use_rs2  = 1'b1;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            7'b00011?? : begin
                                /* SCD */
                                uop = decoder_pkg::SCD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b00001?? : begin
                                /* AMOSWAPD */
                                uop = decoder_pkg::AMOSWAPD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b00000?? : begin
                                /* AMOADDD */
                                uop = decoder_pkg::AMOADDD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b00100?? : begin
                                /* AMOXORD */
                                uop = decoder_pkg::AMOXORD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b01100?? : begin
                                /* AMOANDD */
                                uop = decoder_pkg::AMOANDD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b01000?? : begin
                                /* AMOORD */
                                uop = decoder_pkg::AMOORD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b10000?? : begin
                                /* AMOMIND */
                                uop = decoder_pkg::AMOMIND;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b10100?? : begin
                                /* AMOMAXD */
                                uop = decoder_pkg::AMOMAXD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b11000?? : begin
                                /* AMOMINUD */
                                uop = decoder_pkg::AMOMINUD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b11100?? : begin
                                /* AMOMAXUD */
                                uop = decoder_pkg::AMOMAXUD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b100 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* XOR */
                                uop = decoder_pkg::XOR;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0000001 : begin
                                /* DIV */
                                uop = decoder_pkg::DIV;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0111011 : begin
                                /* DIVW */
                                uop = decoder_pkg::DIVW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b101 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* SRL */
                                uop = decoder_pkg::SRL;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0100000 : begin
                                /* SRA */
                                uop = decoder_pkg::SRA;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0000001 : begin
                                /* DIVU */
                                uop = decoder_pkg::DIVU;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0111011 : begin
                                /* DIVUW */
                                uop = decoder_pkg::DIVUW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b110 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* OR */
                                uop = decoder_pkg::OR;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0000001 : begin
                                /* REM */
                                uop = decoder_pkg::REM;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0111011 : begin
                                /* REMW */
                                uop = decoder_pkg::REMW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b111 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* AND */
                                uop = decoder_pkg::AND;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0000001 : begin
                                /* REMU */
                                uop = decoder_pkg::REMU;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0111011 : begin
                                /* REMUW */
                                uop = decoder_pkg::REMUW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b0011011 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* ADDIW */
                        uop = decoder_pkg::ADDIW;
                        use_rs1  = 1'b1;
                    end
                    3'b001 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* SLLIW */
                                uop = decoder_pkg::SLLIW;
                                use_rs1  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b101 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* SRLIW */
                                uop = decoder_pkg::SRLIW;
                                use_rs1  = 1'b1;
                            end
                            7'b0100000 : begin
                                /* SRAIW */
                                uop = decoder_pkg::SRAIW;
                                use_rs1  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b0111011 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* ADDW */
                                uop = decoder_pkg::ADDW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0100000 : begin
                                /* SUBW */
                                uop = decoder_pkg::SUBW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b001 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* SLLW */
                                uop = decoder_pkg::SLLW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b101 : begin
                        /* func7 */
                        unique casez(func7)
                            7'b0000000 : begin
                                /* SRLW */
                                uop = decoder_pkg::SRLW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            7'b0100000 : begin
                                /* SRAW */
                                uop = decoder_pkg::SRAW;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b0001111 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* FENCE */
                        uop = decoder_pkg::FENCE;
                        use_rs1 = 1'b0;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b1110011 : begin
                /* func3 */
                unique casez(func3)
                    3'b000 : begin
                        /* rd */
                        unique casez(rd)
                            5'b00000 : begin
                                /* rs1 */
                                unique casez(rs1)
                                    5'b00000 : begin
                                        /* func12 */
                                        unique casez(func12)
                                            12'b000000000000 : begin
                                                /* ECALL */
                                                uop = decoder_pkg::ECALL;
                                                ecall = 1'b1;
                                                use_rs1 = 1'b0;
                                            end
                                            12'b000000000001 : begin
                                                /* EBREAK */
                                                uop = decoder_pkg::EBREAK;
                                                ebreak = 1'b1;
                                                use_rs1 = 1'b0;
                                            end
                                            12'b001100000010 : begin
                                                /* MRET */
                                                uop = decoder_pkg::MRET;
                                                mret = 1'b1;
                                                use_rs1 = 1'b0;
                                            end
                                            12'b000100000010 : begin
                                                /* SRET */
                                                uop = decoder_pkg::SRET;
                                                sret = 1'b1;
                                                use_rs1 = 1'b0;
                                            end
                                            default : begin
                                                illigal = 1'b1;
                                            end
                                        endcase
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b001 : begin
                        /* CSRRW */
                        uop = decoder_pkg::CSRRW;
                        use_rs1  = 1'b1;
                    end
                    3'b010 : begin
                        /* CSRRS */
                        uop = decoder_pkg::CSRRS;
                        use_rs1  = 1'b1;
                    end
                    3'b011 : begin
                        /* CSRRC */
                        uop = decoder_pkg::CSRRC;
                        use_rs1  = 1'b1;
                    end
                    3'b101 : begin
                        /* CSRRWI */
                        uop = decoder_pkg::CSRRWI;
                        use_uimm = 1'b1;
                        use_rs1 = 1'b0;
                    end
                    3'b110 : begin
                        /* CSRRSI */
                        uop = decoder_pkg::CSRRSI;
                        use_uimm = 1'b1;
                        use_rs1 = 1'b0;
                    end
                    3'b111 : begin
                        /* CSRRCI */
                        uop = decoder_pkg::CSRRCI;
                        use_uimm = 1'b1;
                        use_rs1 = 1'b0;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b0000111 : begin
                /* func3 */
                unique casez(func3)
                    3'010 : begin
                        /* FLW */
                        uop = decoder_pkg::FLW;
                        use_rs1  = 1'b1;
                    end
                    3'011 : begin
                        /* FLD */
                        uop = decoder_pkg::FLD;
                        use_rs1  = 1'b1;
                    end
                    3'100 : begin
                        /* FLQ */
                        uop = decoder_pkg::FLQ;
                        use_rs1  = 1'b1;
                    end
                    3'001 : begin
                        /* FLH */
                        uop = decoder_pkg::FLH;
                        use_rs1  = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b0100111 : begin
                /* func3 */
                unique casez(func3)
                    3'010 : begin
                        /* FSW */
                        uop = decoder_pkg::FSW;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'011 : begin
                        /* FSD */
                        uop = decoder_pkg::FSD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'100 : begin
                        /* FSQ */
                        uop = decoder_pkg::FSQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    3'001 : begin
                        /* FSH */
                        uop = decoder_pkg::FSH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b1000011 : begin
                /* func7 */
                unique casez(func7)
                    7'b?????00 : begin
                        /* FMADDS */
                        uop = decoder_pkg::FMADDS;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????01 : begin
                        /* FMADDD */
                        uop = decoder_pkg::FMADDD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????11 : begin
                        /* FMADDQ */
                        uop = decoder_pkg::FMADDQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????10 : begin
                        /* FMADDH */
                        uop = decoder_pkg::FMADDH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b1000111 : begin
                /* func7 */
                unique casez(func7)
                    7'b?????00 : begin
                        /* FMSUBS */
                        uop = decoder_pkg::FMSUBS;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????01 : begin
                        /* FMSUBD */
                        uop = decoder_pkg::FMSUBD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????11 : begin
                        /* FMSUBQ */
                        uop = decoder_pkg::FMSUBQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????10 : begin
                        /* FMSUBH */
                        uop = decoder_pkg::FMSUBH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b1001011 : begin
                /* func7 */
                unique casez(func7)
                    7'b?????00 : begin
                        /* FNMSUBS */
                        uop = decoder_pkg::FNMSUBS;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????01 : begin
                        /* FNMSUBD */
                        uop = decoder_pkg::FNMSUBD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????11 : begin
                        /* FNMSUBQ */
                        uop = decoder_pkg::FNMSUBQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????10 : begin
                        /* FNMSUBH */
                        uop = decoder_pkg::FNMSUBH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b1001111 : begin
                /* func7 */
                unique casez(func7)
                    7'b?????00 : begin
                        /* FNMADDS */
                        uop = decoder_pkg::FNMADDS;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????01 : begin
                        /* FNMADDD */
                        uop = decoder_pkg::FNMADDD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????11 : begin
                        /* FNMADDQ */
                        uop = decoder_pkg::FNMADDQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b?????10 : begin
                        /* FNMADDH */
                        uop = decoder_pkg::FNMADDH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        use_rs3  = 1'b1;
                        check_frm = 1'b1;
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            7'b1010011 : begin
                /* func7 */
                unique casez(func7)
                    7'b0000000 : begin
                        /* FADDS */
                        uop = decoder_pkg::FADDS;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0000100 : begin
                        /* FSUBS */
                        uop = decoder_pkg::FSUBS;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0001000 : begin
                        /* FMULS */
                        uop = decoder_pkg::FMULS;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0001100 : begin
                        /* FDIVS */
                        uop = decoder_pkg::FDIVS;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0101100 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FSQRTS */
                                uop = decoder_pkg::FSQRTS;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0010000 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* FSGNJS */
                                uop = decoder_pkg::FSGNJS;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FSGNJNS */
                                uop = decoder_pkg::FSGNJNS;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'010 : begin
                                /* FSGNJXS */
                                uop = decoder_pkg::FSGNJXS;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0010100 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* FMINS */
                                uop = decoder_pkg::FMINS;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FMAXS */
                                uop = decoder_pkg::FMAXS;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1100000 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FCVTWS */
                                uop = decoder_pkg::FCVTWS;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTWUS */
                                uop = decoder_pkg::FCVTWUS;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1110000 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FMVXW */
                                        uop = decoder_pkg::FMVXW;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            3'001 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FCLASSS */
                                        uop = decoder_pkg::FCLASSS;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1010000 : begin
                        /* func3 */
                        unique casez(func3)
                            3'010 : begin
                                /* FEQS */
                                uop = decoder_pkg::FEQS;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FLTS */
                                uop = decoder_pkg::FLTS;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'000 : begin
                                /* FLES */
                                uop = decoder_pkg::FLES;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1101000 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FCVTSW */
                                uop = decoder_pkg::FCVTSW;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTSWU */
                                uop = decoder_pkg::FCVTSWU;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1111000 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FMVWX */
                                        uop = decoder_pkg::FMVWX;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1100010 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00010 : begin
                                /* FCVTLS */
                                uop = decoder_pkg::FCVTLS;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00011 : begin
                                /* FCVTLUS */
                                uop = decoder_pkg::FCVTLUS;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00000 : begin
                                /* FCVTWH */
                                uop = decoder_pkg::FCVTWH;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTWUH */
                                uop = decoder_pkg::FCVTWUH;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1101010 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00010 : begin
                                /* FCVTSL */
                                uop = decoder_pkg::FCVTSL;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00011 : begin
                                /* FCVTSLU */
                                uop = decoder_pkg::FCVTSLU;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00000 : begin
                                /* FCVTHW */
                                uop = decoder_pkg::FCVTHW;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTHWU */
                                uop = decoder_pkg::FCVTHWU;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0000001 : begin
                        /* FADDD */
                        uop = decoder_pkg::FADDD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0000101 : begin
                        /* FSUBD */
                        uop = decoder_pkg::FSUBD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0001001 : begin
                        /* FMULD */
                        uop = decoder_pkg::FMULD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0001101 : begin
                        /* FDIVD */
                        uop = decoder_pkg::FDIVD;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0101101 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FSQRTD */
                                uop = decoder_pkg::FSQRTD;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0010001 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* FSGNJD */
                                uop = decoder_pkg::FSGNJD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FSGNJND */
                                uop = decoder_pkg::FSGNJND;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'010 : begin
                                /* FSGNJXD */
                                uop = decoder_pkg::FSGNJXD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0010101 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* FMIND */
                                uop = decoder_pkg::FMIND;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FMAXD */
                                uop = decoder_pkg::FMAXD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0100000 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00001 : begin
                                /* FCVTSD */
                                uop = decoder_pkg::FCVTSD;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00011 : begin
                                /* FCVTSQ */
                                uop = decoder_pkg::FCVTSQ;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00010 : begin
                                /* FCVTSH */
                                uop = decoder_pkg::FCVTSH;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0100001 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FCVTDS */
                                uop = decoder_pkg::FCVTDS;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00011 : begin
                                /* FCVTDQ */
                                uop = decoder_pkg::FCVTDQ;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00010 : begin
                                /* FCVTDH */
                                uop = decoder_pkg::FCVTDH;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1010001 : begin
                        /* func3 */
                        unique casez(func3)
                            3'010 : begin
                                /* FEQD */
                                uop = decoder_pkg::FEQD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FLTD */
                                uop = decoder_pkg::FLTD;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'000 : begin
                                /* FLED */
                                uop = decoder_pkg::FLED;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1110001 : begin
                        /* func3 */
                        unique casez(func3)
                            3'001 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FCLASSD */
                                        uop = decoder_pkg::FCLASSD;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            3'b000 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FMVXD */
                                        uop = decoder_pkg::FMVXD;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1100001 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FCVTWD */
                                uop = decoder_pkg::FCVTWD;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTWUD */
                                uop = decoder_pkg::FCVTWUD;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00010 : begin
                                /* FCVTLD */
                                uop = decoder_pkg::FCVTLD;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00011 : begin
                                /* FCVTLUD */
                                uop = decoder_pkg::FCVTLUD;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1101001 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FCVTDW */
                                uop = decoder_pkg::FCVTDW;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTDWU */
                                uop = decoder_pkg::FCVTDWU;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00010 : begin
                                /* FCVTDL */
                                uop = decoder_pkg::FCVTDL;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00011 : begin
                                /* FCVTDLU */
                                uop = decoder_pkg::FCVTDLU;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1111001 : begin
                        /* func3 */
                        unique casez(func3)
                            3'b000 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FMVDX */
                                        uop = decoder_pkg::FMVDX;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0000011 : begin
                        /* FADDQ */
                        uop = decoder_pkg::FADDQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0000111 : begin
                        /* FSUBQ */
                        uop = decoder_pkg::FSUBQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0001011 : begin
                        /* FMULQ */
                        uop = decoder_pkg::FMULQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0001111 : begin
                        /* FDIVQ */
                        uop = decoder_pkg::FDIVQ;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0101111 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FSQRTQ */
                                uop = decoder_pkg::FSQRTQ;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0010011 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* FSGNJQ */
                                uop = decoder_pkg::FSGNJQ;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FSGNJNQ */
                                uop = decoder_pkg::FSGNJNQ;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'010 : begin
                                /* FSGNJXQ */
                                uop = decoder_pkg::FSGNJXQ;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0010111 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* FMINQ */
                                uop = decoder_pkg::FMINQ;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FMAXQ */
                                uop = decoder_pkg::FMAXQ;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0100011 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FCVTQS */
                                uop = decoder_pkg::FCVTQS;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTQD */
                                uop = decoder_pkg::FCVTQD;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00010 : begin
                                /* FCVTQH */
                                uop = decoder_pkg::FCVTQH;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1010011 : begin
                        /* func3 */
                        unique casez(func3)
                            3'010 : begin
                                /* FEQQ */
                                uop = decoder_pkg::FEQQ;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FLTQ */
                                uop = decoder_pkg::FLTQ;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'000 : begin
                                /* FLEQ */
                                uop = decoder_pkg::FLEQ;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1110011 : begin
                        /* func3 */
                        unique casez(func3)
                            3'001 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FCLASSQ */
                                        uop = decoder_pkg::FCLASSQ;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1100011 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FCVTWQ */
                                uop = decoder_pkg::FCVTWQ;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTWUQ */
                                uop = decoder_pkg::FCVTWUQ;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00010 : begin
                                /* FCVTLQ */
                                uop = decoder_pkg::FCVTLQ;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00011 : begin
                                /* FCVTLUQ */
                                uop = decoder_pkg::FCVTLUQ;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1101011 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FCVTQW */
                                uop = decoder_pkg::FCVTQW;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTQWU */
                                uop = decoder_pkg::FCVTQWU;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00010 : begin
                                /* FCVTQL */
                                uop = decoder_pkg::FCVTQL;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00011 : begin
                                /* FCVTQLU */
                                uop = decoder_pkg::FCVTQLU;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0000010 : begin
                        /* FADDH */
                        uop = decoder_pkg::FADDH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0000110 : begin
                        /* FSUBH */
                        uop = decoder_pkg::FSUBH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0001010 : begin
                        /* FMULH */
                        uop = decoder_pkg::FMULH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0001110 : begin
                        /* FDIVH */
                        uop = decoder_pkg::FDIVH;
                        use_rs1  = 1'b1;
                        use_rs2  = 1'b1;
                        check_frm = 1'b1;
                    end
                    7'b0101110 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FSQRTH */
                                uop = decoder_pkg::FSQRTH;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0010010 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* FSGNJH */
                                uop = decoder_pkg::FSGNJH;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FSGNJNH */
                                uop = decoder_pkg::FSGNJNH;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'010 : begin
                                /* FSGNJXH */
                                uop = decoder_pkg::FSGNJXH;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0010110 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* FMINH */
                                uop = decoder_pkg::FMINH;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FMAXH */
                                uop = decoder_pkg::FMAXH;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b0100010 : begin
                        /* rs2 */
                        unique casez(rs2)
                            5'b00000 : begin
                                /* FCVTHS */
                                uop = decoder_pkg::FCVTHS;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00001 : begin
                                /* FCVTHD */
                                uop = decoder_pkg::FCVTHD;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            5'b00011 : begin
                                /* FCVTHQ */
                                uop = decoder_pkg::FCVTHQ;
                                use_rs1  = 1'b1;
                                use_rs2 = 1'b0;
                                check_frm = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1110010 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FMVXH */
                                        uop = decoder_pkg::FMVXH;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            3'001 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FCLASSH */
                                        uop = decoder_pkg::FCLASSH;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1010010 : begin
                        /* func3 */
                        unique casez(func3)
                            3'010 : begin
                                /* FEQH */
                                uop = decoder_pkg::FEQH;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'001 : begin
                                /* FLTH */
                                uop = decoder_pkg::FLTH;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            3'000 : begin
                                /* FLEH */
                                uop = decoder_pkg::FLEH;
                                use_rs1  = 1'b1;
                                use_rs2  = 1'b1;
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    7'b1111010 : begin
                        /* func3 */
                        unique casez(func3)
                            3'000 : begin
                                /* rs2 */
                                unique casez(rs2)
                                    5'b00000 : begin
                                        /* FMVHX */
                                        uop = decoder_pkg::FMVHX;
                                        use_rs1  = 1'b1;
                                        use_rs2 = 1'b0;
                                    end
                                    default : begin
                                        illigal = 1'b1;
                                    end
                                endcase
                            end
                            default : begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    default : begin
                        illigal = 1'b1;
                    end
                endcase
            end
            default : begin
                illigal = 1'b1;
            end
        endcase
        /* Imm Selector */
        unique case(imm_type)
            decoder_pkg::I: begin
                use_imm = 1'b1;
                imm[32:12] = {21{instruction[11]}};
                imm[11:0] = instruction[31:20];
            end
            decoder_pkg::S: begin
                use_imm = 1'b1;
                imm[32:12] = {21{instruction[11]}};
                imm[11:5] = instruction[31:25];
                imm[4:0] = instruction[11:7];
            end
            decoder_pkg::B: begin
                use_imm = 1'b1;
                imm[32:13] = {20{instruction[12]}};
                imm[12] = instruction[31];
                imm[11] = instruction[7];
                imm[10:5] = instruction[30:25];
                imm[4:1] = instruction[11:8];
                imm[1:0] = 2'b0;
            end
            decoder_pkg::U: begin
                use_imm = 1'b1;
                imm[32:32] = {1{1'b0}};
                imm[31:12] = instruction[31:12];
                imm[12:0] = 13'b0;
            end
            decoder_pkg::J: begin
                use_imm = 1'b1;
                imm[32:21] = {12{instruction[20]}};
                imm[20] = instruction[31];
                imm[19:12] = instruction[19:12];
                imm[11] = instruction[20];
                imm[10:1] = instruction[30:21];
                imm[1:0] = 2'b0;
            end
            default: begin
                imm = 33'b0;
                use_imm = 1'b0;
            end
        endcase
    end
    /* Signal Assignment */
    assign rs1             = instruction[19:15];
    assign rs2             = instruction[24:20];
    assign rs3             = instruction[31:27];
    assign rm              = func3;
    assign rd              = instruction[11:7];
    assign opcode          = instruction[6:0];
    assign func3           = instruction[14:12];
    assign func7           = instruction[31:25];
    assign func12          = instruction[31:20];
    assign funct2          = instruction[26:26];
endmodule