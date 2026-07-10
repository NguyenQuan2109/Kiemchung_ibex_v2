# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Shuffled RV32C/Zca directed test.
#
#   The body contains 10 deterministic shuffled rounds. Each round has one
#   source-level instance of every compressed integer mnemonic below:
#     c.addi4spn c.lw c.sw c.nop c.addi c.jal c.li c.addi16sp
#     c.lui c.srli c.srai c.andi c.sub c.xor c.or c.and c.j
#     c.beqz c.bnez c.slli c.lwsp c.jr c.mv c.ebreak c.jalr c.add c.swsp
#   Setup/trap/pass code and encoded branch-target helpers are auxiliary and
#   are not part of the per-mnemonic source count.
###############################################################################

  .option rvc
  .section .text.init
  .org 0x80
  .global _start

_start:
  lui   x2, %hi(mem_area)
  addi  x2, x2, %lo(mem_area)
  addi  x2, x2, 128
  lui   x31, %hi(trap_handler)
  addi  x31, x31, %lo(trap_handler)
  csrw  mtvec, x31
  addi  x8, x2, -64
  addi  x9, x2, -60
  addi  x10, x2, -56
  addi  x11, x2, -52
  addi  x12, x2, -48
  addi  x13, x2, -44
  addi  x14, x2, -40
  addi  x15, x2, -36

round_0:
  c.sw      x9, 0(x8)
  c.lw      x9, 4(x9)
  c.addi4spn x10, x2, 16
  c.swsp    x17, 12(x2)
  c.add     x13, x22
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r0_5_jalr:
  c.ebreak
  c.mv      x22, x6
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r0_8_jr:
  c.lwsp    x28, 36(x2)
  c.slli    x31, 10
  c.bnez    x11, r0_11_bnez
r0_11_bnez:
  c.beqz    x12, r0_12_beqz
r0_12_beqz:
  c.j       r0_13_j
r0_13_j:
  c.and     x14, x15
  c.or      x15, x8
  c.xor     x8, x9
  c.sub     x9, x10
  c.andi    x10, 3
  c.srai    x11, 19
  c.srli    x12, 20
  c.lui     x1, 1
  c.addi16sp x2, 16
  c.li      x8, 7
  c.jal     r0_24_jal
r0_24_jal:
  c.addi    x14, 7
  c.nop

round_1:
  c.lui     x3, 2
  c.srai    x10, 4
  c.sub     x11, x14
  c.or      x12, x15
  c.j       r1_4_j
r1_4_j:
  c.bnez    x15, r1_5_bnez
r1_5_bnez:
  c.lwsp    x26, 32(x2)
  c.mv      x29, x17
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r1_8_jalr:
  c.swsp    x27, 44(x2)
  c.lw      x11, 12(x12)
  c.nop
  c.jal     r1_12_jal
r1_12_jal:
  c.addi16sp x2, -16
  c.srli    x15, 15
  c.andi    x8, 31
  c.xor     x9, x12
  c.and     x10, x13
  c.beqz    x12, r1_18_beqz
r1_18_beqz:
  c.slli    x3, 20
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r1_20_jr:
  c.ebreak
  c.add     x12, x30
  c.addi4spn x8, x2, 32
  c.sw      x12, 4(x10)
  c.addi    x21, 15
  c.li      x24, -16

round_2:
  c.sub     x10, x15
  c.andi    x11, 1
  c.srai    x12, 8
  c.srli    x13, 5
  c.lui     x4, 2
  c.addi16sp x2, 32
  c.li      x18, -32
  c.jal     r2_7_jal
r2_7_jal:
  c.addi    x8, -32
  c.nop
  c.sw      x9, 16(x14)
  c.lw      x13, 20(x15)
  c.addi4spn x14, x2, 48
  c.swsp    x27, 4(x2)
  c.add     x26, x1
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r2_15_jalr:
  c.ebreak
  c.mv      x4, x16
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r2_18_jr:
  c.lwsp    x10, 28(x2)
  c.slli    x13, 22
  c.bnez    x9, r2_21_bnez
r2_21_bnez:
  c.beqz    x10, r2_22_beqz
r2_22_beqz:
  c.j       r2_23_j
r2_23_j:
  c.and     x10, x15
  c.or      x11, x8
  c.xor     x12, x9

