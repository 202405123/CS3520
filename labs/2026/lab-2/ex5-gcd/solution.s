# Ex5 - GCD by repeated subtraction, written as a procedure
        .data
x:      .word   48
y:      .word   18
msg:    .asciz  "GCD: "

        .text
main:
        lw      a0, x               # first argument
        lw      a1, y               # second argument
        jal     ra, gcd             # call gcd(x, y); result in a0
        mv      s0, a0
        la      a0, msg
        li      a7, 4
        ecall
        mv      a0, s0
        li      a7, 1
        ecall
        li      a7, 10
        ecall

# gcd(a in a0, b in a1) -> gcd in a0. Inputs must be positive.
# Leaf procedure using only argument registers, so nothing to save.
gcd:
gcd_loop:
        beq     a0, a1, gcd_done    # equal: a0 is the answer
        blt     a0, a1, b_bigger    # a < b: subtract a from b
        sub     a0, a0, a1          # a > b: a = a - b
        j       gcd_loop
b_bigger:
        sub     a1, a1, a0          # b = b - a
        j       gcd_loop
gcd_done:
        jalr    x0, ra, 0           # return, result already in a0
