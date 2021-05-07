
.data
.text
.globl main
main:
	addi $s0, $s0, 5 #set up some registers
	addi $s1, $s1, 10
	addi $s2, $s2, 15
	
	slt $t0, $s0, $s1 #set less than testing
	slti $t1, $s2, 15
	
	sltu $t2, $s1, $s0
	sltiu $t3, $s0, 15
	
	beq $t0, 1, test1#branch if equal test
	
	
test1:
	addi $s0, $s0, 1 
	bne $t1, 1, test2 #bne test

test2:
	addi $s2, $s2, 1
	j test3 #j test
	
test3:
	addi $s1, $s1, 1
	jal test4 #jal test
	
test4:
	addi $s0, $s0, 1
	beq $s0, $s1, Exit
	jr $ra #jr test
	
Exit:
	addi $v0, $zero, 10
	halt
	
	
	
	
	
