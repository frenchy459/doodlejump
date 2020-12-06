#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestone is reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################
.data

    # Screen
    screenWidth:    .word 32
    screenHeight:   .word 32
    # buffer:         .word 10:2048

    # Colours
    characterColour:    .word  0x0066cc # blue
    backgroundColour:   .word  0x000000 # black

    # Score variables
    score:      .word 0
    scoreGain:  .word 10

    # Messages
    lostMessage:    .asciiz "You died. Score: "
    replayMessage:  .asciiz "Replay?"
    startMessage:   .asciiz "Press j or k to start"

    # Character info
    Ydirection:     .word 1 # starts with character falling
    # 1 for falling
    # -1 for jumping
    characterX:     .word 14
    characterY:     .word 2
    jumpHeight:     .word 15
    jumpCounter:    .word 0
    bottomJumpHeight:   .word 20

    # Platforms
    platformColour:         .word 0xffffff
    platformAddresses:      .word 3:3 # array of 3 words, all 3
    
.text

# initalizeBuffer:
#     la $t9, buffer
#     move $t0, $0 # t0 = loop counter
#     addi $t1, $0, 8192 # t1 = 1024 * 4 = 4096, 1024 loops

# initalizeBufferLoop:
#     bge $t0, $t1, main

#     add $t2, $t9, $t0 # t2 holds address(buffer[i])
#     add $t3, $gp, $t0
#     sw $t3, 0($t2)  # save pixel's memory address at buffer[i]

#     addi $t0, $t0, 8

#     j initalizeBufferLoop

main: 
    
    li $v0, 32
    addi $a0, $0, 100
    syscall

#     la $t9, buffer
#     move $t0, $0 # t0 = loop counter
#     addi $t1, $0, 8192 # t1 = 1024 * 4 = 4096, 1024 loops

# drawBuffer:
#     bge $t0, $t1, clearRegisters

#     add $t2, $t9, $t0
#     lw $a0, 0($t2) 

#     addi $t0, $t0, 4

#     add $t2, $t9, $t0
#     lw $a1, 0($t2) 

#     addi $t0, $t0, 4

#     jal drawPixel

#     j drawBuffer


clearRegisters:
    li $v0, 0
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0	





#########################################################
# Draws character

clearCharacter:

    ################
    # 1234
    # 5XX6
    # 7XX8
    # 9101112
    ################

    #1
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a0, $a0, 1
    subi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0
    
    #2
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #3
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    subi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #4
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 2
    subi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #5
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a0, $a0, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #6
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 2
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #7
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a0, $a0, 1
    addi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #8
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 2
    addi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #9
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a0, $a0, 1
    addi $a1, $a1, 2
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #10
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a1, $a1, 2
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #11
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    addi $a1, $a1, 2
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    #12
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 2
    addi $a1, $a1, 2
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, backgroundColour # set a1 to character colour
    jal drawPixel # draws colour at a0

drawCharacter:
    
    # top left
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, characterColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    # top right
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, characterColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    # bottom right
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, characterColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    # bottom left
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, characterColour # set a1 to character colour
    jal drawPixel # draws colour at a0

CheckPlatformAddresses:
    la $t9, platformAddresses
    move $t0, $0 # t0 is loop counter
    addi $t1, $0, 12 # t1 = 12, so 3 loops

loopOverPlatformAddresses:
    bge $t0, $t1, checkInput # when counter >= 12 (3 loops) , jump to checkInput
    add $t2, $t9, $t0 # t2 holds address(platformAddress[i])
    lw $t3, 0($t2) # t3 = platformAddress[i]
    blt $t3, $gp, generatePlatformCoord # address < global pointer

    add $t4, $gp, 65512 # t4 = $gp + 256^2 - 4*6
    bgt $t3, $t4, generatePlatformCoord # address > global pointer + 256^2 - 4*6

doneGeneratingPlatformCoord:

    addi $t0, $t0, 4 # add 4 to counter for addresses
    
    move $t5, $0 # counter for drawing platform, t5 = 0
    addi $t6, $0, 24 # max = 24, 6 loops

drawPlatform:
    lw $a0, 0($t2) # sets a0 to address of pixel 
    add $a0, $a0, $t5
    lw $a1, platformColour # sets a1 to platform colour
    jal drawPixel # draws pixel
    addi $t5, $t5, 4 # add 4 to drawing platform counter
    
    blt $t5, $t6, drawPlatform # if t5 < t6, keep drawing platform

    bge $t5, $t6, loopOverPlatformAddresses # if t5 >= t6, draw a new platform
     
    
generatePlatformCoord:
    li $v0, 42
    addi $a0, $0, 0
    addi $a1, $0, 24
    syscall
    move $t7, $a0 # t7 temp stores y coordinate

    li $a0, 0
    syscall
    move $t8, $a0  # t8 stores x coordinate

    move $a0, $t7 # moves x coord into a0
    move $a1, $t8 # moves y coord into a1 
    jal convertCoordToAddress # returns v0 which contains new address

    sw $v0, 0($t2)

    j doneGeneratingPlatformCoord

        
