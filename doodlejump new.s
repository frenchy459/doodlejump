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
    screenHeight:   .word 64

    # Colours
    characterColour:    .word  0x0066cc # blue
    #backgroundColour:   .word  0xff0000 # black
    backgroundColour:   .word  0xcc6611 # orange

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
    Ydirection:     .word -1 # starts with character falling
    # -1 for falling
    # 1 for jumping
    Xdirection:     .word 107 # starts with character going right
    # 106 (j) for left
    # 107 (k) for right
    characterX:     .word 0
    characterY:     .word 0

    # Platforms

    
.text

main: 
    lw $a0, screenWidth
    lw $a1, backgroundColour
    mul $a2, $a0, 64 # total number of pixels on screen 
    mul $a2, $a2, 4
    add $a2, $a2, $gp # add display address
    add $a0, $gp, $0 # loop counter
fillLoop:
    beq $a0, $a2, init
    sw $a1, 0($a0) # colours pixel
    addi $a0, $a0, 4 # increase counter
    j fillLoop

# Start: 
#     beq $t0, $0, Exit
#     lw $a0, displayAddress # a0 stores the base address for display
#     #jal clearScreen
# exitClearScreen:
#     jal drawCharacter
# exitDrawCharacter:
#     jal checkInput
#     move $t0, $v0


init:
    li $t0, 4
    sw $t0, characterX
    li $t0, 10
    sw $t0, characterY
    sw $0, score

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
# Draw character
# just draws 5x5 square that will act as character for now

drawCharacter:
    
    
    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, characterColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, characterColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a0, $a0, 1
    addi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, characterColour # set a1 to character colour
    jal drawPixel # draws colour at a0

    lw $a0, characterX # load x coord
    lw $a1, characterY # load y coord
    addi $a1, $a1, 1
    jal convertCoordToAddress # converts coordinate to address
    move $a0, $v0 # copy addresss to a0
    lw $a1, characterColour # set a1 to character colour
    jal drawPixel # draws colour at a0

drawPlatform:


    # move $t2, $0

    # addi $t1, $0, 4
    # mul $t6, $a1, $t1
    # #lw $t1, screenWidth
    # addi $t1, $0, 256

    # mul $t2, $t1, $a2 # does t2 = y * screenWidth
    # add $t2, $t2, $t6 # does t2 += x
    # add $t2, $t2, $a0 # does t2 += dispalyAddress

    # lw $t1, characterColour # load character colour into $t1

    # # t3 = counter for y value
    # # t4 = counter for x value
    # # t5 = stores value of 5 since character is 5x5 square
    # addi $t5, $0, 5 # t5 = 5
    # move $t3, $0 # t3 = 0
    # move $t4, $0 # t4 = 0


# clearScreen:
#     # lw $t1, backgroundColour # t1 stores colour black
#     move $t2, $a0 # t2 is location pointer
#     addi $t3, $a0, 131072 # max

#     loopClearBackground: 
#         beq $t2, $t3, exitClearScreen
#         sw $0, ($t2) # actually draws the fucking pixel at t2
#         addi $t2, $t2, 4
#         j loopClearBackground
        

# checkInput:
#     lw $t1, 0xffff0004
#     lw $t2, jPressed
#     lw $t3, kPressed

#     beq $t1, $t2, moveLeft
#     beq $t1, $t3, moveRight

#     j Start

#     moveLeft:
#         subi $a1, $a1, 1
#         #move $v0, $0
#         #sw 0xffff0004, $0
#         j Start
        
   
#     moveRight:
#     	addi $a1, $a1, 1
#     	move $v0, $0
#         #sw 0xffff0004, $0
#     	j Start
        
        
#########################################################
# Draw function
# a0 = address of pixel
# a1 = colour 
# return: null
drawPixel:
    sw $a1, ($a0)   # fills pixel with colour
    jr $ra          # returns nothing


#########################################################
# Convert coordinate to address
# a0 = x coord
# a1 = y coord
# return: null
convertCoordToAddress:
	lw $v0, screenWidth 	#Store screen width into $v0
	mul $v0, $v0, $a1	#multiply by y position
	add $v0, $v0, $a0	#add the x position
	mul $v0, $v0, 4		#multiply by 4
	add $v0, $v0, $gp	#add global pointerfrom bitmap display
	jr $ra			# return $v0


#########################################################
# Pauses game
# a0 = amount to pause
# return: null
pause:
    li $v0, 10 # terminate the program gracefully
    syscall
    jr $ra


##################################################################
# Check Platform Collision
# $a0 = snakeHeadPositionX
# $a1 = snakeHeadPositionY
# returns $v0:
#	0 = did not touch platform
#	1 = did hit platform
CheckFruitCollision:
	
	#get fruit coordinates
	lw $t0, fruitPositionX
	lw $t1, fruitPositionY
	#set $v0 to zero, to default to no collision
	add $v0, $zero, $zero	
	#check first to see if x is equal
	beq $a0, $t0, XEqualFruit
	#if not equal end function
	j ExitCollisionCheck
	
XEqualFruit:
	#check to see if the y is equal
	beq $a1, $t1, YEqualFruit
	#if not eqaul end function
	j ExitCollisionCheck
YEqualFruit:
	#update the score as fruit has been eaten
	lw $t5, score
	lw $t6, scoreGain
	add $t5, $t5, $t6
	sw $t5, score
	# play sound to signify score update
	li $v0, 31
	li $a0, 79
	li $a1, 150
	li $a2, 7
	li $a3, 127
	syscall	
	
	li $a0, 96
	li $a1, 250
	li $a2, 7
	li $a3, 127
	syscall
	
	li $v0, 1 #set return value to 1 for collision
	
ExitCollisionCheck:
	jr $ra
