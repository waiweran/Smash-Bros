# Assembulator Quirks:
# - No numbers in function names.
# - PC immediate works for jal/functions, but not for branching - must do it manually for branching.
# - If you write "functionName:" then on a newline write the next instruction, a nop will be inserted.
# - Comments cannot be on the same line as an instruction.

main: nop
nop
jal initializeConstants
j loop

# Loads constants from dmem and puts them in the special registers
# Mass P1
initializeConstants: lw $24 0($0)
# Mass P2
lw $25 1($0)

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

jr $31

loop: nop
nop
nop
nop
j loop
