# Assembulator Quirks:
# - No numbers in function names.
# - PC immediate works for jal/functions, but not for branching - must do it manually for branching.
# - If you write "functionName:" then on a newline write the next instruction, a nop will be inserted.
# - Comments cannot be on the same line as an instruction.


# --------Initialization--------
main: jal initCharacters
jal selectCharacter
# PRECONDITION: $r1 = P1 mass, $r2 = P1 size,
jal initPlayerOne
# PRECONDITION: $r3 = P2 mass, $r4 = P2 size
jal initPlayerTwo

# --------Game loop------------
addi $r1 $r0 0
bne $r0 $r1 ___TODO NEED UPDATE___
# Controller Coprocessor, P1
lw $r2 4608($r0)
#address: 100100xxxxxxx

# Controller Coprocessor, P2
lw $r3 4736($r0)
#address: 100101xxxxxxx

# $r2 = gameControllerInputP1, $r3 = gameControllerInputP2

# Collision Coprocessor, P1 - for input: (gameControllerInputP1 or pos1? ask Nathaniel, assuming former now)
sw $r2 5632($r0)
# position, address: 1011000000000
lw $r4 5632($r0)
# collision_out, address: 101100xxxxxxx

# Collision Coprocessor, P2
# position, address: 1011010000000
sw $r3 5760($r0)
# collision_out, address: 101101xxxxxxx
lw $r5 5760($r0)

# $r4 = collision_out, p1; $r5 = collision_out, p2

# Physics Coprocessor, P1
sw $r2 4112($r0)
# gameControllerInputP1, address: 1000000010000
sw $r4 4124($r0)
# collision_out, address: 1000000011100
lw $r6 4096($r0)
# pos1, address: 100000xxxxxxx

# Physics Coprocessor, P2
sw $r3 4240($r0)
# gameControllerInputP2, address: 1000010010000
sw $r5 4252($r0)
# collision_out, address: 1000010011100
lw $r7 4224($r0)
# pos2, address: 100001xxxxxxx

# $r6 = pos1, $r7 = pos2

# VGA Coprocessor (display new image)
sw $r6 5120($r0)
# pos1, address: 1010000000000
sw $r7 5376($r0)
# pos2, address: 1010100000000

# Check game termination condition

# --------- Game Termination----------
terminateGame: nop
#TODO once a player loses all health
# Probably need a signal here to tell the processor to stop cycling.
# Alternatively, could have an infinite loop here.


# ---------------------------------------------------------
# ---------------------FUNCTIONS---------------------------
# ---------------------------------------------------------


# initialize sizes of different characters, average size around 60X120
# stores: Mem[0] = P1 mass, Mem[1] = P1 size, Mem[2] = P2 mass, Mem[3] = P2 size

# Bowser - Player 1
# mass
initCharacters: addi $r1 $r0 16
sw $r1 0($r0)

# size
addi $r1 $r0 133
# width                    #TODO Is this width and height right? (got it from player_size for collision constants)
sll $r1 $r1 16
# shift to top order
addi $r1 $r1 125
# height in bottom order
sw $r1 1($r0)

# ______ - Player 2
# mass
addi $r1 $r0 ____P2 MASS HERE____  #TODO
sw $r1 2($r0)

# size
addi $r1 $r0 ___P2 WIDTH HERE____  #TODO
# width                    #TODO Is this width and height right? (got it from player_size for collision constants)
sll $r1 $r1 16
# shift to top order
addi $r1 $r1 ____P2 HEIGHT HERE____  #TODO
# height in bottom order
sw $r1 3($r0)

jr $r31

# load up sizes, for now just character 1
# Loads Mem[0] into $r1, Mem[1] into $r2, Mem[2] into $r3, Mem[3] into $r4

# player 1
# mass
selectCharacter: lw $r1 0($r0)
# size
lw $r2 1($r0)
# player 2
# mass
lw $r3 3($r0)
# size
lw $r4 4($r0)

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

# initialize player constants
# Executes sw's to mmio addresses to load initial constants for the coprocessors
# Precondition: $r3 has mass, $r4 has width and height (for P2)

#---------Physics-----------
# Mass
initPlayerTwo: sw $r3 4224($r0)
# address: 1000010000000 #Precondition: $r3 has mass (p2)
# Gravity
addi $r5 $r0 65536
sw $r5 4228($r0)
#address: 1000010000100
# Wind Resistance
addi $r5 $r0 16
sw $r5 4232($r0)
# address: 1000010001000
# Position
addi $r5 $r0 425
# xpos
sll $r5 $r5 16
# shift to top order
addi $r5 $r5 250
# ypos in bottom order
sw $r5 4236($r0)
# address: 1000010001100

# Controller
addi $r5 $r0 0
sw $r5 4240($r0)
# address: 1000010010000

# Knockback
addi $r5 $r0 0
sw $r5 4244($r0)
# address: 1000010010100

# Attack
addi $r5 $r0 0
sw $r5 4248($r0)
# address: 1000010011000

# Collision
addi $r5 $r0 0
# address: 1000010011100
sw $r5 4252($r0)

#-----------Controller----------
#no constants!

#----------Collision-------------
#Player size
sw $r4 5764($r0)
# address: 1011010000100 #PRECONDITION: $r4 contains player size! (for p2)

#Stage position
addi $r5 $r0 323
# address: 1011010001000
sll $r5 $r5 16
addi $r5 $r0 20
sw $r5 5768($r0)

#Stage size
addi $r5 $r0 506
# address: 1011010001100
sll $r5 $r5 16
addi $r5 $r0 200
sw $r5 5772($r0)

#----------VGA--------------------
#whP2InVGA      # address: 1010010000100 #PRECONDITION: $r4 contains player size! (for p2)
sw $r4 5252($r0)

#posStageInVGA - TODO will likely remove later
#whStageInVGA - TODO will likely remove later
# No need to repeat these again! Just once needed because same vga coprocessor!

# Controller, Collision have iniital input parameters that are not constant and
# will be set in game loop; for now, set those parameters to 0

jr $r31
