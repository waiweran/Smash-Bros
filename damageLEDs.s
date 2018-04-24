#First counter variable to turn high
# Upper bits
#addi $8 $0 3051
#sll $8 $8 12
# Lower bits
#addi $6 $8 3104
#Second counter variable to turn low
# Upper bits
#addi $8 $0 381
#sll $8 $8 16
# Lower bits
#addi $7 $8 30784
#bne $5 $6 1
#addi $23 $0 1

# CAUTION: This function overwrite ALL of reg23, not just the bits it uses
gameLoop:
addi $23 $23 0
# P1 (23[0])
addi $15 $15 0
# P2 (23[1])
addi $16 $16 0


bne $21 $0 2
# Zero code
addi $15 $0 0
j endLEDBranchOne
# Nonzero code
addi $15 $0 1
endLEDBranchOne:


bne $22 $0 2
# Zero code
addi $16 $0 0
j endLEDBranchTwo
# Nonzero code
addi $16 $0 1
endLEDBranchTwo:

#Shift into reg23
sll $16 $16 1
add $16 $16 $15
addi $23 $16 0

j gameLoop