checkInput:
    
    lw $a0, characterX
	lw $a1, characterY

    li $t0, 0xffff0000
    lw $t1, ($t0)
    andi $t1, $t1, 0x0001
	beq $t1, $0, selectDrawDirection # if no new input, draw up or down
	lw $a1, 4($t0) #store direction based on input
    jal checkValidDirection # checks for keyboard input (move left/right)

selectDrawDirection:
    lw $t6, Ydirection

    beq $t6, 1, falling # fall
    beq $t6, -1, jumping # jump
    j checkInput


jumping:
    lw $t0, jumpCounter
    lw $t1, jumpHeight
    addi $t0, $t0, 1
    sw $t0, jumpCounter

    bne $t0, 1, continueJumping

    lw $t3, characterY
    lw $t4, bottomJumpHeight
    ble $t3, $t4, movePlatformsDown

continueJumping:
    lw $t0, jumpCounter
    lw $t1, jumpHeight
    bge $t0, $t1, changeDirectionToFalling

    # changes Ydirection to -1 for jumping
    lw $t3, Ydirection 
    subi $t3, $0, 1
    sw $t3, Ydirection

    lw $a0, characterY
    subi $a0, $a0, 1
    sw $a0, characterY

    j main

changeDirectionToFalling:

    # reset jump counter back to 0
    move $t0, $0
    sw $t0, jumpCounter
    
    # changes Ydirection to 1 for falling
    lw $t3, Ydirection 
    addi $t3, $0, 1
    sw $t3, Ydirection

    j main

falling: # character is falling

    # check collision
    lw $a0, characterX # a0 = x coord
    lw $a1, characterY # a1 = y coord

    # add 1 to a1 serves two purposes
    # increase y coord of character if it keeps falling
    # checks if the pixel below the bottom pixel of character is platform
    addi $a1, $a1, 1 # a1 = bottom row of character

    jal convertCoordToAddress 
    move $a0, $v0 # a0 = memory address of bottom left pixel of character
    jal platformCollision
   
    sw $a1, characterY
    j main
    

platformCollision:

    lw $t1, platformColour

    addi $t9, $a0, 128 # t9 is now memory address below bottom left pixel of character
    lw $t0, 0($t9) # t0 is colour of pixel
    beq $t0, $t1, jumping # if pixel below is white, go to jump

    addi $t9, $t9, 4 # t9 is memory address below bottom right pixel of character
    lw $t0, 0($t9) # t0 is colour of pixel
    beq $t0, $t1, jumping # if pixel below is white, go to jump

    jr $ra

movePlatformsDown:
    # bottom of jump is above lowest point so move platforms down
    la $t7, platformAddresses

    move $t0, $0
    addi $t1, $t0, 12 # 3 loops

loopMovePlatformsDown:
    bge $t0, $t1, continueJumping

    # erasing the platform
    lw $t8, backgroundColour # sets t8 to background colour
    move $t5, $0 # counter for erasing platform to 0
    addi $t4, $0, 24 # 6 loops
loopErasingPlatform:
    lw $t6, 0($t7)
    add $t6, $t6, $t5
    sw $t8, 0($t6)
    addi $t5, $t5, 4 # add 4 to counter

    blt $t5, $t4, loopErasingPlatform # t5 < t4, keep erasing
    
    lw $t6, 0($t7)
    addi $t6, $t6, 128
    sw $t6, 0($t7)

    addi $t7, $t7, 4
    addi $t0, $t0, 4

    j loopMovePlatformsDown

#########################################################
# Draw function
# a0 = address of pixel
# a1 = colour 
drawPixel:
    sw $a1, ($a0)   # fills pixel with colour
    jr $ra          # returns nothing
    

#########################################################
# Convert coordinate to address
# a0 = x coord
# a1 = y coord
convertCoordToAddress:
	lw $v0, screenWidth 	#Store screen width into $v0
	mul $v0, $v0, $a1	#multiply by y position
	add $v0, $v0, $a0	#add the x position
	mul $v0, $v0, 4		#multiply by 4
	add $v0, $v0, $gp	#add global pointerfrom bitmap display
	jr $ra			# return $v0


#########################################################
# checks direction of character
# a0 = current X direction
# a2 = input
# a3 = coordinates of direction change if acceptable
checkValidDirection:
    # beq $a1, 115, 
    beq $a1, 106, moveCharacterLeft
    beq $a1, 107, moveCharacterRight
    j exitCheckValidDirection

moveCharacterLeft:
    li $v0, 1
    lw $t0, characterX
    subi $t0, $t0, 1
    sw $t0, characterX
    j exitCheckValidDirection

moveCharacterRight:
    li $v0, 1
    lw $t0, characterX
    addi $t0, $t0, 1
    sw $t0, characterX
    j exitCheckValidDirection

exitCheckValidDirection:
    jr $ra


#########################################################
# Pauses game
# a0 = amount to pause
# return: null
# pause:
#     add $a0, $a0, 200
#     li $v0, 32
#     syscall
#     jr $ra
