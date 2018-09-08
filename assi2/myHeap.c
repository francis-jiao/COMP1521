// COMP1521 18s1 Assignment 2
// Implementation of heap management system
// MINGFANG JIAO Z5142125

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "myHeap.h"

// minimum total space for heap
#define MIN_HEAP  4096
// minimum amount of space for a free Chunk (excludes Header)
#define MIN_CHUNK 32

#define ALLOC     0x55555555
#define FREE      0xAAAAAAAA

typedef unsigned int uint;   // counters, bit-strings, ...

typedef void *Addr;          // addresses

typedef struct {             // headers for Chunks
   uint  status;             // status (ALLOC or FREE)
   uint  size;               // #bytes, including header
} Header;

static Addr  heapMem;        // space allocated for Heap
static int   heapSize;       // number of bytes in heapMem
static Addr *freeList;       // array of pointers to free chunks
static int   freeElems;      // number of elements in freeList[]
static int   nFree;          // number of free chunks 


// initialise heap
int initHeap(int size){
    if(size < MIN_HEAP) {                          // If N is less than the minimum heap size (4096)
        size = MIN_HEAP;                           // then N is set to the minimum heap size. 
    }
    while(size%4 != 0){                            // The value of N is rounded up to the nearest multiple of 4.
        size++;
    }
    heapMem = malloc(size*sizeof(char));           // malloc space for the heap memory 
    if(heapMem == NULL) return -1;                 // if malloc is unsuccessful return -1
    memset(heapMem, 0, size*sizeof(char));         // zeroes out the entire region
    Header *start = (Header*)heapMem;              // set the entire heap to be the first FREE chunk
    start->status = FREE;
    start->size = size;
    freeElems = size/MIN_CHUNK;                    // set freeElems to be size/MIN_CHUNK
    freeList = malloc(freeElems*sizeof(void *));   // malloc sapce for the freeList
    if(freeList == NULL) return -1;                // if malloc is unsuccessful return -1
    memset(freeList,0,freeElems);                  // zeros out the entire freeList
    freeList[0] = heapMem;                         // put the first FREE chunk in the freeList
    nFree = 1;                                     // nFree = 1
    heapSize = size;                               // set the size to be the value of heapSize
    return 0;                                   
}

// clean heap
void freeHeap()
{
   free(heapMem);
   free(freeList);
}

// allocate a chunk of memory
void *myMalloc(int size) {
    if(size <1) return NULL;                            
    if(nFree <= 0) return NULL;
    while(size%4 != 0){                                // increase the size to the multiple of 4 if it's not
        size++;
    }                       
    int headersize = sizeof(Header);                   // set the headersize (won't change through the function)
    int needsize = headersize+size;                    // set the needed size of the chunk (won't change through the function)
    Header *curr;                                      
    int fit = 0;                                       // use to record the fittest chunk's size
    int record = 0;                                    // record the index of the fittest chunk
    int i = 0;                                         
    while(i < nFree){                                  // stop untill i = nFree
        curr = (Header *) freeList[i];                 // record freechunk of freeList[i] in the curr
        if(curr->size >= needsize && fit == 0){          // if fit = 0 and curr chunk size >= needsize
            fit = curr->size;                             // record index and curr chunk size
            record = i;
        }
        if(curr->size >= needsize && curr->size <= fit){  // if curr chunk size >= needsize and curr chunk size <= the fittest chunk size recorded so far
            fit = curr->size;                                // record index and curr chunk size
            record = i;      
        }
        i++;
    }
    
    Header *insert = (Header *) freeList[record];         // insert to be the header of the fittest free chunk
    if(fit < needsize){
        return NULL;                                      
    }
    int breakchunk = needsize+MIN_CHUNK;   
    if(fit >= breakchunk){                                            // if split the chunk
        insert->status = ALLOC;                                       // value the size and staus
        insert->size = needsize;
        Addr newposition = (Addr)((char *)freeList[record]+needsize); // set the address of new free chunk
        Header *newchunk =  (Header *) newposition;                   
        newchunk->size = fit-needsize;                                // value the size and status
        newchunk->status = FREE;
        freeList[record] = newposition;                               // put it in the freeList
    }else {                                                           // fit-needsize < breankchunk
        insert->status = ALLOC;                                      
        while(record < nFree-1){
            freeList[record] = freeList[record+1];                    // move all the free chunks forward for one index in the freeList
            record++;                                                
        }
        freeList[record] = NULL;                                      
        nFree--;
    }
    Addr usable = (Addr)((char *)insert+headersize);                  //return a pointer to the first usable byte of data in the chunk
    return usable;
}



