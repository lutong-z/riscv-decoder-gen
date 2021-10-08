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
    output wbType_t        wbType,
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
        wbType          =  wbType_t.X;
        illigal         =  1'b0;
        ecall           =  1'b0;
        ebreak          =  1'b0;
        mret            =  1'b0;
        sret            =  1'b0;
        uret            =  1'b0;
        immType         =  immType_t.I;
    /* Decode opcode */
    switch (opcode) {
    case OpcodeLui:
        /* LUI */
        decode_format_U(ctx);
        gen_lui(env, ctx);
        break;
    case OpcodeAuipc:
        /* AUIPC */
        decode_format_U(ctx);
        gen_auipc(env, ctx);
        break;
    case OpcodeJal:
        /* JAL */
        decode_format_UJ(ctx);
        gen_jal(env, ctx);
        break;
    case OpcodeJalr:
        /* Decode func3 */
        switch (extract32(ctx->opcode, 0, 0)) {
        case 0:
            /* JALR */
            decode_format_I(ctx);
            gen_jalr(env, ctx);
            break;
        default:
            kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
            break;
        }
        break;
    case OpcodeBranch:
        /* Decode func3 */
        switch (extract32(ctx->opcode, 0, 0)) {
        case 0:
            /* BEQ */
            decode_format_SB(ctx);
            gen_beq(env, ctx);
            break;
        case 1:
            /* BNE */
            decode_format_SB(ctx);
            gen_bne(env, ctx);
            break;
        case 4:
            /* BLT */
            decode_format_SB(ctx);
            gen_blt(env, ctx);
            break;
        case 5:
            /* BGE */
            decode_format_SB(ctx);
            gen_bge(env, ctx);
            break;
        case 6:
            /* BLTU */
            decode_format_SB(ctx);
            gen_bltu(env, ctx);
            break;
        case 7:
            /* BGEU */
            decode_format_SB(ctx);
            gen_bgeu(env, ctx);
            break;
        default:
            kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
            break;
        }
        break;
    case OpcodeLoad:
        /* Decode func3 */
        switch (extract32(ctx->opcode, 0, 0)) {
        case 0:
            /* SB */
            decode_format_S(ctx);
            gen_sb(env, ctx);
            break;
        case 1:
            /* SH */
            decode_format_S(ctx);
            gen_sh(env, ctx);
            break;
        case 2:
            /* SW */
            decode_format_S(ctx);
            gen_sw(env, ctx);
            break;
        case 4:
            /* LBU */
            decode_format_I(ctx);
            gen_lbu(env, ctx);
            break;
        case 5:
            /* LHU */
            decode_format_I(ctx);
            gen_lhu(env, ctx);
            break;
        default:
            kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
            break;
        }
        break;
    case OpcodeOpImm:
        /* Decode func3 */
        switch (extract32(ctx->opcode, 0, 0)) {
        case 0:
            /* ADDI */
            decode_format_I(ctx);
            gen_addi(env, ctx);
            break;
        case 2:
            /* SLTI */
            decode_format_I(ctx);
            gen_slti(env, ctx);
            break;
        case 3:
            /* SLTIU */
            decode_format_I(ctx);
            gen_sltiu(env, ctx);
            break;
        case 4:
            /* XORI */
            decode_format_I(ctx);
            gen_xori(env, ctx);
            break;
        case 6:
            /* ORI */
            decode_format_I(ctx);
            gen_ori(env, ctx);
            break;
        case 7:
            /* ANDI */
            decode_format_I(ctx);
            gen_andi(env, ctx);
            break;
        case 1:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* SLLI */
                decode_format_R(ctx);
                gen_slli(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 5:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* SRLI */
                decode_format_R(ctx);
                gen_srli(env, ctx);
                break;
            case 32:
                /* SRAI */
                decode_format_R(ctx);
                gen_srai(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        default:
            kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
            break;
        }
        break;
    case OpcodeOp:
        /* Decode func3 */
        switch (extract32(ctx->opcode, 0, 0)) {
        case 0:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* ADD */
                decode_format_R(ctx);
                gen_add(env, ctx);
                break;
            case 32:
                /* SUB */
                decode_format_R(ctx);
                gen_sub(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 1:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* SLL */
                decode_format_R(ctx);
                gen_sll(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 2:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* SLT */
                decode_format_R(ctx);
                gen_slt(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 3:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* SLTU */
                decode_format_R(ctx);
                gen_sltu(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 4:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* XOR */
                decode_format_R(ctx);
                gen_xor(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 5:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* SRL */
                decode_format_R(ctx);
                gen_srl(env, ctx);
                break;
            case 32:
                /* SRA */
                decode_format_R(ctx);
                gen_sra(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 6:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* OR */
                decode_format_R(ctx);
                gen_or(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 7:
            /* Decode func7 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* AND */
                decode_format_R(ctx);
                gen_and(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        default:
            kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
            break;
        }
        break;
    case OpcodeMiscMem:
        /* Decode FENCE2 */
        switch (extract32(ctx->opcode, 0, 0)) {
        case 0:
            /* Decode FENCE3 */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* FENCE */
                decode_format_R(ctx);
                gen_fence(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 32:
            /* Decode FENCEI */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* FENCEI */
                decode_format_R(ctx);
                gen_fence_i(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        default:
            kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
            break;
        }
        break;
    case OpcodeSystem:
        /* Decode func3 */
        switch (extract32(ctx->opcode, 0, 0)) {
        case 0:
            /* Decode FENCEI */
            switch (extract32(ctx->opcode, 0, 0)) {
            case 0:
                /* ECALL */
                decode_format_I(ctx);
                gen_ecall(env, ctx);
                break;
            case 1:
                /* EBREAK */
                decode_format_I(ctx);
                gen_ebreak(env, ctx);
                break;
            default:
                kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
                break;
            }
            break;
        case 1:
            /* CSRRW */
            decode_format_I(ctx);
            gen_csrrw(env, ctx);
            break;
        case 2:
            /* CSRRS */
            decode_format_I(ctx);
            gen_csrrs(env, ctx);
            break;
        case 3:
            /* CSRRC */
            decode_format_I(ctx);
            gen_csrrc(env, ctx);
            break;
        case 5:
            /* CSRRWI */
            decode_format_I(ctx);
            gen_csrrwi(env, ctx);
            break;
        case 6:
            /* CSRRSI */
            decode_format_I(ctx);
            gen_csrrsi(env, ctx);
            break;
        case 7:
            /* CSRRCI */
            decode_format_I(ctx);
            gen_csrrci(env, ctx);
            break;
        default:
            kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
            break;
        }
        break;
    default:
        kill_unknown(ctx, RISCV_EXCP_ILLEGAL_INST);
        break;
    }
}
    assign rs1             =  instr[19:15];
    assign rs2             =  instr[24:20];
    assign rd              =  instr[11:7];
    assign opcode          =  instr[6:0];
    assign func3           =  instr[14:12];
    assign func7           =  instr[31:25];
endmodule