. text # text section
. globl main # c all main
main :
addi $t1 , $0 , 8 # load immediate value ( 8 ) i nt o $t1
addi $t2 , $0 , 9 # load immediate value ( 9 ) i nt o $t2
add $t3 , $t1 , $t2 # add two numbers into $t3
jr $ra # return from main ; return address stored in $ra
