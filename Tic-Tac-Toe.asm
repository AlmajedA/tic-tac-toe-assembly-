# Title:  Tic-Tac-Toe	Filename:  Tic-Tac-Toe.asm
# Author: Ammar Almajed			Date: 3/4/2022
# Description: this program allows you to play Tic-Tac-Toe with your friends :)
# Input: integers from 1 to 9
# Output: board with X or O

.data
col: .asciiz " | "
divider: .asciiz "\n-----------\n"
player1: .asciiz "Player 1, Enter a square from 1 to 9: "
player2: .asciiz "Player 2, Enter a square from 1 to 9: "
newLine: .asciiz "\n"
outOfRange: .asciiz "Invalid square! "
alreadyUsed: .asciiz "Square is already used! "
player1Won: .asciiz "Player 1 WINS\n"
player2Won: .asciiz "Player 2 WINS\n"
draw: .asciiz "DRAW!!! no one wins\n"

.text

main:

#creating array to save the X and O position
li $a0, 9 # allocates 9 bytes
li $v0, 9
syscall
move $s0, $v0 # $s0 is the array
# this loop is just to fill the array with blanks
li $t0, 9
fillBlanks:
li $t1, ' '
sb $t1, 0($s0)
addi $s0, $s0, 1
addi $t0, $t0, -1
bnez $t0, fillBlanks

move $s0, $v0 # reset $s0
move $a0, $s0 # $a0 is a parameter
jal board


# t5 to control the while true loop
li $t5, 0
# while no one wins 
whileTrue:
# =====================Player1 inside the while loop======================
whileNotValidPlayer1: # this loop is to check the validity of the input (if between 1:9 and if not used)
la $a0, player1
li $v0, 4
syscall

li $v0, 5
syscall
# check if not between 1 and 9
blt $v0, 1, notValidMassagePlayer1
bgt $v0, 9, notValidMassagePlayer1
# if false (between 1 and 9) then valid
j validPlayer1

#if true (not between 1 and 9) then ask again
notValidMassagePlayer1:
la $a0, outOfRange
li $v0, 4
syscall
j whileNotValidPlayer1

validPlayer1:

addi $v0, $v0, -1 # since indexing start from 0 but our range is from 1 to 9 I will simply add -1 to $v0
add $t7, $s0, $v0
# check if the posision is not used
lb $t4, 0($t7)
beq $t4, ' ', notUsedPlayer1 # branch if it is black
la $a0, alreadyUsed
li $v0, 4
syscall
j whileNotValidPlayer1 # ask again if it is used

notUsedPlayer1:
li $t6, 'X'
sb $t6, 0($t7)

move $a0, $s0 # $a0 is a parameter
jal board

# $a0 is a parameter to the function isWin
move $a0, $s0
jal isWin
bne $v0, 2001, contnue  # 2001 indicate that the player wins
la $a0, player1Won
li $v0, 4
syscall
j existWhileLoop
contnue:

addi $t5, $t5, 1 # increment by one (one move)
bne $t5, 9, doNotExistWhileLoop # finish if we reached 9 moves
la $a0, draw
li $v0, 4
syscall
j existWhileLoop
doNotExistWhileLoop:
#=====================Player2 inside the while loop======================
whileNotValidPlayer2: # this loop is to check the validity of the input (if between 1:9 and if not used)
la $a0, player2
li $v0, 4
syscall

li $v0, 5
syscall

# check if not between 1 and 9
blt $v0, 1, notValidMassagePlayer2
bgt $v0, 9, notValidMassagePlayer2
# if false (between 1 and 9) then valid
j validPlayer2

#if true (not between 1 and 9) then ask again
notValidMassagePlayer2:
la $a0, outOfRange
li $v0, 4
syscall
j whileNotValidPlayer2

validPlayer2:

addi $v0, $v0, -1 # since indexing start from 0 but our range is from 1 to 9 I will simply add -1 to $v0
add $t7, $s0, $v0
# check if the posision is not used
lb $t4, 0($t7)
beq $t4, ' ', notUsedPlayer2 # branch if it is blank
la $a0, alreadyUsed
li $v0, 4
syscall
j whileNotValidPlayer2 # ask again if it is used

