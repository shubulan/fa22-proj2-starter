.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    # Prologue
# deal malformed
    addi t0 x0 1
    blt a2 t0 return_36
    blt a3 t0 return_37
    blt a4 t0 return_37

dot_begin:
# t0: loop idx for a2
# t1: not used
# a0/a1: point the current int, change with the loop
# t2: res
# t3...: used for temp calc
    add t0 x0 x0
    add t2 x0 x0
    slli a3 a3 2
    slli a4 a4 2
loop_start:
    beq t0 a2 loop_end

    lw t3 0(a0)
    lw t4 0(a1)
    mul t3 t3 t4
    add t2 t2 t3

    addi t0 t0 1
    add a0 a0 a3
    add a1 a1 a4

    j loop_start
loop_end:
    add a0 t2 x0

    # Epilogue
    jr ra

return_36:
    li a0 36
    j exit

return_37:
    li a0 37
    j exit
