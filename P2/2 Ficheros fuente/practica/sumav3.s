# Esta versión modifica la declaración de la lista para que cada elemento sea  un int
# Además se imprime por printf y se acaba con exit()
# Para acceso rápido: 0x0fffffff 0x10000000
.section .data
lista:	.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000
		.int 0x10000000 	# En este caso tiene un tamaño de 16 * 4 bytes = 8 direcciones de 64 bits

longlista:	.int   (.-lista)/4
resultado:	.quad   0
formato: 	.asciz	"suma = %u = 0x%x hex\n"

.section .text
main: .global  main

	call	trabajar	# subrutina de usuario
	call	imprim_C	# printf()  de libC
	call	acabar_C	# exit()    de libC
	ret



trabajar:
	mov     $lista,		%rbx		# rbx = lista
	mov		longlista, 	%rcx		# rcx = longlista
	call	suma					# suma(&lista, longlista);
	mov		%eax, resultado 		# global resultado = local resultado (parte inferior), al ser little endian primero va el pequeño
	mov		%edx, resultado + 4		# global resultado = local resultado (parte superior)
	ret


suma:
	mov		$0, %edx	# resultado_suma_parte_superior = 0
	mov		$0, %eax	# resultado_suma_parte_inferior = 0
	mov		$0, %rsi	# i = 0

bucle:
	add		(%rbx,%rsi,4), %eax	# resultado_suma_parte_inferior += (lista[i])
	adc		$0,		%edx		# resultado_suma_parte_superior += acarreo, es mejor opción que hacer la etiqueta
	inc		%rsi				# i++
	cmp		%rsi, 	%rcx		# i == tam_lista ? iguales=true : iguales=false	
	jne		bucle				# if iguales == true, PC = goto bucle

	ret							# Devuelve suma




imprim_C:					# requiere libC
	mov		$formato, %rdi
	mov		resultado, %rsi
	mov		resultado, %rdx
	mov		$0, %eax		# varargin sin xmm
	call	printf			# == printf(formato, res, res);
	ret

acabar_C:					# requiere libC
	mov		resultado, %rdi
	call	_exit			# ==  exit(resultado)
	ret
