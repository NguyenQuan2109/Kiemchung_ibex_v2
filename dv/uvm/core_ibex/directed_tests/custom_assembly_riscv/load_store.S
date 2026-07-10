# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Custom RV32I load/store directed test.
#
#   The body contains 20 source-level instances of each RV32I load/store
#   mnemonic: lb, lh, lw, lbu, lhu, sb, sh, and sw. Addresses and registers are
#   shuffled across a local data window. All halfword/word accesses are aligned,
#   while byte accesses intentionally use mixed byte offsets. Several operations
#   use x0 as a source or destination to cover architectural zero-register cases.
###############################################################################

  .option norvc
  .section .text.init
  .global _start

_start:
  lui   x20, %hi(mem_area)
  addi  x20, x20, %lo(mem_area)

  addi  x1,  x0,  0x7f
  addi  x2,  x0, -1
  addi  x3,  x0,  0x55
  addi  x4,  x0, -128
  addi  x5,  x0,  0x101
  addi  x6,  x0, -257
  addi  x7,  x0,  0x3ff
  addi  x8,  x0, -1024
  addi  x9,  x0,  0x12
  addi  x10, x0, -17
  addi  x11, x0,  0x7e
  addi  x12, x0, -64
  lui   x13, 0x12345
  addi  x13, x13, 0x678
  lui   x14, 0xabcdf
  addi  x14, x14, -0x321
  lui   x15, 0x80000
  addi  x16, x0,  0
  addi  x17, x0,  1
  addi  x18, x0, -2048
  addi  x19, x0,  2047

block_00:
  sb    x1,   3(x20)
  lb    x21,  3(x20)
  lbu   x22,  3(x20)
  sh    x2,   8(x20)
  lh    x23,  8(x20)
  lhu   x24,  8(x20)
  sw    x13, 16(x20)
  lw    x25, 16(x20)

block_01:
  sb    x4,  19(x20)
  lbu   x26, 19(x20)
  sw    x14, 24(x20)
  lh    x27, 24(x20)
  sh    x5,  32(x20)
  lb    x28, 33(x20)
  lw    x29, 24(x20)
  lhu   x30, 32(x20)

block_02:
  sw    x15, 40(x20)
  sb    x0,  47(x20)
  lh    x1,  40(x20)
  lbu   x2,  47(x20)
  sh    x6,  48(x20)
  lw    x3,  40(x20)
  lb    x4,  49(x20)
  lhu   x5,  48(x20)

block_03:
  sh    x7,  56(x20)
  sw    x8,  60(x20)
  lhu   x6,  56(x20)
  lb    x7,  61(x20)
  sb    x9,  66(x20)
  lw    x8,  60(x20)
  lh    x9,  56(x20)
  lbu   x10, 66(x20)

block_04:
  sb    x10, 71(x20)
  sh    x11, 72(x20)
  lb    x11, 71(x20)
  sw    x12, 76(x20)
  lhu   x12, 72(x20)
  lw    x13, 76(x20)
  lbu   x14, 71(x20)
  lh    x15, 72(x20)

block_05:
  sw    x1,  84(x20)
  sh    x2,  88(x20)
  sb    x3,  91(x20)
  lw    x16, 84(x20)
  lhu   x17, 88(x20)
  lb    x18, 91(x20)
  lh    x19, 88(x20)
  lbu   x21, 91(x20)

block_06:
  sb    x15, 97(x20)
  lb    x0,  97(x20)
  sh    x14, 98(x20)
  lhu   x22, 98(x20)
  sw    x13, 104(x20)
  lw    x23, 104(x20)
  lh    x24, 98(x20)
  lbu   x25, 97(x20)

block_07:
  sh    x12, 112(x20)
  sb    x11, 115(x20)
  sw    x10, 116(x20)
  lh    x26, 112(x20)
  lbu   x27, 115(x20)
  lw    x28, 116(x20)
  lb    x29, 115(x20)
  lhu   x30, 112(x20)

