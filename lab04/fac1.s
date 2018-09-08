# COMP1521 18s2 Week 04 Lab
# Compute factorials, no functions


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
   # set up stack frame
   sw    $fp, -4($sp)       # push $fp onto stack
   la    $fp, -4($sp)       # set up $fp for this function
   sw    $ra, -4($fp)       # save return address
   sw    $s0, -8($fp)       # save $s0 to use as ... int n; $s0
   sw    $s1, -12($fp)      # save $s1 to use as ... int i; $s1
   sw    $s2, -16($fp)      # save $s2 to use as ... int fac; $s2
   addi  $sp, $sp, -20      # reset $sp to last pushed item

   # code for main()
   li    $s0, 0             # n = 0;
   
   la    $a0, msg1
   li    $v0, 4
   syscall                  # printf("n  = ");
   li    $v0, 5
   syscall                  # scanf("%d", &n);                    
   move  $s0, $v0
   li	 $s2, 1
   li    $s1, 1             # fac = 1     for (i = 1; i <= n; i++) fac *= i;
                            #            printf("n! = %d\n", fac);
                            #            return 0;
   for_loop:
   bgt   $s1, $s0, end_for
   mul   $s2, $s2, $s1
   addi  $s1, $s1, 1
   j for_loop
   
   end_for:
  
   la    $a0, msg2         #printf("n! = ");
   li    $v0, 4
   syscall
   
   move  $a0, $s2          #printf("%d",fac);
   li    $v0, 1
   syscall

   la    $a0, eol
   li    $v0, 4
   syscall                  # printf("\n");

   # clean up stack frame
   lw    $s2, -16($fp)      # restore $s2 value
   lw    $s1, -12($fp)      # restore $s1 value
   lw    $s0, -8($fp)       # restore $s0 value
   lw    $ra, -4($fp)       # restore $ra for return
   la    $sp, 4($fp)        # restore $sp (remove stack frame)
   lw    $fp, ($fp)         # restore $fp (remove stack frame)

   li    $v0, 0
   jr    $ra                # return 0

