/*
 * THIS FILE IS GENERATED, DO NOT EDIT IT MANUALLY
 * (C) 2021 Lutong Zhang <lutong.z@rioslab.org>
 */

module decoder(
    // input signal
    input  instr_t         instr,
    // output signal
    output uop_t           uop,
    output isaReg_t        rs1,
    output logic           rdRs1En,
    output isaReg_t        rs2,
    output logic           rdRs2En,
    output isaReg_t        rd,
    output logic           illigal,
    output logic           ecall,
    output logic           ebreak,
    output logic           mret,
    output logic           sret,
    output logic           uret
);
    // parameter
    localparam OpcodeLoad      = 7'b00_000_11;
    localparam OpcodeLoadFp    = 7'b00_001_11;
    localparam OpcodeCustom0   = 7'b00_010_11;
    localparam OpcodeMiscMem   = 7'b00_011_11;
    localparam OpcodeOpImm     = 7'b00_100_11;
    localparam OpcodeAuipc     = 7'b00_101_11;
    localparam OpcodeOpImm32   = 7'b00_110_11;
    localparam OpcodeStore     = 7'b01_000_11;
    localparam OpcodeStoreFp   = 7'b01_001_11;
    localparam OpcodeCustom1   = 7'b01_010_11;
    localparam OpcodeAmo       = 7'b01_011_11;
    localparam OpcodeOp        = 7'b01_100_11;
    localparam OpcodeLui       = 7'b01_101_11;
    localparam OpcodeOp32      = 7'b01_110_11;
    localparam OpcodeMadd      = 7'b10_000_11;
    localparam OpcodeMsub      = 7'b10_001_11;
    localparam OpcodeNmsub     = 7'b10_010_11;
    localparam OpcodeNmadd     = 7'b10_011_11;
    localparam OpcodeOpFp      = 7'b10_100_11;
    localparam OpcodeRsrvd1    = 7'b10_101_11;
    localparam OpcodeCustom2   = 7'b10_110_11;
    localparam OpcodeBranch    = 7'b11_000_11;
    localparam OpcodeJalr      = 7'b11_001_11;
    localparam OpcodeRsrvd2    = 7'b11_010_11;
    localparam OpcodeJal       = 7'b11_011_11;
    localparam OpcodeSystem    = 7'b11_100_11;
    localparam OpcodeRsrvd3    = 7'b11_101_11;
    localparam OpcodeCustom3   = 7'b11_110_11;
    // temp varible
    immType_t       immType;
    logic[6:0]      opcode;
    logic[2:0]      func3;
    logic[6:0]      func7;
    logic[12:0]     FENCE2;
    logic[4:0]      FENCE3;
    logic[11:0]     FENCEI;
    // decode logic
    always_comb  begin
        uop             =  uop_t.ADDI;
        rdRs1En         =  1'b0;
        rdRs2En         =  1'b0;
        illigal         =  1'b0;
        ecall           =  1'b0;
        ebreak          =  1'b0;
        mret            =  1'b0;
        sret            =  1'b0;
        uret            =  1'b0;
        immType         =  immType_t.I;
        /* Decode opcode */
        case (opcode) 
            /* LUI */
            OpcodeLui : begin
                uop = uop_t.LUI;
                immType = immType_t.U;
            end
            /* AUIPC */
            OpcodeAuipc : begin
                uop = uop_t.AUIPC;
                immType = immType_t.U;
            end
            /* JAL */
            OpcodeJal : begin
                uop = uop_t.JAL;
                immType = immType_t.J;
            end
            OpcodeJalr : begin
                /* Decode func3 */
                case (func3)
                    /* JALR */
                    3'b000 : begin
                        uop = uop_t.JALR;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    default: begin
                        illigal = 1'b1;
                    end
                endcase
            end
            OpcodeBranch : begin
                /* Decode func3 */
                case (func3)
                    /* BEQ */
                    3'b000 : begin
                        uop = uop_t.BEQ;
                        rdRs1En = 1'b1;
                        rdRs2En = 1'b1;
                        immType = immType_t.B;
                    end
                    /* BNE */
                    3'b001 : begin
                        uop = uop_t.BNE;
                        rdRs1En = 1'b1;
                        rdRs2En = 1'b1;
                        immType = immType_t.B;
                    end
                    /* SRAW */
                    3'b100 : begin
                        uop = uop_t.SRAW;
                        rdRs1En = 1'b1;
                        rdRs2En = 1'b1;
                        immType = immType_t.B;
                    end
                    /* BGE */
                    3'b101 : begin
                        uop = uop_t.BGE;
                        rdRs1En = 1'b1;
                        rdRs2En = 1'b1;
                        immType = immType_t.B;
                    end
                    /* BLTU */
                    3'b110 : begin
                        uop = uop_t.BLTU;
                        rdRs1En = 1'b1;
                        rdRs2En = 1'b1;
                        immType = immType_t.B;
                    end
                    /* BGEU */
                    3'b111 : begin
                        uop = uop_t.BGEU;
                        rdRs1En = 1'b1;
                        rdRs2En = 1'b1;
                        immType = immType_t.B;
                    end
                    default: begin
                        illigal = 1'b1;
                    end
                endcase
            end
            OpcodeLoad : begin
                /* Decode func3 */
                case (func3)
                    /* SB */
                    3'b000 : begin
                        uop = uop_t.SB;
                        rdRs1En = 1'b1;
                        rdRs2En = 1'b1;
                        immType = immType_t.S;
                    end
                    /* SH */
                    3'b001 : begin
                        uop = uop_t.SH;
                        rdRs1En = 1'b1;
                        rdRs2En = 1'b1;
                        immType = immType_t.S;
                    end
                    /* SW */
                    3'b010 : begin
                        uop = uop_t.SW;
                        rdRs1En = 1'b1;
                        rdRs2En = 1'b1;
                        immType = immType_t.S;
                    end
                    /* LBU */
                    3'b100 : begin
                        uop = uop_t.LBU;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* LHU */
                    3'b101 : begin
                        uop = uop_t.LHU;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    default: begin
                        illigal = 1'b1;
                    end
                endcase
            end
            OpcodeOpImm : begin
                /* Decode func3 */
                case (func3)
                    /* ADDI */
                    3'b000 : begin
                        uop = uop_t.ADDI;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* SLTI */
                    3'b010 : begin
                        uop = uop_t.SLTI;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* SLTIU */
                    3'b011 : begin
                        uop = uop_t.SLTIU;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* XORI */
                    3'b100 : begin
                        uop = uop_t.XORI;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* ORI */
                    3'b110 : begin
                        uop = uop_t.ORI;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* ANDI */
                    3'b111 : begin
                        uop = uop_t.ANDI;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    3'b001 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SLLI */
                            7'd0 : begin
                                uop = uop_t.SLLI;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b101 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SRLI */
                            7'd0 : begin
                                uop = uop_t.SRLI;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            /* SRAI */
                            7'd32 : begin
                                uop = uop_t.SRAI;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    default: begin
                        illigal = 1'b1;
                    end
                endcase
            end
            OpcodeOp : begin
                /* Decode func3 */
                case (func3)
                    3'b000 : begin
                        /* Decode func7 */
                        case (func7)
                            /* ADD */
                            7'd0 : begin
                                uop = uop_t.ADD;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            /* SUB */
                            7'd32 : begin
                                uop = uop_t.SUB;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b001 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SLL */
                            7'd0 : begin
                                uop = uop_t.SLL;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b010 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SLT */
                            7'd0 : begin
                                uop = uop_t.SLT;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b011 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SLTU */
                            7'd0 : begin
                                uop = uop_t.SLTU;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b100 : begin
                        /* Decode func7 */
                        case (func7)
                            /* XOR */
                            7'd0 : begin
                                uop = uop_t.XOR;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b101 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SRL */
                            7'd0 : begin
                                uop = uop_t.SRL;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            /* SRA */
                            7'd32 : begin
                                uop = uop_t.SRA;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b110 : begin
                        /* Decode func7 */
                        case (func7)
                            /* OR */
                            7'd0 : begin
                                uop = uop_t.OR;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    3'b111 : begin
                        /* Decode func7 */
                        case (func7)
                            /* AND */
                            7'd0 : begin
                                uop = uop_t.AND;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    default: begin
                        illigal = 1'b1;
                    end
                endcase
            end
            OpcodeMiscMem : begin
                /* Decode FENCE2 */
                case (FENCE2)
                    'd0 : begin
                        /* Decode FENCE3 */
                        case (FENCE3)
                            /* FENCE */
                            'd0 : begin
                                uop = uop_t.FENCE;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    'd32 : begin
                        /* Decode FENCEI */
                        case (FENCEI)
                            /* FENCEI */
                            'd0 : begin
                                uop = uop_t.FENCEI;
                                rdRs1En = 1'b1;
                                rdRs2En = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    default: begin
                        illigal = 1'b1;
                    end
                endcase
            end
            OpcodeSystem : begin
                /* Decode func3 */
                case (func3)
                    3'b000 : begin
                        /* Decode FENCEI */
                        case (FENCEI)
                            /* ECALL */
                            'd0 : begin
                                uop = uop_t.ECALL;
                                rdRs1En = 1'b1;
                                immType = immType_t.I;
                                ecall = 1'b1;
                            end
                            /* EBREAK */
                            'd1 : begin
                                uop = uop_t.EBREAK;
                                rdRs1En = 1'b1;
                                immType = immType_t.I;
                                ebreak = 1'b1;
                            end
                            default: begin
                                illigal = 1'b1;
                            end
                        endcase
                    end
                    /* CSRRW */
                    3'b001 : begin
                        uop = uop_t.CSRRW;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* CSRRS */
                    3'b010 : begin
                        uop = uop_t.CSRRS;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* CSRRC */
                    3'b011 : begin
                        uop = uop_t.CSRRC;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* CSRRWI */
                    3'b101 : begin
                        uop = uop_t.CSRRWI;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* CSRRSI */
                    3'b110 : begin
                        uop = uop_t.CSRRSI;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    /* CSRRCI */
                    3'b111 : begin
                        uop = uop_t.CSRRCI;
                        rdRs1En = 1'b1;
                        immType = immType_t.I;
                    end
                    default: begin
                        illigal = 1'b1;
                    end
                endcase
            end
            default: begin
                illigal = 1'b1;
            end
        endcase
    end
    /* Assignment */
    assign rs1             =  instr[19:15];
    assign rs2             =  instr[24:20];
    assign rd              =  instr[11:7];
    assign opcode          =  instr[6:0];
    assign func3           =  instr[14:12];
    assign func7           =  instr[31:25];
    assign FENCE2          =  instr[19:7];
    assign FENCE3          =  instr[31:27];
    assign FENCEI          =  instr[31:20];
endmodule