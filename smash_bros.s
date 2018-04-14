.text
main:
    # --------Initialization--------
    jal initCharacters
    jal selectCharacter
    jal initPlayer1
    #jal initPlayer2

    # --------Game loop------------
    addi $r1 $r1 0
    bne $r0 $r1 terminateGame:
      # Controller Coprocessor
      lw $r2 4736($r0)   #address: 100101xxxxxxx

      # Collision Coprocessor - for input: (gameControllerInputP1 or pos1? ask Nathaniel, assuming former now)
      sw $r2 5632($r0) # position, address: 1011000000000
      lw $r3 1($r0)    # load width/height (size) into $r3
      sw $r3 5640($r0) # width/height, address: 1011000001000
      lw $r4 5632($r0) # collision_output, address: 101100xxxxxxx
      


    # --------- Game Termination----------
terminateGame: #TODO once a player loses all health


# initialize sizes of different characters, average size around 60X120
# stores mass in Mem[0] and width/height in Mem[1]
# TODO change the immediate values in here to bowser
initCharacters:
# Kirby
    # mass
    addi $r1 $r0 16
    sw $r1 0($r0)

    # size
    addi $r1 $r0 _____ # width
    sll $r1 $r1 16 # shift to top order
    addi $r1 $r1 ____ # height in bottom order
    sw $r1 1($r0)

    jr $rd

# load up sizes, for now just character 1
# Loads mass (Mem[0]) and width/height (Mem[1]) into $r1 and $r2
selectCharacter:
    # player 1
    lw $r1 0($r0) # mass
    lw $r2 1($r0) # size
    # player 2
    # lw $r3 0($r0)
    # lw $r4 1($r0)

    jr $rd

# initialize player constants
# Executes sw's to mmio addresses to load initial constants for the coprocessors
# Precondition: $r1 has mass, TODO $r2 has width and height
initPlayer1:
    #---------Physics-----------
    # Mass
    sw $r1 4096($r0) # address: 1000000000000
    # Gravity
    addi $r5 $r0 65536
    sw $r5 4100($r0) # address: 1000000000100
    # Wind Resistance
    addi $r5 16
    sw $r5 4104($r0) # address: 1000000001000
    # Position
    addi $r5 $r0 352 # xpos
    sll $r5 $r5 16 # shift to top order
    addi $r5 $r5 250 # ypos in bottom order
    sw $r5 4108($r0) # address: 1000000001100

    # Controller
    addi $r5 $r0 0
    sw $r5 4112($r0)         # address: 1000000010000

    # Knockback
    addi $r5 $r0 0
    sw $r5 4116($r0)   # address: 1000000010100

    # Attack
    addi $r5 $r0 0
    sw $r5 4120($r0)    # address: 1000000011000

    # Collision
    addi $r5 $r0 0      # address: 1000000011100
    sw $r5 4124($r0)

    # Controller, Collision iniital input parameters are not constant and
    # will be set in game loop; for now, set them to 0

    jr $rd

initPlayer2:
    # Mass
    sw $r3 4224($r0) # address: 1000010000000
    # Gravity
    addi $r5 $r0 98
    addi $r6 $r0 10
    div $r5 $r5 $r6 # gravity
    sw $r5 4228($r0) # address: 1000010000100
    # Wind
    addi $r5 10
    sw $r5 4232($r0) # address: 1000010001000
    # Position
    addi $r5 $r0 440 # x position of right edge
    sra $r6 $r2 16 # shift player 1 size to get width
    sub $r5 $r5 $r6 # xpos
    sll $r5 $r5 16 # shift xpos to top order
    addi $r5 $r5 300 # ypos in bottom order
    sw $r5 4236($r0) # address: 1000010001100

    # Controller
    # TODO finish this function when necessary

    # Knockback

    # Attack

    # Collision
    jr $rd
