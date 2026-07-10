# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Mixed RV32I directed test.
#
#   The body below contains ten shuffled rounds. Each round exercises one
#   instance of the RV32I mnemonics listed in the comments, using varying
#   registers, PCs, branch targets, and memory offsets. Setup/trap/pass code is
#   auxiliary and is not part of the per-instruction count.
###############################################################################

  .option norvc
  .section .text.init
  .org 0x80
  .global _start

_start:
  lui   x20, %hi(mem_area)
  addi  x20, x20, %lo(mem_area)
  lui   x31, %hi(trap_handler)
  addi  x31, x31, %lo(trap_handler)
  csrw  mtvec, x31

round_0:
  lui   x1, 0x10101
  addi  x2, x0, 17
  sw    x2, 0(x20)
  auipc x3, 0
  lb    x4, 1(x20)
  beq   x0, x0, r0_beq
r0_beq:
  xor   x5, x1, x2
  jal   x6, r0_jal
r0_jal:
  lh    x7, 2(x20)
  slti  x8, x2, 18
  bne   x0, x1, r0_bne
r0_bne:
  slli  x9, x2, 1
  sh    x9, 4(x20)
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x10, 0(x31)
  lw    x11, 0(x20)
  blt   x0, x2, r0_blt
r0_blt:
  add   x12, x2, x9
  lbu   x13, 5(x20)
  srli  x14, x12, 1
  bge   x2, x0, r0_bge
r0_bge:
  sub   x15, x12, x2
  sb    x15, 8(x20)
  sltiu x16, x2, 32
  bltu  x0, x2, r0_bltu
r0_bltu:
  and   x17, x1, x12
  lhu   x18, 6(x20)
  srai  x19, x15, 1
  bgeu  x2, x0, r0_bgeu
r0_bgeu:
  or    x21, x17, x19
  xori  x22, x21, 0x35
  sll   x23, x2, x8
  ori   x24, x22, 0x7
  slt   x25, x0, x24
  andi  x26, x24, 0x7f
  sltu  x27, x0, x26
  srl   x28, x23, x8
  sra   x29, x19, x8
  fence
  fence.i
  ecall
  ebreak

round_1:
  addi  x3, x0, -23
  lui   x4, 0x20202
  sh    x3, 12(x20)
  bne   x3, x0, r1_bne
r1_bne:
  auipc x5, 1
  lhu   x6, 12(x20)
  xor   x7, x4, x6
  beq   x0, x0, r1_beq
r1_beq:
  sw    x7, 16(x20)
  lw    x21, 16(x20)
  sltiu x8, x6, 0x100
  jal   x9, r1_jal
r1_jal:
  lb    x10, 13(x20)
  slli  x11, x8, 2
  bltu  x0, x8, r1_bltu
r1_bltu:
  add   x12, x11, x10
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x13, 0(x31)
  lh    x14, 14(x20)
  srli  x15, x12, 2
  bgeu  x8, x0, r1_bgeu
r1_bgeu:
  sub   x16, x12, x15
  lbu   x17, 17(x20)
  slti  x18, x16, 64
  blt   x0, x18, r1_blt
r1_blt:
  sb    x18, 20(x20)
  and   x19, x16, x4
  srai  x21, x3, 3
  bge   x18, x0, r1_bge
r1_bge:
  or    x22, x19, x21
  xori  x23, x22, 0x56
  sll   x24, x8, x18
  ori   x25, x23, 0x18
  slt   x26, x21, x25
  andi  x27, x25, 0xf0
  sltu  x28, x0, x27
  srl   x29, x24, x8
  sra   x30, x21, x8
  fence
  fence.i
  ebreak
  ecall

round_2:
  auipc x7, 2
  addi  x8, x0, 45
  sb    x8, 24(x20)
  lui   x9, 0x30303
  lbu   x10, 24(x20)
  blt   x0, x10, r2_blt
r2_blt:
  slti  x11, x10, 80
  sw    x11, 28(x20)
  lhu   x5, 30(x20)
  beq   x0, x0, r2_beq
r2_beq:
  xor   x12, x9, x11
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x13, 0(x31)
  lh    x14, 30(x20)
  bge   x11, x0, r2_bge