block_08:
  sw    x9,  124(x20)
  sh    x8,  128(x20)
  sb    x7,  131(x20)
  lhu   x1,  128(x20)
  lb    x2,  131(x20)
  lw    x3,  124(x20)
  lh    x4,  128(x20)
  lbu   x5,  131(x20)

block_09:
  sb    x6,  137(x20)
  sw    x5,  140(x20)
  sh    x4,  144(x20)
  lbu   x6,  137(x20)
  lh    x7,  144(x20)
  lb    x8,  137(x20)
  lw    x9,  140(x20)
  lhu   x10, 144(x20)

block_10:
  sh    x3,  152(x20)
  sb    x2,  155(x20)
  sw    x1,  156(x20)
  lw    x11, 156(x20)
  lhu   x12, 152(x20)
  lb    x13, 155(x20)
  lh    x14, 152(x20)
  lbu   x15, 155(x20)

block_11:
  sw    x18, 164(x20)
  sb    x19, 169(x20)
  sh    x17, 170(x20)
  lb    x16, 169(x20)
  lhu   x17, 170(x20)
  lw    x18, 164(x20)
  lbu   x19, 169(x20)
  lh    x21, 170(x20)

block_12:
  sb    x16, 181(x20)
  sh    x15, 182(x20)
  sw    x14, 188(x20)
  lbu   x22, 181(x20)
  lh    x23, 182(x20)
  lb    x24, 181(x20)
  lw    x25, 188(x20)
  lhu   x26, 182(x20)

block_13:
  sh    x13, 196(x20)
  sw    x12, 200(x20)
  sb    x11, 207(x20)
  lw    x27, 200(x20)
  lb    x28, 207(x20)
  lhu   x29, 196(x20)
  lh    x30, 196(x20)
  lbu   x1,  207(x20)

block_14:
  sw    x0,  212(x20)
  sh    x10, 216(x20)
  sb    x9,  219(x20)
  lh    x2,  216(x20)
  lbu   x3,  219(x20)
  lw    x4,  212(x20)
  lb    x5,  219(x20)
  lhu   x6,  216(x20)

block_15:
  sb    x8,  225(x20)
  sw    x7,  228(x20)
  sh    x6,  232(x20)
  lhu   x0,  232(x20)
  lb    x7,  225(x20)
  lw    x8,  228(x20)
  lh    x9,  232(x20)
  lbu   x10, 225(x20)

block_16:
  sh    x5,  240(x20)
  sb    x4,  243(x20)
  sw    x3,  244(x20)
  lw    x0,  244(x20)
  lbu   x11, 243(x20)
  lh    x12, 240(x20)
  lb    x13, 243(x20)
  lhu   x14, 240(x20)

block_17:
  sw    x2,  252(x20)
  sh    x1,  256(x20)
  sb    x19, 259(x20)
  lh    x15, 256(x20)
  lb    x16, 259(x20)
  lhu   x17, 256(x20)
  lw    x18, 252(x20)
  lbu   x19, 259(x20)

block_18:
  sb    x18, 265(x20)
  sh    x17, 266(x20)
  sw    x16, 272(x20)
  lbu   x21, 265(x20)
  lw    x22, 272(x20)
  lh    x23, 266(x20)
  lb    x24, 265(x20)
  lhu   x25, 266(x20)

block_19:
  sh    x15, 280(x20)
  sw    x14, 284(x20)
  sb    x13, 291(x20)
  lw    x26, 284(x20)
  lhu   x27, 280(x20)
  lb    x28, 291(x20)
  lh    x29, 280(x20)
  lbu   x30, 291(x20)

pass:
  li    x31, 0x8ffffff8
  li    x1,  0x1
  sw    x1,  0(x31)

done:
  j     done

  .section .data
  .balign 4
mem_area:
  .space 512
