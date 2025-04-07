.data
print: .asciiz "Please enter a positive integer less than 16: "
output: .asciiz "Its binary form is: "
binary: .space 16
	.align 2
.text
main:
la $a0, print
li $v0, 4
syscall

li $v0, 5
syscall
addi $t0, $v0, 0 # luu input vao $s0
li $t1, 2
la $t5, binary

loop:
divu $t0, $t1
mfhi $t2 #reminder
mflo $t0 # $t0 = quotient
sw $t2, 0($t5)
addi $t5, $t5, 4
bne $t0, $zero, loop
addi $s0, $zero, 0
la $a0, output
li $v0, 4
syscall
j printBin

printBin:
addi $t5, $t5, -4
lw $t0,0($t5)
add $a0, $0, $t0
li $v0, 1
syscall
addi $s0, $s0, 1 
bne $s0, 4, printBin

exit:
li $v0, 10
syscall






