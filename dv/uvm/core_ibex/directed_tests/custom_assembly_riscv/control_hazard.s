# Copyright Nguyen Quan.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Custom RV32I/Zifencei directed control hazard stress test.
#
#   The body contains 200 source-level body instructions. It stresses taken/
#   not-taken conditional branches, load-to-branch dependencies, ALU-to-branch
#   dependencies, jal, jalr, and fence.i.
###############################################################################

  .option norvc
  .section .text.init
  .global _start

_start:
  addi  x3,  x0, 7
  addi  x4,  x0, 3
  addi  x5,  x0, 1
  addi  x6,  x0, 2
  addi  x7,  x0, -1
  lui   x20, %hi(data_area)
  addi  x20, x20, %lo(data_area)

body_start:
block_00:
  addi  x8,  x0, 1
  addi  x9,  x8, -1
  beq   x9,  x0, b00_t0
  addi  x10, x0, 0x10
b00_t0:
  addi  x10, x9, 2
  bne   x10, x9, b00_t1
  addi  x11, x0, 0x11
b00_t1:
  fence.i
  addi  x11, x10, 3
  beq   x11, x0, b00_dead

block_01:
b00_dead:
  jal   x1,  b01_jal
  addi  x12, x0, 0x21
b01_jal:
  addi  x12, x1, 4
  lui   x30, %hi(b01_jalr)
  addi  x30, x30, %lo(b01_jalr)
  jalr  x2,  0(x30)
  addi  x13, x0, 0x22
b01_jalr:
  add   x13, x5, x6
  blt   x0,  x13, b01_done
  addi  x14, x0, 0x23

block_02:
b01_done:
  lw    x14, 0(x20)
  beq   x14, x3, b02_t0
  addi  x15, x0, 0x31
b02_t0:
  addi  x15, x14, -7
  beq   x15, x0, b02_t1
  addi  x16, x0, 0x32
b02_t1:
  sw    x15, 4(x20)
  fence.i
  lw    x16, 4(x20)
  bne   x16, x15, b02_dead

block_03:
b02_dead:
  addi  x17, x0, 5
  add   x18, x17, x4
  bge   x18, x17, b03_t0
  addi  x19, x0, 0x41
b03_t0:
  addi  x19, x18, -8
  beq   x19, x0, b03_t1
  addi  x21, x0, 0x42
b03_t1:
  jal   x22, b03_jal
  addi  x21, x0, 0x43
b03_jal:
  add   x21, x22, x19

block_04:
  lui   x30, %hi(b04_jalr)
  addi  x30, x30, %lo(b04_jalr)
  jalr  x23, 0(x30)
  addi  x24, x0, 0x51
b04_jalr:
  addi  x24, x0, 9
  bgeu  x24, x4, b04_t0
  addi  x25, x0, 0x52
b04_t0:
  addi  x25, x24, -9
  beq   x25, x0, b04_t1
  addi  x26, x0, 0x53

block_05:
b04_t1:
  sw    x24, 8(x20)
  lw    x26, 8(x20)
  beq   x26, x24, b05_t0
  addi  x27, x0, 0x61
b05_t0:
  addi  x27, x26, -8
  bne   x27, x0, b05_t1
  addi  x28, x0, 0x62
b05_t1:
  fence.i
  addi  x28, x27, 1
  bge   x28, x0, b05_done

block_06:
b05_done:
  addi  x8,  x0, -4
  blt   x8,  x0, b06_t0
  addi  x9,  x0, 0x71
b06_t0:
  addi  x9,  x8, 4
  beq   x9,  x0, b06_t1
  addi  x10, x0, 0x72
b06_t1:
  jal   x11, b06_jal
  addi  x10, x0, 0x73
b06_jal:
  addi  x10, x9, 6
  bne   x10, x9, b06_done

block_07:
b06_done:
  lui   x30, %hi(b07_jalr)
  addi  x30, x30, %lo(b07_jalr)
  jalr  x12, 0(x30)
  addi  x13, x0, 0x81
b07_jalr:
  lw    x13, 12(x20)
  addi  x14, x13, -11
  beq   x14, x0, b07_t0
  addi  x15, x0, 0x82
b07_t0:
  addi  x15, x14, 1
  bgeu  x15, x14, b07_done

block_08:
b07_done:
  sw    x15, 16(x20)
  fence.i
  lw    x16, 16(x20)
  beq   x16, x15, b08_t0
  addi  x17, x0, 0x91
b08_t0:
  addi  x17, x16, -1
  beq   x17, x14, b08_t1
  addi  x18, x0, 0x92
b08_t1:
  jal   x19, b08_done
  addi  x18, x0, 0x93

block_09:
b08_done:
  add   x18, x17, x4
  bne   x18, x17, b09_t0
  addi  x21, x0, 0xa1
b09_t0:
  lui   x30, %hi(b09_jalr)
  addi  x30, x30, %lo(b09_jalr)
  jalr  x22, 0(x30)
  addi  x21, x0, 0xa2
b09_jalr:
  addi  x21, x18, -3
  beq   x21, x17, b09_done
  addi  x23, x0, 0xa3

