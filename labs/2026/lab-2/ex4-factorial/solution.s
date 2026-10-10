# Ex4 - Factorial as a procedure called from main
        .data
n:      .word   5
msg:    .asciz  "Factorial: "

        .text
main:
        lw      a0, n               # argument: N in a0
        jal     ra, factorial       # call factorial(N); result in a0
        mv      s0, a0              # keep the result across the print
        la      a0, msg
        li      a7, 4
        ecall
        mv      a0, s0
        li      a7, 1
        ecall
        li      a7, 10
        ecall

# factorial(n in a0) -> n! in a0
# Leaf procedure: saves s1 on the stack, does not need to save ra.
factorial:
        addi    sp, sp, -4          # make room on the stack
        sw      s1, 0(sp)           # preserve the caller's s1
        li      s1, 1               # result = 1
        li      t0, 2               # i = 2
fact_loop:
        bgt     t0, a0, fact_done   # exit when i > n
        mul     s1, s1, t0          # result *= i
        addi    t0, t0, 1           # i++
        j       fact_loop
fact_done:
        mv      a0, s1              # return value goes in a0
        lw      s1, 0(sp)           # restore the caller's s1
        addi    sp, sp, 4           # release the stack space
        jalr    x0, ra, 0           # return to the caller
