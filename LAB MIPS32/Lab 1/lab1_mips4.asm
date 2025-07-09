.data
prompt: .asciiz "Please enter a positive integer less than 16: "
print: 	.asciiz "Its binary form is: "
	.align 2
Bin: 	.space 16
	.align 2
Result: .space 16

.text
main:

la $a0, prompt
li $v0, 4
syscall

li $v0, 5
syscall
addi $s0, $v0, 0 # luu input vao $s0

la $a0, Bin
addi $a1, $a0, 0

#Tinh binary
BIN:
div $s0, $s0, 2 # s0 /= 2

mfhi $t0 #remainder
sb $t0, 0($a1)
addi $a1, $a1, 1

bne $s0, 0, BIN 

addi $t2, $0, 0 #i = 0
addi $s1, $0, 0 # result = s1
la $a2, Result

#Cách 1:
printBin:
addi $a1, $a1, -1
lb $t1, 0($a1)

addi $a0, $t1, 0
li $v0, 1
syscall
addi $t2, $t2, 1

bne $t2, 4, printBin

li $v0, 10
syscall