block_10:
b09_done:
  addi  x23, x0, 13
  sw    x23, 20(x20)
  lw    x24, 20(x20)
  bge   x24, x23, b10_t0
  addi  x25, x0, 0xb1
b10_t0:
  addi  x25, x24, -13
  beq   x25, x0, b10_t1
  addi  x26, x0, 0xb2
b10_t1:
  fence.i
  bne   x24, x0, b10_done

block_11:
b10_done:
  jal   x26, b11_jal
  addi  x27, x0, 0xc1
b11_jal:
  addi  x27, x0, 17
  addi  x28, x27, -17
  beq   x28, x0, b11_t0
  addi  x29, x0, 0xc2
b11_t0:
  lui   x30, %hi(b11_jalr)
  addi  x30, x30, %lo(b11_jalr)
  jalr  x29, 0(x30)
  addi  x8,  x0, 0xc3

block_12:
b11_jalr:
  addi  x8,  x0, 19
  bltu  x4,  x8, b12_t0
  addi  x9,  x0, 0xd1
b12_t0:
  sw    x8,  24(x20)
  lw    x9,  24(x20)
  beq   x9,  x8, b12_t1
  addi  x10, x0, 0xd2
b12_t1:
  addi  x10, x9, -19
  beq   x10, x0, b12_done
  addi  x11, x0, 0xd3

block_13:
b12_done:
  fence.i
  addi  x11, x0, -21
  blt   x11, x0, b13_t0
  addi  x12, x0, 0xe1
b13_t0:
  addi  x12, x11, 21
  beq   x12, x0, b13_t1
  addi  x13, x0, 0xe2
b13_t1:
  jal   x13, b13_done
  addi  x14, x0, 0xe3

block_14:
b13_done:
  addi  x14, x12, 23
  bge   x14, x12, b14_t0
  addi  x15, x0, 0xf1
b14_t0:
  lui   x30, %hi(b14_jalr)
  addi  x30, x30, %lo(b14_jalr)
  jalr  x15, 0(x30)
  addi  x16, x0, 0xf2
b14_jalr:
  addi  x16, x14, -23
  beq   x16, x12, b14_done
  addi  x17, x0, 0xf3

block_15:
b14_done:
  sw    x16, 28(x20)
  lw    x17, 28(x20)
  beq   x17, x16, b15_t0
  addi  x18, x0, 0x101
b15_t0:
  addi  x18, x17, 1
  bne   x18, x17, b15_t1
  addi  x19, x0, 0x102
b15_t1:
  fence.i
  jal   x19, b15_done
  addi  x21, x0, 0x103

block_16:
b15_done:
  addi  x21, x18, 2
  bgeu  x21, x18, b16_t0
  addi  x22, x0, 0x111
b16_t0:
  lui   x30, %hi(b16_jalr)
  addi  x30, x30, %lo(b16_jalr)
  jalr  x22, 0(x30)
  addi  x23, x0, 0x112
b16_jalr:
  addi  x23, x21, -2
  beq   x23, x18, b16_done
  addi  x24, x0, 0x113

block_17:
b16_done:
  lw    x24, 32(x20)
  addi  x25, x24, -29
  beq   x25, x0, b17_t0
  addi  x26, x0, 0x121
b17_t0:
  sw    x25, 36(x20)
  fence.i
  lw    x26, 36(x20)
  beq   x26, x25, b17_t1
  addi  x27, x0, 0x122
b17_t1:
  bne   x24, x0, b17_done

block_18:
b17_done:
  addi  x27, x26, 31
  blt   x26, x27, b18_t0
  addi  x28, x0, 0x131
b18_t0:
  jal   x28, b18_jal
  addi  x29, x0, 0x132
b18_jal:
  addi  x29, x27, -31
  beq   x29, x26, b18_t1
  addi  x8,  x0, 0x133
b18_t1:
  fence.i

block_19:
  lui   x30, %hi(b19_jalr)
  addi  x30, x30, %lo(b19_jalr)
  jalr  x8,  0(x30)
  addi  x9,  x0, 0x141
b19_jalr:
  addi  x9,  x0, 1
  beq   x9,  x5, b19_t0
  addi  x10, x0, 0x142
b19_t0:
  addi  x10, x9, 1
  bne   x10, x9, b20_start
  addi  x11, x0, 0x143

b20_start:
  fence.i
  addi  x11, x10, -1
  beq   x11, x9, b20_t0
  addi  x12, x0, 0x151
b20_t0:
  jal   x12, b20_jal
  addi  x13, x0, 0x152
b20_jal:
  lui   x30, %hi(b20_jalr)
  addi  x30, x30, %lo(b20_jalr)
  jalr  x13, 0(x30)
  addi  x14, x0, 0x153
b20_jalr:
  addi  x14, x13, 0
  bne   x13, x0, pass

pass:
  li    x31, 0x8ffffff8
  li    x1,  0x1
  sw    x1,  0(x31)

done:
  j     done

  .section .data
  .balign 4
data_area:
  .word 0x00000007, 0x00000000, 0x00000009, 0x0000000b
  .word 0x00000000, 0x00000000, 0x00000000, 0x00000000
  .word 0x0000001d, 0x00000000, 0x00000000, 0x00000000
