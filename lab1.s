#                                           ICS 51, Lab #1
#
#                                          IMPORTATNT NOTES:
#
#                       Write your assembly code only in the marked blocks.
#
#                       DO NOT change anything outside the marked blocks.
#
#                      Remember to fill in your name, student ID in the designated sections.
#
#

###############################################################
#                           Data Section
.data
#
# Fill in your name, student ID in the designated sections.
#
student_name: .asciiz "Ayman Syed"
student_id: .asciiz "87719684"

new_line: .asciiz "\n"
space: .asciiz " "
double_range_lbl: .asciiz "Double range (Decimal Values) \n"
swap_bits_lbl: .asciiz "Swap bits (Hexadecimal Values)\n"

swap_bits_test_data:  .word 0xAAAAAAAA, 0x01234567, 0xFEDCBA98
swap_bits_expected_data:  .word 0x55555555, 0x02138A9B, 0xFDEC7564

double_range_test_data: .word 80000, 111, 0, -111, 11
double_range_expected_data: .word 160000, 0, -200

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2
srl $t4, $t4, 28
la    $t3, hex_digits
add   $t3, $t3, $t4
lb    $a0, 0($t3)
li    $v0, 11
syscall
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
j $ra

###############################################################
###############################################################
###############################################################
#                            PART 1 (Swap Bits)
#
# You are given an 32-bits integer stored in $t0. You need swap the bits
# at odd and even positions. i.e. b31 <-> b30, b29 <-> b28, ... , b1 <-> b0
# The result must be stored inside $t0 as well.
swap_bits:
move $t0, $a0
############################## Part 1: your code begins here ###
li $t5, 0x55555555
and $t2, $t0, $t5
sll $t2, $t2, 1
li $t6, 0xAAAAAAAA
and $t3, $t0, $t6
srl $t3, $t3, 1
or $t4, $t2, $t3
move $t0, $t4
############################## Part 1: your code ends here ###
move $v0, $t0
jr $ra
###############################################################
###############################################################
###############################################################
#                           PART 2 (Double Range)
#
# You are given three integers. You need to find the smallest
# one and the largest one and multiply their sum by two and return it
#
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2. You
# need to store the answer into register $t0. It will be returned by the function
# to the caller.

double_range:
move $t0, $a0
move $t1, $a1
move $t2, $a2
############################### Part 2: your code begins here ##
addi $t6, $zero, 2

bgt $t2, $t0, L1
j L30

L30:
    bgt $t2, $t1, L5
    j L31

L31:
    bgt $t1, $t0, L9
    j L32

L32:
    bgt $t1, $t2, L13
    j L33

L33:
    bgt $t0, $t1, L17
    j L34

L34:
    bgt $t0, $t2, L21


L1:
    bgt $t0, $t1, L2
    bgt $t1, $t0, L3
    j L30

L2:
    move $t4, $t2
    move $t5, $t1
    j End

L3:
    bgt $t2, $t1, L4
    j L30

L4:
    move $t4, $t2
    move $t5, $t0
    j End

L5:
    bgt $t1, $t0, L6
    bgt $t0, $t1, L7
    j L31

L6:
    move $t4, $t2
    move $t5, $t0
    j End

L7:
    bgt $t2, $t0, L8
    j L31

L8:
    move $t4, $t2
    move $t5, $t1
    j End

L9:
    bgt $t0, $t2, L10
    bgt $t2, $t0, L11
    j L32

L10:
    move $t4, $t1
    move $t5, $t2
    j End

L11:
    bgt $t1, $t2, L12
    j L32

L12:
    move $t4, $t1
    move $t5, $t0
    j End

L13:
    bgt $t2, $t0, L14
    bgt $t0, $t2, L15
    j L33

L14:
    move $t4, $t1
    move $t5, $t0
    j End

L15:
    bgt $t1, $t0, L16
    j L33

L16:
    move $t4, $t1
    move $t5, $t2
    j End

L17:
    bgt $t1, $t2, L18
    bgt $t2, $t1, L19
    j L34

L18:
    move $t4, $t0
    move $t5, $t2
    j End

L19:
    bgt $t0, $t2, L20
    j L34

L20:
    move $t4, $t0
    move $t5, $t1
    j End

L21:
    bgt $t2, $t1, L22
    bgt $t1, $t2, L23


L22:
    move $t4, $t0
    move $t5, $t1
    j End

L23:
    bgt $t0, $t1, L24

L24:
    move $t4, $t0
    move $t5, $t2
    j End

End:
    add $t7, $t4, $t5
    mult $t7, $t6
    mflo $t0

############################### Part 2: your code ends here  ##
move $v0, $t0
jr $ra
###############################################################
###############################################################
###############################################################
#                          Main Function
main:

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall
la $a0, student_id
syscall
la $a0, new_line
syscall

la $a0, swap_bits_lbl
syscall

# Testing part 1
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal swap_bits

move $a0, $v0
jal print_hex
li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

li $v0, 4
la $a0, new_line
syscall
la $a0, double_range_lbl
syscall


# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, double_range_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 8($s4)
jal double_range

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

_end:
# end program
li $v0, 10
syscall
