# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Shuffled RV32I arithmetic/logic/shift directed test.
#
#   The body contains 20 deterministic shuffled rounds. Each round has one
#   source-level instance of every arithmetic/logic/shift mnemonic below:
#     addi slti sltiu xori ori andi slli srli srai
#     add sub sll slt sltu xor srl sra or and
#   Setup/pass code is auxiliary and is not part of the per-mnemonic count.
###############################################################################

  .option norvc
  .section .text.init
  .org 0x80
  .global _start

_start:
round_0:
  ori   x0, x1, 0
  slli  x10, x0, 5
  srai  x17, x7, 10
  sub   x24, x10, x17
  slt   x31, x13, x22
  xor   x6, x16, x27
  sra   x13, x19, x0
  and   x20, x22, x5
  slti  x27, x25, -17
  xori  x0, x28, 819
  andi  x9, x0, 0
  srli  x16, x2, 23
  add   x23, x5, x30
  sll   x30, x8, x3
  sltu  x5, x11, x8
  srl   x12, x14, x13
  or    x19, x17, x18
  addi  x26, x20, 511
  sltiu x1, x23, 1023

round_1:
  sub   x0, x6, x15
  slt   x21, x0, x20
  xor   x28, x12, x0
  sra   x3, x15, x30
  and   x10, x18, x3
  slti  x17, x21, -17
  xori  x24, x24, 546
  andi  x31, x27, 1092
  srli  x6, x30, 17
  add   x0, x1, x28
  sll   x20, x0, x1
  sltu  x27, x7, x0
  srl   x2, x10, x11
  or    x9, x13, x16
  addi  x16, x16, 511
  sltiu x23, x19, 1023
  ori   x30, x22, 546
  slli  x5, x25, 30
  srai  x12, x28, 3

round_2:
  and   x0, x11, x28
  slti  x0, x0, -33
  xori  x7, x17, 1110
  andi  x14, x20, 273
  srli  x21, x23, 6
  add   x28, x26, x21
  sll   x3, x29, x26
  sltu  x10, x0, x31
  srl   x17, x3, x4
  or    x0, x6, x9
  addi  x31, x0, 255
  sltiu x6, x12, 511
  ori   x13, x15, 1110
  slli  x20, x18, 19
  srai  x27, x21, 24
  sub   x2, x24, x7
  slt   x9, x27, x12
  xor   x16, x30, x17
  sra   x23, x1, x22

round_3:
  andi  x0, x16, 1620
  srli  x11, x0, 0
  add   x18, x22, x0
  sll   x25, x25, x24
  sltu  x0, x28, x29
  srl   x7, x31, x2
  or    x14, x2, x7
  addi  x21, x5, 255
  sltiu x28, x8, 511
  ori   x0, x11, 801
  slli  x10, x0, 13
  srai  x17, x17, 18
  sub   x24, x20, x5
  slt   x31, x23, x10
  xor   x6, x26, x15
  sra   x13, x29, x20
  and   x20, x0, x25
  slti  x27, x3, -64
  xori  x2, x6, -257

round_4:
  sltu  x0, x21, x22
  srl   x22, x0, x27
  or    x29, x27, x0
  addi  x4, x30, 127
  sltiu x11, x1, 255
  ori   x18, x4, -513
  slli  x25, x7, 2
  srai  x0, x10, 7
  sub   x7, x13, x30
  slt   x0, x16, x3
  xor   x21, x0, x8
  sra   x28, x22, x0
  and   x3, x25, x18
  slti  x10, x28, -129
  xori  x17, x31, -2048
  andi  x24, x2, -513
  srli  x31, x5, 20
  add   x6, x8, x11
  sll   x13, x11, x16

round_5:
  addi  x0, x26, 127
  sltiu x1, x0, 255
  ori   x8, x0, -1024
  slli  x15, x3, 28
  srai  x22, x6, 1
  sub   x29, x9, x28
  slt   x4, x12, x1
  xor   x11, x15, x6
  sra   x18, x18, x11
  and   x0, x21, x16
  slti  x0, x0, -129
  xori  x7, x27, 1807
  andi  x14, x30, -1024
  srli  x21, x1, 14
  add   x28, x4, x9
  sll   x3, x7, x14
  sltu  x10, x10, x19
  srl   x17, x13, x24
  or    x24, x16, x29

