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
lw $29 1($0)

# left boundary (since left start is 256 off the screen, 56 is 200 off the screen)
addi $2 $0 56
# top boundary
addi $3 $0 680
# right boundary
addi $4 $0 1096
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
blt $6 $2 6
# if out of right bound
blt $4 $6 5
# if out of bottom bound
blt $7 $0 4
# if out of top bound
blt $3 $7 3

doneOne:
nop
jr $31

# decrease lives P1
dieOne:
addi $7 $0 1
sll $8 $7 19
nop
nop
addi $7 $7 1
nop
nop
nop
blt $7 $8 -6
nop
sra $28 $28 1
addi $24 $0 0
bne $28 $0 1
j gameEndOne
nop
addi $23 $23 4
addi $7 $0 1
sll $8 $7 20
nop
nop
addi $7 $7 1
nop
nop
nop
blt $7 $8 -6
nop
nop
addi $23 $23 -4

j doneOne

 # Pos P2
checkpTwo:
# xpos
sra $9 $20 16
# ypos
sll $10 $20 16
sra $10 $10 16

# if out of left bound
blt $9 $2 6
# if out of right bound
blt $4 $9 5
# if out of bottom bound
blt $10 $0 4
# if out of top bound
blt $3 $10 3

doneTwo:
nop
jr $31

# decrease lives P2
dieTwo:
addi $7 $0 1
sll $8 $7 19
nop
nop
addi $7 $7 1
nop
nop
nop
blt $7 $8 -6
nop
sra $29 $29 1
addi $25 $0 0
bne $29 $0 1
j gameEndTwo
nop
addi $23 $23 8
addi $7 $0 1
sll $8 $7 20
nop
nop
addi $7 $7 1
nop
nop
nop
blt $7 $8 -6
nop
nop
addi $23 $23 -8

j doneTwo

gameEndTwo:
lw $24 10($0)
lw $25 11($0)
addi $24 $24 1
sw $24 10($0)
j gameEnd

gameEndOne:
lw $24 10($0)
lw $25 11($0)
addi $25 $25 1
sw $25 11($0)

gameEnd:
nop
nop
nop
nop
j gameEnd

blinkLEDs:
addi $23 $23 0
# P1 (23[0])
addi $7 $7 0
# P2 (23[1])
addi $8 $8 0

bne $21 $0 2
# Zero code
addi $7 $0 0
j endLEDBranchOne
# Nonzero code
addi $7 $0 1
endLEDBranchOne:

bne $22 $0 2
# Zero code
addi $8 $0 0
j endLEDBranchTwo
# Nonzero code
addi $8 $0 1
endLEDBranchTwo:

#Shift into reg23
sll $8 $8 1
add $8 $8 $7
addi $23 $8 0

jr $31
