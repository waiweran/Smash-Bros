# Assembulator Quirks:
# - No numbers in function names.
# - PC immediate works for jal/functions, but not for branching - must do it manually for branching.
# - If you write "functionName:" then on a newline write the next instruction, a nop will be inserted.
# - Comments cannot be on the same line as an instruction.

main:
nop
nop
jal initializeConstants
j loop

# Loads constants from dmem and puts them in the special registers
# Mass P1
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

jr $31

loop:
jal checkpOne
jal checkpTwo

# damage to P1
lw $1 7168($0)
add $24 $24 $1

# damage to P2
lw $1 7296($0)
add $25 $25 $1

j loop

checkpOne:
# Pos P1
lw $5 4096($0)
# xpos
sra $6 $5 16
# ypos
sll $7 $5 16
sra $7 $7 16

# if out of left bound
blt $6 $2 54
# if out of right bound
blt $4 $6 54
# if out of bottom bound
blt $7 $0 54
# if out of top bound
blt $3 $7 54

doneOne:
jr $31

checkpTwo:
# Pos P1
lw $8 4224($0)
# xpos
sra $9 $8 16
# ypos
sll $10 $8 16
sra $10 $10 16

# if out of left bound
blt $9 $2 57
# if out of right bound
blt $4 $9 57
# if out of bottom bound
blt $10 $0 57
# if out of top bound
blt $3 $10 57

doneTwo:
jr $31

dieOne:
# decrease lives P1
sub $28 $28 $1
j doneOne

dieTwo:
# decrease lives P2
sub $29 $29 $1
j doneTwo
