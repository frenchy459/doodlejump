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
# - Milestone 4 (choose the one the applies)
#
# Which approved additional features have been implemented?
# (See the assignment handout for the list of additional features)
# 1. Game over / rety
# 2. Dynamic increase in difficulty (every three jumps, the jumping height
#    of the Doodler decreases by one until the smallest jumping height is reached)
#
# Any additional information that the TA needs to know:
# - Before running program please restart MARS
# - The Bitmap Display in MARS is EXTREMELY BUGGY, the restart button (the s key)
#   and the replay button the game over screen should work. If you get a black screen
#   or the doodler doesn't load when trying to restart the game: recompile and run again.
#   Also, don't restart the game using the s key too quickly.
# - Also because MARS is very buggy, the "You died" text when the gamer terminates
#   sometimes is displayed properly, or as "You died1000" or "1000". I have no idea
#   why this occurs and no idea how to fix it, since usually the "Replay" text
#   that follows the "You died" displays properly.
#####################################################################
.data

    # Screen
    screenWidth:    .word 32
    screenHeight:   .word 32
    buffer:         .word 10:1024

    # Colours
    characterColour:    .word  0x0066cc # blue
    backgroundColour:   .word  0x000000 # black

    # Messages
    lostMessage:    .asciiz "You died"
    replayMessage:  .asciiz "Replay?"

    # Character info
    Ydirection:     .word 1 # starts with character falling
    # 1 for falling
    # -1 for jumping
    characterX:     .word 14
    characterY:     .word 2
    jumpHeight:     .word 10
    jumpCounter:    .word 0
    bottomJumpHeight:   .word 20

    # score
    score:  .word 0

    # Platforms
    platformColour:         .word 0xffffff
    platformAddresses:      .word 3:6 # array of 3 words, all 3
    numPlatforms:           .word 6
    
.text
restart:
    lw $t0, characterX
    addi $t0, $0, 14
    sw $t0, characterX

    lw $t0, characterY
    addi $t0, $0, 2
    sw $t0, characterY

    sw $0, score

    lw $t0, Ydirection
    addi $t0, $0, 1
    sw $t0, Ydirection

    sw $0, jumpCounter

    lw $t0, characterX
    addi $t0, $0, 14
    sw $t0, characterX

initalizeBuffer:
    la $t9, buffer

    addi $t0, $t9, 4096 # t1 = 1024 * 4 = 4096, 1024 loops
    lw $t1, backgroundColour

initalizeBufferLoop:
    bge $t9, $t0, clearPlatformAddresses

    sw $t1, 0($t9)  # save pixel's memory address at buffer[i]
    addi $t9, $t9, 4

    j initalizeBufferLoop

clearPlatformAddresses:
    move $t0, $0 # t0 is loop counter
    lw $t1, numPlatforms
    addi $t2, $0, 4
    mul $t1, $t1, $t2 # t1 = numPlatforms * 4

    la $t9, platformAddresses

clearPlatformAddressesLoop:
    bge $t0, $t1, clearScreen
    
    add $t2, $t9, $t0
    sw $0, 0($t2)

    addi $t0, $t0, 4

    j clearPlatformAddressesLoop

clearScreen:
    addi $t0, $gp, 0
    addi $t1, $gp, 4096
    lw $t2, backgroundColour

clearScreenLoop:
    beq $t0, $t1, initalPlatforms
    sw $t2, 0($t0)
    addi $t0, $t0, 4
    j clearScreenLoop

initalPlatforms:
    move $t0, $0 # t0 is loop counter
    lw $t1, numPlatforms
    addi $t2, $0, 4
    mul $t1, $t1, $t2 # t1 = numPlatforms * 4

loopOverInitalPlatforms:
    bge $t0, $t1, main # when counter >= numPlatforms * 4 , jump to checkInput

    la $t9, platformAddresses

    add $t2, $t9, $t0 # t2 holds address(platformAddress[i])
    lw $t3, 0($t2) # t3 = platformAddress[i]
    blt $t3, $gp, generateInitalPlatformCoord # address < global pointer

    add $t4, $gp, 4072 # t4 = $gp + 4(32^2) - 4*6
    bgt $t3, $t4, generateInitalPlatformCoord # address > global pointer + 256^2 - 4*6

doneGeneratingInitialPlatformCoord:
    
    move $t5, $0 # counter for drawing platform, t5 = 0
    addi $t6, $0, 24 # max = 24, 6 loops

drawInitalPlatform:

    lw $a2, platformColour # sets a2 to platform colour

    lw $a0, 0($t2) # sets a0 to address of pixel 
    add $a0, $a0, $t5
    jal drawPixel # draws pixel
    addi $t5, $t5, 4 # add 4 to drawing platform counter
    
    blt $t5, $t6, drawInitalPlatform # if t5 < t6, keep drawing platform

    bge $t5, $t6, loopOverInitalPlatforms # if t5 >= t6, draw a new platform
     
    