round_6:
  srai  x0, x31, 22
  sub   x12, x0, x21
  slt   x19, x5, x0
  xor   x26, x8, x31
  sra   x1, x11, x4
  and   x8, x14, x9
  slti  x15, x17, -255
  xori  x22, x20, 1365
  andi  x29, x23, 240
  srli  x0, x26, 3
  add   x11, x0, x2
  sll   x18, x0, x0
  sltu  x25, x3, x12
  srl   x0, x6, x17
  or    x7, x9, x22
  addi  x14, x12, 31
  sltiu x21, x15, 63
  ori   x28, x18, 1365
  slli  x3, x21, 16

round_7:
  xor   x0, x4, x29
  sra   x23, x0, x2
  and   x30, x10, x0
  slti  x5, x13, -255
  xori  x12, x16, 2047
  andi  x19, x19, 682
  srli  x26, x22, 29
  add   x1, x25, x0
  sll   x8, x28, x5
  sltu  x0, x31, x10
  srl   x22, x0, x15
  or    x29, x5, x0
  addi  x4, x8, 31
  sltiu x11, x11, 63
  ori   x18, x14, 2047
  slli  x25, x17, 10
  srai  x0, x20, 15
  sub   x7, x23, x18
  slt   x14, x26, x23

round_8:
  xori  x0, x9, 0
  andi  x2, x0, -1
  srli  x9, x15, 18
  add   x16, x18, x25
  sll   x23, x21, x30
  sltu  x30, x24, x3
  srl   x5, x27, x8
  or    x12, x30, x13
  addi  x19, x1, 7
  sltiu x0, x4, 31
  ori   x1, x0, 0
  slli  x8, x10, 31
  srai  x15, x13, 4
  sub   x22, x16, x11
  slt   x29, x19, x16
  xor   x4, x22, x21
  sra   x11, x25, x26
  and   x18, x28, x31
  slti  x25, x31, -1024

round_9:
  add   x0, x14, x23
  sll   x13, x0, x28
  sltu  x20, x20, x0
  srl   x27, x23, x6
  or    x2, x26, x11
  addi  x9, x29, 7
  sltiu x16, x0, 31
  ori   x23, x3, 1092
  slli  x30, x6, 25
  srai  x0, x9, 30
  sub   x12, x0, x9
  slt   x19, x15, x0
  xor   x26, x18, x19
  sra   x1, x21, x24
  and   x8, x24, x29
  slti  x15, x27, -1024
  xori  x22, x30, 546
  andi  x29, x1, 1092
  srli  x4, x4, 11

round_10:
  or    x0, x19, x4
  addi  x24, x0, 1
  sltiu x31, x25, 7
  ori   x6, x28, 273
  slli  x13, x31, 14
  srai  x20, x2, 19
  sub   x27, x5, x2
  slt   x2, x8, x7
  xor   x9, x11, x12
  sra   x0, x14, x17
  and   x23, x0, x22
  slti  x30, x20, -1537
  xori  x5, x23, 1110
  andi  x12, x26, 273
  srli  x19, x29, 0
  add   x26, x0, x15
  sll   x1, x3, x20
  sltu  x8, x6, x25
  srl   x15, x9, x30

round_11:
  ori   x0, x24, 1620
  slli  x3, x0, 8
  srai  x10, x30, 13
  sub   x17, x1, x0
  slt   x24, x4, x5
  xor   x31, x7, x10
  sra   x6, x10, x15
  and   x13, x13, x20
  slti  x20, x16, -1537
  xori  x0, x19, 801
  andi  x2, x0, 1620
  srli  x9, x25, 26
  add   x16, x28, x13
  sll   x23, x31, x18
  sltu  x30, x2, x23
  srl   x5, x5, x28
  or    x12, x8, x1
  addi  x19, x11, 0
  sltiu x26, x14, 1

round_12:
  slt   x0, x29, x30
  xor   x14, x0, x3
  sra   x21, x3, x0
  and   x28, x6, x13
  slti  x3, x9, -2048
  xori  x10, x12, -513
  andi  x17, x15, 291
  srli  x24, x18, 15
  add   x31, x21, x6
  sll   x0, x24, x11
  sltu  x13, x0, x16
  srl   x20, x30, x0
  or    x27, x1, x26
  addi  x2, x4, -1
  sltiu x9, x7, 0
  ori   x16, x10, -513
  slli  x23, x13, 28
  srai  x30, x16, 1
  sub   x5, x19, x24