round_3:
  c.bnez    x14, r3_0_bnez
r3_0_bnez:
  c.lwsp    x25, 28(x2)
  c.mv      x28, x14
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r3_3_jalr:
  c.swsp    x24, 40(x2)
  c.lw      x8, 0(x11)
  c.nop
  c.jal     r3_7_jal
r3_7_jal:
  c.addi16sp x2, -32
  c.srli    x12, 12
  c.andi    x13, 1
  c.xor     x14, x13
  c.and     x15, x14
  c.beqz    x11, r3_13_beqz
r3_13_beqz:
  c.slli    x19, 17
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r3_15_jr:
  c.ebreak
  c.add     x11, x27
  c.addi4spn x13, x2, 64
  c.sw      x13, 24(x9)
  c.addi    x20, -1
  c.li      x23, 15
  c.lui     x5, 4
  c.srai    x10, 0
  c.sub     x11, x10
  c.or      x12, x11
  c.j       r3_26_j
r3_26_j:

round_4:
  c.mv      x29, x15
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r4_1_jr:
  c.lwsp    x4, 40(x2)
  c.slli    x7, 7
  c.bnez    x12, r4_4_bnez
r4_4_bnez:
  c.beqz    x13, r4_5_beqz
r4_5_beqz:
  c.j       r4_6_j
r4_6_j:
  c.and     x11, x12
  c.or      x12, x13
  c.xor     x13, x14
  c.sub     x14, x15
  c.andi    x15, 15
  c.srai    x8, 24
  c.srli    x9, 17
  c.lui     x6, 3
  c.addi16sp x2, 48
  c.li      x15, -8
  c.jal     r4_17_jal
r4_17_jal:
  c.addi    x21, -8
  c.nop
  c.sw      x9, 0(x12)
  c.lw      x9, 4(x13)
  c.addi4spn x10, x2, 80
  c.swsp    x6, 60(x2)
  c.add     x8, x11
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r4_25_jalr:
  c.ebreak

round_5:
  c.lw      x13, 20(x10)
  c.nop
  c.jal     r5_2_jal
r5_2_jal:
  c.addi16sp x2, -48
  c.srli    x9, 9
  c.andi    x10, -32
  c.xor     x11, x14
  c.and     x12, x15
  c.beqz    x10, r5_8_beqz
r5_8_beqz:
  c.slli    x1, 14
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r5_10_jr:
  c.ebreak
  c.add     x10, x24
  c.addi4spn x10, x2, 96
  c.sw      x14, 12(x8)
  c.addi    x19, -32
  c.li      x22, -1
  c.lui     x7, 8
  c.srai    x15, 1
  c.sub     x8, x11
  c.or      x9, x12
  c.j       r5_21_j
r5_21_j:
  c.bnez    x8, r5_22_bnez
r5_22_bnez:
  c.lwsp    x12, 4(x2)
  c.mv      x15, x22
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r5_25_jalr:
  c.swsp    x1, 16(x2)

round_6:
  c.jal     r6_0_jal
r6_0_jal:
  c.addi    x15, 31
  c.nop
  c.sw      x14, 4(x15)
  c.lw      x10, 8(x8)
  c.addi4spn x11, x2, 112
  c.swsp    x5, 8(x2)
  c.add     x18, x10
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r6_8_jalr:
  c.ebreak
  c.mv      x11, x25
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r6_11_jr:
  c.lwsp    x17, 32(x2)
  c.slli    x20, 19
  c.bnez    x10, r6_14_bnez
r6_14_bnez:
  c.beqz    x11, r6_15_beqz
r6_15_beqz:
  c.j       r6_16_j
r6_16_j:
  c.and     x15, x12
  c.or      x8, x13
  c.xor     x9, x14
  c.sub     x10, x15
  c.andi    x11, -8
  c.srai    x12, 8
  c.srli    x13, 29
  c.lui     x16, 15
  c.addi16sp x2, 64
  c.li      x28, 1

round_7:
  c.andi    x15, -8
  c.xor     x8, x15
  c.and     x9, x8
  c.beqz    x9, r7_3_beqz
r7_3_beqz:
  c.slli    x31, 11
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r7_5_jr:
  c.ebreak
  c.add     x9, x21
  c.addi4spn x15, x2, 128
  c.sw      x15, 0(x15)
  c.addi    x18, 31
  c.li      x21, -32
  c.lui     x17, 16
  c.srai    x12, 2
  c.sub     x13, x12
  c.or      x14, x13
  c.j       r7_16_j
