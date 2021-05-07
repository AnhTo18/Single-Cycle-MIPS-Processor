.data
arr:.word 5,1,2,6,7,3,8,4,9
temp: .word 0,0,0,0,0,0,0,0
.text
.globl main
main:
	la $a0, arr #a0 = array address edit for pipeline version
	addi $a1, $0, 0 #a1 = low
	addi $a2, $0, 8 #a2 = high
	jal sort
		
	li $v0, 10
	syscall
sort:
	slt $t0, $a1, $a2
	beq $t0, 0, continue
	
	sub $sp, $sp, 16
	sw $ra 12($sp)
	sw $a1, 8($sp)
	sw $a2, 4($sp)
	
	add $s0, $a1, $a2
	sra $s0, $s0, 1
	sw $s0, 0($sp)
	
	add $a2, $s0, $0
	
	jal sort
	
	lw $s0, 0($sp)
	addi $s1, $s0, 1
	add $a1, $s1, 0
	lw $a2, 4($sp)
	
	jal sort
	
	lw $a1, 8($sp)
	lw $a2, 4($sp)
	lw $a3, 0($sp)
	
	jal merge
	
	lw $ra 12($sp)
	addi $sp, $sp, 16
	jr $ra
merge:
	add $s0, $a1, $0 #i = low
	addi $s1, $a3, 1 #j = mid + 1
	add $s2, $a1, $0 #k = low
	#multiplied by 4 for ease of addressing
	sll $s5, $s0, 2
	sll $s6, $s1, 2
	sll $s7, $s2, 2
	j while
while:
	slt $t0, $a3, $s0
	slt $t1, $a2, $s1
	beq $t0, 1, iWhile
	beq $t1, 1, iWhile
	
	add $t5, $s5, $a0
	lw $t6, 0($t5)
	
	add $t7, $s6, $a0
	lw $t8, 0($t7)
	
	slt $t4, $t8, $t7
	beq $t4, 1, if
	
	la $s4, temp #modify for pipeline version
	add $t9, $s7, $s4
	sw $t6, 0($t9)
	
	addi $s0, $s0, 1
	addi $s2, $s2, 1
	
	addi $s5, $s5, 4
	addi $s7, $s7, 4
	j while
if:
	la $s4, temp #modify for pipeline version
	add $t9, $s7, $s4
	
	sw $t8, 0($t9)
	
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	
	addi $s6, $s6, 4
	addi $s7, $s7, 4
	j while
iWhile:
	slt $t3, $a3, $s0
	beq $t3, 1, jWhile
	
	add $t5, $s5, $a0
	lw $t6, 0($t5)
	
	la $s4, temp #modify for pipeline version
	add $t9, $s7, $s4
	
	sw $t6, 0($t9)
	addi $s0, $s0, 1
	addi $s2, $s2, 1
	
	addi $s5, $s5, 4
	addi $s7, $s7, 4
	j iWhile
	
jWhile:
	slt $t3, $a2, $s2
	beq $t3, 1, start_for
	add $t7, $s6, $a0
	lw $t8, 0($t7)
	
	la $s4, temp #modify for pipeline version
	add $t9, $s7, $s4
	
	sw $t8, 0($t9)
	
	addi $s1, $s1, 1
	addi $s2, $s2, 1
	
	addi $s6, $s6, 4
	addi $s7, $s7, 4
	j jWhile
start_for:
	add $t1, $a1, $0
	addi $t2, $a2, 1
	la $s4, temp #modify for pipeline version
for:
	slt $t3, $t1, $t2
	beq $t3, $0, continue
	sll $t4, $t1, 2
	
	add $t5, $t4, $a0
	add $t6, $s4, $t4
	
	lw $t7 , 0($t6)
	sw $t7, 0($t5)
	
	addi $t1, $t1, 1
	j for
continue:
	jr $ra
exit:
	jr $ra
	


	
