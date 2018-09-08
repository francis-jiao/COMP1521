// Recursive factorial function
//
// Doesn't do error checking
// n < 1 or not a number produce n! = 1

#include <stdio.h>

int fac(int);  // fac :: int -> int

int main(void)
{
    int n = 0;
    printf("n  = ");
    scanf("%d", &n);
    printf("n! = %d\n", fac(n));
    return 0;
}

int fac(int n)
{
    if (n <= 1)
        return 1;
    else
        return n * fac(n-1);
}
