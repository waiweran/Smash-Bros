# Assembulator Quirks:
# - No numbers in function names.
# - PC immediate works for jal/functions, but not for branching - must do it manually for branching.
# - If you write "functionName:" then on a newline write the next instruction, a nop will be inserted.
# - Comments cannot be on the same line as an instruction.
# - Do not write the dollar sign or equals sign in a comment and do not write it in code unless actually calling a register.


main:
nop
nop
jal initializeConstants
nop
nop
j loop

# Loads constants from dmem and puts them in the special registers
# Registers:
initializeConstants:
#Damage to P1
addi $24 $0 0

#Damage to P2
addi $25 $0 0

# Size P1
lw $1 2($0)
sll $1 $1 16
lw $2 3($0)
add $1 $1 $2
addi $26 $1 0

#Size P2
lw $1 4($0)
sll $1 $1 16
lw $2 5($0)
add $1 $1 $2
addi $27 $1 0

#Lives P1
lw $28 0($0)

#Lives P2
lw $29 0($0)

# left boundary (since left start is 256 off the screen, 56 is 200 off the screen)
addi $2 $0 56
# top boundary
addi $3 $0 680
# right boundary
addi $4 $0 880
# bottom boundary just 0

# $5 is the counter
addi $5 $5 0

nop
nop
jr $31

loop:
nop
nop
jal checkpOne
nop
nop
jal checkpTwo
nop
nop
jal blinkLEDs
nop
nop

# damage to P1
bne $21 $15 1
j afterAddOne
add $24 $24 $21
afterAddOne:
add $15 $21 $0

# damage to P2
bne $22 $16 1
j afterAddTwo
add $25 $25 $22
afterAddTwo:
add $16 $22 $0

j loop

checkpOne:
# Pos P1
# xpos
sra $6 $19 16
# ypos
sll $7 $19 16
sra $7 $7 16

# if out of left bound
blt $6 $2 18
# if out of right bound
blt $4 $6 17
# if out of bottom bound
blt $7 $0 16
# if out of top bound
blt $3 $7 15

doneOne:
nop
jr $31

 # Pos P1
checkpTwo:
# xpos
sra $9 $20 16
# ypos
sll $10 $20 16
sra $10 $10 16

# if out of left bound
blt $9 $2 9
# if out of right bound
blt $4 $9 8
# if out of bottom bound
blt $10 $0 7
# if out of top bound
blt $3 $10 6

doneTwo:
nop
jr $31

# decrease lives P1
dieOne:
sra $28 $28 1
j doneOne

# decrease lives P2
dieTwo:
sra $29 $29 1
j doneTwo




blinkLEDs:
#First counter variable to turn high
# Upper bits
addi $8 $0 3051
sll $8 $8 12
# Lower bits
addi $6 $8 3104
#Second counter variable to turn low
# Upper bits
addi $8 $0 381
sll $8 $8 16
# Lower bits
addi $7 $8 30784
bne $5 $6 1
addi $23 $0 1

bne $5 $7 2
addi $23 $0 0
addi $5 $0 0

addi $5 $5 1

nop
nop
jr $31
