// gcc -Og bomba.c -o bomba -no-pie -fno-guess-branch-probability

#include <stdio.h>	// para printf(), fgets(), scanf()
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define SIZE 100
#define TLIM 5

char PASSWORD[]="abracadabra\n";	// contraseÃ±a
int  PASSCODE  = 7777;			// pin

void boom(void){
	printf(	"\n"
		"***************\n"
		"*** BOOM!!! ***\n"
		"***************\n"
		"\n");
	exit(-1);
}

void defused(void){
	printf(	"\n"
		"·······························\n"
		"······ bomba desactivada ······\n"
		"·······························\n"
		"\n");
	exit(0);
}

int main(){
	char pw[SIZE];
	int  pc, n;

	struct timeval tv1,tv2;	// gettimeofday() secs-usecs
	gettimeofday(&tv1,NULL);

	do	printf("\nIntroduce la contraseÃ±a: ");
	while (	fgets(pw, SIZE, stdin) == NULL );
	if    (	strncmp(pw,PASSWORD,sizeof(PASSWORD)) )
	    boom();

	gettimeofday(&tv2,NULL);
	if    ( tv2.tv_sec - tv1.tv_sec > TIME_LIMIT )
	    boom();

	do  {	printf("\nIntroduce el pin: ");
	 if ((n=scanf("%i",&pc))==0)
		scanf("%*s")    ==1;         }
	while (	n!=1 );
	if    (	pc != PASSCODE )
	    boom();

	gettimeofday(&tv1,NULL);
	if    ( tv1.tv_sec - tv2.tv_sec > TIME_LIMIT )
	    boom();

	defused();
}