generateInitalPlatformCoord:
    li $v0, 42
    move $a0, $0
    addi $a1, $0, 24
    syscall
    move $t7, $a0 # t7 temp stores x coordinate

    move $a0, $0
    addi $a1, $0, 5
    syscall
    add $t8, $a0, $t0  # t8 stores y coordinate

    move $a0, $t7 # moves x coord into a0
    move $a1, $t8 # moves y coord into a1 
    jal convertCoordToAddress # returns v0 which contains new address
    
    sw $v0, 0($t2) # saves pixel address to platformAddress[i]
 
    addi $t0, $t0, 4 # add 4 to counter for addresses 

    j doneGeneratingInitialPlatformCoord

main: 
    
    li $v0, 32
    addi $a0, $0, 200
    syscall

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

clearCharacter:

    ################
    # 1234
    # 5XX6
    # 7XX8
    # 9101112
    ################

    lw $a2, backgroundColour

    #1
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a0, $a0, 1
    subi $a1, $a1, 1
    jal drawToBuffer

    #2
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a1, $a1, 1
    jal drawToBuffer

    #3
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    subi $a1, $a1, 1
    jal drawToBuffer

    #4
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 2
    subi $a1, $a1, 1
    jal drawToBuffer

    #5
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a0, $a0, 1
    jal drawToBuffer

    #6
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 2
    jal drawToBuffer

    #7
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a0, $a0, 1
    addi $a1, $a1, 1
    jal drawToBuffer

    #8
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 2
    addi $a1, $a1, 1
    jal drawToBuffer

    #9
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    subi $a0, $a0, 1
    addi $a1, $a1, 2
    jal drawToBuffer

    #10
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a1, $a1, 2
    jal drawToBuffer

    #11
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    addi $a1, $a1, 2
    jal drawToBuffer

    #12
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 2
    addi $a1, $a1, 2
    jal drawToBuffer

drawCharacter:
    
    lw $a2, characterColour

    # top left
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    jal drawToBuffer

    # top right
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    jal drawToBuffer

    # bottom right
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    jal drawToBuffer

    # bottom left
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a1, $a1, 1
    jal drawToBuffer

checkEnd:
    lw $t0, characterY

    bge $t0, 30, endScreen

        
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
    addi $t0, $t0, 1
    sw $t0, jumpCounter

    bne $t0, 1, noScoreIncrease
    lw $t3, score # increase score by 1
    addi $t3, $t3, 1
    sw $t3, score

    li $t4, 3
    div $t3, $t4
    mfhi $t4 # t4 = remainder

    bne $t4, 0, noScoreIncrease

    lw $t3, jumpHeight
    beq $t3, 6, noScoreIncrease
    subi $t3, $t3, 1
    sw $t3, jumpHeight

noScoreIncrease:

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

    j CheckPlatformAddresses

changeDirectionToFalling:

    # reset jump counter back to 0
    move $t0, $0
    sw $t0, jumpCounter
    
    # changes Ydirection to 1 for falling
    lw $t3, Ydirection 
    addi $t3, $0, 1
    sw $t3, Ydirection

    j CheckPlatformAddresses

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
    j CheckPlatformAddresses
    

platformCollision:

    lw $t1, platformColour

    addi $t9, $a0, 0 # t9 is now memory address below bottom left pixel of character
    lw $t0, 0($t9) # t0 is colour of pixel
    beq $t0, $t1, jumping # if pixel below is white, go to jump

    addi $t9, $t9, 4 # t9 is memory address below bottom right pixel of character
    lw $t0, 0($t9) # t0 is colour of pixel
    beq $t0, $t1, jumping # if pixel below is white, go to jump

    jr $ra

movePlatformsDown:
    # bottom of jump is above lowest point so move platforms down
    
    move $t0, $0 # t0 is loop counter
    lw $t1, numPlatforms
    addi $t2, $0, 4
    mul $t1, $t1, $t2 # t1 = numPlatforms * 4

loopMovePlatformsDown:
    bge $t0, $t1, continueJumping
    # bge $t0, $t1, redrawPlatforms

    la $t7, platformAddresses
    add $t2, $t7, $t0

    # erasing the platform
    lw $t8, backgroundColour # sets t8 to background colour
    move $t5, $0 # counter for erasing platform to 0
    addi $t4, $0, 24 # 6 loops

    lw $a0, 0($t2)
    jal convertAddressToCoord
    addi $a0, $v0, 0
    addi $a1, $v1, 0
    lw $a2, backgroundColour

loopErasingPlatform:

    jal drawToBuffer
    addi $a0, $a0, 1

    addi $t5, $t5, 4 # add 4 to counter

    blt $t5, $t4, loopErasingPlatform # t5 < t4, keep erasing
    
    lw $t6, 0($t2)
    addi $t6, $t6, 128
    sw $t6, 0($t2)

    addi $t0, $t0, 4

    j loopMovePlatformsDown

