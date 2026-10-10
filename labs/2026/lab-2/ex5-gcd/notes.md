# Ex5 - GCD (Euclid, repeated subtraction)

What it does: main loads x and y, calls gcd, and prints the result.

Registers: a0 and a1 hold the two numbers and are modified in place. The answer is left in a0.

Logic: while the numbers differ, subtract the smaller from the larger. When they are equal, that value is the GCD. The procedure is a leaf and only touches argument registers, so it saves nothing on the stack.

Limit: both inputs must be positive, otherwise the loop never ends.

Harder than expected: 
