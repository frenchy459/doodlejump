#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 512
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
    buffer:         .word 10:1024

    # Colours
    characterColour:    .word  0x0066cc # blue
    backgroundColour:   .word  0x000000 # black
    # backgroundColour:   .word  0xcc6611 # orange

    # Game info
    #continue:   .byte 0x1 # 0 to end game, 1 to keep running game loop (Start)

    # Score variables
    score:      .word 0
    scoreGain:  .word 10

    # Messages
    lostMessage:    .asciiz "You died. Score: "
    replayMessage:  .asciiz "Replay?"
    startMessage:   .asciiz "Press j or k to start"

    # Controls
    # jPressed: .word 106
    # kPressed: .word 107

    # Character info
    Ydirection:     .word 1 # starts with character falling
    # 1 for falling
    # -1 for jumping
    characterX:     .word 4
    characterY:     .word 4

    # Platforms
    #platformColour:         .word 0xffffff # white
    platformColour:         .word 0xffffff
    platformAddresses:      .word 3:3 # array of 3 words, all 3
    
.text

main: 
    
    li $v0, 32
    addi $a0, $0, 100
    syscall

    # lw $a0, screenWidth
    # lw $a1, backgroundColour
    # mul $a2, $a0, 32 # total number of pixels on screen 
    # mul $a2, $a2, 4
    # add $a2, $a2, $gp # add display address
    # add $a0, $gp, $0 # loop counter

    # lw $t0, platformColour

# fillLoop:
#     beq $a0, $a2, clearRegisters
#     lw $t1, 0($a0) # loads colour at a0 into t1
# continueFillLoop:
#     sw $a1, 0($a0) # colours pixel
#     addi $a0, $a0, 4 # increase counter
#     j fillLoop



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



###################
# TERSTING PURPOSES 
#j CheckPlatformAddresses

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
    # bge $t0, $t1, checkInput
    # add $t2, $t9, $t0 # t2 = pl atforAddress[i]   
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

    # j loopOverPlatformAddresses
     
    
generatePlatformCoord:
    li $v0, 42
    addi $a0, $0, 0
    addi $a1, $0, 24
    syscall
    # lw $t7, 0($a0) # t7 temp stores y coordinate
    move $t7, $a0 # t7 temp stores y coordinate

    li $a0, 0
    syscall
    #lw $t8, 0($a1) # v8 stores x coordinate
    move $t8, $a0  # t8 stores x coordinate

    move $a0, $t7 # moves x coord into a0
    move $a1, $t8 # moves y coord into a1 
    jal convertCoordToAddress # returns v0 which contains new address

    sw $v0, 0($t2)

    # addi $t0, $gp, 0
    # sw $t0, 0($t2)

    j doneGeneratingPlatformCoord

        
checkInput:

    lw $a0, characterX
	lw $a1, characterY

    li $t0, 0xffff0000
    lw $t1, ($t0)
    andi $t1, $t1, 0x0001
	beq $t1, $0, selectDrawDirection # if no new input, draw up or down
	lw $a1, 4($t0) #store direction based on input
    jal checkValidDirection

selectDrawDirection:
    lw $t6, Ydirection
    beq $t6, -1, decreaseYCoord
    beq $t6, 1, increaseYCoord
    j checkInput

decreaseYCoord: # character is jumping
    lw $a0, characterY
    subi $a0, $a0, 1
    sw $a0, characterY
    j main

increaseYCoord: # character is falling
    lw $a0, characterY
    addi $a0, $a0, 1
    sw $a0, characterY
    j main
    
#########################################################
# Draw function
# a0 = address of pixel
# a1 = colour 
drawPixel:
    sw $a1, ($a0)   # fills pixel with colour
    jr $ra          # returns nothing
    

    # la $t9, buffer
    # move $t0, $0
    # add $t1, 
    # jr $ra

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
#     li $v0, 32 # terminate the program gracefully
#     syscall
#     jr $ra
