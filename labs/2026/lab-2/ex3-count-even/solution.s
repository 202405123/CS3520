# Ex3 - Count the even elements of an array
        .data
array:  .word   3, 8, 15, 22, 7, 10, 41, 6
n:      .word   8
msg:    .asciz  "Even count: "

        .text
main:
        la      t0, array           # t0 = base address
        lw      t1, n               # t1 = number of elements
        li      t2, 0               # t2 = i
        li      t3, 0               # t3 = count
loop:
        bge     t2, t1, done        # leave once i >= n
        slli    t4, t2, 2           # t4 = i * 4
        add     t5, t0, t4          # t5 = &array[i]
        lw      t6, 0(t5)           # t6 = array[i]
        andi    t6, t6, 1           # t6 = lowest bit (1 if odd)
        bnez    t6, skip            # odd: do not count it
        addi    t3, t3, 1           # even: count++
skip:
        addi    t2, t2, 1           # i++
        j       loop
done:
        la      a0, msg
        li      a7, 4
        ecall
        mv      a0, t3
        li      a7, 1
        ecall
        li      a7, 10
        ecall
