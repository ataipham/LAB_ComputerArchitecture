.data
board:      .space 225           # 15x15 board
head: .asciiz "   0   1   2   3   4   5   6   7   8   9   10  11  12  13  14\n\n"
x_char:     .byte 'X'
o_char:     .byte 'O'
empty_char: .byte '.'
newline:    .asciiz "\n"
comma:      .asciiz ","
prompt1:    .asciiz "Player 1, please input your coordinates(x,y): "
prompt2:    .asciiz "Player 2, please input your coordinates(x,y): "
out_of_range: .asciiz "Invalid input: coordinates must be from 0 to 14.\n"
invalid:    .asciiz "Invalid input. Please enter coordinates again (x,y).\n"
occupied: .asciiz "Cell already occupied. Select a different position.\n"
win1:       .asciiz "Player 1 wins\n"
win2:       .asciiz "Player 2 wins\n"
tie_msg:    .asciiz "Tie\n"
result_file: .asciiz "result.txt"
space:      .byte ' '
buffer:     .space 20
playagain:  .asciiz "Play again ? Y or N"

.text
.globl main
main:
    li $t0, 0
    #li $t3, 225
init_board:
    la $t1, board #t1 stores base address of board[225]
    add $t1, $t1, $t0 # t1 is position of that element in board[225]
    lb $t2, empty_char # t2 = '.'
    sb $t2, 0($t1)
    addi $t0, $t0, 1
    li $t3, 225
    blt $t0, $t3, init_board

    li $s0, 0          # player turn: 0=Player1, 1=Player2
    li $s1, 0          # move count

game_loop:
    jal print_board
game_without_init:
    beq $s0, 0, prompt_player1
    j prompt_player2

prompt_player1:
    li $v0, 4
    la $a0, prompt1
    syscall
    li $a2, 1 # ?
    j input_coords
prompt_player2:
    li $v0, 4
    la $a0, prompt2
    syscall
    li $a2, 2

input_coords:
    li $v0, 8
    la $a0, buffer #buffer = inputting r,c
    li $a1, 10
    syscall

    la $t0, buffer
    li $t1, 0
parse_x:
    lb $t2, 0($t0)
    beq $t2, ',', parse_y
    beqz $t2, invalid_input #t2 == '\0' => terminate
    sub $t2, $t2, 48
    blt $t2, 0, invalid_input
    bgt $t2, 9, invalid_input
    mul $t1, $t1, 10
    add $t1, $t1, $t2 # t1 = r
    addi $t0, $t0, 1
    j parse_x

parse_y:
    addi $t0, $t0, 1
    li 	$t3, 0
parse_y_loop:
    lb 	$t2, 0($t0)
    beqz $t2, end_parse # t2 = '\0' => terminate
    li  $t4, 10
    beq $t2, $t4, end_parse # when parsing y, when it encounter 10 (\n) => stop parsing
    sub $t2, $t2, 48
    blt $t2, 0, invalid_input
    bgt $t2, 9, invalid_input
    mul $t3, $t3, 10
    add $t3, $t3, $t2
    addi $t0, $t0, 1
    j parse_y_loop
end_parse:
    #li $t4, 14
    bgt $t1, 14, invalid_input_out_of_range
    #bgt $t1, $t4, invalid_input
    bgt $t3, 14, invalid_input_out_of_range
    #bgt $t3, $t4, invalid_input

    mul $t5, $t1, 15 #index = row($t1) * 15 + col ($t3)
    add $t5, $t5, $t3
    la $t6, board
    add $t6, $t6, $t5
    lb $t7, 0($t6)
    lb $t8, empty_char
    #if the current (r,c) is empty ( == '.')
    bne $t7, $t8, invalid_occupied # else => invalid input (occupied)
    li $t9, 1
    beq $a2, $t9, mark_x
    lb $t7, o_char
    j mark_done
mark_x:
    lb $t7, x_char
mark_done:
    sb $t7, 0($t6) # board[0($t6)] = X or Y

    move $a0, $t1  # a0 = r (t1)
    move $a1, $t3  # a1 = c (t3)
    move $a2, $s0  #a2 = player1 or player2
    jal check_win
    bnez $v0, winner

    addi $s1, $s1, 1
    li $t0, 225 #check_tie
    beq $s1, $t0, tie_game

    xori $s0, $s0, 1
    j game_loop

invalid_input:
    li $v0, 4
    la $a0, invalid
    syscall
    j game_without_init

