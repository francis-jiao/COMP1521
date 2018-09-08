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
