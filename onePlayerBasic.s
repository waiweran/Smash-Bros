# Assembulator Quirks:
# - No numbers in function names.
# - PC immediate works for jal/functions, but not for branching - must do it manually for branching.
# - If you write "functionName:" then on a newline write the next instruction, a nop will be inserted.
# - Comments cannot be on the same line as an instruction.


# --------Initialization--------
main: jal initCharacters
jal selectCharacter
jal initPlayerOne
#cannot use a number in function name!
# PRECONDITION: $r1 has mass, $r2 has width and height
#jal setupPlayerTwo

# --------Game loop------------
addi $r1 $r0 0
bne $r0 $r1 12
# Controller Coprocessor
lw $r2 4608($r0)
#address: 100100xxxxxxx

# Collision Coprocessor - for input: (gameControllerInputP1 or pos1? ask Nathaniel, assuming former now)
sw $r2 5632($r0)
# position, address: 1011000000000
lw $r4 5632($r0)
# collision_out, address: 101100xxxxxxx

# Physics Coprocessor
sw $r2 4112($r0)
# gameControllerInputP1, address: 1000000010000
sw $r4 4124($r0)
# collision_out, address: 1000000011100
lw $r6 4096($r0)
# pos1, address: 100000xxxxxxx

# VGA Coprocessor (display new image)
sw $r6 5120($r0)
# pos1, address: 1010000000000

# Check game termination condition

# --------- Game Termination----------
terminateGame: nop
#TODO once a player loses all health
# Probably need a signal here to tell the processor to stop cycling.
# Alternatively, could have an infinite loop here.

# initialize sizes of different characters, average size around 60X120
# stores mass in Mem[0] and width/height in Mem[1]
# TODO change the immediate values in here to bowser

# Kirby
# mass
initCharacters: addi $r1 $r0 16
sw $r1 0($r0)

# size
addi $r1 $r0 133
# width                    #Is this width and height right? (got it from player_size for collision constants)
sll $r1 $r1 16
# shift to top order
addi $r1 $r1 125
# height in bottom order
sw $r1 1($r0)

jr $r31

# load up sizes, for now just character 1
# Loads mass (Mem[0]) and width/height (Mem[1]) into $r1 and $r2

# player 1
selectCharacter: lw $r1 0($r0)
# mass
lw $r2 1($r0)
# size
# player 2
# lw $r3 0($r0)
# lw $r4 1($r0)

jr $r31

# initialize player constants
# Executes sw's to mmio addresses to load initial constants for the coprocessors
# Precondition: $r1 has mass, $r2 has width and height

#---------Physics-----------
# Mass
initPlayerOne: sw $r1 4096($r0)
# address: 1000000000000 #Precondition: $r1 has mass
# Gravity
addi $r5 $r0 65536
sw $r5 4100($r0)
#address: 1000000000100
# Wind Resistance
addi $r5 $r0 16
sw $r5 4104($r0)
# address: 1000000001000
# Position
addi $r5 $r0 352
# xpos
sll $r5 $r5 16
# shift to top order
addi $r5 $r5 250
# ypos in bottom order
sw $r5 4108($r0)
# address: 1000000001100

# Controller
addi $r5 $r0 0
sw $r5 4112($r0)
# address: 1000000010000

# Knockback
addi $r5 $r0 0
sw $r5 4116($r0)
# address: 1000000010100

# Attack
addi $r5 $r0 0
sw $r5 4120($r0)
# address: 1000000011000

# Collision
addi $r5 $r0 0
# address: 1000000011100
sw $r5 4124($r0)

#-----------Controller----------
#no constants!

#----------Collision-------------
#Player size
sw $r2 5636($r0)
# address: 1011000000100 #PRECONDITION: $r2 contains player size!

#Stage position
addi $r5 $r0 323
# address: 1011000001000
sll $r5 $r5 16
addi $r5 $r0 20
sw $r5 5640($r0)

#Stage size
addi $r5 $r0 506
# address: 1011000001100
sll $r5 $r5 16
addi $r5 $r0 200
sw $r5 5644($r0)

#----------VGA--------------------
#whP1InVGA      # address: 1010000000100 #PRECONDITION: $r2 contains player size!
sw $r2 5124($r0)

#posStageInVGA - TODO will likely remove later
addi $r5 $r0 323
# address: 1010100000000
sll $r5 $r5 16
addi $r5 $r0 20
sw $r5 5376($r0)

#whStageInVGA - TODO will likely remove later
addi $r5 $r0 506
# address: 1010100000100
sll $r5 $r5 16
addi $r5 $r0 200
sw $r5 5380($r0)

# Controller, Collision have iniital input parameters that are not constant and
# will be set in game loop; for now, set those parameters to 0

jr $r31


# Mass
initPlayerTwo: sw $r3 4224($r0)
 # address: 1000010000000
# Gravity
addi $r5 $r0 98
addi $r6 $r0 10
div $r5 $r5 $r6 # gravity
sw $r5 4228($r0)
# address: 1000010000100
# Wind
addi $r5 $r0 10
sw $r5 4232($r0)
# address: 1000010001000
# Position
addi $r5 $r0 440
# x position of right edge
sra $r6 $r2 16
# shift player 1 size to get width
sub $r5 $r5 $r6
# xpos
sll $r5 $r5 16
# shift xpos to top order
addi $r5 $r5 300
# ypos in bottom order
sw $r5 4236($r0)
# address: 1000010001100

# Controller
# TODO finish this function when necessary

# Knockback

# Attack

# Collision
jr $r31
