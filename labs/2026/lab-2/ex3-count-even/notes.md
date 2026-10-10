# Ex3 - Count the even elements of an array

What it does: walks through the array and prints how many elements are even.

Registers: t0 = array base, t1 = n, t2 = i, t3 = count, t4 = i*4, t5 = address of array[i], t6 = element, then its low bit.

Logic: andi t6, t6, 1 keeps only the lowest bit. A number is even when that bit is 0, so bnez skips the count for odd numbers.

Harder than expected: Understanding that andi with 1 isolates the lowest bit, so the branch skips odd numbers.


