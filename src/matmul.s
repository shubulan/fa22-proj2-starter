.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    # Error checks
    ebreak
    addi t0 x0 1
    blt a1 t0 return_38
    blt a2 t0 return_38
    blt a4 t0 return_38
    blt a5 t0 return_38
    bne a2 a4 return_38
    # Prologue
    addi sp sp -48 # 12 saved register
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
    sw s10 44(sp)

    # s9: loop for s1, rows of first
    # s10: loop for s5, cols of second
    # s7: loop for s3, pointer of B
    # s8: save for a6, int* res
    add s0 a0 x0
    add s1 a1 x0
    add s2 a2 x0
    add s3 a3 x0
    add s4 a4 x0 # rows of B, no use, because it same as s3
    add s5 a5 x0 # cols of B
    add s6 a6 x0

    add s9 x0 x0
    add s8 a6 x0
    ebreak
outer_loop_start:
    beq s9 s1 outer_loop_end

    add s7 s3 x0
    add s10 x0 x0
inner_loop_start:
    beq s10 s5 inner_loop_end

    add a0 s0 x0
    add a1 s7 x0
    add a2 s2 x0
    addi a3 x0 1
    add a4 s5 x0
    ebreak
    jal ra dot
    ebreak
    sw a0 0(s8) # store res

    addi s8 s8 4
    addi s10 s10 1
    
    addi s7 s7 4
    j inner_loop_start

inner_loop_end:
    addi s9 s9 1
    add t0 s2 x0
    slli t0 t0 2
    add s0 s0 t0
    j outer_loop_start

outer_loop_end:

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
    lw s10 44(sp)
    addi sp sp 48 # 12 saved register

    jr ra

return_38:
    li a0 38
    j exit