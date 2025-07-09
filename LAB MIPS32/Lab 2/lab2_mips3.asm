.data
 input: .asciiz "Please insert an element: "
 	.align 2
 array: .space 40
 output1: .asciiz "Second largest value is "
 output2: .asciiz ", found in index "
 comma:	  .asciiz ", "
 
.text
main:
li $t0, 0
la $s0, array #s0 = base address of array

inputArray:
la $a0, input
li $v0, 4
syscall

li $v0, 5
syscall
mul $t1, $t0, 4 #i * 4
add $t1, $t1, $s0 # &array + i * 4
sw $v0, 0($t1)

addi $t0, $t0, 1
blt $t0, 10, inputArray

lw $t2, 0($s0) # t2 = largest = array[0]
move $s1, $t2
li $s2, -100
li $t0, 1 #i = 1

find_Max_and_Second:
bge $t0, 10, Exit
sll $t6, $t0, 2 # t6 = i * 4
add $t4, $t6, $s0 # t4 = &array[i]
lw $t5, 0($t4) #t5 = array[i]

bgt $t5, $s1, assignLargest # neu array[i] > max

bgt $t5, $s2, assign2ndLargest1 #array[i] > second largest && array
j Else

assign2ndLargest1:
bne $t5, $s1, assign2ndLargest

Else:
addi $t0, $t0, 1 #i++
j find_Max_and_Second

assignLargest:
move $s2, $s1 # secondlargest = largest
move $s1, $t5 #largest = array[i]
addi $t0, $t0, 1 #i++
blt $t0, 10, find_Max_and_Second
j Exit

assign2ndLargest:
move $s2, $t5 #secondlargest = array[i]
addi $t0, $t0, 1 #i++
blt $t0, 10, find_Max_and_Second

Exit:

la $a0, output1
li $v0, 4
syscall

move $a0, $s2
li $v0, 1
syscall

la $a0, output2
li $v0, 4
syscall

li $t0, 0 # i = 0
li $t8, 0
printIndex:
bge $t0, 10, OUT
sll $t6, $t0, 2 # i * 4
add $t6, $t6, $s0 # &array + i * 4
lw $t7, 0($t6) # t7 = array[i]

bne $t7, $s2, skipPrint # if array[i] == secondlargest

beq $t8, $zero, printIdx
la $a0, comma
li $v0, 4
syscall

printIdx:
move $a0, $t0
li $v0, 1
syscall
addi $t8, $t8, 1

skipPrint:
addi $t0, $t0, 1
j printIndex

OUT:

li $v0, 10
syscall
