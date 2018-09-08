# COMP1521 18s2 Week 04 Lab
# Compute factorials, recursive function


# COMP1521 18s2 Week 04 Lab
# Compute factorials, recursive function


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
   sw    $s0, -8($fp)       # save $s0 to use as ... int n;
   addi  $sp, $sp, -12      # reset $sp to last pushed item

   #  code for main()
   li    $s0, 0             # n = 0;
   
   la    $a0, msg1
   li    $v0, 4
   syscall                  # printf("n  = ");

   li    $v0, 5
   syscall
   move  $s0, $v0           #scanf("%d", &n);
   
   la    $a0, msg2
   li    $v0, 4
   syscall
   
   
   move  $a0, $s0
   jal fac
   
   move  $a0, $v0
   li    $v0, 1
   syscall
   

   la    $a0, eol
   li    $v0, 4
   syscall                  # printf("\n");
   
   move  $a0, $s0
   li    $v0, 1
   syscall
   
   la    $a0, eol
   li    $v0, 4
   syscall    

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
   addi  $sp, $sp, -12      # reset $sp to last pushed item;
   
   
   move  $s0, $a0
   
   li    $t0, 1
      
   if:
   
     bgt   $s0, $t0, recursion
     li    $v0, 1
     j end
   
   
   recursion:
   
     addi  $t1, $s0, -1
     move  $a0, $t1
     jal fac
     mul   $v0, $s0, $v0
   end:
   
   lw    $s0, -8($fp)
   lw    $ra, -4($fp)
   la    $sp, 4($fp)
   lw    $fp, ($fp)
   
   jr    $ra
    
   
   
