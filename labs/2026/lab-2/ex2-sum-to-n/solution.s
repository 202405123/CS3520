# Ex2 - Sum of the first N integers
        .data
n:      .word   10
msg:    .asciz  "Sum: "

        .text
main:
        lw      t0, n               # t0 = N
        li      t1, 1               # t1 = i = 1
        li      t2, 0               # t2 = sum = 0
loop:
        bgt     t1, t0, done        # exit the loop once i > N
        add     t2, t2, t1          # sum += i
        addi    t1, t1, 1           # i++
        j       loop
done:
        la      a0, msg
        li      a7, 4
        ecall
        mv      a0, t2
        li      a7, 1
        ecall
        li      a7, 10
        ecall
