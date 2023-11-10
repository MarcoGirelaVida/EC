.section .data
#Suma de numeros enteros sin signo de 32 bits sobre dos registros de 32
#bits, usando el primero para el acarreo

#lista:		.int 0x0fffffff, 0x0fffffff, 0x0fffffff, 0x0fffffff
#		.int 0x0fffffff, 0x0fffffff, 0x0fffffff, 0x0fffffff
#		.int 0x0fffffff, 0x0fffffff, 0x0fffffff, 0x0fffffff
#		.int 0x0fffffff, 0x0fffffff, 0x0fffffff, 0x0fffffff
lista:		.int 0x10000000, 0x10000000, 0x10000000, 0x10000000
		.int 0x10000000, 0x10000000, 0x10000000, 0x10000000
		.int 0x10000000, 0x10000000, 0x10000000, 0x10000000
		.int 0x10000000, 0x10000000, 0x10000000, 0x10000000
longlista:	.int   (.-lista)/4
resultado:	.quad   0
  formato: 	.asciz	"suma = %lu = 0x%lx hex\n"

# opción: 1) no usar printf, 2)3) usar printf/fmt/exit, 4) usar tb main
# 1) as  suma.s -o suma.o
#    ld  suma.o -o suma					1232 B
# 2) as  suma.s -o suma.o				6520 B
#    ld  suma.o -o suma -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2
# 3) gcc suma.s -o suma -no-pie –nostartfiles		6544 B
# 4) gcc suma.s -o suma	-no-pie				8664 B

.section .text
#_start: .global _start
main: .global  main
	mov     $lista, %rbx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);
	mov  %eax, resultado
	mov  %edx, resultado+4

	mov   $formato, %rdi
	mov   resultado,%rsi	# ahora 64 bits
	mov   resultado,%rdx	# ahora 64 bits
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);
	
	mov $0, %edi
	call _exit


suma:
	#push     %rdx
	mov  $0, %eax		#resultado
	mov  $0, %edx		#acumulador
	mov  $0, %rsi 		#indice
bucle:
	add  (%rbx,%rsi,4),  %eax
	jnc   noacar		#salta si no hay carry
	inc   %edx		#cuento el acarreo
noacar: inc %rsi
	cmp   %rsi,%rcx
	jne    bucle
	ret


#acabar_L:
#	mov        $60, %rax
#	mov  resultado, %edi
#	syscall			# == _exit(resultado)
#	ret

#acabar_C:			# requiere libC
#	mov  resultado, %edi
#	call _exit		# ==  exit(resultado)
#	ret
