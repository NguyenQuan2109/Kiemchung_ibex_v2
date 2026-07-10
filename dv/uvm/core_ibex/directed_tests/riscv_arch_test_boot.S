/* Boot shim for RISC-V architecture tests.
 *
 * The restored riscv-arch-tests sources put rvtest_entry_point at offset 0x80
 * in .text.init. The Ibex UVM memory loader starts executing at BOOT_ADDR
 * (0x80000000), so provide the first instruction in the image and jump to the
 * architecture-test entry point.
 */

.section .text.init
.option push
.option norvc
.globl _start
_start:
  jal x0, rvtest_entry_point
.option pop
