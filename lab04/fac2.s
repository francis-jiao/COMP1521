# COMP1521 18s2 Week 04 Lab
# Compute factorials, iterative function


### Global data

   .data
msg1:
   .asciiz "n  = "
msg2:
   .asciiz "n! = "
eol:
   .asciiz "\n"

### main() function
   .text
   .globl main
main:
   #  set up stack frame
   sw    $fp, -4($sp)       # push $fp onto stack
   la    $fp, -4($sp)       # set up $fp for this function
   sw    $ra, -4($fp)       # save return address
   sw    $s0, -8($fp)       # save $s0 to use as ... int n;  n = $s0
   addi  $sp, $sp, -12      # reset $sp to last pushed item

   #  code for main()
   li    $s0, 0             # n = 0;
   
   la    $a0, msg1
   li    $v0, 4
   syscall                  # printf("n  = ");

   li    $v0, 5
   syscall
   move  $s0, $v0           #scanf("%d", &n);
                                                
   la    $a0, msg2          #printf("n! =");
   li    $v0, 4
   syscall
   
   
   jal   fac  

   move  $a0, $v0
   li    $v0, 1
   syscall
   
   la    $a0, eol
   li    $v0, 4
   syscall                  # printf("\n");

   # clean up stack frame
   lw    $s0, -8($fp)       # restore $s0 value
   lw    $ra, -4($fp)       # restore $ra for return
   la    $sp, 4($fp)        # restore $sp (remove stack frame)
   lw    $fp, ($fp)          # restore $fp (remove stack frame)

   li    $v0, 0
   jr    $ra                # return 0

# fac() function

fac:
   sw    $fp, -4($sp)       # push $fp onto stack
   la    $fp, -4($sp)       # set up $fp for this function
   sw    $ra, -4($fp)       # save return address
   sw    $s0, -8($fp)       # save $s0 to use as ... int n;
   sw    $s1, -12($fp)      # save $s1 to use as ... int i;
   sw    $s2, -16($fp)      # save $s2 to use as ... int prod;
   addi  $sp, $sp, -20      # reset $sp to last pushed item;
   
       # put value of n in $s0
   
   li    $s1, 1             # i = 1;
   
   li    $s2, 1             # prod = 1;
   
   loop_start:
   
   bgt   $s1, $s0, end_loop
   mul   $s2, $s2, $s1
   addi  $s1, $s1, 1
   j loop_start
   
   end_loop:
   move  $v0, $s2
   
   
   lw    $s2, -16($fp)
   lw    $s1, -12($fp)
   lw    $s0, -8($fp)
   lw    $ra, -4($fp)
   la    $sp, 4($fp)
   lw    $fp, ($fp)
   jr    $ra
   
   
   
   
   
   
   
   
   
   
   
   
   
   