CheckPlatformAddresses:
    
    move $t0, $0 # t0 is loop counter
    lw $t1, numPlatforms
    addi $t2, $0, 4
    mul $t1, $t1, $t2 # t1 = numPlatforms * 4

loopOverPlatformAddresses:
    bge $t0, $t1, drawBuffer # when t0 > t1,  jump to checkInput
    la $t9, platformAddresses
    add $t2, $t9, $t0 # t2 holds address(platformAddress[i])
    lw $t3, 0($t2) # t3 = platformAddress[i]
    blt $t3, $gp, generatePlatformCoord # address < global pointer

    add $t4, $gp, 4072 # t4 = $gp + 4(32^2) - 4*6
    bgt $t3, $t4, generatePlatformCoord # address > global pointer + 256^2 - 4*6

doneGeneratingPlatformCoord:

    addi $t0, $t0, 4 # add 4 to counter for addresses
    
    move $t5, $0 # counter for drawing platform, t5 = 0
    addi $t6, $0, 24 # max = 24, 6 loops

    lw $a2, platformColour
    lw $a0, 0($t2) # sets a0 to address of pixel 

    jal convertAddressToCoord
    addi $a0, $v0, 0
    addi $a1, $v1, 0

drawPlatform:

    jal drawToBuffer
    addi $a0, $a0, 1

    addi $t5, $t5, 4 # add 4 to drawing platform counter
    
    blt $t5, $t6, drawPlatform # if t5 < t6, keep drawing platform

    bge $t5, $t6, loopOverPlatformAddresses # if t5 >= t6, draw a new platform
     
    
generatePlatformCoord:
    li $v0, 42
    addi $a0, $0, 0
    addi $a1, $0, 24
    syscall
    move $t7, $a0 # t7 temp stores x coordinate

    move $a0, $t7 # moves x coord into a0
    move $a1, $0 # moves y coord into a1 
    jal convertCoordToAddress # returns v0 which contains new address

    sw $v0, 0($t2)

    j doneGeneratingPlatformCoord     

drawBuffer:

    la $t9, buffer
    addi $t1, $t9, 4096
    add $a0, $0, $gp

drawBufferLoop:
    bge $t9, $t1, main # when t9 >= t1, go to main

    lw $a1, 0($t9) # a1 = buffer[i] (colour of pixel)

    sw $a1, ($a0)   # fills pixel with colour

    addi $a0, $a0, 4
    addi $t9, $t9, 4

    j drawBufferLoop


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
# Convert address to coordinate
# a0 = address
# v0 = x coord
# v1 = y coord
convertAddressToCoord:
	lw $v1, screenWidth 	#Store screen width into $v0

    sub $a0, $a0, $gp   # subtract gp

    li $v0, 4
    div $a0, $v0          # divide by 4
    mflo $a0
    div $a0, $v1       # divide a0 by 32

    mfhi $v0 # move remainder into v0
    mflo $v1 # move quotient into v1

	jr $ra			# return $v0


#########################################################
# Draws to buffer
# a0 = x coord
# a1 = y coord
# a2 = colour
drawToBuffer:
    la $t9, buffer # t9 = address(buffer[0])
    lw $t8, screenWidth 	#Store screen width into $v0
	mul $t8, $t8, $a1	#multiply by y positionW
	add $t8, $t8, $a0	#add the x position
    mul $t8, $t8, 4		#multiply by 4

    add $t9, $t9, $t8 # t9 = address in buffer for pixel at (x, y)
    sw $a2, 0($t9) # saves colour in byte next to address in buffer

	jr $ra			# return nmothing



#########################################################
# checks direction of character
# a0 = current X direction
# a2 = input
# a3 = coordinates of direction change if acceptable
checkValidDirection:
    beq $a1, 115, restart
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


endScreen:

drawBuffer2:

    la $t9, buffer
    addi $t1, $t9, 4096
    add $a0, $0, $gp

drawBufferLoop2:
    bge $t9, $t1, continueEndScreen # when t9 >= t1, go to main

    lw $a1, 0($t9) # a1 = buffer[i] (colour of pixel)

    sw $a1, ($a0)   # fills pixel with colour

    addi $a0, $a0, 4
    addi $t9, $t9, 4

    j drawBufferLoop2

continueEndScreen:

    #play a sound tune to signify game over
	li $v0, 31
	li $a0, 28
	li $a1, 250
	li $a2, 32
	li $a3, 127
	syscall
		
	li $a0, 33
	li $a1, 250
	li $a2, 32
	li $a3, 127
	syscall
	
	li $a0, 47
	li $a1, 1000
	li $a2, 32
	li $a3, 127
	syscall
	
	li $v0, 56 #syscall value for dialog
	la $a0, lostMessage #get message
	syscall
	
	li $v0, 50 #syscall for yes/no dialog
	la $a0, replayMessage #get message
	syscall
	
	beqz $a0, restart #jump back to start of program
	#end program
	li $v0, 10
	syscall
