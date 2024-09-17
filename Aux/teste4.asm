		.data
		.align 0
str_src:	.asciz "Desafianteee, slk rapaiz"
		.align 2
ptr:		.word		# ptr para str_dst
		.text
		.align 2
		.globl main
main:		# contar o num de caracteres na str_src
		la s0, str_src
		lb t0, 0(s0)	# carregar o primeiro caractere
		addi t1, zero, 1
		
loop:		beq t0, zero, sai_loop
		addi s0, s0, 1
		lb t0, 0(s0)	# carregar o próx. caractere
		addi t1, t1, 1
		j loop
		
sai_loop:	# aloca memória
		addi a7, zero, 9
		add a0, zero, t1	# aloca a quantidade de caracteres da str_src
		ecall
		
		la s1, ptr
		sw a0, 0(s1)	# salvar o endereço da str_dst
		
		# copiar
		# s0 : str_src
		# s2 : str_dst
		la s0, str_src
		la s1, ptr
		lw s2, 0(s1)
		
loop2:		lb t0, 0(s0)	# pega um caractere de str_src
		sb t0, 0(s2)	# copia o caractere em str_dst
		addi s0, s0, 1
		addi s2, s2, 1
		bne t0, zero, loop2

		# imprimir a str_dst copiada
		addi a7, zero, 4
		la a1, ptr
		lw a0, 0(a1)
		ecall
		
		# finalizar o programa
		addi a7, zero, 10
		ecall
		