# Ex1 - Larger of two integers

What it does: loads a and b from .data, then prints the larger one.

Registers: t0 = a, t1 = b, t2 = larger. a0 and a7 are used for the ecalls (print string, print int, exit).

Logic: bge t0, t1, use_a jumps when a >= b. Otherwise the code falls through and picks b.

Harder than expected: 
