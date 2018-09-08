// where_are_the_bits.c ... determine bit-field order
// COMP1521 Lab 03 Exercise
// Completed by z5142125 mingfang jiao

#include <stdio.h>
#include <stdlib.h>

struct _bit_fields {
   unsigned int a : 4,
                b : 8,
                c : 20;
};

union jj {
    struct _bit_fields fields;
    int value;
};

int main(void)
{
    union jj y;
    y.value = 4;
    printf("value of a is %d\n",y.fields.a);
    printf("value of b is %d\n",y.fields.b);
    printf("value of c is %d\n",y.fields.c);
    printf("So the bit-field order should like this |00000000000000000000|00000000|0000| \n");
}