round_13:
  and   x0, x2, x11
  slti  x25, x0, -2048
  xori  x0, x8, -1024
  andi  x7, x11, -257
  srli  x14, x14, 9
  add   x21, x17, x4
  sll   x28, x20, x9
  sltu  x3, x23, x14
  srl   x10, x26, x19
  or    x0, x29, x24
  addi  x24, x0, -1
  sltiu x31, x3, 0
  ori   x6, x6, -1024
  slli  x13, x9, 22
  srai  x20, x12, 27
  sub   x27, x15, x22
  slt   x2, x18, x27
  xor   x9, x21, x0
  sra   x16, x24, x5

round_14:
  srli  x0, x7, 30
  add   x4, x0, x29
  sll   x11, x13, x0
  sltu  x18, x16, x7
  srl   x25, x19, x12
  or    x0, x22, x17
  addi  x7, x25, -17
  sltiu x14, x28, -1
  ori   x21, x31, 240
  slli  x0, x2, 11
  srai  x3, x0, 16
  sub   x10, x8, x0
  slt   x17, x11, x20
  xor   x24, x14, x25
  sra   x31, x17, x30
  and   x6, x20, x3
  slti  x13, x23, 1023
  xori  x20, x26, 1365
  andi  x27, x29, 240

round_15:
  sltu  x0, x12, x5
  srl   x15, x0, x10
  or    x22, x18, x0
  addi  x29, x21, -17
  sltiu x4, x24, -1
  ori   x11, x27, 682
  slli  x18, x30, 5
  srai  x25, x1, 10
  sub   x0, x4, x13
  slt   x0, x7, x18
  xor   x14, x0, x23
  sra   x21, x13, x0
  and   x28, x16, x1
  slti  x3, x19, 1023
  xori  x10, x22, 2047
  andi  x17, x25, 682
  srli  x24, x28, 23
  add   x31, x31, x26
  sll   x6, x2, x31

round_16:
  sltiu x0, x17, -17
  ori   x26, x0, -1
  slli  x1, x23, 26
  srai  x8, x26, 31
  sub   x15, x29, x6
  slt   x22, x0, x11
  xor   x29, x3, x16
  sra   x4, x6, x21
  and   x11, x9, x26
  slti  x0, x12, 511
  xori  x25, x0, 0
  andi  x0, x18, -1
  srli  x7, x21, 12
  add   x14, x24, x19
  sll   x21, x27, x24
  sltu  x28, x30, x29
  srl   x3, x1, x2
  or    x10, x4, x7
  addi  x17, x7, -64

round_17:
  srai  x0, x22, 25
  sub   x5, x0, x4
  slt   x12, x28, x0
  xor   x19, x31, x14
  sra   x26, x2, x19
  and   x1, x5, x24
  slti  x8, x8, 511
  xori  x15, x11, 1092
  andi  x22, x14, 1
  srli  x0, x17, 6
  add   x4, x0, x17
  sll   x11, x23, x0
  sltu  x18, x26, x27
  srl   x25, x29, x0
  or    x0, x0, x5
  addi  x7, x3, -64
  sltiu x14, x6, -33
  ori   x21, x9, 1092
  slli  x28, x12, 19

round_18:
  sra   x0, x27, x12
  and   x16, x0, x17
  slti  x23, x1, 255
  xori  x30, x4, 273
  andi  x5, x7, 819
  srli  x12, x10, 27
  add   x19, x13, x10
  sll   x26, x16, x15
  sltu  x1, x19, x20
  srl   x0, x22, x25
  or    x15, x0, x30
  addi  x22, x28, -129
  sltiu x29, x31, -64
  ori   x4, x2, 273
  slli  x11, x5, 8
  srai  x18, x8, 13
  sub   x25, x11, x28
  slt   x0, x14, x1
  xor   x7, x17, x6

round_19:
  xori  x0, x0, 1620
  andi  x27, x0, 546
  srli  x2, x6, 21
  add   x9, x9, x8
  sll   x16, x12, x13
  sltu  x23, x15, x18
  srl   x30, x18, x23
  or    x5, x21, x28
  addi  x12, x24, -129
  sltiu x0, x27, -64
  ori   x26, x0, 1620
  slli  x1, x1, 2
  srai  x8, x4, 7
  sub   x15, x7, x26
  slt   x22, x10, x31
  xor   x29, x13, x4
  sra   x4, x16, x9
  and   x11, x19, x14
  slti  x18, x22, 127

pass:
  lui   x2, 0x90000
  addi  x2, x2, -8
  addi  x1, x0, 1
  sw    x1, 0(x2)
1:
  jal   x0, 1b
