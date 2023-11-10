#include <stdio.h> // para printf()
#include <stdlib.h> // para exit()
#include <sys/time.h> // para gettimeofday(), struct timeval
int resultado=0;
#ifndef TEST
#define TEST 5
#endif
/* -------------------------------------------------------------------- */
#if TEST==1
/* -------------------------------------------------------------------- */
	#define SIZE 4
	unsigned lista[SIZE]={0x80000000, 0x00400000, 0x00000200, 0x00000001};
	#define RESULT 4
/* -------------------------------------------------------------------- */
#elif TEST==2
/* -------------------------------------------------------------------- */
	#define SIZE 8
	unsigned lista[SIZE]={0x7fffffff, 0xffbfffff, 0xfffffdff, 0xfffffffe,
						  0x01000023, 0x00456700, 0x8900ab00, 0x00cd00ef};
	#define RESULT 156
/* -------------------------------------------------------------------- */
#elif TEST==3
/* -------------------------------------------------------------------- */
	#define SIZE 8
	unsigned lista[SIZE]={0x0       , 0x01020408, 0x35906a0c, 0x70b0d0e0,
						  0xffffffff, 0x12345678, 0x9abcdef0, 0xdeadbeef};
	#define RESULT 116
/* -------------------------------------------------------------------- */
#elif TEST==4 || TEST==0
/* -------------------------------------------------------------------- */
	#define NBITS 20
	#define SIZE (1<<NBITS) // tamaño suficiente para tiempo apreciable
	unsigned lista[SIZE]; // unsigned para desplazamiento derecha lógico
	#define RESULT ( NBITS * ( 1 << NBITS-1 ) ) // pistas para deducir fórmula
/* -------------------------------------------------------------------- */
#else
	#error "Definir TEST entre 0..4"
#endif
/* -------------------------------------------------------------------- */

int popcount1(unsigned * array, size_t tam)
{
}


int popcount2(unsigned * array, size_t tam)
{
}


int popcount3(unsigned * array, size_t tam)
{
}

int popcount4(unsigned * array, size_t tam) //algo está mal
{

	int result = 0;
	for (size_t i=0; i<tam; i++){
		unsigned aux = array[i];
		asm("\n\t"
		  "clc				  \n"
	"ini4:					\n\t"
			"adc $0, %[r] 	\n\t"
			"shr %[x]		\n\t"
			"jne ini4		\n\t"
			"adc $0, %[r]	\n\t"
			: [r]"+r" (result)
			: [x]"r" (aux)		);
	}		

	return result;
}

int popcount5(unsigned * array, size_t tam)
{
}


// Todas las máscaras que utiliza el popcount6 
const unsigned long m1 = 0x5555555555555555; //binary: 0101...
const unsigned long m2 = 0x3333333333333333; //binary: 00110011..
const unsigned long m4 = 0x0f0f0f0f0f0f0f0f; //binary: 4 zeros, 4 ones ...
const unsigned long m8 = 0x00ff00ff00ff00ff; //binary: 8 zeros, 8 ones ...
const unsigned long m16 = 0x0000ffff0000ffff; //binary: 16 zeros, 16 ones ...
const unsigned long m32 = 0x00000000ffffffff; //binary: 32 zeros, 32 ones


int popcount6(unsigned *array, int tam)
{
}


int popcount7(unsigned* array, size_t len)
{
}


int popcount8(unsigned* array, size_t len)
{
}




int popcount9(unsigned* array, size_t len)
{
}


int popcount10(unsigned* array, size_t len)
{
}


/******************************************************/


void crono(int (*func)(), char* msg){
	struct timeval tv1,tv2; // gettimeofday() secs-usecs
	long tv_usecs; // y sus cuentas
	
	gettimeofday(&tv1,NULL);
	resultado = func(lista, SIZE);
	gettimeofday(&tv2,NULL);

	tv_usecs=(tv2.tv_sec -tv1.tv_sec )*1E6+
			 (tv2.tv_usec-tv1.tv_usec);
#if TEST==0
	printf( "%ld" "\n", tv_usecs);
#else
	printf("resultado = %d\t", resultado);
	printf("%s:%9ld us\n", msg, tv_usecs);
#endif
}



int main()
{
#if TEST==0 || TEST==4
	size_t i; // inicializar array
	for (i=0; i<SIZE; i++)
		lista[i]=i;
#endif
	crono(popcount1 , "popcount1 (lenguaje C - for)");
	crono(popcount2 , "popcount2 (lenguaje C - while)");
	crono(popcount3 , "popcount3 (leng.ASM-body while 4i)");
	crono(popcount4 , "popcount4 (leng.ASM-body while 3i)");
	crono(popcount5 , "popcount5 (CS:APP2e 3.49-group 8b)");
	crono(popcount6 , "popcount6 (Wikipedia- naive - 32b)");
	crono(popcount7 , "popcount7 (Wikipedia- naive -128b)");
	crono(popcount8 , "popcount8 (asm SSE3 - pshufb 128b)");
	crono(popcount9 , "popcount9 (asm SSE4- popcount 32b)");
	crono(popcount10, "popcount10(asm SSE4- popcount128b)");
#if TEST != 0
	printf("calculado = %d\n", RESULT);
#endif
	exit(0);
}