r2_bge:
  slli  x15, x11, 3
  jal   x16, r2_jal
r2_jal:
  add   x17, x15, x10
  sh    x17, 32(x20)
  bne   x17, x0, r2_bne
r2_bne:
  srli  x18, x17, 1
  lw    x19, 28(x20)
  bltu  x0, x19, r2_bltu
r2_bltu:
  sub   x21, x19, x18
  sltiu x22, x19, 0x200
  bgeu  x22, x0, r2_bgeu
r2_bgeu:
  and   x23, x21, x12
  lb    x24, 33(x20)
  srai  x25, x21, 2
  or    x26, x23, x25
  xori  x27, x26, 0x77
  sll   x28, x22, x11
  ori   x29, x27, 0x1c
  slt   x30, x25, x29
  andi  x1, x29, 0x3f
  sltu  x2, x0, x1
  srl   x3, x28, x22
  sra   x4, x25, x22
  fence
  fence.i
  ecall
  ebreak

round_3:
  lui   x11, 0x40404
  addi  x12, x0, 63
  sw    x12, 36(x20)
  lh    x10, 36(x20)
  bgeu  x12, x0, r3_bgeu
r3_bgeu:
  auipc x13, 3
  lw    x14, 36(x20)
  sltiu x15, x14, 128
  bne   x14, x0, r3_bne
r3_bne:
  sh    x15, 40(x20)
  xor   x16, x11, x15
  jal   x17, r3_jal
r3_jal:
  lhu   x18, 40(x20)
  slli  x19, x15, 4
  beq   x0, x0, r3_beq
r3_beq:
  add   x21, x19, x18
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x22, 0(x31)
  lb    x23, 37(x20)
  blt   x0, x21, r3_blt
r3_blt:
  srli  x24, x21, 3
  sb    x24, 44(x20)
  bge   x21, x24, r3_bge
r3_bge:
  sub   x25, x21, x24
  lbu   x26, 44(x20)
  slti  x27, x25, 256
  bltu  x24, x21, r3_bltu
r3_bltu:
  and   x28, x25, x16
  srai  x29, x25, 2
  or    x30, x28, x29
  xori  x1, x30, 0x12
  sll   x2, x15, x27
  ori   x3, x1, 0x21
  slt   x4, x29, x3
  andi  x5, x3, 0x55
  sltu  x6, x0, x5
  srl   x7, x2, x15
  sra   x8, x29, x15
  fence
  fence.i
  ebreak
  ecall

round_4:
  addi  x16, x0, -91
  auipc x17, 4
  sb    x16, 48(x20)
  lh    x14, 48(x20)
  bltu  x0, x17, r4_bltu
r4_bltu:
  lui   x18, 0x50505
  lb    x19, 48(x20)
  slti  x21, x19, 0
  beq   x0, x0, r4_beq
r4_beq:
  sh    x21, 52(x20)
  xor   x22, x18, x21
  bge   x0, x19, r4_bge
r4_bge:
  lhu   x23, 52(x20)
  slli  x24, x23, 1
  jal   x25, r4_jal
r4_jal:
  sw    x24, 56(x20)
  add   x26, x24, x23
  bne   x26, x0, r4_bne
r4_bne:
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x27, 0(x31)
  lw    x28, 56(x20)
  bgeu  x28, x0, r4_bgeu
r4_bgeu:
  srli  x29, x28, 2
  sub   x30, x28, x29
  blt   x19, x0, r4_blt
r4_blt:
  lbu   x1, 49(x20)
  sltiu x2, x1, 255
  and   x3, x30, x22
  srai  x4, x16, 4
  or    x5, x3, x4
  xori  x6, x5, 0x23
  sll   x7, x2, x23
  ori   x8, x6, 0x42
  slt   x9, x4, x8
  andi  x10, x8, 0xaa
  sltu  x11, x0, x10
  srl   x12, x7, x2
  sra   x13, x4, x2
  fence
  fence.i
  ecall
  ebreak

round_5:
  lui   x21, 0x60606
  addi  x22, x0, 111
  sw    x22, 60(x20)
  lw    x1, 60(x20)
  bge   x22, x0, r5_bge
