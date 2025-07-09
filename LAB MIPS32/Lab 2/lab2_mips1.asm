.data
enter:	.asciiz "Enter a string: "
string:	.space 200
freq:	.space 128
endl:	.asciiz "\n"
comma:	.asciiz ", "
semicolon: .asciiz "; "

.text
main:
#Print to the screen
la $a0, enter
li $v0, 4
syscall
# cin >> a string
li $v0, 8
li $a1, 200
la $a0, string
syscall

# assign freq to 0s
la $t0, freq
li $t1, 128

clear:
sb $zero, 0($t0)
addi $t1, $t1, -1
addi $t0, $t0, 1
bgtz $t1, clear

#update freq
la $t2, string # t2 = &string

count:
lb $t3, 0($t2) #t3 = string[i]
beq $t3, $zero, finish #if string[i] == '\0' => finish counting

la $t4, freq
add $t4, $t4, $t3 #t4 = freq[string[i]]
lb $t5, 0($t4)
addi $t5, $t5, 1
sb $t5, 0($t4)
addi $t2, $t2, 1
j count
finish:

#find max frequency
la $t0, freq
li $t1, 128
li $t2, 0 #max = t2 = 0
li $t3, 128 # t3 = i = 128

findmax:
lb $t4, 0($t0) # t4 = freq[i]
bgt $t4, $t2, assign #freq[i] > max
addi $t0, $t0, 1 
addi $t3, $t3, -1 # i--
bgtz $t3, findmax
j Exit

  assign:
  addi $t2, $t4, 0 # max = freq[i]
  addi $t0, $t0, 1
  addi $t3, $t3, -1
  bgtz $t3, findmax
   
Exit:
li $t5, 1 # f = 1
addi $s0, $zero, 0 # first = true
outer_loop:
bgt $t5, $t2, stop_outer # if f > max => stop

li $t8, 0 # t8 = ASCII code

 inner_loop:
 bgt $t8, 127, stop_inner
 
 la $t0, freq
 
 add $t0, $t0, $t8
 lb $t1, 0($t0) # t1 = freq[i]

 bne $t1, $t5, ELSE 
 ble $t8, 32, ELSE
 # if (freq[i] == f)
 #print string[freq[i]], freq[i]
 
 beq $s0, $zero, printsemi
 la $a0, semicolon
 li $v0, 4
 syscall

 printsemi:
 move $a0, $t8
 li $v0, 11
 syscall
 

 la $a0, comma
 li $v0, 4
 syscall

 move $a0, $t1 #print a0 = freq[i]
 li $v0, 1
 syscall
 addi $s0, $zero, 1
 
 ELSE:
 addi $t8, $t8, 1
 j inner_loop

 stop_inner:
 addi $t5, $t5, 1 # f++
 j outer_loop

stop_outer:

li $v0, 10
syscall
