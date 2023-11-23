// gcc -O2 bomba_Marco_Girela.c -o bomba_Marco_Girela -no-pie -fno-stack-protector -fno-reorder-blocks
#undef  _FORTIFY_SOURCE
#define _FORTIFY_SOURCE 0

#include <stdio.h>	// para printf(), fgets(), scanf(), clearerr(stdin)
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()
#include <sys/time.h>	// para gettimeofday(), struct timeval
#include <stdbool.h>

/*----------------------------------------------------------*/
// VARIABLES GLOBALES
#define SIZE 10
#define TIME_LIMIT 5
char PASSWORD[]="wjojwuei\n";	// contraseña es realmente "teletubi\n"
char encriptada[SIZE];
int  PASSCODE  = 2011;				// pin real es 4022

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

bool esprimo(int n)
{
	int i;
	for (i = 2; i < n; i++)
		if (n % i == 0)
			return false;
	return true;
}

bool espar(int n)
{
	if (n % 2 == 0){
		return true;
	}
	return false;
}

char * encriptar(char * constrasena)		// realmente el algoritmo puede dar lugar a que varias contraseñas sean correctas, pero bueno, mejor para el que quiera acertarla
{
	for (int i = 0; i < SIZE-2; i++)
	{
		if (espar((int) constrasena[i]))
		{
			//fprintf(stderr, "El caracter %d de la contraseña es: %c \n", i, constrasena[i]);
			//fprintf(stderr, "Al encriptarlo, al ser par, se tranforma en: %c \n", (char) ((int)constrasena[i] + 3));
			encriptada[i] = (char) ((int)constrasena[i] + 3);
		}
		else if (esprimo((int) constrasena[i]))
		{
			//fprintf(stderr, "El caracter %d de la contraseña es: %c \n", i, constrasena[i]);
			//fprintf(stderr, "Al encriptarlo, al ser primo, se tranforma en: %c \n", (char) ((int)constrasena[i] + 5));
			encriptada[i] = (char) ((int)constrasena[i] + 5);
		}
		else
		{
			//fprintf(stderr, "El caracter %d de la contraseña es: %c \n", i, constrasena[i]);
			//fprintf(stderr, "Al encriptarlo, al no ser ni primo ni par, se tranforma en: %c \n", constrasena[i]);
			encriptada[i] = constrasena[i];
		}
	}
	encriptada[SIZE-2] = '\n';
	encriptada[SIZE-1] = '\0';

	return encriptada;
}



int funcion_confusa(int n){		// Se llama cuando el pin proporcinado es menor que el real
	return n+2;
}

int funcion_confusaa(int n){		// Se llama cuando el pin proporcinado es igual que el real	
	return n*8;
}

int funcion_confuusa(int n){		// Se llama cuando el pin proporcinado es menor que el real
	return n*3;
}

int funcion_confuusaa(int n){		// Se llama cuando el pin proporcinado es menor que el real
	return n+1;
}

/*----------------------------------------------------------*/
// MAIN
int main(){
	/**********************************************************/
	// DECLARACIONES
	char input_password[SIZE];
	int  input_passcode, n;

	/**********************************************************/
	// CONTRASEÑA
	//char * original_encriptada = encriptar("teletubi\n");
	//printf("\n La contraseñao original encriptada es: %s\n", original_encriptada);

	// 2. Lee el input del usuario
	do
	{
		printf("\nIntroduce la contraseña: ");

	} 	while (	clearerr(stdin), fgets(input_password, SIZE, stdin) == NULL );	
	
	char * input_password_encriptada = encriptar(input_password);

	// 3. Si la contraseña introducida no coincide con la real explota
	if    (	strncmp(input_password_encriptada, PASSWORD, sizeof(PASSWORD)) )
		boom();

	printf("Enhorabuena, has acertado la contraseña\n");

	// PIN

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

	int numero;
	// 3. Si el pin introducido no coincide con el real explota
	if    (	input_passcode < PASSCODE )				// input < 2011 < 4022		--> EXPLOTA
		numero = funcion_confusa(input_passcode);

	else
	{
		if (input_passcode > PASSCODE*3)			// input > 2011*3 > 4022	--> EXPLOTA
			numero = funcion_confuusaa(input_passcode);	

		else if (input_passcode == PASSCODE)		// input == 2011 < 4022		--> EXPLOTA
			numero = funcion_confuusa(input_passcode);

		else if (input_passcode == PASSCODE*2)		// input == 2011*2 == 4022	--> DEFUSED
			numero = funcion_confusaa(input_passcode);
													// input == (cualquier otra cosa) --> EXPLOTA
		else
			boom();
	}

	// DESACTIVACIÓN
	// Si ha llegado hasta aquí sin explotar significa que ha sido desactivada
	printf("\n El numero es: %d\n", numero);

	if (numero == 32176){		// 4022 * 8
		defused();
	}
	else{
		boom();
	}

	return 0;
}
