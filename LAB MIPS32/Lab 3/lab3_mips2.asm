.data
	inputu:	.asciiz "Please input u: "
	inputv:	.asciiz 	"Please input v: "
	inputa:	.asciiz 	"Please input a: "
	inputb:	.asciiz 	"Please input b: "
	inputc:	.asciiz 	"Please input c: "
	inputd:	.asciiz 	"Please input d: "
	inpute:	.asciiz 	"Please input e: "
	result: .asciiz "Result = "
	const7:     .float 7.0
	const6:     .float 6.0
	const2:     .float 2.0
.text
main:
la 	$a0, inputu
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f1, $f0 # f1 = u

la 	$a0, inputv
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f2, $f0 # f2 = v

la 	$a0, inputa
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f3, $f0 # f3 = a

la 	$a0, inputb
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f4, $f0 # f4 = b

la 	$a0, inputc
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f5, $f0 # f5 = c

la 	$a0, inputd
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f6, $f0 # f6 = d

la 	$a0, inpute
li 	$v0, 4
syscall
li 	$v0, 6
syscall
mov.s 	$f7, $f0 # f7 = e

# d^4 + e^3
mul.s 	$f30, $f6, $f6 # f30 = d^2
mul.s 	$f30, $f30, $f30 # f30 = d^4

mul.s 	$f31, $f7, $f7 # f31 = e^2
mul.s 	$f31, $f31, $f7 # f31 = e^2 * e = e^3
add.s 	$f31, $f31, $f30 # f31 = d^4 + e^3

# compute u^7, u^6, u^2
l.s 	$f10, const7
l.s 	$f11, const6
l.s 	$f13, const2

mul.s 	$f30, $f1, $f1 # f30 = u^2
mul.s 	$f29, $f30, $f30 # f29 = u^4
mul.s 	$f29, $f29, $f30 # f29 = u^4 * u^2 = u^6
mul.s 	$f28, $f29, $f1 # f28 = u^7
mul.s 	$f28, $f28, $f3 # f28 = a * u^7
div.s 	$f28, $f28, $f10 # f28 = (a* u^7)/7
mul.s 	$f29, $f29, $f4 # f29 = b * u^6
div.s 	$f29, $f29, $f11 # f29 = (b * u^6)/6
mul.s 	$f30, $f30, $f5 # f30 = c * u^2
div.s 	$f30, $f30, $f13 # f30 = (c * u^2)/2

add.s 	$f22, $f28, $f29
add.s 	$f22, $f22, $f30 # f22 = tử số (theo u)

mul.s 	$f27, $f2, $f2 # f27 = v^2
mul.s 	$f26, $f27, $f27 # f26 = v^4
mul.s 	$f26, $f26, $f27 # f26 = v^4 * v^2 = v^6
mul.s 	$f25, $f26, $f2 # f25 = v^7
mul.s	$f27, $f27, $f5 # f27 = c * v ^2
div.s 	$f27, $f27, $f13 # f27 = (c * v^2)/2
mul.s 	$f26, $f26, $f4 # f26 = b* v^6
div.s 	$f26, $f26, $f11 # f26 = (b * v^6)/6
mul.s 	$f25, $f25, $f3 # f25 = a * v^7
div.s 	$f25, $f25, $f10 # f25 = (a * v^7)/7

add.s 	$f23, $f25, $f26
add.s 	$f23, $f23, $f27 # f23 = tử số (theo v)

sub.s 	$f21, $f22, $f23 # f21 = F(u) - F(v)
div.s	$f21, $f21, $f31 # f21 = (F(u) - F(v))/ d^4 + e^3


la 	$a0, result
li 	$v0, 4
mov.s 	$f12, $f21
li 	$v0, 2
syscall



li 	$v0, 10
syscall