# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Custom RV32I/Zicsr directed CSR test.
#
#   The body contains 20 source-level instances of each base CSR instruction:
#   csrrw, csrrs, csrrc, csrrwi, csrrsi, and csrrci. The instruction body uses
#   mscratch so the test stresses CSR encodings without depending on WARL/reset
#   details of special machine CSRs that can differ between RTL and ISS models.
###############################################################################

  .option norvc
  .section .text.init
  .global _start

_start:
  lui   x31, %hi(trap_handler)
  addi  x31, x31, %lo(trap_handler)
  csrw  mtvec, x31

  lui   x1,  0x13579
  addi  x1,  x1,  0x246
  lui   x2,  0x2468a
  addi  x2,  x2, -0x135
  addi  x3,  x0,  0
  addi  x4,  x0,  1
  addi  x5,  x0, -1
  addi  x6,  x0,  0x55
  addi  x7,  x0,  0xaa
  lui   x8,  0x80000
  addi  x9,  x0,  0x10
  addi  x10, x0,  0x20
  addi  x11, x0,  0x40
  addi  x12, x0,  0x80
  addi  x13, x0,  0x100
  addi  x14, x0,  0x200
  addi  x15, x0,  0x400

body_start:
block_00:
  csrrw x16, mscratch, x1
  csrrs x17, mscratch, x4
  csrrc x18, mscratch, x4
  csrrwi x19, mscratch, 3
  csrrsi x20, mscratch, 4
  csrrci x21, mscratch, 1

block_01:
  csrrw x22, mscratch, x2
  csrrs x23, mscratch, x6
  csrrc x24, mscratch, x6
  csrrwi x25, mscratch, 7
  csrrsi x26, mscratch, 8
  csrrci x27, mscratch, 2

block_02:
  csrrw x28, mscratch, x31
  csrrs x29, mscratch, x0
  csrrc x30, mscratch, x0
  csrrwi x16, mscratch, 11
  csrrsi x17, mscratch, 12
  csrrci x18, mscratch, 4

block_03:
  csrrw x19, mscratch, x31
  csrrs x20, mscratch, x0
  csrrc x21, mscratch, x0
  csrrwi x22, mscratch, 15
  csrrsi x23, mscratch, 16
  csrrci x24, mscratch, 8

block_04:
  csrrw x25, mscratch, x0
  csrrs x26, mscratch, x4
  csrrc x27, mscratch, x4
  csrrwi x28, mscratch, 19
  csrrsi x29, mscratch, 20
  csrrci x30, mscratch, 16

block_05:
  csrrw x16, mscratch, x8
  csrrs x17, mscratch, x0
  csrrc x18, mscratch, x0
  csrrwi x19, mscratch, 23
  csrrsi x20, mscratch, 24
  csrrci x21, mscratch, 3

block_06:
  csrrw x22, mscratch, x31
  csrrs x23, mscratch, x0
  csrrc x24, mscratch, x0
  csrrwi x25, mscratch, 27
  csrrsi x26, mscratch, 28
  csrrci x27, mscratch, 7

block_07:
  csrrw x28, mscratch, x5
  csrrs x29, mscratch, x0
  csrrc x30, mscratch, x0
  csrrwi x16, mscratch, 31
  csrrsi x17, mscratch, 1
  csrrci x18, mscratch, 31

block_08:
  csrrw x19, mscratch, x9
  csrrs x20, mscratch, x10
  csrrc x21, mscratch, x9
  csrrwi x22, mscratch, 2
  csrrsi x23, mscratch, 5
  csrrci x24, mscratch, 2

block_09:
  csrrw x25, mscratch, x10
  csrrs x26, mscratch, x11
  csrrc x27, mscratch, x10
  csrrwi x28, mscratch, 6
  csrrsi x29, mscratch, 9
  csrrci x30, mscratch, 6

block_10:
  csrrw x16, mscratch, x11
  csrrs x17, mscratch, x12
  csrrc x18, mscratch, x11
  csrrwi x19, mscratch, 10
  csrrsi x20, mscratch, 13
  csrrci x21, mscratch, 10

block_11:
  csrrw x22, mscratch, x12
  csrrs x23, mscratch, x13
  csrrc x24, mscratch, x12
  csrrwi x25, mscratch, 14
  csrrsi x26, mscratch, 17
  csrrci x27, mscratch, 14

block_12:
  csrrw x28, mscratch, x13
  csrrs x29, mscratch, x14
  csrrc x30, mscratch, x13
  csrrwi x16, mscratch, 18
  csrrsi x17, mscratch, 21
  csrrci x18, mscratch, 18

block_13:
  csrrw x19, mscratch, x14
  csrrs x20, mscratch, x15
  csrrc x21, mscratch, x14
  csrrwi x22, mscratch, 22
  csrrsi x23, mscratch, 25
  csrrci x24, mscratch, 22

block_14:
  csrrw x25, mscratch, x15
  csrrs x26, mscratch, x1
  csrrc x27, mscratch, x15
  csrrwi x28, mscratch, 26
  csrrsi x29, mscratch, 29
  csrrci x30, mscratch, 26

block_15:
  csrrw x16, mscratch, x0
  csrrs x17, mscratch, x2
  csrrc x18, mscratch, x1
  csrrwi x19, mscratch, 30
  csrrsi x20, mscratch, 31
  csrrci x21, mscratch, 30

block_16:
  csrrw x22, mscratch, x31
  csrrs x23, mscratch, x0
  csrrc x24, mscratch, x0
  csrrwi x25, mscratch, 0
  csrrsi x26, mscratch, 2
  csrrci x27, mscratch, 0

block_17:
  csrrw x28, mscratch, x31
  csrrs x29, mscratch, x0
  csrrc x30, mscratch, x0
  csrrwi x16, mscratch, 4
  csrrsi x17, mscratch, 6
  csrrci x18, mscratch, 4

block_18:
  csrrw x19, mscratch, x0
  csrrs x20, mscratch, x0
  csrrc x21, mscratch, x0
  csrrwi x22, mscratch, 8
  csrrsi x23, mscratch, 10
  csrrci x24, mscratch, 8

block_19:
  csrrw x25, mscratch, x31
  csrrs x26, mscratch, x0
  csrrc x27, mscratch, x0
  csrrwi x28, mscratch, 12
  csrrsi x29, mscratch, 14
  csrrci x30, mscratch, 12

pass:
  li    x31, 0x8ffffff8
  li    x1,  0x1
  sw    x1,  0(x31)

done:
  j     done

trap_handler:
  li    x31, 0x8ffffff8
  li    x1,  0x2
  sw    x1,  0(x31)
trap_loop:
  j     trap_loop
