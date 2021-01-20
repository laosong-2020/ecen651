.data
msg1:	.asciiz "Enter the first number \n"
msg2:	.asciiz"Enter the second number \n"
msg:	.asciiz"The productis"
.text
.globl main
.globl my_mul
main:
addi $sp, $sp, -8 #make room for $raand $fp on the stack
sw $ra, 4($sp)#push $ra
sw $fp, 0($sp)#push $fp
la $a0, msg1	#load address of msg1 into $a0
li $v0, 4
syscall#print msg1
li $v0, 5
syscall#read int
add $t0, $v0, $0 #putin $t0
la $a0, msg2 #load address of msg2 into $a0
li $v0, 4
syscall#print msg2
li $v0, 5
syscall#read int
add $a1, $v0, $0#put in $a1
add $a0, $t0, $0#put first number in $a0
add $fp, $sp, $0#set fp to top of stack prior
# to function call
jal my_mul #do mul,result is in $v0
add $t0, $v0, $0#save the result in $t0
la $a0, msg
li $v0, 4
syscall#print msg
add $a0, $t0, $0#put computation result in $a0
li $v0, 1
syscall#print result number
lw $fp, 0($sp)#restore (pop) $fp
lw $ra, 4($sp)#restore (pop) $ra
addi $sp, $sp, 8#adjust $sp
jr $ra#return
my_mul:
#push s0, s1, s2
addi $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)
#set s0 and s1 as 0
add $s0, $a0, $0
add $s1, $a1, $0
#set result v0 as zero
add $v0, $0, $0
mult_loop:
#exit condition: a == 0
beqz $s0, mult_eol
#if(s0 & 1 == 1) v0 += s1
#else continue
andi $s2, $s0, 1
beqz $s2, continue
add $v0, $v0, $s1
continue:
#each time left shift s1 and right shift s0 1 bit
sll $s1, $s1, 1
srl $s0, $s0, 1
j mult_loop

mult_eol:
#when exit, restore s0, s1, s2 from sp
lw $s0, 0($sp)
lw $s1, 4($sp)
lw $s2, 8($sp)
#push original sp from stack
addi $sp, $sp, 12
#return
jr $ra