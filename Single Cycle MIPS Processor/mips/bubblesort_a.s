.data
	list: .word 2, 3, 67, 15, 12, 1, 0, 888, 46, 99
	size: .word 10

.text
.globl main
main:
	lui $a1, 0x1001
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	ori $a1, 0x0028
	lui $a0, 0x1001
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	ori $a0, 0
	lw $a1, 0($a1) #load size
	
	li $t0, 0 #i

loop:
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $t0, $t0, 1 #i+1
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	slt $t1, $t0, $a1 #i+1 < n
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	beq $t1, $0, exit
	addi $0, $0, 0
	li $t2, 0 #j
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	subu $a2, $a1, $t2 #n-j
	
innerloop:
	addi $t2, $t2, 1 #j+1
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	slt $t3, $t2, $a2 #j+1 < n-j
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	beq $t3, $0, loop
	addi $0, $0, 0
	
sort:
	addi $t4, $t2, -1 #j
	sll $t5, $t2, 2 #(j+1)*4
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	sll $t6, $t4, 2 #j*4
	add $t5, $t5, $a0 #address of (j+1)th element
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	add $t6, $t6, $a0 #address of jth element
	lw $t7, 0($t5) #(j+1)th element
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	lw $t8, 0($t6) #jth element
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	slt $t9, $t7, $t8
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	beq $t9, $0, store
	addi $0, $0, 0
	add $a2, $0, $t7
	add $t7, $0, $t8
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	add $t8, $0, $a2
	
store:
	
	sw $t7, 0($t5)
	addi $0, $0, 0
	addi $0, $0, 0
	addi $0, $0, 0
	sw $t8, 0($t6)
	j innerloop
	addi $0, $0, 0

exit:
	# Exit program
    li $v0, 10
    syscall
