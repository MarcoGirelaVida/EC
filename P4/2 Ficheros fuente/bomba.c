// gcc -Og bomba.c -o bomba -no-pie -fno-stack-protector -fno-reorder-blocks
#undef  _FORTIFY_SOURCE
#define _FORTIFY_SOURCE 0

#include <stdio.h>	// para printf(), fgets(), scanf(), clearerr(stdin)
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define SIZE 16
#define TLIM 5

char password[]="abracadabra\n";	// contraseña
int  passcode  = 7777;			// pin

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
		"·························\n"
		"··· bomba desactivada ···\n"
		"·························\n"
		"\n");
	exit(0);
}

int main(){
	char pw[SIZE];
	int  pc, n;

	struct timeval tv1, tv2;	// gettimeofday() secs-usecs
	gettimeofday(&tv1, NULL);

	do	printf("\nIntroduce la contraseña: ");
	while (	clearerr(stdin),	// EOF (Ctrl-D)
		fgets(pw, SIZE, stdin) == NULL      );
	if    (	strncmp(pw,password,sizeof(password)) )
		boom();

	gettimeofday(&tv2, NULL);
	if    ( tv2.tv_sec - tv1.tv_sec > TLIM )
		boom();

	do  {	   printf("\nIntroduce el pin: ");
	 switch (n=scanf("%i",&pc)) {
	 case  0 : scanf("%*s")==0;	// match.failure
	 case EOF: clearerr(stdin);}}	// EOF (Ctrl-D)
	while (	n!=1 );
	if    (	pc != passcode )
		boom();

	gettimeofday(&tv1, NULL);
	if    ( tv1.tv_sec - tv2.tv_sec > TLIM )
		boom();

	defused();
}
