# CS3520 Lab 3 - Trace tables

Program: `trace-classes.s`. Processor: Ripes RISC-V Single Cycle, Extended layout.
Text segment starts at 0x00000000, data segment at 0x10000000.

## Program layout (from the Instruction memory panel)

| Addr | Instruction | Note |
|------|-------------|------|
| 0x00 | addi t0, zero, 12 | |
| 0x04 | addi t1, zero, 5 | |
| 0x08 | add t2, t0, t1 | |
| 0x0C | sub t3, t0, t1 | |
| 0x10 | lui t4, 0x2B | |
| 0x14 | auipc t5, 0x0 | |
| 0x18 | auipc a0, hi | `la a0, val` expands to two instructions |
| 0x1C | addi a0, a0, lo | second half of `la` |
| 0x20 | lw a1, 0(a0) | |
| 0x24 | sw t2, 4(a0) | |
| 0x28 | beq t0, t1, skip | not taken |
| 0x2C | bne t0, t1, target | taken |
| 0x30 | addi a2, zero, 99 | `skip`, never executed |
| 0x34 | jal ra, report | `target` |
| 0x38 | addi a7, zero, 10 | |
| 0x3C | ecall | |
| 0x40 | addi a2, zero, 7 | `report` |
| 0x44 | jalr zero, ra, 0 | |

The source file has 17 instruction lines. The panel lists 18 because `la` is a pseudo-instruction that becomes `auipc` + `addi`.

## Step 3 - tracing `add t2, t0, t1` (PC = 0x08)

| Element | Port | Value |
|---------|------|-------|
| pc_reg | out | 0x00000008 |
| pc_4 | out | 0x0000000C |
| instr_mem | data_out | 0x006283B3 |
| decode | r1_reg_idx / r2_reg_idx | 5 / 6 (t0 = x5, t1 = x6) |
| decode | wr_reg_idx | 7 (t2 = x7) |
| control | reg_do_write_ctrl | 1 |
| control | alu_op2_ctrl | 0 (register, not immediate) |
| registerFile | r1_out / r2_out | 12 / 5 |
| alu_op1_src | out | 12 |
| alu_op2_src | out | 5 |
| alu | res | 17 |
| data_mem | wr_en | 0 |
| reg_wr_src | select / out | 1 (ALU result) / 17 |
| pc_src | select / out | 0 / 0x0000000C |

## Step 4 - one row per instruction class

| Instruction | Addr | Format | imm | op1 mux | op2 mux | alu.res | wb mux / pc mux |
|-------------|------|--------|-----|---------|---------|---------|-----------------|
| addi t0, zero, 12 | 0x00 | I | 12 | reg (x0 = 0) | imm | 12 | wb: ALU result / pc: PC+4 (0x04) |
| add t2, t0, t1 | 0x08 | R | not used | reg (12) | reg (5) | 17 | wb: ALU result / pc: PC+4 (0x0C) |
| lui t4, 0x2B | 0x10 | U | 0x2B000 (176128) | reg (ignored) | imm | 176128 (0x0002B000) | wb: ALU result / pc: PC+4 (0x14) |
| auipc t5, 0x0 | 0x14 | U | 0 | PC (0x14) | imm | 20 (0x14) | wb: ALU result / pc: PC+4 (0x18) |
| lw a1, 0(a0) | 0x20 | I | 0 | reg (a0 = 0x10000000) | imm | 0x10000000 | wb: memory data (42) / pc: PC+4 (0x24) |
| sw t2, 4(a0) | 0x24 | S | 4 | reg (a0 = 0x10000000) | imm | 0x10000004 (268435460) | wb: nothing written (reg_do_write = 0) / pc: PC+4 (0x28) |
| beq t0, t1, skip | 0x28 | B | 8 | PC (0x28) | imm | 0x30 (target) | branch unit res = 0 / pc: PC+4 (0x2C), select 0 |
| bne t0, t1, target | 0x2C | B | 8 | PC (0x2C) | imm | 0x34 (target) | branch unit res = 1 / pc: select 1, out 0x34 |
| jal ra, report | 0x34 | J | 12 | PC (0x34) | imm | 0x40 (target) | wb: PC+4 (0x38 into ra) / pc: select 1, out 0x40 |
| jalr zero, ra, 0 | 0x44 | I | 0 | reg (ra = 0x38) | imm | 0x38 (target) | wb: PC+4 (discarded, rd = x0) / pc: select 1, out 0x38 |