r5_bge:
  auipc x23, 5
  lhu   x24, 62(x20)
  sltiu x25, x24, 0x400
  blt   x0, x22, r5_blt
r5_blt:
  sb    x25, 64(x20)
  xor   x26, x21, x25
  bne   x25, x0, r5_bne
r5_bne:
  lb    x27, 64(x20)
  slli  x28, x25, 5
  beq   x0, x0, r5_beq
r5_beq:
  add   x29, x28, x27
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x30, 0(x31)
  lh    x1, 60(x20)
  bltu  x0, x29, r5_bltu
r5_bltu:
  srli  x2, x29, 4
  sh    x2, 66(x20)
  bgeu  x29, x2, r5_bgeu
r5_bgeu:
  sub   x3, x29, x2
  lbu   x4, 67(x20)
  slti  x5, x3, 512
  jal   x6, r5_jal
r5_jal:
  and   x7, x3, x26
  srai  x8, x3, 3
  or    x9, x7, x8
  xori  x10, x9, 0x44
  sll   x11, x5, x25
  ori   x12, x10, 0x63
  slt   x13, x8, x12
  andi  x14, x12, 0x33
  sltu  x15, x0, x14
  srl   x16, x11, x5
  sra   x17, x8, x5
  fence
  fence.i
  ebreak
  ecall

round_6:
  auipc x26, 6
  addi  x27, x0, -7
  sh    x27, 68(x20)
  lhu   x24, 68(x20)
  beq   x0, x0, r6_beq
r6_beq:
  lui   x28, 0x70707
  lh    x29, 68(x20)
  slti  x30, x29, 0
  blt   x29, x0, r6_blt
r6_blt:
  sw    x30, 72(x20)
  xor   x1, x28, x30
  bge   x0, x29, r6_bge
r6_bge:
  lbu   x2, 72(x20)
  slli  x3, x2, 2
  bne   x2, x0, r6_bne
r6_bne:
  add   x4, x3, x2
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x5, 0(x31)
  lw    x6, 72(x20)
  bltu  x0, x6, r6_bltu
r6_bltu:
  srli  x7, x6, 1
  sb    x7, 76(x20)
  bgeu  x6, x7, r6_bgeu
r6_bgeu:
  sub   x8, x6, x7
  lb    x9, 76(x20)
  sltiu x10, x8, 1024
  jal   x11, r6_jal
r6_jal:
  and   x12, x8, x1
  srai  x13, x27, 1
  or    x14, x12, x13
  xori  x15, x14, 0x65
  sll   x16, x10, x2
  ori   x17, x15, 0x24
  slt   x18, x13, x17
  andi  x19, x17, 0x5a
  sltu  x21, x0, x19
  srl   x22, x16, x10
  sra   x23, x13, x10
  fence
  fence.i
  ecall
  ebreak

round_7:
  lui   x2, 0x80808
  addi  x3, x0, 9
  sb    x3, 80(x20)
  bne   x3, x0, r7_bne
r7_bne:
  auipc x4, 7
  lbu   x5, 80(x20)
  sltiu x6, x5, 16
  bgeu  x6, x0, r7_bgeu
r7_bgeu:
  sw    x6, 84(x20)
  lw    x30, 84(x20)
  xor   x7, x2, x6
  jal   x8, r7_jal
r7_jal:
  lh    x9, 84(x20)
  slli  x10, x6, 6
  beq   x0, x0, r7_beq
r7_beq:
  add   x11, x10, x9
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x12, 0(x31)
  lb    x13, 81(x20)
  blt   x0, x11, r7_blt
r7_blt:
  srli  x14, x11, 2
  sh    x14, 88(x20)
  bge   x11, x14, r7_bge
r7_bge:
  sub   x15, x11, x14
  lhu   x16, 88(x20)
  slti  x17, x15, 2047
  bltu  x14, x11, r7_bltu
r7_bltu:
  and   x18, x15, x7
  srai  x19, x15, 4
  or    x21, x18, x19
  xori  x22, x21, 0x86
  sll   x23, x17, x6
  ori   x24, x22, 0x45
  slt   x25, x19, x24
  andi  x26, x24, 0x6c
  sltu  x27, x0, x26
  srl   x28, x23, x17
  sra   x29, x19, x17
  fence
  fence.i
  ebreak
  ecall

