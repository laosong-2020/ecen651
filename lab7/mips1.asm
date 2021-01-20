TestProg4:
				li $t1, 0xfeed				# $t1 = 0xfeed
				li $t0, 0x190				# Load address of P4jr
				jr $t0						# Jump to P4jr
				li $t1, 0					# Check for failure to jump
		P4jr:	sw $t1, 84($0)				# $t1 should be 0xfeed if successful
				li $t0, 0xcafe				# $t0 = 0xcafe
				jal P4Jal					# Jump to P4Jal
				li $t0, 0xbabe				# Check for failure to jump
		P4Jal:	sw $t0, 88($0)			# $t0 should be 0xcafe if successful
				li $t2, 0xface				# $t2 = 0xface
				j P4Skip						# Jump to P4Skip
				li $t2, 0           	
		P4Skip:	sw $t2, 92($0)			# $t2 should be 0xface if successful
				sw $ra, 96($0)				# Store $ra
				lw $t0, 84($0)				# Load value for check
				lw $t1, 88($0)				# Load value for check
				lw $t2, 92($0)				# Load value for check
				lw $ra, 96($0)				# Load value for check

Test5-1:
				li $t0, -2147450880
				add $t0, $t0, $t0
				lw $t0, 4($0)        #incorrect if this instruction completes
				
		Test5-2:
				li $t0, 2147450879
				add $t0, $t0, $t0
				lw $t0, 4($0)        #incorrect if this instruction completes
		
		Test 5-3:
				lw $t0, 4($0)
				li $t0, -2147483648
				li $t1, 1
				sub $t0, $t0, $t1
				lw $t0, 4($0)
		
		Test 5-4:
				li $t0, 2147483647
				mula $t0, $t0, $t0
				lw $t0, 4($0)

lw $t0, 0($0)

li $t5, 0	    # initialize data to 0
				 li $t0, 100	    # initialize exit value
				 li $t1, 0	    # initialize outer loop index to 0
			outer_loop: 
				 addi $t1, $t1, 1 #increment outer loop index
				 li $t2, 0         #initialize inner loop index to 0
			inner_loop: 
				 addi $t2, $t2, 1 #increment inner loop index
				 addi $t5, $t5, 1 #increment data
				 bne $t2, $t0, inner_loop #go back to top of inner loop
				 bne $t1, $t0, outer_loop #go back to top of outer loop
				 sw $t5, 12($0) #store data into memory
				 lw $t5, 12($0) #load data back out of memory