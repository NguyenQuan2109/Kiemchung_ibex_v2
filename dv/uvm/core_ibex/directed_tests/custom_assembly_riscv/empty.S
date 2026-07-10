# Copyright lowRISC contributors.
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0

###############################################################################
# Description:
#   Minimal custom directed test for the Ibex UVM core testbench.
#
#   The core_ibex_base_test waits for a riscv-dv TEST_RESULT handshake at
#   signature_addr - 4. run_rtl.py passes signature_addr=0x8ffffffc, so the
#   pass/fail control address is 0x8ffffff8.
###############################################################################

  .section .text.init
  .org 0x80
  .global _start

_start:
  # TEST_RESULT is encoded in bits [7:0], TEST_PASS is encoded above bit 8.
  li x2, 0x8ffffff8
  li x1, 0x1
  sw x1, 0(x2)

1:
  j 1b
