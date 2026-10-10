# Ex4 - Factorial as a procedure

What it does: main loads N, calls factorial with jal, then prints the value returned in a0.

Registers: a0 = argument, then return value. s0 (in main) holds the result across the print ecalls. s1 = running result inside factorial. t0 = i.

Stack: factorial uses s1, which is callee-saved, so it stores it on the stack at entry and restores it before returning. It calls nothing, so it does not save ra.

Harder than expected: 