notUsedPlayer2:
li $t6, 'O'
sb $t6, 0($t7)

move $a0, $s0 # $a0 is a parameter
jal board

# $a0 is a parameter to the function isWin
move $a0, $s0
jal isWin
bne $v0, 2001, contnue2 # 2001 indicate that the player wins
la $a0, player2Won
li $v0, 4
syscall
j existWhileLoop

contnue2:


addi $t5, $t5, 1 # increment by one (one move)

j whileTrue

existWhileLoop:

li $v0, 10
syscall

# board function (function to print the board)
# the idea of this function is to take $a0 as a parameter which is the list containing X and O
# and place the first element is the list and then place the character " | " and then place the 
# second element and then place " | " again and place the third one all of this are done 
# in the inner loop except the first one done in the outer loop and print the divider in the outer loop.
# parameters: $a0
# results: no results
board:
# move the address to $s1
move $s1, $a0 

# loop to print board
# $t0 to control (outerLoop)
li $t0, 3
outerLoop:

lb $a0, 0($s1)
li $v0, 11
syscall

# $t2 to control (innerLoop)
li $t2, 2
innerLoop: 
addi $s1, $s1, 1

la $a0, col
li $v0, 4
syscall

lb $a0, 0($s1)
li $v0, 11
syscall

addi $t2, $t2, -1
bnez $t2, innerLoop

addi $s1, $s1, 1

# this line is just to skip the last divider
beq  $t0, 1, exist 

la $a0, divider
li $v0, 4
syscall


addi $t0, $t0, -1
bnez $t0, outerLoop

exist:

la $a0, newLine
li $v0, 4
syscall
jr $ra #return to the caller

# isWin Function 
# the way it works:
# it takes $a0 as a parameter (which is a list containing X or O) and the variable $s2 which is the same
# list but I used it because I want to change it but I do not want to change $a0 because I want
# reset $s2. $s2 is used to get the variable from it. $t0, $t1, and $t2 if they are equal and not
# equal to ' ' (space) means that the player wins. I used a loop to check rows and another loop to check
# colums and I checked diagonals manually. the function return 2001 if there is a winner and 2022 if there 
# is not.
# parameters: $a0 (a list)
# results: $v0 (winner: 2001, no winner: 2022)
isWin:
move $s2, $a0
#check rows
li $t3, 3
rowsChecker:
lb $t0, 0($s2)
lb $t1, 1($s2)
lb $t2, 2($s2)
addi $s2, $s2, 3
addi $t3, $t3, -1
beqz $t3, noWinnerRows
bne $t0, $t1, rowsChecker
bne $t0, $t2, rowsChecker
beq $t0, ' ', rowsChecker
li $v0, 2001
jr $ra #return to the caller

noWinnerRows:

move $s2, $a0 # reset $s2
#check colums
li $t3, 3
colsChecker:
lb $t0, 0($s2)
lb $t1, 3($s2)
lb $t2, 6($s2)
addi $s2, $s2, 1
addi $t3, $t3, -1
beqz $t3, noWinnerCols
bne $t0, $t1, colsChecker
bne $t0, $t2, colsChecker
beq $t0, ' ', colsChecker
li $v0, 2001
jr $ra #return to the caller

noWinnerCols:

move $s2, $a0 # reset $s2
# check diagonals

# first diagonal
lb $t0, 0($s2)
lb $t1, 4($s2)
lb $t2, 8($s2)
bne $t0, $t1, noWinnerDiag1
bne $t0, $t2, noWinnerDiag1
beq $t0, ' ', noWinnerDiag1
li $v0, 2001
jr $ra #return to the caller

noWinnerDiag1:
move $s2, $a0 # reset $s2
# second diagonal
lb $t0, 2($s2)
lb $t1, 4($s2)
lb $t2, 6($s2)
bne $t0, $t1, noWinnerDiag2
bne $t0, $t2, noWinnerDiag2
beq $t0, ' ', noWinnerDiag2
li $v0, 2001
jr $ra #return to the caller

noWinnerDiag2:
li $v0, 2022
jr $ra #return to the caller

