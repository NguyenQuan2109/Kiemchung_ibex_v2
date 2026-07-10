# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Shuffled RV32M directed test.
#
#   The body contains 10 deterministic shuffled rounds. Each round has one
#   source-level instance of every RV32M mnemonic:
#     mul mulh mulhsu mulhu div divu rem remu
#   Register selection covers x0..x31 as destinations and sources. Immediate
#   diversity is applied in the setup code that seeds operand registers; RV32M
#   instructions themselves are register-register only.
###############################################################################

  .option norvc
  .section .text.init
  .org 0x80
  .global _start

_start:
  # Seed all writable registers with varied signed immediates.
  addi  x1, x0, -2048
  addi  x2, x0, -1536
  addi  x3, x0, -1025
  addi  x4, x0, -1024
  addi  x5, x0, -777
  addi  x6, x0, -513
  addi  x7, x0, -512
  addi  x8, x0, -257
  addi  x9, x0, -256
  addi  x10, x0, -129
  addi  x11, x0, -128
  addi  x12, x0, -65
  addi  x13, x0, -64
  addi  x14, x0, -33
  addi  x15, x0, -32
  addi  x16, x0, -17
  addi  x17, x0, -16
  addi  x18, x0, -9
  addi  x19, x0, -8
  addi  x20, x0, -1
  addi  x21, x0, 0
  addi  x22, x0, 1
  addi  x23, x0, 2
  addi  x24, x0, 3
  addi  x25, x0, 5
  addi  x26, x0, 7
  addi  x27, x0, 11
  addi  x28, x0, 13
  addi  x29, x0, 17
  addi  x30, x0, 31
  addi  x31, x0, 63
  lui   x1, 0x7ffff
  xori  x1, x1, 2047
  lui   x2, 0x80000
  xori  x2, x2, -1
  lui   x3, 0x55555
  xori  x3, x3, 1365
  lui   x4, 0xaaaaa
  xori  x4, x4, -1366
  lui   x5, 0x12345
  xori  x5, x5, 801
  lui   x6, 0xfffff
  xori  x6, x6, -2048
  lui   x7, 0x1
  xori  x7, x7, 2047
  lui   x8, 0x40000
  xori  x8, x8, 0

round_0:
  mulh   x0, x1, x2
  mulhsu x5, x0, x5
  mulhu  x10, x23, x0
  div    x15, x2, x11
  divu   x20, x13, x14
  rem    x25, x24, x17
  remu   x30, x3, x20
  mul    x3, x14, x23

round_1:
  mulhu  x0, x8, x15
  mulhsu x14, x0, x18
  mulh   x19, x30, x0
  mul    x24, x9, x24
  remu   x29, x20, x27
  rem    x2, x31, x30
  divu   x7, x10, x1
  div    x12, x21, x4

round_2:
  remu   x0, x15, x28
  mul    x23, x0, x31
  mulh   x28, x5, x0
  mulhsu x1, x16, x5
  mulhu  x6, x27, x8
  div    x11, x6, x11
  divu   x16, x17, x14
  rem    x21, x28, x17

round_3:
  mulh   x0, x22, x9
  mul    x0, x0, x12
  remu   x5, x12, x0
  rem    x10, x23, x18
  divu   x15, x2, x21
  div    x20, x13, x24
  mulhu  x25, x24, x27
  mulhsu x30, x3, x30

round_4:
  divu   x0, x29, x22
  rem    x9, x0, x25
  remu   x14, x19, x0
  mul    x19, x30, x31
  mulh   x24, x9, x2
  mulhsu x29, x20, x5
  mulhu  x2, x31, x8
  div    x7, x10, x11

round_5:
  remu   x0, x4, x3
  rem    x18, x0, x6
  divu   x23, x26, x0
  div    x28, x5, x12
  mulhu  x1, x16, x15
  mulhsu x6, x27, x18
  mulh   x11, x6, x21
  mul    x16, x17, x24

round_6:
  mulhu  x0, x11, x16
  div    x27, x0, x19
  divu   x0, x1, x0
  rem    x5, x12, x25
  remu   x10, x23, x28
  mul    x15, x2, x31
  mulh   x20, x13, x2
  mulhsu x25, x24, x5

round_7:
  divu   x0, x18, x29
  div    x4, x0, x0
  mulhu  x9, x8, x0
  mulhsu x14, x19, x6
  mulh   x19, x30, x9
  mul    x24, x9, x12
  remu   x29, x20, x15
  rem    x2, x31, x18

round_8:
  mulh   x0, x25, x10
  mulhsu x13, x0, x13
  mulhu  x18, x15, x0
  div    x23, x26, x19
  divu   x28, x5, x22
  rem    x1, x16, x25
  remu   x6, x27, x28
  mul    x11, x6, x31

round_9:
  mulhu  x0, x0, x23
  mulhsu x22, x0, x26
  mulh   x27, x22, x0
  mul    x0, x1, x0
  remu   x5, x12, x3
  rem    x10, x23, x6
  divu   x15, x2, x9
  div    x31, x30, x29

pass:
  lui   x2, 0x90000
  addi  x2, x2, -8
  addi  x1, x0, 1
  sw    x1, 0(x2)
1:
  jal   x0, 1b
