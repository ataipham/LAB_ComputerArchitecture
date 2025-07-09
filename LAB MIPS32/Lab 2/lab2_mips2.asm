.data
 inputa: .asciiz "a = "
 inputb: .asciiz "b = "
 outputGCD: .asciiz "GCD = "
 outputLCM: .asciiz ", LCM = "
 
.text
main:
la $a0, inputa
li $v0, 4
syscall

li $v0, 5
syscall
move $s0, $v0 # s0 = a

la $a0, inputb
li $v0, 4
syscall

li $v0, 5
syscall
move $s1, $v0 # s1 = b

mul $t1, $s0, $s1 # t1 = a * b



jal findGCD
# in ra ket qua
move $t0, $v0
la $a0, outputGCD
li $v0, 4
syscall

move $a0, $t0
li $v0, 1
syscall

findLCM:
div $t1, $t0 # a * b / GCD
mflo $t1 # t1 = LCM

la $a0, outputLCM
li $v0, 4
syscall

move $a0, $t1
li $v0, 1
syscall

li $v0, 10
syscall


findGCD:
addi $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp) #save 2 arguments
sw $ra, 8($sp)

beq $s1, $zero, base_case

div $s0, $s1
mfhi $t0 # to = a % b

#return findGCD(b, a % b)
move $s0, $s1
move $s1, $t0
jal findGCD

base_case:
move $v0, $s0
lw $ra, 8($sp)
addi $sp, $sp, 12
jr $ra




