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
    continue: .byte 0x1 # 0 to end game, 1 to keep running game loop (Start)
    displayAddress: .word 0x10008000 # draws shit to the screen
    characterColour: .word -1 # stores colour white, character's colour for now
    screenWidth: .word 256 # width of screen

.text
main: 
    lb $t0, continue # $t0 stores value of continue
Start: 
    beq $t0, $0, Exit
    lw $a0, displayAddress #$t0 stores the base address for display
    addi $a1, $0, 500
    addi $a1, $0, 10
    addi $a2, $0, 10
    jal drawCharacter

Exit:
    li $v0, 10 # terminate the program gracefully
    syscall


drawCharacter:
# just draws 5x5 square that will act as character for now
# a0 = display address
# a1 = x
# a2 = y
# a3 = colour
# t2 = location pointer
# t1 = holds screen wdith then character colour
    addi $t1, $0, 4
    mul $a1, $a1, $t1
    lw $t1, screenWidth

    mul $t2, $t1, $a2 # does t2 = y * screenWidth
    add $t2, $t2, $a1 # does t2 += x
    add $t2, $t2, $a0 # does t2 += dispalyAddress

    lw $t1, characterColour # load character colour into $t1

    # t3 = counter for y value
    # t4 = counter for x value
    # t5 = stores value of 5 since character is 5x5 square
    addi $t5, $0, 5 # t5 = 5
    move $t3, $0 # t3 = 0
    move $t4, $0 # t4 = 0

    loopDrawCharX:
        beq $t4, $t5, loopDrawCharY # if t4 = 5 go to loopDrawCharX
        sw $t1, ($t2) # actually draws the fucking pixel at t2
        addi $t4, $t4, 1 # add one to counter
        addi $t2, $t2, 4 # moves pointer over 4
        j loopDrawCharX	
    
    loopDrawCharY:
        beq $t3, $t5, exitDrawCharacter # if t3 = 5 go to exitDrawCharacter
        move $t4, $0 # sets counter t4 back to 0
        subi $t2, $t2, -20 # moves x position of pointer back to correct column
        addi $t2, $t2, 216 # moves pointer down one row for next reow of pixels
        addi $t3, $t3, 1 # add one to counter
        j loopDrawCharX

exitDrawCharacter:
    jr $ra
