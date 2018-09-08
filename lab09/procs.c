// COMP1521 17s2 Lab08 ... processes competing for a resource
 
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>

#define MAXLINE BUFSIZ

void copyInput(char *);

void handler(int);

int main(void)
{
   struct sigaction act;
   memset (&act, 0, sizeof(act));

   if (fork() != 0) {
      signal(SIGINT, SIG_IGN);
      copyInput("Parent");
   }
   else if (fork() != 0) {
      signal(SIGINT, SIG_IGN);
      copyInput("Child");
   }
   else {
      //signal(SIGINT, SIG_IGN);
      copyInput("Grand-child");
   }
   return 0;
}

void copyInput(char *name)
{
   pid_t mypid = getpid();
   char  line[MAXLINE];
   printf("%s (%d) ready\n", name, mypid);
   while (fgets(line, MAXLINE, stdin) != NULL) {
      printf("%s %d: %s", name, getppid(),line);
      sleep(3);
   }
   printf("%s quitting\n", name);
   return;
}



void handler(int i){
}
