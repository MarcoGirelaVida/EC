# Practica 4, Actividad 4.1: explicacion de la bomba

# CONTRASEÑA: abracadabra
# 	 PIN: 7777

# MODIFICADA: hola,adios.
#	 PIN: 123

# Describe el proceso logico seguido
# primero: para descubrir las claves, y
# despues: para cambiarlas 

# Pensado para ejecutar mediante "source explain.gdb"
# o desde linea de comandos con gdb -q -x explain.gdb
# Renombrar temporalmente el fichero "bomba-gdb.gdb"
# para que no se cargue automat. al hacer "file bomba"

# funciona sobre la bomba original, para recompilarla
# usar la orden gcc en la primera linea de bomba.c
# gcc -Og bomba.c -o bomba -no-pie -fno-stack-protector -fno-reorder-blocks

########################################################

### cargar el programa
    file bomba
### util para la sesion interactiva, no para source/gdb -q -x
#   layout asm
#   layout regs
### arrancar programa, notar automatizacion para teclear hola y 123
    br main
    run < <(echo -e hola\\n123\\n)
### hicimos ni hasta call boom, antes pide contraseña y tecleamos hola
### si entramos en boom explota y hay que empezar de nuevo
### la decision se toma antes, justo antes de call boom
### hay un je que se salta la bomba, y el test anterior
### activaria ZF si el retorno de strncmp produjera 0,
### es decir, si 0==strncmp(rdi,rsi,edx)
#   0x4012a6 <main+80>:		lea    0x30(%rsp),%rdi
#   0x4012ab <main+85>:		mov    $0xd,%edx
#   0x4012b0 <main+90>:		lea    0x2db9(%rip),%rsi        # 0x404070 <password>
#   0x4012b7 <main+97>:		call   0x4010b0 <strncmp@plt>
#   0x4012bc <main+102>:	test   %eax,%eax
#   0x4012be <main+104>:	je     0x4012c5 <main+111>
#   0x4012c0 <main+106>:	call   0x401216 <boom>
#   0x4012c5 <main+111>:	mov    ...
### avancemos hasta strncmp para consultar los valores
    br *main+97
    cont
### escribir "hola" cuando pida contraseña, resuelto ya en run
### ahora mismo estamos viendo de donde sale la contraseña
#   0x4012b0 <main+90>:		lea    0x2db9(%rip),%rsi        # 0x404070 <password>
### imprimir la contraseña y recordar que esta en 0x404070 longitud 13B
#   p(char*    )$rsi
#   p(char*    )0x404070
    p(char[0xd])password
### dejar que strncmp salga mal y corregir eax=0 para evitar boom()
    ni
    set $eax=0
    ni
    ni
### siguiente bomba es por tiempo
#   0x4012cd <main+119>:	call   0x4010e0 <gettimeofday@plt>
#   0x4012d2 <main+124>:	mov    (%rsp),%rax
#   0x4012d6 <main+128>:	sub    0x10(%rsp),%rax
#   0x4012db <main+133>:	cmp    $0x5,%rax
#   0x4012df <main+137>:	jle    0x4012e6 <main+144>
#   0x4012e1 <main+139>:	call   0x401216 <boom>
#   0x4012e6 <main+144>:	lea    ...
### avanzar hasta el cmp
    br *main+133
    cont
### falsear tiempo=0 por si acaso se ha tardado en teclear
    set $eax=0
    ni
    ni
### siguiente bomba compara resultado scanf con variable de memoria
#   0x40133a <main+228>:	mov    0x2d28(%rip),%eax        # 0x404068 <passcode>
#   0x401340 <main+234>:	cmp    %eax,0x2c(%rsp)
#   0x401344 <main+238>:	je     0x40134b <main+245>
#   0x401346 <main+240>:	call   0x401216 <boom>
#   0x40134b <main+245>:	lea    
### avanzar hasta cmp para consultar valores
    br *main+234
    cont
### escribir "123" cuando pida pin, resuelto ya en run
### imprimir el pin y recordar que esta en 0x404068 tipo int
#   p*(int*)0x404068
    p (int )passcode
### corregir sobre la marcha EAX para que cmp salga bien
    set $eax=123
    ni
    ni
### siguiente bomba es por tiempo
#   0x401355 <main+255>:	call   0x4010e0 <gettimeofday@plt>
#   0x40135a <main+260>:	mov    0x10(%rsp),%rax
#   0x40135f <main+265>:	sub    (%rsp),%rax
#   0x401363 <main+269>:	cmp    $0x5,%rax
#   0x401367 <main+273>:	jle    0x40136e <main+280>
#   0x401369 <main+275>:	call   0x401216 <boom>
#   0x40136e <main+280>:	call   0x401236 <defused>

### avanzar hasta el cmp
    br *main+269
    cont
### falsear tiempo=0 por si acaso se ha tardado en teclear
    set $eax=0
    ni
    ni
### hemos llegado a defused, fin del programa
    ni

########################################################

### permitir escribir en el ejecutable
    set write on
### reabrir ejecutable con permisos r/w
    file bomba
### realizar los cambios
#   set {char[13]}0x404070="hola,adios.\n"
#   set {int     }0x404068=123
    set {char[13]}&password="hola,adios.\n"
    set {int     }&passcode=123
### comprobar las instrucciones cambiadas
    p (char[0xd])password
    p (int      )passcode
### salir para desbloquear el ejecutable
    quit

########################################################

