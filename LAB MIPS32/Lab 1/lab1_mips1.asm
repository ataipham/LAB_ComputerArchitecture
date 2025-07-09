.data 

Greetings: .asciiz "Hello, "
name: .space 100
.text
main:

li $v0, 8
la $a0, name
addi $a1, $0, 10
syscall 

la $a0, Greetings
li $v0, 4
syscall

la $a0, name
li $v0, 4
syscall

li $v0, 10
syscall	
