# Copyright Nguyen Quan.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Custom RV32I/Zifencei control-hazard corner-case stress test.
#
#   The body contains 35 source-level instructions. It intentionally places
#   branch, jump, ret, and fence.i instructions close together, with both taken
#   and not-taken branches plus forward positive and backward negative branch
#   offsets.
###############################################################################

  .option norvc
  .section .text.init
  .global _start

_start:
  jal   x0,  body_start

  .org 0x80

body_start:
  addi  x5,  x0, 3
  addi  x7,  x0, 0
  beq   x7,  x0, forward_taken
  jal   x0,  fail_path
forward_taken:
  fence.i
  bne   x7,  x0, fail_path
  addi  x7,  x7, 1
backward_loop:
  addi  x7,  x7, 1
  blt   x7,  x5,  backward_loop
  bge   x7,  x5,  after_bge
  jal   x0,  fail_path
after_bge:
  jal   x1,  ret_chain
  fence.i
  bltu  x0,  x7,  unsigned_taken
  jal   x0,  fail_path
unsigned_taken:
  bgeu  x7,  x0,  indirect_setup
  jal   x0,  fail_path
indirect_setup:
  lui   x30, %hi(indirect_target)
  addi  x30, x30, %lo(indirect_target)
  jalr  x2,  0(x30)
  jal   x0,  fail_path
indirect_target:
  fence.i
  beq   x2,  x0,  fail_path
  jal   x1,  ret_chain
  fence.i
  addi  x10, x0, 1
  beq   x10, x0, fail_path
  fence.i
  bne   x10, x0, tail_taken
  jal   x0,  pass
tail_taken:
  beq   x10, x0, fail_path
  jal   x0,  pass
  addi  x11, x0, 0x7

ret_chain:
  fence.i
  ret

pass:
  li    x31, 0x8ffffff8
  li    x1,  0x1
  sw    x1,  0(x31)

done:
  j     done

fail_path:
  li    x31, 0x8ffffff8
  li    x1,  0x2
  sw    x1,  0(x31)
fail_loop:
  j     fail_loop
