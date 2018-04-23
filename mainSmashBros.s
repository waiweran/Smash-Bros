# Assembulator Quirks:
# - No numbers in function names.
# - PC immediate works for jal/functions, but not for branching - must do it manually for branching.
# - If you write "functionName:" then on a newline write the next instruction, a nop will be inserted.
# - Comments cannot be on the same line as an instruction.
#
# Special Registers
# - $23 = LED/Rumble Output
# - $24 = Damage P1
# - $25 = Damage P2
# - $26 = Size P1
# - $27 = Size P2
# - $28 = Lives P1
# - $29 = Lives P2
# - $30 = Exceptions that we shouldn't use
# - $31 = Return Address
#
# Other Registers
# - $2. $3, $4 = Stage Boundaries for Death
# - $5 is the counter for LEDs

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
lw $1 7168($0)
add $24 $24 $1

# damage to P2
lw $1 7296($0)
add $25 $25 $1

j loop

checkpOne:
# Pos P1
lw $11 4096($0)
# xpos
sra $6 $11 16
# ypos
sll $7 $11 16
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
lw $8 4224($0)

# xpos
sra $9 $8 16
# ypos
sll $10 $8 16
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
sub $28 $28 $1
j doneOne

# decrease lives P2
dieTwo:
sub $29 $29 $1
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
addi $8 $0 3051
sll $8 $8 12
# Lower bits
addi $7 $8 6208
bne $5 $6 1
addi $23 $0 1

bne $5 $7 2
addi $23 $0 0
addi $5 $0 0

addi $5 $5 1

nop
nop
jr $31
