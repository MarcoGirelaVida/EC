.section .data
lista:		.int 1,1,  1,1,  1,1,  1,1,  1,1,  1,1,  1,1,  1,1	# En este caso tiene un tamaño de 16 * 4 bytes = 8 direcciones de 64 bits
longlista:	.int   (.-lista)/4
resultado:	.int   0
  formato: 	.asciz	"suma = %u = 0x%x hex\n"

# opción: 1) no usar printf, 2)3) usar printf/fmt/exit, 4) usar tb main
# 1) as  suma.s -o suma.o
#    ld  suma.o -o suma					1232 B
# 2) as  suma.s -o suma.o				6520 B
#    ld  suma.o -o suma -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
# 3) gcc suma.s -o suma -no-pie –nostartfiles		6544 B
# 4) gcc suma.s -o suma	-no-pie				8664 B

.section .text
_start: .global _start
# main: .global  main

	call trabajar	# subrutina de usuario
#	call imprim_C	# printf()  de libC
	call acabar_L	# exit()   del kernel Linux
#	call acabar_C	# exit()    de libC
	ret



trabajar:
	mov     $lista, %rbx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);
	mov  %eax, resultado # global resultado = local resultado
	ret



suma:
	push     %rdx	# Guardo rdx
	mov  $0, %eax	# suma = 0
	mov  $0, %rdx	# i = 0
bucle:
	add  (%rbx,%rdx,4), %eax	# suma = (lista[i]) + suma
	inc   %rdx					# i++
	cmp   %rdx,%rcx				# i == tam_lista ? iguales=true : iguales=false	
	jne    bucle				# if iguales == true, goto bucle

	pop   %rdx					# Saca rdx
	ret							# Devuelve suma



#imprim_C:			# requiere libC
#	mov   $formato, %rdi
#	mov   resultado,%esi
#	mov   resultado,%edx
#	mov          $0,%eax	# varargin sin xmm
#	call  printf			# == printf(formato, res, res);
#	ret

acabar_L:
	mov        $60, %rax	# argv[0] = exit
	mov  resultado, %edi	# argv[1] = resultado
	syscall					# syscall argv[0] argv[1] (syscall exit resultado)
	ret

#acabar_C:			# requiere libC
#	mov  resultado, %edi
#	call _exit		# ==  exit(resultado)
#	ret
