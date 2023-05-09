.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    # Prologue
    addi sp sp -24
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp) # a tmp num

    add s1 a1 x0 # buff
    add s2 a2 x0 # row
    add s3 a3 x0 # col

    # open file
    addi a1 x0 1
    jal ra fopen
    addi t0 x0 -1
    beq a0 t0 return_27 # fopen error

    add s0 a0 x0 # save descriptor
    lw s4 0(s1) # save first word
    # write row
    sw s2 0(s1)
    add a1 s1 x0
    addi a2 x0 1
    addi a3 x0 4

    jal ra fwrite
    addi t0 x0 1
    bne a0 t0 return_30 # fwrite error

    # write col
    sw s3 0(s1)
    add a0 s0 x0
    add a1 s1 x0
    addi a2 x0 1
    addi a3 x0 4

    jal ra fwrite
    addi t0 x0 1
    bne a0 t0 return_30 # fwrite error

    sw s4 0(s1) # restore first word
    # write mat
    add a0 s0 x0
    add a1 s1 x0
    mul a2 s2 s3
    add s2 a2 x0 # save total len
    addi a3 x0 4

    jal ra fwrite

    bne a0 s2 return_30 # fwrite error

    # close file
    add a0 s0 x0
    jal fclose
    addi t0 x0 -1
    beq a0 t0 return_28

    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp) # a tmp num
    addi sp sp 24

    jr ra

return_27:
    li a0 27
    j exit

return_28:
    li a0 28
    j exit

return_30:
    li a0 30
    j exit