		.data
		.align 0
str1:	.asciz "Digite um n "
str2:	.asciz "O fatorial de "
str3:	.asciz " eh "

		.text
		.align 2
		.globl main

main:
		# Impressao da string
		addi a7, zero, 4
		la a0, str1
		ecall
		
		# Leitura do numero
		addi a7, zero, 5
		ecall
		add s0, zero, a0
		
		# Chamada de funcao (ret em a1)
		jal fatorial
		
		# Imprime strings e resultados
		
		addi a7, zero, 4
		la a0, str2
		ecall
		
		addi a7, zero, 1
		add a0, zero, s0
		ecall
		
		addi a7, zero, 4
		la a0, str3
		ecall
		
		# Resultado do fatorial esta em a1
		addi a7, zero, 1
		add a0, zero, a1
		ecall
		
		addi a7, zero, 10
		ecall
		
fatorial: # Reservar um espaco na pilha
		
		addi sp, sp, -8
		
		# Salva a0 na stack, pois ele sera mudado internamente e precisa retornar para o valor inicial
		sw a0, 0(sp)
		# Salva ra na stack, pois este sera alterado na chamada recursiva de funcao
		sw ra, 4(sp)
		
		# retorno a1
		beq a0, zero, retorna1
		
		# decrementa o parametro
		addi a0, a0, -1
		jal fatorial
		
		addi a0, a0, 1
		mul a1, a1, a0
		j retorna
		
retorna1:
		addi a1, zero, 1
		
retorna:
		lw ra, 4(sp)
		lw a0, 0(sp)
		addi sp, sp, 8
		jr ra


		
		
		
		
		
		
		
		
