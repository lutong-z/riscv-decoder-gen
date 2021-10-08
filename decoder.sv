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
    output op1Type_t       op1Type,
    output isaReg_t        rs2,
    output op2Type_t       op2Type,
    output isaReg_t        rd,
    output logic           wbType,
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
    // decode logic
    always_comb  begin
        uop             =  uop_t.NOP;
        op1Type         =  op1Type_t.X;
        op2Type         =  op2Type_t.X;
        wbType          =  1'b0;
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
            end
            /* AUIPC */
            OpcodeAuipc : begin
            end
            /* JAL */
            OpcodeJal : begin
            end
            OpcodeJalr : begin
                /* Decode func3 */
                case (func3)
                    /* JALR */
                    3'b000 : begin
                    end
                    default: begin
                        illigal = 1'b1
                    end
                endcase
            end
            OpcodeBranch : begin
                /* Decode func3 */
                case (func3)
                    /* BEQ */
                    3'b000 : begin
                    end
                    /* BNE */
                    3'b001 : begin
                    end
                    /* BLT */
                    3'b100 : begin
                    end
                    /* BGE */
                    3'b101 : begin
                    end
                    /* BLTU */
                    3'b110 : begin
                    end
                    /* BGEU */
                    3'b111 : begin
                    end
                    default: begin
                        illigal = 1'b1
                    end
                endcase
            end
            OpcodeLoad : begin
                /* Decode func3 */
                case (func3)
                    /* SB */
                    3'b000 : begin
                    end
                    /* SH */
                    3'b001 : begin
                    end
                    /* SW */
                    3'b010 : begin
                    end
                    /* LBU */
                    3'b100 : begin
                    end
                    /* LHU */
                    3'b101 : begin
                    end
                    default: begin
                        illigal = 1'b1
                    end
                endcase
            end
            OpcodeOpImm : begin
                /* Decode func3 */
                case (func3)
                    /* ADDI */
                    3'b000 : begin
                    end
                    /* SLTI */
                    3'b010 : begin
                    end
                    /* SLTIU */
                    3'b011 : begin
                    end
                    /* XORI */
                    3'b100 : begin
                    end
                    /* ORI */
                    3'b110 : begin
                    end
                    /* ANDI */
                    3'b111 : begin
                    end
                    3'b001 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SLLI */
                            7'd0 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    3'b101 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SRLI */
                            7'd0 : begin
                            end
                            /* SRAI */
                            7'd32 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    default: begin
                        illigal = 1'b1
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
                            end
                            /* SUB */
                            7'd32 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    3'b001 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SLL */
                            7'd0 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    3'b010 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SLT */
                            7'd0 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    3'b011 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SLTU */
                            7'd0 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    3'b100 : begin
                        /* Decode func7 */
                        case (func7)
                            /* XOR */
                            7'd0 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    3'b101 : begin
                        /* Decode func7 */
                        case (func7)
                            /* SRL */
                            7'd0 : begin
                            end
                            /* SRA */
                            7'd32 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    3'b110 : begin
                        /* Decode func7 */
                        case (func7)
                            /* OR */
                            7'd0 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    3'b111 : begin
                        /* Decode func7 */
                        case (func7)
                            /* AND */
                            7'd0 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    default: begin
                        illigal = 1'b1
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
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    'd32 : begin
                        /* Decode FENCEI */
                        case (FENCEI)
                            /* FENCEI */
                            'd0 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    default: begin
                        illigal = 1'b1
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
                            end
                            /* EBREAK */
                            'd1 : begin
                            end
                            default: begin
                                illigal = 1'b1
                            end
                        endcase
                    end
                    /* CSRRW */
                    3'b001 : begin
                    end
                    /* CSRRS */
                    3'b010 : begin
                    end
                    /* CSRRC */
                    3'b011 : begin
                    end
                    /* CSRRWI */
                    3'b101 : begin
                    end
                    /* CSRRSI */
                    3'b110 : begin
                    end
                    /* CSRRCI */
                    3'b111 : begin
                    end
                    default: begin
                        illigal = 1'b1
                    end
                endcase
            end
            default: begin
                illigal = 1'b1
            end
        endcase
    assign rs1             =  instr[19:15];
    assign rs2             =  instr[24:20];
    assign rd              =  instr[11:7];
    assign opcode          =  instr[6:0];
    assign func3           =  instr[14:12];
    assign func7           =  instr[31:25];
endmodule