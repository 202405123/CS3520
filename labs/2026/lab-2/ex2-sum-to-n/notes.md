# Ex2 - Sum of the first N integers

What it does: reads N from .data and prints 1 + 2 + ... + N.

Registers: t0 = N, t1 = i (counter), t2 = running sum.

Logic: the C++ test is i <= n, so the assembly exits when i > N (bgt). The loop ends with an unconditional jump back to the top.

Harder than expected: Remembering that the C++ test i <= n becomes an exit test of i > N in assembly. 

