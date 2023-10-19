// gcc -Og rand.c -o rand

#include <stdlib.h>	// rand
#include <stdio.h>	// printf
#include <time.h>	// time

// popcount 128 bits para mejorar prestaciones
int popcount10 (unsigned *array, size_t len)
{
    size_t i;
    unsigned long x1;
    unsigned long x2;
    long val;
    int result=0;

    if (len & 0x3)
        printf("leyendo 128b pero "
               "len no múltiplo de 4\n");

    for (i=0; i<len; i+=4)
    {
        x1 = *(unsigned long*) &array[i ];
        x2 = *(unsigned long*) &array[i+2];

        asm ("popcnt %[x1], %[val] \n" //altern.
             "popcnt %[x2], %[x1] \n" //usando
             "add %[x1], %[val] \n" //lea(),
            : [val] "=&r" (val)
            : [x1]  "r"   (x1),
              [x2]  "r"   (x2)
            );

        result += val;
    }

    return result;
}
/*

· Sin early clobber: [val] "=r" (val)
De forma predeterminada, el compilador asume que todas las entradas se consumirán antes de que se escriban los registros de salida, por lo que se permite usar los mismos registros para ambos. Esto conduce a un mejor código cuando sea posible, pero si la suposición es incorrecta, las cosas fallarán catastróficamente. 
En este caso x1 venía en %rdx y lo reusa para val, creando el siguiente código erróneo:

    11f7:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
    11fc:	f3 48 0f b8 d6       	popcnt %rsi,%rdx
    1201:	48 01 d2             	add    %rdx,%rdx

· Con early clobber: [val] "=&r" (val)
El marcador "early clobber" es una forma de decirle al compilador que esta salida se escribirá antes de que se haya consumido toda la entrada, por lo que no puede compartir un registro con ninguna entrada.

    11f7:	f3 48 0f b8 ce       	popcnt %rsi,%rcx
    11fc:	f3 48 0f b8 f7       	popcnt %rdi,%rsi
    1201:	48 01 f1             	add    %rsi,%rcx
    
· Alternativamente se podría haber escrito:
        asm ("popcnt %[x1], %[x1] \n"
             "popcnt %[x2], %[val] \n"
             "add %[x1], %[val] \n"
            : [val] "=&r" (val)
            : [x1]  "r"   (x1),
              [x2]  "r"   (x2)
            );
que genera el código correcto siguiente:
    11f7:	f3 48 0f b8 f6       	popcnt %rsi,%rsi
    11fc:	f3 48 0f b8 cf       	popcnt %rdi,%rcx
    1201:	48 01 f1             	add    %rsi,%rcx

· Alternativamente se podría haber escrito:
        asm ("popcnt %[x1], %[x1] \n"
             "popcnt %[x2], %[x2] \n"
             "lea (%[x1],%[x2]), %[val] \n"
            : [val] "=r" (val)
            : [x1]  "r"   (x1),
              [x2]  "r"   (x2)
            );        
que genera el código correcto siguiente:
    11f7:	f3 48 0f b8 d2       	popcnt %rdx,%rdx
    11fc:	f3 48 0f b8 f6       	popcnt %rsi,%rsi
    1201:	48 8d 14 32          	lea    (%rdx,%rsi,1),%rdx

*/


#define SIZE (1<<16)
unsigned array[SIZE];

int main (void)
{
    unsigned r;
    unsigned i;

    srand (time (NULL));
    for (i=0; i<SIZE; i++)
    {
       r = (unsigned) rand () + (unsigned) rand ();
       array[i] = r;
       printf ("i = %8u: r = %10u = 0x%08x\n",
               i,r,r);
    }

    printf ("popcount10 = %d\n",popcount10 (array,SIZE));
    
    return 0;
}


