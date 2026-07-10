# Copyright Nguyen Quan.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Custom RV32IM directed RAW hazard stress test.
#
#   The body contains 25 blocks x 8 instructions = 200 source-level body
#   instructions. The sequence intentionally keeps back-to-back dependencies
#   across ALU, multiply/divide, load-use, store-data, and store-address paths.
###############################################################################

  .option norvc
  .section .text.init
  .global _start

_start:
  lui   x1,  0x13579
  addi  x1,  x1,  0x246
  lui   x2,  0x2468a
  addi  x2,  x2, -0x135
  addi  x3,  x0,  7
  addi  x4,  x0,  3
  addi  x5,  x0,  11
  addi  x6,  x0,  13
  addi  x7,  x0,  17
  addi  x8,  x0,  19
  addi  x9,  x0,  23
  addi  x10, x0,  29
  lui   x20, %hi(data_area)
  addi  x20, x20, %lo(data_area)

body_start:
block_00:
  add   x5,  x1,  x2
  sub   x6,  x5,  x3
  xor   x7,  x6,  x5
  or    x8,  x7,  x6
  and   x9,  x8,  x7
  sll   x10, x9,  x4
  srl   x11, x10, x4
  sra   x12, x11, x4

block_01:
  lw    x13, 0(x20)
  add   x14, x13, x5
  sw    x14, 4(x20)
  lw    x15, 4(x20)
  xor   x16, x15, x14
  sh    x16, 8(x20)
  lh    x17, 8(x20)
  add   x18, x17, x16

block_02:
  mul   x19, x18, x4
  add   x21, x19, x6
  mulh  x22, x21, x5
  xor   x23, x22, x21
  div   x24, x23, x4
  add   x25, x24, x23
  rem   x26, x25, x4
  sub   x27, x26, x25

block_03:
  addi  x5,  x27, 17
  mul   x6,  x5,  x4
  sw    x6,  12(x20)
  lw    x7,  12(x20)
  add   x8,  x7,  x6
  divu  x9,  x8,  x4
  remu  x10, x9,  x4
  xor   x11, x10, x9

block_04:
  add   x12, x11, x10
  sll   x13, x12, x4
  add   x14, x20, x4
  addi  x14, x14, 16
  sw    x13, 0(x14)
  lw    x15, 0(x14)
  sub   x16, x15, x13
  or    x17, x16, x15

block_05:
  mulhu x18, x17, x5
  add   x19, x18, x17
  mulhsu x21, x19, x6
  sub   x22, x21, x19
  div   x23, x22, x4
  xor   x24, x23, x22
  rem   x25, x24, x4
  add   x26, x25, x24

block_06:
  lb    x27, 24(x20)
  add   x5,  x27, x26
  sb    x5,  25(x20)
  lbu   x6,  25(x20)
  add   x7,  x6,  x5
  sll   x8,  x7,  x4
  sw    x8,  28(x20)
  lw    x9,  28(x20)

block_07:
  add   x10, x9,  x8
  mul   x11, x10, x4
  add   x12, x11, x10
  divu  x13, x12, x4
  sub   x14, x13, x12
  remu  x15, x14, x4
  xor   x16, x15, x14
  and   x17, x16, x15

block_08:
  lw    x18, 32(x20)
  add   x19, x18, x17
  add   x21, x20, x4
  addi  x21, x21, 36
  sw    x19, 0(x21)
  lw    x22, 0(x21)
  xor   x23, x22, x19
  add   x24, x23, x22

block_09:
  mul   x25, x24, x4
  mulh  x26, x25, x24
  add   x27, x26, x25
  div   x5,  x27, x4
  rem   x6,  x5,  x4
  add   x7,  x6,  x5
  sra   x8,  x7,  x4
  xor   x9,  x8,  x7

block_10:
  addi  x10, x9,  -31
  sw    x10, 44(x20)
  lw    x11, 44(x20)
  add   x12, x11, x10
  sh    x12, 48(x20)
  lhu   x13, 48(x20)
  sub   x14, x13, x12
  or    x15, x14, x13

block_11:
  add   x16, x15, x14
  mulhu x17, x16, x4
  add   x18, x17, x16
  divu  x19, x18, x4
  mul   x21, x19, x18
  remu  x22, x21, x4
  add   x23, x22, x21
  xor   x24, x23, x22

