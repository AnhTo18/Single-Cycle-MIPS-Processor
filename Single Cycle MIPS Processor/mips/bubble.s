.data
arr: 5,1,2,6,7,3,8,4
.text
.globl main
main:
	la $a0, arr
	addi, $s0, $s0, 0 #i
	j arrSize #get size of array
outerLoop:
	addi $a1, $a1, -1
	
	sll $0, $0, 0
	sll $0, $0, 0
	sll $0, $0, 0
	sll $0, $0, 0
	
	slt $t0, $s0, $a1  #check if i < arr.size
	addi $s1, $0, 0 #j
	addi $s2, $0, 0 #offset
	
	sll $0, $0, 0
	sll $0, $0, 0
	
	beq $t0, 0, exit #outer loop done, so end
innerLoop:
	slt $t1, $s1, $a1 # check if j is equal to array size
	
	sll $0, $0, 0
	sll $0, $0, 0
	sll $0, $0, 0
	sll $0, $0, 0
	sll $0, $0, 0
	
	beq $t1, 0, innerLoopEnd
	lw $t2, arr($s2) #get first number
	lw $t3, arr + 4($s2) #get second number
	
	sll $0, $0, 0
	sll $0, $0, 0
	sll $0, $0, 0
	sll $0, $0, 0
	
	slt $t4, $t2, $t3 #is the first number < second number?
	beq $t4, 1, noSwap #if it is, then no swapping needed
	sw $t3, arr($s2) #swap values
	sw $t2, arr + 4($s2)
	
noSwap:
	addi $s2, $s2, 4 #go to next element
	addi $s1, $s1, 1 #increment inner loop
	j innerLoop #go back to loop

innerLoopEnd:
	addi $s0, $s0, 1
	j outerLoop
arrSize:
	lw $t5, arr($s5) #loads element from array
	addi $s5, $s5, 4 #increments offset
	sll $0, $0, 0
	sll $0, $0, 0
	sll $0, $0, 0
	sll $0, $0, 0
	beq $t5, 0, outerLoop#if no elements in array, start loop
	addi $a1, $a1, 1 #add one to the size
	j arrSize #repeat
exit:
	addi $v0, $zero, 10