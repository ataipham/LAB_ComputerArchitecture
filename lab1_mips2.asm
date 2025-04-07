.data
prompt: .asciiz "Please input element "
index: .asciiz "Please inter  index: "
haicham: .asciiz ": "

.text
main:
#arr[0]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 0 #print index
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall	
#$v0 = arr[0] 
add $s0, $0, $v0 #s0 = arr[0]
############################
#arr[1]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 1 #print index
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall	
#$v0 = arr[1] 
add $s1, $0, $v0 #s1 = arr[1]
##########################
#arr[2]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 2 #print index
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall	
#$v0 = arr[2] 
add $s2, $0, $v0 #s2 = arr[2]
#######################
#arr[3]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 3 #print index
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall	
#$v0 = arr[0] 
add $s3, $0, $v0 #s3 = arr[3]
#######################
#arr[4]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 4 #print index
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall	
#$v0 = arr[4] 
add $s4, $0, $v0 #s4 = arr[4]
####### Initialized done

la $a0, index
li $v0, 4
syscall

li $v0, 5
syscall 
add $t0, $0, $v0 # $t0 = index

beq $t0, 0, index0
beq $t0, 1, index1
beq $t0, 2, index2
beq $t0, 3, index3
beq $t0, 4, index4

index0: 
add $a0, $s0, $0 # $a0 = arr[0]
li $v0, 1
syscall
j Exit

index1:
add $a0, $s1, $0 # $a0 = arr[0]
li $v0, 1
syscall
j Exit

index2:
add $a0, $s2, $0 # $a0 = arr[0]
li $v0, 1
syscall
j Exit

index3:
add $a0, $s3, $0 # $a0 = arr[0]
li $v0, 1
syscall
j Exit

index4:
add $a0, $s4, $0 # $a0 = arr[0]
li $v0, 1
syscall
j Exit



Exit:
li $v0, 10
syscall