block_12:
  lw    x25, 52(x20)
  add   x26, x25, x24
  sw    x26, 56(x20)
  lw    x27, 56(x20)
  add   x5,  x27, x26
  mul   x6,  x5,  x4
  div   x7,  x6,  x4
  sub   x8,  x7,  x6

block_13:
  xor   x9,  x8,  x7
  and   x10, x9,  x8
  or    x11, x10, x9
  sll   x12, x11, x4
  srl   x13, x12, x4
  add   x14, x13, x12
  sw    x14, 60(x20)
  lw    x15, 60(x20)

block_14:
  add   x16, x15, x14
  mulh  x17, x16, x15
  add   x18, x17, x16
  div   x19, x18, x4
  rem   x21, x19, x4
  sub   x22, x21, x19
  mulhsu x23, x22, x4
  add   x24, x23, x22

block_15:
  addi  x25, x24, 63
  add   x26, x20, x4
  addi  x26, x26, 64
  sw    x25, 0(x26)
  lw    x27, 0(x26)
  xor   x5,  x27, x25
  add   x6,  x5,  x27
  sb    x6,  72(x20)

block_16:
  lbu   x7,  72(x20)
  add   x8,  x7,  x6
  mul   x9,  x8,  x4
  add   x10, x9,  x8
  divu  x11, x10, x4
  remu  x12, x11, x4
  xor   x13, x12, x11
  add   x14, x13, x12

block_17:
  sw    x14, 76(x20)
  lw    x15, 76(x20)
  add   x16, x15, x14
  mulhu x17, x16, x15
  sub   x18, x17, x16
  div   x19, x18, x4
  add   x21, x19, x18
  rem   x22, x21, x4

block_18:
  add   x23, x22, x21
  sll   x24, x23, x4
  sra   x25, x24, x4
  add   x26, x25, x24
  sw    x26, 80(x20)
  lw    x27, 80(x20)
  xor   x5,  x27, x26
  add   x6,  x5,  x27

block_19:
  lh    x7,  84(x20)
  add   x8,  x7,  x6
  sh    x8,  86(x20)
  lhu   x9,  86(x20)
  add   x10, x9,  x8
  mul   x11, x10, x4
  divu  x12, x11, x4
  remu  x13, x12, x4

block_20:
  add   x14, x13, x12
  mulh  x15, x14, x13
  add   x16, x15, x14
  mul   x17, x16, x15
  div   x18, x17, x4
  rem   x19, x18, x4
  xor   x21, x19, x18
  add   x22, x21, x19

block_21:
  add   x23, x20, x4
  addi  x23, x23, 88
  sw    x22, 0(x23)
  lw    x24, 0(x23)
  add   x25, x24, x22
  sw    x25, 92(x20)
  lw    x26, 92(x20)
  sub   x27, x26, x25

block_22:
  addi  x5,  x27, -97
  xor   x6,  x5,  x27
  or    x7,  x6,  x5
  and   x8,  x7,  x6
  mulhu x9,  x8,  x7
  add   x10, x9,  x8
  divu  x11, x10, x4
  remu  x12, x11, x4

block_23:
  add   x13, x12, x11
  sw    x13, 96(x20)
  lw    x14, 96(x20)
  add   x15, x14, x13
  mulhsu x16, x15, x4
  add   x17, x16, x15
  div   x18, x17, x4
  rem   x19, x18, x4

block_24:
  xor   x21, x19, x18
  add   x22, x21, x19
  mul   x23, x22, x21
  add   x24, x23, x22
  sw    x24, 100(x20)
  lw    x25, 100(x20)
  sub   x26, x25, x24
  add   x27, x26, x25

pass:
  li    x31, 0x8ffffff8
  li    x1,  0x1
  sw    x1,  0(x31)

done:
  j     done

  .section .data
  .balign 4
data_area:
  .word 0x00000001, 0x00000003, 0x00000007, 0x0000000b
  .word 0x00000011, 0x00000013, 0x00000017, 0x0000001d
  .word 0x12345678, 0x89abcdef, 0x7fffffff, 0x80000000
  .word 0x01020304, 0xf0e0d0c0, 0x55aa55aa, 0xaa55aa55
  .word 0x00010001, 0x00020002, 0x00030003, 0x00040004
  .word 0x11111111, 0x22222222, 0x33333333, 0x44444444
  .word 0x55555555, 0x66666666, 0x77777777, 0x88888888
  .word 0x99999999, 0xaaaaaaaa, 0xbbbbbbbb, 0xcccccccc
