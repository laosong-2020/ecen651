main:	
	li $t0, 50					# Initialize the array to (50, 40, 30)
	sw $t0, 0($0)				# Store first value
	li $t0, 40          	
	sw $t0, 4($0)				# Store Second Value
	li $t0, 30          	
	sw $t0, 8($0)				# Store Third Value
	li $a0, 0					# address of array
	li $a1, 3					# 3 values to sum
TestProg1:                  	
	add $t0, $0, $0			# This is the sum
	add $t1, $0, $a0			# This is our array pointer
	add $t2, $0, $0			# This is our index counter
P1Loop:	
	beq $t2, $a1, P1Done	# Our loop
	lw	$t3, 0($t1)				# Load Array[i]
	add $t0, $t0, $t3			# Add it into the sum
	add $t1, $t1, 4			# Next address
	add $t2, $t2, 1			# Next index
	j P1Loop						# Jump to loop
P1Done:	sw $t0, 0($t1)			# Store the sum at end of array
	lw $t0, 12($0)      		# Load Final Value
	nop							# Complete
	add $0, $s0, $s0        # do nothing