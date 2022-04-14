.data # assume start address 0

led_data: .word 0xffff # led status, all on at the beginning
swt_data: .word 0xa7b5 # switch status

.text
sw zero, (zero) # test1 sw: led all of

addi t0, zero, 0xff # test2 addi: led[7:0] still on
sw t0, (zero)

lw t0, 4(zero) # test3 lw: led = switch
sw t0, (zero)

addi t2, zero, 0x7 # test4 add: led = switch + 7
add t1, t0, t2
sw t1, (zero)

sub t1, t1, t2 # test5 sub: led = switch
sw t1, (zero)

auipc t1, 0xfffff # test6 auipc: led = 0x2028
sw t1, (zero)

addi t2, zero, 0x7 # test7, 8 beq, jal: led = loop ? i : addr(jal + 4)
add t1, zero, zero
LOOP1:
beq t1, t2, END
addi t1, t1, 1
sw t1, (zero)
jal LOOP1
END:
sw ra, (zero)

addi t2, zero, 0x7 # test9 blt: led = i, for i in range(1, 7)
add t1, zero, zero
LOOP2:
addi t1, t1, 0x1
sw, t1, (zero)
blt t1, t2, LOOP2

jalr ra, ra, 0 # test10 jalr
