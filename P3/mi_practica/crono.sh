#!/bin/bash
# Cronometra el tiempo de ejecución del programa "popcount.c" dependiendo del nivel de optimización usado en la compilación.
# Guarda los resultados en un fichero "resultados_popcounts.csv" con el formato:
# <Nivel de optimización> , <Tiempos de ejecución separados por comas>

# Posteriormente genera un gráfico en gnuplot con los resultados obtenidos que se guarda en "resultados_popcounts.png".

# El script recibe como parámetro el número de veces que se desea ejecutar el programa para cada nivel de optimización (por defecto 100).
# Posteriormente se hará la media de estos valores para cada nivel de optimización y será lo que se guarde en el fichero "resultados_popcounts.csv".
# Ejemplo de uso: ./crono.sh 1000

# Primero se almacenan los parámetros de entrada en variables.
if [ $# -eq 0 ]; then
    echo "No se ha introducido ningún parámetro. Se ejecutará el programa 100 veces para cada nivel de optimización."
    ejecuciones=100
else
    echo "Se ejecutará el programa $1 veces para cada nivel de optimización."
    ejecuciones=$1
fi

# Compilo el programa con los distintos niveles de optimización.
gcc -DTEST=0 -O0 -o popcount00 popcount.c
gcc -DTEST=0 -O1 -o popcountO1 popcount.c
gcc -DTEST=0 -O2 -o popcountO2 popcount.c
gcc -DTEST=0 -Og -o popcountOg popcount.c

# Creo el fichero donde se guardarán los resultados.
if [ -f resultados_popcounts.csv ]; then
    rm resultados_popcounts.csv
fi
echo "Nivel_Optimizacion, T_popcount1, T_popcount2, T_popcount3, T_popcount4, T_popcount5, T_popcount6, T_popcount7, T_popcount8, T_popcount9, T_popcount10" > resultados_popcounts.csv

# Ejecuto el programa para cada nivel de optimización tantas veces como se haya indicado
# y guardo los tiempos de ejecución en el fichero "resultados_popcounts.csv".
for (( i=1; i<=$ejecuciones; i++ ))
do
    echo "Ejecución $i/$ejecuciones"
    echo -n "O0," >> resultados_popcounts.csv
    ./popcount00 >> resultados_popcounts.csv
    echo -n "O1," >> resultados_popcounts.csv
    ./popcountO1 >> resultados_popcounts.csv
    echo -n "O2," >> resultados_popcounts.csv
    ./popcountO2 >> resultados_popcounts.csv
    echo -n "Og," >> resultados_popcounts.csv
    ./popcountOg >> resultados_popcounts.csv
done
