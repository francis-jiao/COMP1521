// BigNum.h ... LARGE positive integer values
// MINGFANG JIAO Z5142125

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <ctype.h>
#include "BigNum.h"

// Initialise a BigNum to N bytes, all zero
void initBigNum(BigNum *n, int Nbytes) {
    n->nbytes = Nbytes;
    n->bytes = calloc(Nbytes,sizeof(Byte));

    assert(n != NULL);
}

// Display a BigNum in decimal format
void showBigNum(BigNum n) {
    int isBegin = 1;
    int index = n.nbytes - 1;
    while(index >= 0){
        if(n.bytes[index] != '0'){
            isBegin = 0;
        }
        if(!isBegin){
            printf("%c",n.bytes[index]);
        }
        index--;
    }
}

// Set the value of a BigNum from a string of digits
// Returns 1 if it *was* a string of digits, 0 otherwise
int scanBigNum(char *s, BigNum *n) {
    int index = 0;
    while(s[index] != '\0'){
        if(s[index] != ' ' && !isdigit(s[index]))
            return 0;
        index++;
    }
    index = 0;
    while(s[index] == ' ' && s[index] != '\0') { 
        index++;
    }
    int begIndex = index;
    while(isdigit(s[index])){
        index++;
    } 
    int j = 0,i;
    if((index - begIndex) >= 20)
        n->bytes = realloc(n->bytes,sizeof(Byte)*(index - begIndex + 1));
    for(i = index - 1;i >= begIndex;i--){
        n->bytes[j++] = s[i];
    }
    n->nbytes = index - begIndex;

    return 1;
}


// Add two BigNums and store result in a third BigNum
void addBigNums(BigNum n, BigNum m, BigNum *res) {
    int index = 0, r = 0;
    int i, j, buff;

    int longer;
    if (n.nbytes < m.nbytes){
        longer = m.nbytes;
    }else{
        longer = n.nbytes; 
    }

    if(longer >= 20){
        res->bytes = realloc(res->bytes,sizeof(Byte) * (longer + 1));
    }

    for(i = 0, j = 0;i < n.nbytes && j < m.nbytes;i++, j++){
        buff = (n.bytes[i] - '0') + (m.bytes[j] - '0') + r;
        r = buff/10;
        res->bytes[index++] = buff%10 + '0';
    }

    //If b finishs first
    while(i < n.nbytes){
        buff = (n.bytes[i] - '0') + r;
        r = buff / 10;
        res->bytes[index++] = buff % 10 + '0';
        i++;
    }

    //if a finish first
    while(j < m.nbytes){
        buff = (m.bytes[j] - '0') + r;  
        r = buff / 10;  
        res->bytes[index++] = buff % 10 + '0';  
        j++; 
    }

    if(r)
        res->bytes[index++] = r + '0';
        
    res->nbytes = index;

}



