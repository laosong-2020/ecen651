.data
msg1:	.asciiz "A 17 byte message"
msg2:	.asciiz "Another message of 27bytes"
num1:	.byte 45
num2:	.half 654
num3:	.word 0xcafebabe
num4:	.word 0xfeedface
.text
.globl main
main :
addu $s0,$ra,$0	#save the return address
li $v0,4	#system call for print str
la $a0,msg1	#address of string to print
syscall
la $a0,msg2	#address of string to print
syscall
lb $t0,num1	#load num1 into $t0
lh $t1,num2	#load num2 into $t1
lw $t2,num3	#load num3 into $t2
lw $t3,num4	#load num4 into $t3
addu $ra,$s0,$0	#restore the return address
jr $ra		#returnfrommain
