.data
insert0: .asciiz "Insert a: "
insert1: .asciiz "Insert b: "
insert2: .asciiz "Insert c: "
insert3: .asciiz "Insert d: "
result: .asciiz "F = "
phay: .asciiz ", reminder "

.text
main:
#input a:
la $a0, insert0
li $v0, 4
syscall

li $v0, 5
syscall
add $s0, $0, $v0

#input b:
la $a0, insert1
li $v0, 4
syscall

li $v0, 5
syscall
add $s1, $0, $v0

#input c:
la $a0, insert2
li $v0, 4
syscall

li $v0, 5
syscall
add $s2, $0, $v0
#input d:
la $a0, insert3
li $v0, 4
syscall

li $v0, 5
syscall
add $s3, $0, $v0

add $t0, $s0, $s1 
add $t0, $t0, $s2 #$t0 = divisor
addi $t1, $s0, 10 # $t1 = a + 10
sub $t2, $s1, $s3 # $t2 = b - d
mul $t1, $t1, $t2
sll $t2, $s0, 1 # a*2
sub $t2, $s2, $t2 # $t2 = c- 2*a
mul $t1, $t1, $t2 #dividend
divu $t1, $t0
mfhi $t1 #reminder
mflo $t2 #quotient

la $a0, result
li $v0, 4
syscall
add $a0, $0, $t2
li $v0, 1
syscall 

la $a0, phay
li $v0, 4
syscall
add $a0, $0, $t1
li $v0, 1
syscall 


li $v0 ,10
syscall

