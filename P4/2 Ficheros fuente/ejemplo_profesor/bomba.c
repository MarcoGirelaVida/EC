// gcc -Og bomba.c -o bomba -no-pie -fno-stack-protector -fno-reorder-blocks
#undef  _FORTIFY_SOURCE
#define _FORTIFY_SOURCE 0

#include <stdio.h>	// para printf(), fgets(), scanf(), clearerr(stdin)
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()
#include <sys/time.h>	// para gettimeofday(), struct timeval

/*----------------------------------------------------------*/
// VARIABLES GLOBALES
#define SIZE 16
#define TIME_LIMIT 5
char PASSWORD[]="abracadabra\n";	// contraseña
int  PASSCODE  = 7777;				// pin

/*----------------------------------------------------------*/
// FUNCIONES
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

/*----------------------------------------------------------*/
// MAIN
int main(){
	/**********************************************************/
	// DECLARACIONES
	char input_password[SIZE];
	int  input_passcode, n;

	struct timeval instante_entrada, instante_salida;

	/**********************************************************/
	// CONTRASEÑA

	// 1. Registra el instante de entrada
	gettimeofday(&instante_entrada, NULL);		

	// 2. Lee el input del usuario
	do
	{
		printf("\nIntroduce la contraseña: ");

	} 	while (	clearerr(stdin), fgets(input_password, SIZE, stdin) == NULL );	
	

	// 3. Si la contraseña introducida no coincide con la real explota
	if    (	strncmp(input_password, PASSWORD, sizeof(PASSWORD)) )
		boom();


	// 4. Registra el intante de salida
	gettimeofday(&instante_salida, NULL);

	// 5. Si ha tardado demasiado en poner la contraseña explota
	if    ( instante_salida.tv_sec - instante_entrada.tv_sec > TIME_LIMIT )	
		boom();

	/**********************************************************/
	// PIN

	// 1. Registra el instante de entrada
	// gettimeofday(&instante_entrada, NULL);		

	// 2. lee el input del usuario
	do
	{
		printf( "\nIntroduce el pin: " );

		switch ( n = scanf("%i", &input_passcode) )
		{
			case  0 : scanf("%*s") == 0;	// match.failure
			case EOF: clearerr(stdin);
		}
	
	}	while (	n != 1 );


	// 3. Si el pin introducido no coincide con el real explota
	if    (	input_passcode != PASSCODE )
		boom();

	// (Atajo no muy bueno desde el punto de vista de la legibilidad)
	// 4. Está registrando el segundo instante de salida (en la variable instante de entrada)
	gettimeofday(&instante_entrada, NULL);

	// 5. Si ha tardado demasiado en poner el PIN explota
	if    ( instante_entrada.tv_sec - instante_salida.tv_sec > TIME_LIMIT )
		boom();

	/**********************************************************/
	// DESACTIVACIÓN
	// Si ha llegado hasta aquí sin explotar significa que ha sido desactivada
	defused();
}
