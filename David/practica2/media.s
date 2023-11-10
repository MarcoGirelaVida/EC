.section .data
#ifndef TEST
#define TEST 20
#endif
	.macro linea
  #if TEST==1
			.int -1,-1,-1,-1
#elif TEST==2
			.int 0x04000000, 0x04000000, 0x04000000, 0x04000000
#elif TEST==3
			.int 0x08000000, 0x08000000, 0x08000000, 0x08000000
#elif TEST==4
			.int 0x10000000, 0x10000000, 0x10000000, 0x10000000
#elif TEST==5
			.int 0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff
#elif TEST==6
			.int 0x80000000, 0x80000000, 0x80000000, 0x80000000
#elif TEST==7
			.int 0xf0000000, 0xf0000000, 0xf0000000, 0xf0000000
#elif TEST==8
			.int 0xf8000000, 0xf8000000, 0xf8000000, 0xf8000000
#elif TEST==9
			.int 0xf7ffffff, 0xf7ffffff, 0xf7ffffff, 0xf7ffffff
#elif TEST==10
			.int 100000000, 100000000, 100000000, 100000000
#elif TEST==11
			.int 200000000, 200000000, 200000000, 200000000
#elif TEST==12
			.int 300000000, 300000000, 300000000, 300000000
#elif TEST==13
			.int 2000000000, 2000000000, 2000000000, 2000000000
#elif TEST==14
			.int 3000000000, 3000000000, 3000000000, 3000000000
#elif TEST==15
			.int -100000000, -100000000, -100000000, -100000000
#elif TEST==16
			.int -200000000, -200000000, -200000000, -200000000
#elif TEST==17
			.int -300000000, -300000000, -300000000, -300000000
#elif TEST==18
			.int -2000000000, -2000000000, -2000000000, -2000000000
#elif TEST==19
			.int -3000000000, -3000000000, -3000000000, -3000000000

#else
	.error "Definir TEST entre 1..19"
#endif
	.endm
lista: .irpc i,1234
		linea
		.endr

longlista:	.int   (.-lista)/4
media:		.int 	0
resto:		.int	0
resultado:	.quad   0
formato: .ascii "resultado \t = %18ld (sgn)\n"
	 	 .ascii "\t\t = 0x%18lx (hex)\n"
	 	 .asciz "\t\t = 0x %08x %08x \n"

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
	
	mov %edx, %ecx 
	mov %eax, %r8d

	mov   $formato, %rdi
	mov   resultado,%rsi	# ahora 64 bits
	mov   resultado,%rdx	# ahora 64 bits
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res, EDX, EAX);
	
	mov $0, %edi
	call _exit


suma:
	mov  $0, %edi		
	mov  $0, %ebp		
	mov  $0, %rsi 		#indice
bucle:
	#add  (%rbx,%rsi,4),  %eax
	mov  (%rbx,%rsi,4),  %eax
	cltd				#extiende signo EDX:EAX
	add %eax, %edi		#sumamos los LSB
	adc %edx, %ebp		#sumamos los MSB y el acarreo de los LSB
	inc  %rsi
	cmp   %rsi,%rcx
	jne    bucle
	
	mov %edi, %eax
	mov %ebp, %edx	
	
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
