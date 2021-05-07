.data
array: .word 2, 3, 4
.text
.globl main
main:

	addi $16, $0, 10 #places 10 into $s0
	addi $17, $0, 5 #places 5 into $s1
	
	add $18, $16, $17 #$s2 = 10 + 5/s0 + s1
	
	addiu $19, $16, 20 #places 25 into $s3, unsigned/#s3 = #s0 + 20
	
	addu $8, $19, $18 #$t0 = 15 + 25, unsigned/$t0 = #s3 + #s2
	
	and $9, $16, $17 #$t1 = 10 AND 5/#t1 = s0 and s1
	andi $10, $18, 10 #$t2 = 15 AND 10/#t3 = s2 and 10
	
	#load and store
	la $23, array
	lw $22, 0($23) #loads array[0] (2) into s6
	sw $17, 12($23) #stores 5 into array[3]
	
	nor $4, $10, $0 #$a0 = 10 NOR 0
	
	xor $11, $9, $10 #$t3 = 0 XOR 10
	xori $12, $11, 15 #t4 = 10 XOR 15
	
	or $5, $8, $18 #$a1 = 0 OR 15
	
	sll $14, $18, 2 #t6 = 15 * 4
	srl $15, $18, 1 #t7 = 15/2
	
	sra $8, $18, 1 #t0 = 15/2 signed
	
	sllv $9, $18, $22 #t1 = 15 * 2
	srlv $10, $18, $22 #t2 = 15/2
	srav $11, $18, $22 #t3 = 15/2 signed
	
	
	
	sub $12, $16, $15 #t4 = 10 - 5/$s0-$s1
	subu $13, $18, $15 #t5 = 15 - 5/$s2-$s1 unsigned  
	
	addi $18, $18, 3100000000

	
	clo $18, $18 #counts leading ones in s2/15
	
	clz $17, $17 #counts leading zeros in s1/5
	halt
	
