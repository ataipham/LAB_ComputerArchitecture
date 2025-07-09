.data
prompt: .asciiz "Please input element "
enter: .asciiz "Please enter index: "
haicham: .asciiz ": "

.text
main:

############  arr[0]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 0
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall 
add $s0, $0, $v0 # $s0 = arr[0]

##################### arr[1]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 1
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall 
add $s1, $0, $v0 # $s1 = arr[1]

##################### arr[2]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 2
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall 
add $s2, $0, $v0 #$s2 = arr[2]

##################### arr[3]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 3
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall 
add $s3, $0, $v0 #$s3 = arr[3]

##################### arr[4]
la $a0, prompt
li $v0, 4
syscall

addi $a0, $0, 4
li $v0, 1
syscall

la $a0, haicham
li $v0, 4
syscall

li $v0, 5
syscall 
add $s4, $0, $v0 #$s4 = arr[4]
#############################################

la $a0, enter
li $v0, 4
syscall

li $v0, 5
syscall
add $t0, $0, $v0 #$t0 = index

beq $t0, 0, zero
beq $t0, 1, first
beq $t0, 2, second
beq $t0, 3, third
beq $t0, 4, fourth

zero: 
addi $a0, $s0, 0
li $v0, 1
syscall
j Exit

first:
addi $a0, $s1, 0
li $v0, 1
syscall
j Exit

second:
addi $a0, $s2, 0
li $v0, 1
syscall
j Exit

third:
addi $a0, $s3, 0
li $v0, 1
syscall
j Exit

fourth:
addi $a0, $s4, 0
li $v0, 1
syscall


Exit:
li $v0, 10
syscall

