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
		
		addi sp, sp, -4
		
		# Salva s0 na stack, pois ele sera mudado internamente e precisa retornar para o valor inicial
		sw s0, 0(sp)
		
		# fat(n) = a1
		# n = a0
		# count = s0
		# condicao parada t0
		
		addi a1, zero, 1
		addi t0, zero, 1
		add s0, zero, a0
		
loop:
		ble s0, t0, saiLoop
		mul a1, a1, s0
		addi s0, s0, -1
		j loop
		
saiLoop:
		# desempilha s0
		lw s0, 0(sp)
		# atualiza o sp
		addi sp, sp, 4
		
		jr ra
		


		
		
		
		
		
		
		
		