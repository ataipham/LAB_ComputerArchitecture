.data
inserta: .asciiz "Insert a: "
insertb: .asciiz "Insert b: "
insertc: .asciiz "Insert c: "
insertd: .asciiz "Insert d: "
quotient: .asciiz "F = "
remainder: .asciiz ", remainder "

.text
main:
#a + b + c
la $a0, inserta
li $v0, 4
syscall

li $v0, 5
syscall
addi $s0, $v0, 0 # s0 = a

la $a0, insertb
li $v0, 4
syscall

li $v0, 5
syscall
addi $s1, $v0, 0 # s1 = b
add $t0, $s0, $s1 # t0 = a + b

la $a0, insertc
li $v0, 4
syscall

li $v0, 5
syscall
addi $s2, $v0, 0 # s2 = c
add $t0, $t0, $s2 #### t0 = a + b + c

la $a0, insertd
li $v0, 4
syscall

li $v0, 5
syscall
addi $s3, $v0, 0 # s3 = d

# calculate a + 10
addi $t1, $s0, 10 # t1 = a + 10
sub $t2, $s1, $s3 # t2 = b - d
sll $t3, $s0, 1 #t3 = 2*a
sub $t3, $s2, $t3 #t3 = c - 2*a

mul $t1, $t1, $t2
mul $t1, $t1, $t3

div $t1, $t0
mfhi $t1 #remainder
mflo $t0 #quotient

la $a0, quotient
li $v0, 4
syscall
addi $a0, $t0, 0
li $v0, 1
syscall

la $a0, remainder
li $v0, 4
syscall
addi $a0, $t1, 0
li $v0, 1
syscall

li $v0 ,10
syscall

