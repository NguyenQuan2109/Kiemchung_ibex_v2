# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Mixed RV32IMC directed test.
#
#   The body has 35 deterministic layout blocks. Each block contains exactly
#   two RV32I instructions, two RV32M instructions, and two RV32C instructions,
#   for a total body mix of 70 RV32I + 70 RV32M + 70 RV32C source-level
#   instructions. The block comments name the intended 16-bit/32-bit memory
#   packing patterns, including 32-32-32, 16-16-32-32, 16-16-32-16,
#   32-16-32-16, and other nearby alignments.
#
#   `.option norvc` is used around RV32I/RV32M instructions so the assembler
#   cannot silently compress them. `.option rvc` is used only around RV32C
#   instructions. The body never writes x2/sp except via setup/pass code, keeping
#   compressed stack loads/stores inside the local data window.
###############################################################################

  .option norvc
  .section .text.init
  .org 0x80
  .global _start

_start:
  lui   x2, %hi(mem_area)
  addi  x2, x2, %lo(mem_area)
  addi  x2, x2, 256
  addi  x1, x0, -2048
  addi  x3, x0, -1025
  addi  x4, x0, -777
  addi  x5, x0, -513
  addi  x6, x0, -257
  addi  x7, x0, -129
  addi  x8, x2, -96
  addi  x9, x2, -92
  addi  x10, x2, -88
  addi  x11, x2, -84
  addi  x12, x2, -80
  addi  x13, x2, -76
  addi  x14, x2, -72
  addi  x15, x2, -68
  addi  x16, x0, -33
  addi  x17, x0, -17
  addi  x18, x0, -9
  addi  x19, x0, -1
  addi  x20, x0, 0
  addi  x21, x0, 1
  addi  x22, x0, 2
  addi  x23, x0, 3
  addi  x24, x0, 5
  addi  x25, x0, 7
  addi  x26, x0, 11
  addi  x27, x0, 13
  addi  x28, x0, 17
  addi  x29, x0, 31
  addi  x30, x0, 63
  addi  x31, x0, 127

body_start:
block_0:  # layout 32-32-32
  .option norvc
  add     x0, x0, x4
  mul     x0, x0, x0
  addi    x5, x8, -1024
  mulh    x13, x19, x24
  .option rvc
  c.add   x8, x9
  c.addi  x11, -16

block_1:  # layout 16-16-16
  .option rvc
  c.and   x14, x11
  c.andi  x9, -1
  .option norvc
  and     x8, x13, x18
  andi    x11, x18, -257
  mulhsu  x24, x1, x11
  mulhu   x5, x15, x28

block_2:  # layout 32-16-32
  .option norvc
  or      x14, x23, x1
  .option rvc
  c.or    x12, x13
  .option norvc
  div     x16, x28, x15
  ori     x17, x28, -65
  divu    x27, x11, x1
  .option rvc
  c.xor   x15, x10

block_3:  # layout 16-32-16
  .option rvc
  c.sub   x10, x15
  .option norvc
  xor     x20, x3, x16
  .option rvc
  c.mv    x9, x24
  .option norvc
  xori    x23, x8, -17
  rem     x8, x24, x19
  remu    x19, x7, x6

block_4:  # layout 32-32-16
  .option norvc
  sll     x26, x13, x30
  mul     x30, x20, x0
  .option rvc
  c.li    x10, 31
  .option norvc
  slli    x29, x18, 9
  mulh    x11, x0, x10
  .option rvc
  c.lui   x11, 10

block_5:  # layout 16-32-32
  .option rvc
  c.slli  x12, 10
  .option norvc
  srl     x1, x23, x14
  mulhsu  x22, x16, x27
  srli    x5, x28, 11
  mulhu   x3, x29, x14
  .option rvc
  c.srli  x9, 11

block_6:  # layout 32-16-16
  .option norvc
  sra     x8, x3, x28
  .option rvc
  c.srai  x12, 12
  c.nop
  .option norvc
  srai    x11, x8, 13
  div     x14, x12, x31
  divu    x25, x25, x18

block_7:  # layout 16-16-32
  .option rvc
  c.addi4spn x10, x2, 48
  c.lwsp  x17, 60(x2)
  .option norvc
  slt     x14, x13, x12
  slti    x17, x18, 63
  rem     x6, x8, x5
  remu    x17, x21, x22

