.data 
	inserta:		.asciiz "Please insert a: "
	insertb:		.asciiz "Please insert b: "
	insertc:		.asciiz "Please insert c: "
	x1:		.asciiz "x1 = "
	x2: 		.asciiz "x2 = "
	oneSolution:	.asciiz "There is one solution, x = "
	msg: 		.asciiz " and "
	noSolution: 	.asciiz "There is no real solution"
	infinite:	.asciiz "Infinite solution"
	NOSOLUTION:	.asciiz "No Solution"
.text

main:

la 	$a0, inserta
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f1, $f0 #f1 = a

la 	$a0, insertb
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f2, $f0 #f2 = b


la 	$a0, insertc
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f3, $f0 #f3 = c


li $t9, 0
mtc1 $t9, $f30
cvt.s.w $f30, $f30
c.eq.s $f30, $f1 # a == 0 ?
bc1f Normalcase
c.eq.s $f30, $f2 # b == 0 ?
bc1f Normalcase
c.eq.s $f30, $f3 # c == 0?
bc1f NoSolution
j InfiniteSolution

Normalcase:
#calculate delta
mul.s 	$f5, $f2, $f2 #f5 = b^2
mul.s 	$f6, $f1, $f3 # f6 = a * c
li 	$s0, 4
mtc1 	$s0, $f7
cvt.s.w 	$f7, $f7 # f7 = 4
mul.s 	$f6, $f6, $f7 # f6 = 4*a*c
sub.s 	$f5, $f5, $f6 # f5 = delta = b^2 - 4ac

# cases
li 	$t0, 0
mtc1 	$t0, $f8
cvt.s.w 	$f8, $f8 # f8 = 0

# 2*a:
li 	$t1, 2
mtc1 	$t1, $f9
cvt.s.w 	$f9, $f9 
mul.s 	$f9, $f9, $f1 # f9 = 2*a


c.lt.s 	$f5, $f8
bc1t noSolu #delta < 0 => noSolu

# else delta >= 0
sqrt.s 	$f5, $f5 # f5 = sqrt(delta)
sub.s 	$f2, $f8, $f2 # b = 0 - b => f2 = -b

c.eq.s 	$f5, $f8
bc1t oneSolu # delta == 0 => oneSolu

# if delta > 0 
sub.s 	$f10, $f2, $f5 # f10 = -b - sqrt(delta)
div.s 	$f10, $f10, $f9 # f10 = (-b -sqrt(delta)) / 2*a
# x1 = f10

add.s 	$f11, $f2, $f5 # f11 = -b + sqrt(delta)
div.s 	$f11, $f11, $f9 # f11 = (-b + sqrt(delta)) / 2*a
# x2 = f11

j twoSolu


oneSolu:
la	$a0, oneSolution
li 	$v0, 4
syscall
div.s	$f13, $f2, $f9 # f13 = x = -b/2a
mov.s $f12, $f13
li $v0, 2
syscall
j Exit


noSolu:
la 	$a0, noSolution
li 	$v0, 4
syscall
j Exit

twoSolu:
la 	$a0, x1
li 	$v0, 4
syscall

mov.s 	$f12, $f10
li 	$v0, 2
syscall

la   	$a0, msg       
li   	$v0, 4       
syscall

la 	$a0, x2
li 	$v0, 4
syscall

mov.s 	$f12, $f11
li 	$v0, 2
syscall
j Exit

InfiniteSolution:
la $a0, infinite
li $v0, 4
syscall
j Exit

NoSolution:
la $a0, NOSOLUTION
li $v0, 4
syscall

Exit:

li 	$v0, 10
syscall
