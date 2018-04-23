# Assembulator Quirks:
# - No numbers in function names.
# - PC immediate works for jal/functions, but not for branching - must do it manually for branching.
# - If you write "functionName:" then on a newline write the next instruction, a nop will be inserted.
# - Comments cannot be on the same line as an instruction.

main: nop
nop

# $5 is the counter
addi $5 $5 0
#First counter variable to turn high
# Upper bits
addi $4 $0 3051
sll $4 $4 12
# Lower bits
addi $6 $4 3104
#Second counter variable to turn low
# Upper bits
addi $4 $0 3051
sll $4 $4 12
# Lower bits
addi $7 $4 6208
gameLoop: bne $5 $6 1
addi $23 $0 1

bne $5 $7 2
addi $23 $0 0
addi $5 $0 0

addi $5 $5 1

j gameLoop
