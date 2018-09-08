# COMP1521 18s2 Week 05 Lab
#
# Matrix data #2

   .data
N: .word  3
M: .word  2
P: .word  4
A: .word  1, 2, 3, 4, 5, 6
B: .word  8, 7, 6, 5, 4, 3, 2, 1
C: .space 48

# COMP1521 18s1 Week 05 Lab
#
# Main program to drive matrix multiplication
# Assumes that labels N,M,P,A,B,C exist, and
# refer to appropriate objects/values
   .data
labelA:
   .asciiz "A:\n"
labelB:
   .asciiz "\nB:\n"
labelC:
   .asciiz "\nC:\n"

   .text
   .globl main
main:
   # set up stack frame for main()
   sw   $fp, -4($sp)
   la   $fp, -4($sp)
   sw   $ra, -4($fp)
   addi $sp, $sp, -8

   # print matrix A
   la   $a0, labelA
   li   $v0, 4
   syscall
   lw   $a0, N
   lw   $a1, M
   la   $a2, A
   jal  printMatrix

   # print matrix B
   la   $a0, labelB
   li   $v0, 4
   syscall
   lw   $a0, M
   lw   $a1, P
   la   $a2, B
   jal  printMatrix

   # multiply C = A x B
   lw   $a0, N             # matrix dimensions in $a?
   lw   $a1, M
   lw   $a2, P
   addi $sp, $sp, -4       # matrix addresses on stack
   la   $t0, A
   sw   $t0, ($sp)         # push(&A)
   addi $sp, $sp, -4
   la   $t0, B
   sw   $t0, ($sp)         # push(&B)
   addi $sp, $sp, -4
   la   $t0, C
   sw   $t0, ($sp)         # push(&C)
   jal  multMatrices
   nop
   addi $sp, $sp, 12       # clean args off stack

   # print matrix C
   la   $a0, labelC
   li   $v0, 4
   syscall
   lw   $a0, N
   lw   $a1, P
   la   $a2, C
   jal  printMatrix

   # return 0 and clean up stack
   li   $v0, 0
   lw   $ra, -4($fp)
   la   $sp, 4($fp)
   lw   $fp, ($fp)
   jr   $ra

# COMP1521 18s1 Week 05 Lab
#
# void printMatrix(int nrows, int ncols, int m[nrows][ncols])
# {
#    for (int r = 0; r < nrows; r++) {
#       for (int c = 0; c < ncols; c++) {
#          printf(" %3d", m[r][c]);
#       }
#       printf("\n");
#    }
# }

   .text
   .globl printMatrix
printMatrix:
   # register usage:
   # nrows is $s0, ncols is $s1, r is $s2, c is $s3

   # set up stack frame for printMatrix()
   sw   $fp, -4($sp)
   la   $fp, -4($sp)
   sw   $ra, -4($fp)
   sw   $s0, -8($fp)
   sw   $s1, -12($fp)
   sw   $s2, -16($fp)
   sw   $s3, -20($fp)
   addi $sp, $sp, -24

   # set up registers
   move $s0, $a0
   move $s1, $a1
   
   # for r in 0..nrows-1
   li   $s2, 0
print_loop1:
   bge  $s2, $s0, print_end1
   # for c in 0..ncols-1
   li   $s3, 0
print_loop2:
   bge  $s3, $s1, print_end2
   # get m[r][c]
   li   $t1, 4            # sizeof(int)
   mul  $t0, $s2, $s1
   mul  $t0, $t0, $t1     # offset of start of row r
   mul  $t1, $s3, $t1     # offset of col c within row
   add  $t0, $t0, $t1     # offset from start of matrix
   add  $t0, $t0, $a2
   lw   $a0, ($t0)        # a0 = m[r][c]
   li   $v0, 1
   syscall                # printf("%d", a0)
   li   $a0, ' '
   li   $v0, 11
   syscall                # putchar(' ')
   addi $s3, $s3, 1       # c++
   j    print_loop2
print_end2:
   li   $a0, '\n'         # putchar('\n')
   li   $v0, 11
   syscall
   addi $s2, $s2, 1       # r++
   j    print_loop1