block_8:  # layout 32-32-32-32
  .option norvc
  sltu    x20, x23, x26
  mul     x28, x4, x0
  sltiu   x23, x0, 255
  mulh    x9, x17, x26
  .option rvc
  c.swsp  x9, 0(x2)
  c.beqz  x11, 1f
1:

block_9:  # layout 16-16-16-16
  .option rvc
  c.bnez  x14, 1f
1:
  c.j     1f
1:
  .option norvc
  sub     x26, x3, x10
  lui     x0, 0x44443
  mulhsu  x20, x0, x13
  mulhu   x0, x13, x30

block_10:  # layout 16-16-32-32
  .option rvc
  c.add   x12, x13
  c.addi  x15, -1
  .option norvc
  auipc   x1, 0x1414
  div     x12, x26, x17
  add     x5, x18, x31
  divu    x23, x9, x4

block_11:  # layout 16-16-32-16
  .option rvc
  c.and   x10, x15
  c.andi  x13, 3
  .option norvc
  and     x8, x23, x8
  or      x11, x28, x15
  rem     x4, x22, x21
  remu    x15, x5, x8

block_12:  # layout 32-16-32-16
  .option norvc
  xor     x14, x3, x22
  .option rvc
  c.or    x8, x9
  .option norvc
  mul     x26, x18, x0
  .option rvc
  c.xor   x11, x14
  .option norvc
  sll     x17, x8, x29
  mulh    x7, x31, x12

block_13:  # layout 32-32-16-16
  .option norvc
  srl     x20, x13, x6
  mulhsu  x18, x14, x29
  .option rvc
  c.sub   x14, x11
  c.mv    x29, x14
  .option norvc
  sra     x23, x18, x13
  mulhu   x29, x0, x16

block_14:  # layout 16-32-16-32
  .option rvc
  c.li    x30, -16
  .option norvc
  slt     x26, x23, x20
  .option rvc
  c.lui   x31, 30
  .option norvc
  div     x10, x10, x3
  sltu    x29, x28, x27
  divu    x21, x23, x20

block_15:  # layout 32-16-16-32
  .option norvc
  addi    x1, x3, -1
  .option rvc
  c.slli  x1, 30
  c.srli  x13, 31
  .option norvc
  rem     x1, x6, x7
  andi    x5, x8, 0
  remu    x13, x19, x24

block_16:  # layout 16-32-32-16
  .option rvc
  c.srai  x8, 1
  .option norvc
  ori     x8, x13, 1
  mul     x24, x1, x0
  .option rvc
  c.nop
  .option norvc
  xori    x11, x18, 7
  mulh    x5, x15, x28

block_17:  # layout 32-16-32-32
  .option norvc
  slti    x14, x0, 15
  .option rvc
  c.addi4spn x14, x2, 176
  .option norvc
  mulhsu  x16, x28, x15
  sltiu   x17, x28, 31
  mulhu   x27, x11, x1
  .option rvc
  c.lwsp  x7, 12(x2)

block_18:  # layout 32-32-16-32
  .option norvc
  slli    x20, x3, 4
  div     x8, x0, x19
  .option rvc
  c.swsp  x13, 16(x2)
  .option norvc
  srli    x23, x8, 5
  divu    x19, x7, x6
  .option rvc
  c.beqz  x15, 1f
1:

block_19:  # layout 16-32-16-16
  .option rvc
  c.bnez  x10, 1f
1:
  .option norvc
  srai    x0, x13, 6
  .option rvc
  c.j     1f
1:
  .option norvc
  sub     x29, x18, x7
  rem     x0, x20, x23
  remu    x11, x3, x10

block_20:  # layout 16-16-16-32
  .option rvc
  c.add   x8, x9
  c.addi  x11, 3
  .option norvc
  add     x1, x23, x14
  addi    x5, x28, 2047
  mul     x22, x16, x0
  mulh    x3, x29, x14

block_21:  # layout 32-16-16-16
  .option norvc
  and     x8, x3, x28
  .option rvc
  c.and   x14, x11
  c.andi  x9, 15
  .option norvc
  andi    x11, x8, -1024
  mulhsu  x14, x12, x31
  mulhu   x25, x25, x18

