.text
main:
    jal initCharacters
    jal selectCharacter
    jal initPlayer1
    jal initPlayer2

# initialize sizes of different characters, average size around 60X120
initCharacters:
# Kirby
    # mass
    addi $r1 $r0 50
    sw $r1 0($r0)
    # size
    addi $r1 $r0 60 # width
    sll $r1 $r1 16 # shift to top order
    addi $r1 $r1 60 # height in bottom order
    sw $r1 1($r0) 

    jr $rd

# load up sizes, for now just character 1
selectCharacter:
    # player 1
    lw $r1 0($r0) # mass
    lw $r2 1($r0) # size
    # player 2
    lw $r3 0($r0) 
    lw $r4 1($r0)

    jr $rd

# initialize player constants
initPlayer1:
    # Mass
    sw $r1 4096($r0) # address: 1000000000000
    # Gravity
    addi $r5 $r0 98
    addi $r6 $r0 10
    div $r5 $r5 $r6 # gravity
    sw $r5 4100($r0) # address: 1000000000100
    # Wind Resistance
    addi $r5 10
    sw $r5 4104($r0) # address: 1000000001000
    # Position
    addi $r5 $r0 200 # xpos
    sll $r5 $r5 16 # shift to top order
    addi $r5 $r5 300 # ypos in bottom order
    sw $r5 4108($r0) # address: 1000000001100
    # Controller

    # Knockback

    # Attack

    # Collision

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

    # Knockback

    # Attack

    # Collision
    jr $rd

initStage:
    addi