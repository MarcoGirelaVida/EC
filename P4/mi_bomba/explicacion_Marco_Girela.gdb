# Me rindo, no sé desencriptar mi propia bomba, da igual cuanto lo simplifique el compilador siempre se inventa las cosas y no hay manera de seguirlo
# Practica 4, Actividad 4.1: explicacion de la bomba

# CONTRASEÑA: teletubi
# 	 PIN: 4022


# Describe el proceso logico seguido
# primero: para descubrir las claves, y
# despues: para cambiarlas 

# funciona sobre la bomba original, para recompilarla
# usar la orden gcc en la primera linea de bomba.c
# gcc -Og bomba_Marco_Girela.c -o bomba_Marco_Girela -no-pie -fno-stack-protector -fno-reorder-blocks

########################################################

Para sacar la contraseña
1 - PRIMERA APROXIMACIÓN
1. Ponemos un breakpoint en main y avanzamos hasta que explote la bomba
        br main
1.2 Podremos ver que el procedimiento es igual que el que se sigue en la bomba que se nos dio en ejemplo,
    no obstante si miramos el contenido de los registros que se dan como parametro a la función strcmp veremos que 
    no son, ni la contraseña que hemos introducido, ni la real (puede probarse a ponerla, se verá que explota).

2 - ANALISIS DE LA FUNCIÓN ENCRIPTAR
3. Si somos un poco avispados se verá que, a diferencia de la bomba de ejemplo, se entra en una función llamada "encriptar", vamos ver como funciona,
    para ello ponemos un breakpoint en la entrada de la función encriptar
        br *(main+79)
    Y entramos con stepi
        stepi
2.2 Ahora ante lo desconocido, lo mejor es ir ejecutando e ir fijándose poco a poco en lo que va haciendo la función.
    Tras observar un buen rato (probablemente es lo que más tiempo lleve de mi bomba) observará que 

Mete 0 en ebx, compara con 7