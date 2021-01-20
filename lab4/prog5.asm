.data
msg1:	.asciiz "Enterthefirstnumber \n"
msg2:	.asciiz"Enterthesecondnumber \n"
msg:	.asciiz"Theproductis"
.text
.globl main
.globl my_mul
main:
addi $sp, $sp, -8 #makeroomfor$raand$fponthestack
sw $ra, 4($sp)#push$ra
sw $fp, 0($sp)#push$fp
la $a0, msg1	#loadaddressofmsg1into$a0
li $v0, 4
syscall#printmsg1
li $v0, 5
syscall#read i n t
add $t0, $v0, $0 #putin$t0
la $a0, msg2 #loadaddressofmsg2into$a0
li $v0, 4
syscall#printmsg2
li $v0, 5
syscall#read i n t
add $a1, $v0, $0#putin$a1
add $a0, $t0, $0#putfirstnumberin$a0
add $fp, $sp, $0#setfptotopofstackprior
# tofunctioncall
jal my_mul #domul,resultisin$v0
add $t0, $v0, $0#savetheresultin$t0
la $a0, msg
li $v0, 4
syscall#printmsg
add $a0, $t0, $0#putcomputationresultin$a0
li $v0, 1
syscall#printresultnumber
lw $fp, 0($sp)#restore(pop)$fp
lw $ra, 4($sp)#restore(pop)$ra
addi $sp, $sp, 8#adjust$sp
jr $ra#return
my_mul :#multiply$a0with$a1
#doesnothandlenegative$a1!
#Note:Thisisaninefficientwaytomultipy!
addi $sp, $sp, -4 #makeroomfor$s0onthestack
sw $s0, 0($sp)#push$s0
add $s0, $a1, $0#set$s0equalto$a1
add $v0, $0, $0#set$v0to0
mult_loop:
beq $s0, $0, mult_eol
add $v0, $v0, $a0
addi $s0, $s0, -1
j mult_loop
mult_eol :
lw $s0, 0($sp)#pop$s0
jr $ra