print_end1:

   # clean up stack and return
   lw   $ra, -4($fp)
   lw   $s0, -8($fp)
   lw   $s1, -12($fp)
   lw   $s2, -16($fp)
   lw   $s3, -20($fp)
   la   $sp, 4($fp)
   lw   $fp, ($fp)
   jr   $ra

# COMP1521 18s1 Week 05 Lab
#
# void multMatrices(int n, int m, int p,
#                   int A[n][m], int B[m][p], int C[n][p])
# {
#    for (int r = 0; r < n; r++) {
#       for (int c = 0; c < p; c++) {
#          int sum = 0;
#          for (int i = 0; i < m; i++) {
#             sum += A[r][i] * B[i][c];
#          }
#          C[r][c] = sum;
#       }
#    }
# }

   .text
   .globl multMatrices
multMatrices:
   sw   $fp, -4($sp)
   la   $fp, -4($sp)
   sw   $ra, -4($fp)
   sw   $s0, -8($fp)       # n is $s0
   sw   $s1, -12($fp)      # m is $s1
   sw   $s2, -16($fp)      # p is $s2
   sw   $s3, -20($fp)      # r is $s3  n
   sw   $s4, -24($fp)      # c is $s4  p
   sw   $s5, -28($fp)      # i is $s5  m
   sw   $s6, -32($fp)      # sum is $s6
   addi $sp, $sp, -32
   
   
   move $s0, $a0
   move $s1, $a1
   move $s2, $a2
   li   $s3, 0
   li   $s4, 0
   li   $s5, 0
   li   $s6, 0
   
   li   $t0, 4            # size = 4
   loop_row:
   
   bge  $s3, $s0, end_row
   
   li   $s4, 0
   loop_col:
   bge  $s4, $s2, end_col
   li   $s6, 0
   li   $s5, 0
   loop_sum:
   
   bge  $s5, $s1, end_sum
   
   # matrix A
   lw   $t3, 12($fp)      #address of A
   mul  $t1, $s3, $s1     # calculate r * m
   add  $t1, $t1, $s5     # calculate r * m + i
   mul  $t1, $t1, $t0     # calculate (r * m + i)*4
   add  $t1, $t1, $t3     # A + (r * m + i)*4   
   lw   $t1, ($t1)
   
   # matrix B
   lw   $t3, 8($fp)       #address of B
   mul  $t2, $s5, $s2     # calculate p * i
   add  $t2, $t2, $s4     # calculate p * i + c
   mul  $t2, $t2, $t0     # calculate (p * i + c)*4
   add  $t2, $t2, $t3     # B + (p * i + c)*4
   lw   $t2, ($t2)
   
   mul  $t2, $t1, $t2     # A[r][i] * B[i][c]
   add  $s6, $s6, $t2     # sum += A[r][i] * B[i][c]
   
   addi $s5, $s5, 1      # i++
   j loop_sum
   
   end_sum:
   lw   $t3, 4($fp)
   mul  $t1, $s3, $s2     # calculate r * p
   add  $t1, $t1, $s4     # calculate r * p + c
   mul  $t1, $t1, $t0     # calculate (r * p + c) * 4
   add  $t1, $t3, $t1     # C + (r * p + c) * 4
   sw   $s6, ($t1)
  
   addi $s4, $s4, 1       # c++
   j loop_col            #jump back tp loop_row and start another row
   
   end_col:
   
   addi $s3, $s3, 1
   j loop_row
   
   end_row: 
   
   la $sp, 4($fp)
   lw $ra, -4($fp)
   lw $s0, -8($fp)
   lw $s1, -12($fp)
   lw $s2, -16($fp)
   lw $s3, -20($fp)
   lw $s4, -24($fp)
   lw $s5, -28($fp)
   lw $s6, -32($fp)
   lw $fp, ($fp)
   jr $ra 
    
    
    
    
    
    
    
   
   # possible register usage:
   # n is $s0, m is $s1, p is $s2,
   # r is $s3, c is $s4, i is $s5, sum is $s6

   # set up stack frame for multMatrices()

   # implement above C code

   # clean up stack and return
