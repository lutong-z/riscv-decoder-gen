module decoder
    import decoder_pkg::*;
(
    /* input signal */
    input       logic[31:0]     instruction,
    /* output signal */
    output      uop_t           uop,
    output      logic[4:0]      rs1,
    output      logic[4:0]      rs2,
    output      logic[4:0]      rd,
    output      logic           use_rs1,
    output      logic           use_rs2,
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
    /* Decode Logic */
    always_comb begin
        /* Signal initialize*/
        uop             = decoder_pkg::ADDI;
        use_rs1         = 1'b0;
        use_rs2         = 1'b0;
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
    assign rd              = instruction[11:7];
    assign opcode          = instruction[6:0];
    assign func3           = instruction[14:12];
    assign func7           = instruction[31:25];
    assign func12          = instruction[31:20];
endmodule