invalid_input_out_of_range:
    li $v0, 4
    la $a0, out_of_range
    syscall
    j game_without_init
invalid_occupied:
    li $v0, 4
    la $a0, occupied
    syscall
    j game_without_init
winner:
jal print_board
    li $v0, 4
    beq $s0, 0, win_p1
    la $a0, win2
    j after_result
win_p1:
    la $a0, win1
after_result:
    syscall

    move $a3, $s0
    #######adding
restart:
    jal save_result
    la $a0, playagain
    li $v0, 4
    syscall
    
    la $a0, newline
    li $v0, 4
    syscall
    
    li $v0, 12
    syscall
    bne $v0, 'Y', exitGame
    
    la $a0, newline
    li $v0, 4
    syscall
    j main
    
    exitGame:
    ######
    jal save_result
    li $v0, 10
    syscall

tie_game:
    la $a0, tie_msg
    li $v0, 4
    
    syscall
    li $a3, 3
    jal save_result
    j restart
    
    
    
    
    #li $v0, 10
    #syscall

print_board:

    li $t0, 0 # row = 0;
    li $v0, 4
    la $a0, head
    syscall

print_rows:
    li $t1, 0 # col = 0;

    # In số dòng (row index)
    move $a0, $t0       # Đưa row index vào $a0
    li $v0, 1           # syscall code 1 = print_int
    syscall

    # In dấu cách sau số dòng
    li $t7, 10
    li $v0, 11
    blt $t0, $t7, printTwoSpace
    lb $a0, space
    syscall
    j print_cols
printTwoSpace:
    lb $a0, space
    syscall
    li $v0, 11
    lb $a0, space 
    syscall
    
    
print_cols:
    mul $t2, $t0, 15    # t2 = row * 15
    add $t2, $t2, $t1   # t2 = t2 + col => offset phần tử board[row][col]
    la $t3, board
    add $t3, $t3, $t2
    lb $a0, 0($t3)

    li $v0, 11
    syscall

    li $v0, 11
    lb $a0, space
    syscall
    
    li $v0, 11
    lb $a0, space
    syscall
    
    li $v0, 11
    lb $a0, space
    syscall

    addi $t1, $t1, 1
    li $t4, 15
    blt $t1, $t4, print_cols

    li $v0, 4
    la $a0, newline
    syscall
    
    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1
    blt $t0, $t4, print_rows
    jr $ra


check_win:
    addi $sp, $sp, -16
    sw $ra, 0($sp)
    sw $a0, 4($sp) # a0 = r
    sw $a1, 8($sp) # a1 = c
    sw $a2, 12($sp) # a2 = which player

    #li $t0, 0
    beq $a2, $zero, get_x_char # a2 == 0=> player 1
    lb $s7, o_char
    j directions
    
get_x_char:
    lb $s7, x_char

directions:
    li $t0, 0 #(0,1) => check horizontally
    li $t1, 1
    jal check_line
    bnez $v0, win_found # v0 != 0 => win_found
    
    li $t0, 1 #(1,0) => check vertically
    li $t1, 0
    jal check_line
    bnez $v0, win_found
    
    li $t0, 1 #(1,1) => check diagonally (down-right)
    li $t1, 1
    jal check_line
    bnez $v0, win_found
    
    li $t0, 1 #(1, -1) => check diagonally (down-left)
    li $t1, -1
    jal check_line
    bnez $v0, win_found

    li $v0, 0
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra
win_found:
    li $v0, 1
    lw $ra, 0($sp)
    addi $sp, $sp, 16
    jr $ra

check_line:
    li $t2, 1 # t2 to check if it's consecutive 5
    lw $t3, 4($sp) # t3 = a0 = r
    lw $t4, 8($sp) # t4 = a1 = c

    li $t5, 1 # k to count 1,2,3,4 => to get new r and new c
    