r7_16_j:
  c.bnez    x15, r7_17_bnez
r7_17_bnez:
  c.lwsp    x11, 0(x2)
  c.mv      x14, x19
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r7_20_jalr:
  c.swsp    x29, 12(x2)
  c.lw      x13, 20(x12)
  c.nop
  c.jal     r7_24_jal
r7_24_jal:
  c.addi16sp x2, -64
  c.srli    x9, 1

round_8:
  c.and     x8, x9
  c.or      x9, x10
  c.xor     x10, x11
  c.sub     x11, x12
  c.andi    x12, 0
  c.srai    x13, 29
  c.srli    x14, 14
  c.lui     x18, 31
  c.addi16sp x2, 16
  c.li      x22, -16
  c.jal     r8_10_jal
r8_10_jal:
  c.addi    x28, -16
  c.nop
  c.sw      x14, 20(x13)
  c.lw      x14, 24(x14)
  c.addi4spn x15, x2, 144
  c.swsp    x15, 0(x2)
  c.add     x15, x20
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r8_18_jalr:
  c.ebreak
  c.mv      x24, x4
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r8_21_jr:
  c.lwsp    x30, 24(x2)
  c.slli    x19, 31
  c.bnez    x8, r8_24_bnez
r8_24_bnez:
  c.beqz    x9, r8_25_beqz
r8_25_beqz:
  c.j       r8_26_j
r8_26_j:

round_9:
  .word 0x00000297
  .word 0x00a28293
  c.jr      x5
r9_0_jr:
  c.ebreak
  c.add     x8, x18
  c.addi4spn x12, x2, 160
  c.sw      x8, 20(x14)
  c.addi    x17, 1
  c.li      x20, 31
  c.lui     x19, 31
  c.srai    x9, 3
  c.sub     x10, x13
  c.or      x11, x14
  c.j       r9_11_j
r9_11_j:
  c.bnez    x14, r9_12_bnez
r9_12_bnez:
  c.lwsp    x10, 60(x2)
  c.mv      x13, x16
  .word 0x00000297
  .word 0x00a28293
  c.jalr    x5
r9_15_jalr:
  c.swsp    x26, 8(x2)
  c.lw      x10, 8(x11)
  c.nop
  c.jal     r9_19_jal
r9_19_jal:
  c.addi16sp x2, -16
  c.srli    x14, 30
  c.andi    x15, -1
  c.xor     x8, x11
  c.and     x9, x12
  c.beqz    x11, r9_25_beqz
r9_25_beqz:
  c.slli    x18, 3

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
  addi  x31, x31, 2
  csrw  mepc, x31
  mret

  .section .data
  .align 4
mem_area:
  .word 0x00000000, 0x11111111, 0x22222222, 0x33333333
  .word 0x44444444, 0x55555555, 0x66666666, 0x77777777
  .word 0x88888888, 0x99999999, 0xaaaaaaaa, 0xbbbbbbbb
  .word 0xcccccccc, 0xdddddddd, 0xeeeeeeee, 0xffffffff
  .word 0x11111110, 0x22222221, 0x33333332, 0x44444443
  .word 0x55555554, 0x66666665, 0x77777776, 0x88888887
  .word 0x99999998, 0xaaaaaaa9, 0xbbbbbbba, 0xcccccccb
  .word 0xdddddddc, 0xeeeeeeed, 0xfffffffe, 0x1111110f
  .word 0x22222220, 0x33333331, 0x44444442, 0x55555553
  .word 0x66666664, 0x77777775, 0x88888886, 0x99999997
  .word 0xaaaaaaa8, 0xbbbbbbb9, 0xccccccca, 0xdddddddb
  .word 0xeeeeeeec, 0xfffffffd, 0x1111110e, 0x2222221f
  .word 0x33333330, 0x44444441, 0x55555552, 0x66666663
  .word 0x77777774, 0x88888885, 0x99999996, 0xaaaaaaa7
  .word 0xbbbbbbb8, 0xccccccc9, 0xddddddda, 0xeeeeeeeb
  .word 0xfffffffc, 0x1111110d, 0x2222221e, 0x3333332f
