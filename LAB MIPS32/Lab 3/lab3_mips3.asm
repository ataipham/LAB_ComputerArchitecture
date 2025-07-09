.data 
 inputFile: 	.asciiz "raw_input.txt"
 outputFile: 	.asciiz "formatted_result.txt"
 tieude:		.asciiz "----Student personal information----\n"
 ten:		.asciiz "Name: "
 mssv: 		.asciiz "ID: "
 diachi:		.asciiz "Address: "
 tuoi:		.asciiz "Age: "
 tongiao:	.asciiz "Religion: "
 error:		.asciiz "No such file directory"
 endl:		.asciiz "\n"

 name:		.space 50
 ID:		.space 50
 address:	.space 100
 age:		.space 50
 religion:	.space 50


.text
main:
#open file	
li 	$v0, 13
la 	$a0, inputFile
li 	$a1, 0
li 	$a2, 0
syscall
move 	$s0, $v0 # s0 = file descriptor of raw_input

bgez 	$s0, Continue
Error:
la 	$a0, error
li 	$v0, 4
syscall
j Exit


Continue:
#dynamic allocating
li 	$v0, 9
li 	$a0, 300
syscall
move 	$a3, $v0 # a3 stores base address of array[]

#read file
li 	$v0, 14
move 	$a0, $s0
move 	$a1, $a3
li 	$a2, 300
syscall 

li  	$v0, 16
move 	$a0, $s0
syscall

#################################################
# Extract into sub array (name, age, address, ...)
move 	$t0, $a3 # t0 is now storing base address of array[]
la 	$t1, name
la 	$t2, ID
la 	$t3, address
la 	$t4, age
la 	$t5, religion
li 	$t6, 0 # comma counting

loop:
lb 	$t7, 0($t0)
beq 	$t7, 0, terminate # if char[i] = '\0' => terminate
beq 	$t7, ',', comma

beq 	$t6, 0, save_to_name
beq 	$t6, 1, save_to_ID
beq 	$t6, 2, save_to_addr
beq 	$t6, 3, save_to_age
beq 	$t6, 4, save_to_religion

save_to_name:
sb 	$t7, 0($t1)
addi 	$t1, $t1, 1
j next_char

save_to_ID:
sb 	$t7, 0($t2)
addi 	$t2, $t2, 1
j next_char

save_to_addr:
sb 	$t7, 0($t3)
addi 	$t3, $t3, 1
j next_char

save_to_age:
sb 	$t7, 0($t4)
addi 	$t4, $t4, 1
j next_char

save_to_religion:
sb 	$t7, 0($t5)
addi 	$t5, $t5, 1
j next_char

comma:
addi 	$t6, $t6, 1

next_char:
addi 	$t0, $t0, 1
j loop

#---------------------------------------------
terminate:
sb 	$zero, 0($t1)
sb 	$zero, 0($t2)
sb 	$zero, 0($t3)
sb 	$zero, 0($t4)
sb 	$zero, 0($t5)

# print tieude
la 	$a0, tieude
li 	$v0, 4
syscall

#print ten
la 	$a0, ten
li 	$v0, 4
syscall

la 	$a0, name
li 	$v0, 4
syscall

la 	$a0, endl
li 	$v0, 4
syscall

#print mssv
la 	$a0, mssv
li 	$v0, 4
syscall

la 	$a0, ID
li 	$v0, 4
syscall

la 	$a0, endl
li 	$v0, 4
syscall

#print diachi
la 	$a0, diachi
li 	$v0, 4
syscall

la 	$a0, address
li 	$v0, 4
syscall

la 	$a0, endl
li 	$v0, 4
syscall
#print tuoi
la 	$a0, tuoi
li 	$v0, 4
syscall

la 	$a0, age
li 	$v0, 4
syscall

la 	$a0, endl
li 	$v0, 4
syscall

#print tongiao
la	$a0, tongiao
li 	$v0, 4
syscall

la 	$a0, religion
li 	$v0, 4
syscall

la 	$a0, endl
li 	$v0, 4
syscall
####################################
# End extracting file

# Write on new file
li 	$v0, 13
la 	$a0, outputFile
li 	$a1, 1
li 	$a2, 0
syscall
move 	$s1, $v0

#print title
li 	$v0, 15
move 	$a0, $s1
la 	$a1, tieude
li 	$a2, 36
syscall

li 	$v0, 15
move 	$a0, $s1
la 	$a1, endl
li 	$a2, 1
syscall

#print name
li 	$v0, 15
move 	$a0, $s1
la 	$a1, ten
li 	$a2, 6
syscall

li 	$v0, 15
move 	$a0, $s1
la	$a1, name
jal 	strLen
move 	$a2, $v1
syscall

li 	$v0, 15
move 	$a0, $s1
la	$a1, endl
li 	$a2, 1
syscall

#print ID
li	$v0, 15
move 	$a0, $s1
la 	$a1, mssv
li 	$a2, 4
syscall

li 	$v0, 15
move 	$a0, $s1
la 	$a1, ID
jal 	strLen
move 	$a2, $v1
syscall

li 	$v0, 15
move 	$a0, $s1
la 	$a1, endl
li 	$a2, 1
syscall

#print address
li 	$v0, 15
move 	$a0, $s1
la 	$a1, diachi
li 	$a2, 9
syscall

li 	$v0, 15
move 	$a0, $s1
la 	$a1, address
jal 	strLen
move 	$a2, $v1
syscall

li 	$v0, 15
move 	$a0, $s1
la 	$a1, endl
li 	$a2, 1
syscall


#print Age
li 	$v0, 15
move 	$a0, $s1
la 	$a1, tuoi
li 	$a2, 5
syscall

li 	$v0, 15
move 	$a0, $s1
la 	$a1, age
jal 	strLen
move 	$a2, $v1
syscall

li 	$v0, 15
move 	$a0, $s1
la 	$a1, endl
li 	$a2, 1
syscall

#print religion
li 	$v0, 15
move 	$a0, $s1
la 	$a1, tongiao
li 	$a2, 10
syscall

li 	$v0, 15
move 	$a0, $s1
la 	$a1, religion
#li $a2, 4
jal 	strLen
move 	$a2, $v1
syscall

li 	$v0, 15
move 	$a0, $s1
la 	$a1, endl
li 	$a2, 1
syscall

# Closing file
li  	$v0, 16
move 	$a0, $s1
syscall
j Exit


strLen:
li 	$v1, 0
move 	$t9, $a1

strloop:
lb 	$t8, 0($t9)
beq 	$t8, $0, out_loop
addi 	$v1, $v1, 1
addi 	$t9, $t9, 1
j strloop
out_loop:
jr 	$ra

Exit:	
li 	$v0, 10
syscall