forward_loop:
    mul $t6, $t5, $t0 # t6 = k * delta r
    add $t7, $t3, $t6 # t7 = k*delta r + r (new r)
    mul $t6, $t5, $t1 # t6 = k * delta c
    add $t8, $t4, $t6 # t8 = k * delta c + c
    blt $t7, 0, forward_done  # new r >= 0 && new r <= 14
    bgt $t7, 14, forward_done # if not => foward_done
    blt $t8, 0, forward_done  # new c >= 0 && new c <= 14
    bgt $t8, 14, forward_done # if not => foward done
    mul $t9, $t7, 15	# if the new r is valid => get its position in board[225] = 15* new r
    add $t9, $t9, $t8	# get the exact position at column new c => 15* new r + new c
    la $a0, board
    add $a0, $a0, $t9 
    lb $a1, 0($a0) # get value in board[225] => a1
    bne $a1, $s7, forward_done #=> consecutive is not the same (only equals to X or equals to O) => foward_done
    addi $t2, $t2, 1 # if yes, t2++ (if t2 == 5 => wins)
    addi $t5, $t5, 1 # k++
    j forward_loop
forward_done:

    li $t5, 1
backward_loop:
    mul $t6, $t5, $t0 # t6 = k * delta r
    sub $t7, $t3, $t6 # t7 = k * delta r - r (new r)
    mul $t6, $t5, $t1 # t6 = k * delta c 
    sub $t8, $t4, $t6 # t8 = k * delta c - c
    blt $t7, 0, back_done  # new r < 0 => false
    bgt $t7, 14, back_done # new r > 14 => false
    blt $t8, 0, back_done  # new c < 0 => false
    bgt $t8, 14, back_done # new c > 14 => false
    mul $t9, $t7, 15	# t9 = new r * 15
    add $t9, $t9, $t8	# t9 = new r * 15 + new c => exact position of (new r, new c) in board[225]
    la $a0, board
    add $a0, $a0, $t9
    lb $a1, 0($a0)
    bne $a1, $s7, back_done # if board[t9] == X or O => continue
    addi $t2, $t2, 1 	   # else back_done
    # t2++ => to check consecutive 5
    addi $t5, $t5, 1 # k++
    j backward_loop
back_done:
    li $v0, 0
    li $t6, 5
    bge $t2, $t6, five_found # t2 == 5 => consecutive 5 found
    jr $ra
five_found:
    li $v0, 1 #v0 = 1
    jr $ra

save_result:
    # Mở file result.txt để ghi
    li $v0, 13              # syscall: open
    la $a0, result_file     # Đường dẫn file
    li $a1, 1            # Chế độ ghi (O_WRONLY | O_CREAT | O_TRUNC)
    li $a2, 0            # Quyền (RW-R--R--)
    syscall
    move $s6, $v0           # Lưu descriptor của file vào $s6

    # Ghi bảng kết quả vào file
    li $t0, 0                # Bắt đầu từ dòng đầu tiên
save_rows:
    li $t1, 0
save_cols:
    mul $t2, $t0, 15        # t2 = row * 15
    add $t2, $t2, $t1       # t2 = t2 + col => tính offset phần tử board[row][col]
    la  $t3, board          # t3 = địa chỉ base của board
    add $t3, $t3, $t2       # t3 = địa chỉ phần tử cụ thể board[row][col]

    li   $v0, 15            # syscall: write to file
    move $a0, $s6           # file descriptor
    move $a1, $t3           # địa chỉ dữ liệu cần ghi (1 byte)
    li   $a2, 1             # số byte cần ghi
    syscall

    addi $t1, $t1, 1
    li $t4, 15
    blt $t1, $t4, save_cols

    # Ghi newline sau mỗi dòng
    li $v0, 15              # syscall: write
    move $a0, $s6           # File descriptor
    la $a1, newline         # Dòng mới
    li $a2, 1               # Số byte cần ghi
    syscall

    addi $t0, $t0, 1
    li $t4, 15
    blt $t0, $t4, save_rows

    # Ghi thông báo kết quả vào file (Win hoặc Tie)
    li $v0, 15              # syscall: write
    move $a0, $s6           # File descriptor
    beq $a3, 0, win_p12     # Player 1 won
    beq $a3, 1, win_p22      # Player 2 won
    la $a1, tie_msg         # Tie message
    li $a2, 4               # Số byte của thông điệp Tie
    syscall
    j done_save_result

win_p12:
    la $a1, win1            # Player 1 wins message
    li $a2, 13              # Số byte của thông điệp Player 1 wins
    syscall
    j done_save_result

win_p22:
    la $a1, win2            # Player 2 wins message
    li $a2, 13              # Số byte của thông điệp Player 2 wins
    syscall

done_save_result:
    # Đóng file sau khi ghi
    li $v0, 16              # syscall: close
    move $a0, $s6           # File descriptor
    syscall

    # Kết thúc chương trình
   jr $ra
   
   
