#################################################
# Imprimir la media en coma flotante
# fdiv64rel.s
# gcc -g -nostartfiles fdiv64rel.s -o fdiv64rel
#################################################

.data
f1:      	.string "media st  = %lf\n" # cadena de formato
f2:      	.string "media xmm = %lf\n" # cadena de formato
longlista:	.quad 32	# ojo: necesario .quad para la instrucción cvtsi2sdq
resultado:	.quad 0
media:		.double 0

#################################################

.text
        .extern printf
        .globl _start

_start: 

	# Ejemplo: edx:eax = 0xee6b28010 (64 000 000 016)
	# 64 000 000 016 / 32 = 2 000 000 000.5
	mov	$0xe6b28010, %eax	
	mov	$0xe, %edx

	mov	%eax, resultado(%rip)
	mov	%edx, resultado+4(%rip)

	# Versión pila
	fildl	longlista(%rip)	# entero 32 bits a coma flotante y apila en st(0)
	fildll	resultado(%rip)	# entero 64 bits a coma flotante y apila en st(0)
	fdivp				# st(0) / st(1), es decir resultado / longlista
 	fstl	media(%rip)		# media = st(0)
        movsd	media(%rip), %xmm0	# paso del parámetro media a printf
        lea	f1(%rip), %rdi		# formato
        mov	$1, %eax		# 1 double argument 
        call	printf

	# Versión registros multimedia
	cvtsi2sdq resultado(%rip), %xmm0	# xmm0 = resultado
	cvtsi2sdq longlista(%rip), %xmm1	# xmm1 = longlista
	divsd	%xmm1, %xmm0		# xmm0 = resultado / longlista
        lea	f2(%rip), %rdi		# formato
        mov	$1, %eax		# 1 double argument 
        call	printf

        movl	$60, %eax		# exit
        xorl	%edi, %edi		# 0
        syscall			# llamada a exit

#################################################
