.data
msg1:	.asciiz "Please enter an integer number: "
msg2:	.asciiz "\tFirst result: "
msg3:	.asciiz "\tSecond result: "

.text
.globl main
#
#
#
main:
addu $s0, $ra, $0
li $v0, 4
la $a0, msg1
syscall
#now get an integer from the user
li $v0, 5
syscall

#do some computation here with the integer
addu $t0, $v0, $0

sll $t1, $t0, 2
srl $t2, $t0, 2

#print the first result
li $v0, 4
la $a0, msg2
syscall
li $v0, 1
addu $a0, $t1, $0
syscall
#print the second result
li $v0, 4
la $a0, msg3
syscall
li $v0, 1
addu $a0, $t2, $0
syscall
#restore now the return address in $ra and return from main
addu $ra, $0, $s0
jr $ra