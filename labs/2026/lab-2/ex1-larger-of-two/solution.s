# Ex1 - Print the larger of two integers
        .data
a:      .word   17
b:      .word   42
msg:    .asciz  "Larger: "

        .text
main:
        lw      t0, a               # t0 = a
        lw      t1, b               # t1 = b
        bge     t0, t1, use_a       # if a >= b, a is the larger
        mv      t2, t1              # otherwise larger = b
        j       print
use_a:
        mv      t2, t0              # larger = a
print:
        la      a0, msg             # print "Larger: "
        li      a7, 4
        ecall
        mv      a0, t2              # print the value
        li      a7, 1
        ecall
        li      a7, 10              # exit
        ecall