block_22:  # layout 16-32-32-32
  .option rvc
  c.or    x12, x13
  .option norvc
  or      x14, x13, x12
  div     x6, x8, x5
  ori     x17, x18, -257
  divu    x17, x0, x22
  .option rvc
  c.xor   x15, x10

block_23:  # layout 32-32-32-16
  .option norvc
  xor     x20, x23, x26
  rem     x28, x4, x9
  xori    x23, x28, -65
  .option rvc
  c.sub   x10, x15
  .option norvc
  remu    x9, x17, x26
  .option rvc
  c.mv    x19, x4

block_24:  # layout 16-32-16-32-32-16
  .option rvc
  c.li    x20, -1
  .option norvc
  sll     x26, x3, x10
  .option rvc
  c.lui   x21, 19
  .option norvc
  mul     x20, x30, x0
  slli    x29, x8, 17
  mulh    x31, x13, x30

block_25:  # layout 32-16-32-16-16-32
  .option norvc
  srl     x1, x13, x24
  .option rvc
  c.slli  x22, 18
  .option norvc
  mulhsu  x12, x26, x17
  .option rvc
  c.srli  x9, 19
  .option norvc
  srli    x5, x0, 19
  mulhu   x23, x9, x4

block_26:  # layout 16-16-32-32-16-32
  .option rvc
  c.srai  x12, 20
  c.nop
  .option norvc
  sra     x8, x23, x8
  div     x4, x22, x21
  srai    x11, x28, 21
  divu    x15, x5, x8

block_27:  # layout 32-32-16-16-32-16
  .option norvc
  slt     x14, x3, x22
  rem     x26, x0, x25
  .option rvc
  c.addi4spn x10, x2, 112
  c.lwsp  x27, 28(x2)
  .option norvc
  slti    x17, x8, 15
  remu    x7, x31, x12

block_28:  # layout 16-32-32-16-16-32
  .option rvc
  c.swsp  x9, 32(x2)
  .option norvc
  sltu    x20, x13, x6
  mul     x18, x14, x0
  .option rvc
  c.beqz  x11, 1f
1:
  .option norvc
  sltiu   x0, x18, 63
  mulh    x0, x27, x16

block_29:  # layout 32-16-16-32-32-16
  .option norvc
  sub     x26, x23, x20
  .option rvc
  c.bnez  x14, 1f
1:
  c.j     1f
1:
  .option norvc
  mulhsu  x10, x10, x3
  lui     x29, 0xeeeeb
  mulhu   x21, x23, x20

block_30:  # layout 32-16-32-32-16-16
  .option norvc
  auipc   x1, 0x3c3c
  .option rvc
  c.add   x12, x13
  .option norvc
  div     x1, x6, x7
  add     x5, x8, x11
  .option rvc
  c.addi  x15, 15
  .option norvc
  divu    x13, x19, x24

block_31:  # layout 16-32-16-16-32-32
  .option rvc
  c.and   x10, x15
  .option norvc
  and     x8, x13, x18
  .option rvc
  c.andi  x13, -32
  .option norvc
  rem     x24, x1, x11
  or      x11, x18, x25
  remu    x5, x0, x28

block_32:  # layout 32-32-16-32-16-16
  .option norvc
  xor     x14, x23, x1
  mul     x16, x28, x0
  .option rvc
  c.or    x8, x9
  .option norvc
  sll     x17, x28, x9
  .option rvc
  c.xor   x11, x14
  .option norvc
  mulh    x27, x11, x1

block_33:  # layout 16-16-32-16-32-32
  .option rvc
  c.sub   x14, x11
  c.mv    x9, x24
  .option norvc
  srl     x20, x3, x16
  mulhsu  x8, x24, x19
  sra     x23, x8, x23
  mulhu   x19, x7, x6

block_34:  # layout 32-16-16-16-32-32
  .option norvc
  slt     x26, x0, x30
  .option rvc
  c.li    x10, 3
  c.lui   x11, 8
  .option norvc
  div     x30, x20, x23
  sltu    x29, x18, x7
  divu    x11, x3, x10

pass:
  .option norvc
  lui   x2, 0x90000
  addi  x2, x2, -8
  addi  x1, x0, 1
  sw    x1, 0(x2)
1:
  jal   x0, 1b

  .section .data
  .balign 4
mem_area:
  .rept 256
  .word 0x5a5aa5a5
  .endr
