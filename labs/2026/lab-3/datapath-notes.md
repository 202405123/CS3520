# CS3520 Lab 3 - Datapath notes

## Predictions (written from the Week 6-8 lectures, before measuring)

1. `add` will use the register file, ALU and write-back only. data_mem.wr_en will be 0, and the write-back mux will select the ALU result.
2. `lw` will be the only instruction whose write-back mux selects memory data. It is the slowest path, so it sets the clock period.
3. `beq` (12 vs 5) will not redirect the PC, and `bne` on the same registers will, so pc_src.select will be 0 then 1.
4. CPI will be exactly 1.00, because every instruction takes one cycle.

I then checked each one in Ripes; they matched (or I noted the difference below).

## Step 3 - Think: data_mem.addr during an `add`

The value on data_mem.addr is the ALU result (17). The ALU always computes something and its output is wired permanently to the memory address input. It is harmless because wr_en = 0, so nothing is written, and the write-back mux selects the ALU result, so whatever the memory reads is ignored. The cost is time: the memory sits in series on the path of every instruction, so the clock period must be long enough for `lw`, and `add` pays for it too.

## Step 4 - Questions

1. **lui vs auipc.** The difference is made by the ALU operand-1 mux (alu_op1_src) together with the ALU operation. For `auipc` the mux selects the PC and the ALU adds PC + immediate. For `lui` the register value is ignored and the ALU passes the immediate through unchanged.
2. **sw.** The signal is the register write enable (reg_do_write_ctrl), which is 0. The write-back mux still selects something, but its output is never committed because nothing is enabled to write.
3. **Branch to pc_src.** The branch unit compares r1 and r2 and produces `res` (1 if the condition holds). That goes into the AND gate (`br_and`) together with the control unit's `branch` signal. The result goes into the OR gate (`controlflow_or`), which also receives the jump signal. The OR output drives pc_src.select. For `beq` 12 vs 5, `res` = 0, so no redirect. For `bne`, `res` = 1, so the PC is redirected.
4. **jal / jalr.** The return address is PC+4, supplied by the third input of the write-back mux. The ALU cannot supply it because it is busy computing the jump target (PC + imm, or rs1 + imm). Data memory cannot supply it because it only returns loaded data. PC+4 comes from the dedicated pc_4 adder.

## Step 5 - Statistics and the CPU time question

Recorded from the Statistics panel: listed instructions = 18, retired = 17, CPI = 1.00, IPC = 1.00. The count of 18 includes the never-executed `addi a2, zero, 99` at 0x30 (the 18 listed minus 1 skipped gives the 17 retired).

**Think.** CPU time = IC x CPI x Tc. The term sacrificed is Tc, the clock period. With the Week 7 delays, `lw` needs 925 ps, so every instruction runs at 925 ps. An `add` never uses data memory and could finish in about 675 ps (925 minus 250 ps for the memory access), so it wastes roughly 250 ps every cycle. A pipelined design with the same components would be limited by its slowest stage, about 250 ps, which makes Tc roughly 925/250 = 3.7 times shorter. The factor is below 5 because the stages are unbalanced. CPI stays near 1, so overall time falls by about that factor.

## Step 6 - Three differences from the textbook

**A. No dedicated branch adder.** In the textbook the branch target PC + offset is computed by a second adder. In Ripes the ALU computes it: alu_op1_src selects the PC and alu_op2_src selects the immediate. The gain is less hardware (one adder fewer). The same trick also gives `auipc`, `jal` and `jalr` their addresses through existing hardware.

**B. A separate comparison unit.** The textbook tests the ALU's Zero flag after a subtraction, which only works well for `beq`. A separate branch unit can do every comparison (`beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu`) directly. Less-than, signed and unsigned, is awkward to get from a Zero flag. It also solves a conflict created by A: the ALU is busy computing the target, so it cannot also subtract to compare. Instructions that need it: `bne`, `blt`, `bge`, `bltu`, `bgeu` (and `beq`).

**C. A three-input write-back mux.** The textbook MemtoReg mux has two inputs (ALU result, memory data). Here a third input carries PC+4. Instructions that depend on it: `jal` and `jalr`, which must save a return address.

**Think: dedicated adder vs reusing the ALU.** A dedicated adder is faster and allows the target to be computed in parallel with the comparison, at the cost of extra area. Reusing the ALU saves area and power, but the ALU is busy, so a separate comparator is needed, and the operand mux adds a little delay. I would choose the dedicated adder for a pipelined high-speed design, where the target is needed early. I would reuse the ALU in a small, cheap design where area matters more than the cycle time.
