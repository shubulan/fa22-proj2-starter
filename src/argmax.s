.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    # Prologue
    
    addi t0 x0 1  # deal the malformed
    blt a1 t0 malformed

    lw t1 0(a0)  # max elem inited as first
    add t2 x0 x0 # res inited as 0

    addi a0 a0 4
    # addi t0 x0 1 # t0 has been put 1        
loop_start:
    beq t0 a1 loop_end
    lw t3 0(a0)
    blt t3 t1 loop_continue
    add t1 t3 x0  # update res
    add t2 t0 x0

loop_continue:
    addi a0 a0 4
    addi t0 t0 1
    j loop_start

loop_end:
    add a0 t2 x0
    # Epilogue

    jr ra

malformed:
    li a0 36
    j exit