### Q1: Why does the assembly test `i >= n` when C++ says `i < n`?

In C++, the loop continues running as long as `i < n` is true. In assembly, however, the branch instruction is used to jump to another part of the program when a particular condition is met. Since the loop body comes immediately after the condition check, the program can continue into the loop body without jumping. Therefore, the assembly code checks the opposite condition, `i >= n`, so that it jumps out of the loop when the condition is true. The instruction `beq x0, x0, loop` then sends the program back to the beginning of the loop because `x0` is always equal to itself.

The same idea applies to `ble t4, s1, skip`. In C++, the program updates the maximum value if `arr[i] > max`. The assembly code instead checks whether `arr[i] <= max`. If that condition is true, it skips the update because the current element is not greater than the maximum.

### Q2: What do the pseudo-instructions become?

Pseudo-instructions are simplified instructions that make assembly code easier to read and write. They are translated into actual RISC-V instructions before execution.

For example, `li a7, 4` becomes `addi a7, x0, 4`, which loads the value 4 into register `a7`. Similarly, `mv s0, a0` becomes `addi s0, a0, 0`, which copies the value in `a0` into `s0`.

The instruction `la a0, array` is expanded into `auipc` and `addi`, which work together to calculate the address of `array` relative to the program counter. Similarly, `lw a1, n` may be expanded into `auipc` and `lw` to access the value stored at `n`.

Another example is `ble t4, s1, skip`, which becomes `bge s1, t4, skip`. The operands are swapped because RISC-V does not have a native `ble` instruction. Instead, it provides instructions such as `beq`, `bne`, `blt`, `bge`, `bltu` and `bgeu`.

The main reason pseudo-instructions exist is to make assembly programming more convenient while keeping the actual instruction set relatively small and regular. This helps simplify processor design, while pseudo-instructions allow programmers to express common operations more easily. Each pseudo-instruction is translated into one or more real instructions. The exact translation can be checked in the right-hand pane of Ripes.

### Q3: Why does `find_max` save `s1` but not `ra`?

The register `s1` is a callee-saved register, meaning that a procedure must preserve its original value if it uses the register. Since `find_max` uses `s1` to store the current maximum value, it saves the original value on the stack and restores it before returning. This ensures that the procedure does not accidentally change a value that the calling procedure expects to remain unchanged.

On the other hand, `ra` stores the return address, which tells the processor where to continue after the procedure finishes. In this case, `find_max` is a leaf procedure because it does not call another procedure using `jal`. Therefore, its return address is not overwritten, and it can return safely using `jalr x0, ra, 0` without saving `ra` on the stack. If `find_max` called another procedure using `jal`, it would normally need to save its return address before making that call.

Finally, registers such as `t1` to `t4` are caller-saved registers. This means that the calling procedure is responsible for preserving their values if it needs them after a procedure call. Therefore, `find_max` does not need to save these registers simply because it uses them.
