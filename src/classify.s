.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    addi t0 x0 5
    bne a0 t0 return_31
    # Prologue
    addi sp sp -48
    sw ra 0(sp)
    sw s0 4(sp)
    sw s1 8(sp)
    sw s2 12(sp)
    sw s3 16(sp)
    sw s4 20(sp)
    sw s5 24(sp)
    sw s6 28(sp)
    sw s7 32(sp)
    sw s8 36(sp)
    sw s9 40(sp)
    sw s11 44(sp)

    add s0 a1 x0 # argv
    # s1 # p mat0
    # s2 # size mat0
    # s3 # p mat1
    # s4 # size mat1
    # s5 # p input
    # s6 # size input
    # s7 # row of h
    # s8 # col of h
    # s9 # p h
    add s11 a2 x0 # whether print class
    # Read pretrained m0
    li a0 8
    jal ra malloc # malloc size
    beq a0 x0 return_26
    add s2 a0 x0

    lw a0 4(s0) # path of mat0
    addi a1 s2 0 # row of mat0
    addi a2 s2 4 # col of mat0
    jal ra read_matrix
    add s1 a0 x0 # save mat0

    # Read pretrained m1
    li a0 8
    jal ra malloc # malloc size
    beq a0 x0 return_26
    add s4 a0 x0

    lw a0 8(s0) # path of mat1
    addi a1 s4 0 # row of mat1
    addi a2 s4 4 # col of mat1
    jal ra read_matrix
    add s3 a0 x0 # save mat1

    # Read input matrix
    li a0 8
    jal ra malloc # malloc size
    beq a0 x0 return_26
    add s6 a0 x0

    lw a0 12(s0) # path of input
    addi a1 s6 0 # row of input
    addi a2 s6 4 # col of input
    jal ra read_matrix
    add s5 a0 x0 # save input
    # Compute h = matmul(m0, input)
    lw s7 0(s2)
    lw s8 4(s6)
    mul a0 s7 s8
    slli a0 a0 2
    jal ra malloc
    beq a0 x0 return_26
    addi a6 a0 0
    addi s9 a0 0 # save the res(mat h) buff

    add a0 s1 x0
    add a1 s7 x0
    lw a2 4(s2)
    add a3 s5 x0
    lw a4 0(s6)
    add a5 s8 x0

    jal ra matmul

    # free mat0 input
    add a0 s1 x0
    jal ra free # free mat0
    add a0 s2 x0
    jal ra free # free size of mat0
    add a0 s5 x0
    jal ra free # free input
    add a0 s6 x0
    jal ra free # free size of input

    # s1 s2 s5 s6 is free so far
    # s1: pointer of o
    # s2: row of o
    # s5: no use
    # s6: len of o
    # s8: len of o

    # Compute h = relu(h)
    add a0 s9 x0
    mul a1 s7 s8
    jal ra relu

    # Compute o = matmul(m1, h)
    lw s2 0(s4) # save row of m1, also row of o

    mul a0 s2 s8 # len of o
    add s6 a0 x0 # save len of o
    slli a0 a0 2 # mul 4
    jal ra malloc
    beq a0 x0 return_26
    add s1 a0 x0 # save pointer of o

    add a0 s3 x0
    add a1 s2 x0
    lw a2 4(s4)
    add a3 s9 x0
    add a4 s7 x0
    add a5 s8 x0
    add a6 s1 x0
    jal ra matmul

    # free h mat1
    add a0 s9 x0
    jal ra free # free h
    add a0 s3 x0
    jal ra free # free mat1
    add a0 s4 x0
    jal ra free # free len of mat1

    # s3 s4 s7 s9 is no use

    # Write output matrix o
    lw a0 16(s0)
    add a1 s1 x0
    add a2 s2 x0
    add a3 s8 x0

    jal ra write_matrix

    # Compute and return argmax(o)
    add a0 s1 x0
    add a1 s6 x0
    
    jal ra argmax
    add s9 a0 x0
    # free o
    add a0 s1 x0
    jal free

    add a0 s9 x0
    # If enabled, print argmax(o) and newline
    bne s11 x0 classify_done
    jal ra print_int
    addi a0 x0 0x0A
    jal ra print_char

    add a0 s9 x0
classify_done:
    # Epilogue
    lw ra 0(sp)
    lw s0 4(sp)
    lw s1 8(sp)
    lw s2 12(sp)
    lw s3 16(sp)
    lw s4 20(sp)
    lw s5 24(sp)
    lw s6 28(sp)
    lw s7 32(sp)
    lw s8 36(sp)
    lw s9 40(sp)
    lw s11 44(sp)
    addi sp sp 48

    jr ra

return_26:
    li a0 26
    j exit

return_31:
    li a0 31
    j exit