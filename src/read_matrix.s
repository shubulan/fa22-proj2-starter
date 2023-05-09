.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

    # Prologue
    addi sp sp -16
    sw ra 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp) # descriptor

    add s1 x0 a1 # p to save row
    add s2 x0 a2 # p to save col

    # open file
    add a1 x0 x0
    jal ra fopen # a0 should be a file descriptor
    addi t0 x0 -1
    beq a0 t0 return_27

    add s3 x0 a0 # save descriptor
    # read row 
    add a1 s1 x0
    addi a2 x0 4
    jal ra fread
    addi a2 x0 4 # fread error
    bne a0 a2 return_29

    # read col
    add a0 s3 x0
    add a1 s2 x0
    addi a2 x0 4
    jal ra fread
    addi a2 x0 4 # fread error
    bne a0 a2 return_29

    # alloc len col
    lw t0 0(s1)
    lw t1 0(s2) # s1 s2 is no longer used
    mul s1 t0 t1
    slli s1 s1 2 # len of matrix bytes
    add a0 s1 x0

    jal ra malloc
    beq a0 x0 return_26 # malloc error
    
    # read the rest num in file
    add s2 a0 x0 # save buffer
    add a1 a0 x0 # buffer
    add a0 s3 x0 # descriptor
    add a2 s1 x0

    jal ra fread
    bne a0 s1 return_29

    # close file
    add a0 s3 x0
    jal fclose
    addi t0 x0 -1
    beq a0 t0 return_28
    
    # set result
    add a0 s2 x0

    # Epilogue
    lw ra 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp) # descriptor
    addi sp sp 16

    jr ra
return_27:
    li a0 27
    j exit

return_29:
    li a0 29
    j exit

return_26:
    li a0 26
    j exit

return_28:
    li a0 28
    j exit