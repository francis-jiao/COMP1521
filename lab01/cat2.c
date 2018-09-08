// Copy input to output
// COMP1521 18s1
// MINGFANG JIAO Z5142125
#include <stdlib.h>
#include <stdio.h>

void copy(FILE *, FILE *);

int main(int argc, char *argv[])
{
	copy(stdin,stdout);
	return EXIT_SUCCESS;
}

// Copy contents of input to output, char-by-char
// Assumes both files open in appropriate mode

void copy(FILE *input, FILE *output)
{
    char c = fgetc(input);
    while( c != EOF) {
        fputc(c, output);
        c = fgetc(input);
    }
}