round_8:
  addi  x7, x0, -31
  lui   x8, 0x90909
  sh    x7, 92(x20)
  lhu   x5, 92(x20)
  bltu  x0, x8, r8_bltu
r8_bltu:
  auipc x9, 8
  lh    x10, 92(x20)
  slti  x11, x10, 0
  beq   x0, x0, r8_beq
r8_beq:
  sb    x11, 96(x20)
  xor   x12, x8, x11
  bge   x0, x10, r8_bge
r8_bge:
  lbu   x13, 96(x20)
  slli  x14, x13, 3
  jal   x15, r8_jal
r8_jal:
  sw    x14, 100(x20)
  add   x16, x14, x13
  bne   x16, x0, r8_bne
r8_bne:
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x17, 0(x31)
  lw    x18, 100(x20)
  bgeu  x18, x0, r8_bgeu
r8_bgeu:
  srli  x19, x18, 1
  sub   x21, x18, x19
  blt   x10, x0, r8_blt
r8_blt:
  lb    x22, 97(x20)
  sltiu x23, x22, 255
  and   x24, x21, x12
  srai  x25, x7, 2
  or    x26, x24, x25
  xori  x27, x26, 0xa7
  sll   x28, x23, x13
  ori   x29, x27, 0x66
  slt   x30, x25, x29
  andi  x1, x29, 0x78
  sltu  x2, x0, x1
  srl   x3, x28, x23
  sra   x4, x25, x23
  fence
  fence.i
  ecall
  ebreak

round_9:
  auipc x12, 9
  addi  x13, x0, 127
  sw    x13, 104(x20)
  bgeu  x13, x0, r9_bgeu
r9_bgeu:
  lui   x14, 0xa0a0a
  lw    x15, 104(x20)
  sltiu x16, x15, 256
  bne   x15, x0, r9_bne
r9_bne:
  sh    x16, 108(x20)
  lh    x10, 108(x20)
  xor   x17, x14, x16
  jal   x18, r9_jal
r9_jal:
  lhu   x19, 108(x20)
  slli  x21, x16, 7
  beq   x0, x0, r9_beq
r9_beq:
  add   x22, x21, x19
  .word 0x00000f97
  .word 0x00cf8f93
  jalr  x23, 0(x31)
  lb    x24, 105(x20)
  blt   x0, x22, r9_blt
r9_blt:
  srli  x25, x22, 3
  sb    x25, 112(x20)
  bge   x22, x25, r9_bge
r9_bge:
  sub   x26, x22, x25
  lbu   x27, 112(x20)
  slti  x28, x26, 2047
  bltu  x25, x22, r9_bltu
r9_bltu:
  and   x29, x26, x17
  srai  x30, x26, 5
  or    x1, x29, x30
  xori  x2, x1, 0xc8
  sll   x3, x28, x16
  ori   x4, x2, 0x87
  slt   x5, x30, x4
  andi  x6, x4, 0x7e
  sltu  x7, x0, x6
  srl   x8, x3, x28
  sra   x9, x30, x28
  fence
  fence.i
  ebreak
  ecall

pass:
  lui   x2, 0x90000
  addi  x2, x2, -8
  addi  x1, x0, 1
  sw    x1, 0(x2)
1:
  jal   x0, 1b

  .balign 256
trap_handler:
  csrr  x31, mepc
  addi  x31, x31, 4
  csrw  mepc, x31
  mret

  .section .data
  .align 4
mem_area:
  .word 0x01020304, 0x11121314, 0x21222324, 0x31323334
  .word 0x41424344, 0x51525354, 0x61626364, 0x71727374
  .word 0x81828384, 0x91929394, 0xa1a2a3a4, 0xb1b2b3b4
  .word 0xc1c2c3c4, 0xd1d2d3d4, 0xe1e2e3e4, 0xf1f2f3f4
  .word 0x00112233, 0x44556677, 0x8899aabb, 0xccddeeff
  .word 0x10213243, 0x54657687, 0x98a9bacb, 0xdcedfe0f