void myFree(void *block){
    uint headersize = sizeof(Header);                                         // headersize
    Addr heapTop = (Addr)((char *)heapMem + heapSize);                        // address of the end of the heap
    if(nFree == 0 || block == NULL || block > heapTop || block < heapMem){    // if block is out of the heap address or NULL, then exit
        fprintf(stderr,"Attempt to free unallocated chunk\n");
        exit(1);
    }
    int myfree = 0;                              
    Addr freechunk = (Addr) ((char *)block - headersize);                     // set freechunk to be the address of block - headersize
    Addr find = heapMem;                                                      
    while(find < heapTop ){                                                   // for every chunk in the heap
        if(find == freechunk) {                                               // if freechunk is not any header of an ALLOC chunk in the heap
            if(((Header *)find)->status == ALLOC){                            // exit
                myfree = 1;
                break;
            }
        }
        find = (Addr)(((Header *)find)->size + (char *)find);
    }
    if(myfree == 0){
        fprintf(stderr,"Attempt to free unallocated chunk\n");
        exit(1);
    }
    
    Header *release = (Header *)freechunk;                                    // set release to be the header of the freechunk
    release->status = FREE;                                                   
    memset(block,0,(release->size-headersize));                               // zeros out the block part
    
    nFree++;                                                 
    freeList[nFree - 1] = freechunk;                                          // put the new free chunk in the end of the free chunk
    
   
    Addr temp;
    int i = 0, n = 0;                                                         // use bubble sort to put the new free chunk in the corresponding location
    for (i = 0; i < nFree; i++){                                              // keep the freeList ascending
        for (n = i + 1; n < nFree; n++){
            if ((char *)freeList[i] > (char *)freeList[n]){
                temp =  freeList[i];
                freeList[i] = freeList[n];
                freeList[n] = temp;
            }
        }
    }
    
    i = 0;                                                                // from the start of freeList
    Addr preaddr = freeList[i];                                           // address of freeList[i]
    Addr aftaddr = freeList[i + 1];                                       // address of freeList[i+1]
    Header *prechunk = (Header *)preaddr;                                 // Header pointer of freeList[i]
    Header *aftchunk = (Header *)aftaddr;                                 // Header pointer of freeList[i+1]
    for(i = 0;i < nFree-1;i++ ){
        preaddr = freeList[i];                                            // go throught the entire freeList from the head
        aftaddr = freeList[i + 1];                                        // from the first two free chunks in the freeList
        prechunk = (Header *)preaddr;                                     
        aftchunk = (Header *)aftaddr;                                     // if these two free chunks are adjacent in physical memory
        if((Addr)((char *)preaddr + prechunk->size) == aftaddr){          // merge these two chunks
            prechunk->size = prechunk->size + aftchunk->size;             // revalue the size
            memset(aftaddr, 0, aftchunk->size);                           // zeros out the free chunk 
            n = i+1;                                                      
            while(n < nFree-1){                                           // move all the free chunks forward for one index in the freeList
                freeList[n] = freeList[n+1];
                n++;
            }
            nFree--;                                                      // nFree-1
            i--;                                                          
        }                                                                 // check the next two free chunks if they need to merge
    }                                                                      
}

// convert pointer to offset in heapMem
int  heapOffset(void *p)
{
   Addr heapTop = (Addr)((char *)heapMem + heapSize);
   if (p == NULL || p < heapMem || p >= heapTop)
      return -1;
   else
      return p - heapMem;
}



// dump contents of heap (for testing/debugging)
void dumpHeap()
{
   Addr    curr;
   Header *chunk;
   Addr    endHeap = (Addr)((char *)heapMem + heapSize);
   int     onRow = 0;

   curr = heapMem;
   while (curr < endHeap) {
      char stat;
      chunk = (Header *)curr;
      switch (chunk->status) {
      case FREE:  stat = 'F'; break;
      case ALLOC: stat = 'A'; break;
      default:    fprintf(stderr,"Corrupted heap %08x\n",chunk->status); exit(1); break;
      }
      printf("+%05d (%c,%5d) ", heapOffset(curr), stat, chunk->size);
      onRow++;
      if (onRow%5 == 0) printf("\n");
      curr = (Addr)((char *)curr + chunk->size);
   }
   if (onRow > 0) printf("\n");
}




