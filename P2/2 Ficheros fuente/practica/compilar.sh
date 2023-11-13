#!/bin/bash

# opción: 1) no usar printf, 2)3) usar printf/fmt/exit, 4) usar tb main
# 1) as  suma.s -o suma.o
#    ld  suma.o -o suma					1232 B
# 2) as  suma.s -o suma.o				6520 B
#    ld  suma.o -o suma -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
# 3) gcc suma.s -o suma -no-pie –nostartfiles		6544 B
# 4) gcc suma.s -o suma	-no-pie				8664 B

nombre_fichero=$1

# 2)
# Ensamblar el código fuente y generar un archivo objeto (.o)
#as "$nombre_fichero.s" -o "$nombre_fichero.o"

# Enlazar el archivo objeto y generar un ejecutable
#ld "$nombre_fichero.o" -o "${nombre_fichero}_exe" -lc --dynamic-linker /lib64/ld-linux-x86-64.so.2

# Borramos el archivo objeto
#rm "$nombre_fichero.o"

#3)
gcc -g "$nombre_fichero.s" -o "${nombre_fichero}_exe" -no-pie