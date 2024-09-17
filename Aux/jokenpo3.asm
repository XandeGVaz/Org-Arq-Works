	.data
	.align 0
	
str_Inicio:     .asciz "Bem vindo ao pedra, papel, tesoura contra o computador!\n" 
str_pAgain:     .asciz "Deseja jogar novamente? 1 - sim; 2 - nao\n"
str_choice:     .asciz "Escolha sua jogada: 1 - pedra; 2 - papel; 3 - tesoura.\n"
str_warning:    .asciz "Escolha invalida. Tente novamente.\n"
str_goodbye:	.asciz "Ate mais!\n"
str_msg1:       .asciz "O computador escolheu: "
str_msg2:       .asciz "Voce escolheu: "
str_msg3:       .asciz "Voce venceu! Parabens!\n"
str_msg4:       .asciz "O computador venceu! Mais sorte da proxima vez.\n"
str_msg5:       .asciz "Empate!\n"
str_msg6:       .asciz "O historico de escolha do computador foi: "
str_rock:       .asciz "pedra.\n"
str_paper:      .asciz "papel.\n"
str_scisor:     .asciz "tesoura.\n"
str_space:		.asciz " "
str_nl:			.asciz "\n"

	.align 2
	
comp_array: 	.word 1, 2, 3
list_address:	.word

	.text
	.align 2
	.globl main
				
main:
	
	# Printa str_Inicio
    addi a7, zero, 4
    la a0, str_Inicio
    ecall
    
    
loopInput:					# Loop principal de execucao do programa
	
	# Printa str_choice
	addi a7, zero, 4
    la a0, str_choice
    ecall
    
    # Entrada do usuario
    addi a7, zero, 5
    ecall
    
    # Copia entrada do usuario para registradror salvo
    add s0, zero, a0
    
    # Endereco do array de valores de comparacao para s1
    la s1, comp_array
    lw t1, 0(s1)
    lw t2, 4(s1)
    lw t3, 8(s1)
    
    # Verifica se as escolhas foram validas
    beq s0, t1, validChoice1
    beq s0, t2, validChoice1
    beq s0, t3, validChoice1
    
    # Caso s0 != valores aceitos
    
    addi a7, zero, 4
    la a0, str_warning
    ecall
    j loopInput
    
validChoice1:
	
	# Printa str_msg2
	addi a7, zero, 4
    la a0, str_msg2
    ecall
    
    # Print da escolha do usuario
    add a0, zero, s0
    jal print_choice
    
	jal pc_choice
	# Salvando a escolha do pc em s2
	add s2, zero, a1
	
	# Print da escolha do pc
	add a0, zero, a1
	jal print_choice
	
	# Salva a escolha do pc na heap
	add a0, zero, s2
	jal save_choice
	
	# Compara os resultados
	add a0, zero, s0
	add a1, zero, s2
	jal compareResults
	
play_again:

	addi a7, zero, 4
    la a0, str_pAgain
    ecall

    addi a7, zero, 5
    ecall

	add t0, zero, a0
	lw t1, 0(s1)
    lw t2, 4(s1)
    
    beq t0, t1, loopInput
    beq t0, t2, ending
    
    addi a7, zero, 4
    la a0, str_warning
    ecall
    j play_again
    
ending:
	jal print_history
	add t0, zero, a0
	# Multiplica o numero de elementos por 8 = numero de bytes
	slli t0, t0, 3
	# Obtem o negativo
	not t0, t0
	addi t0, t0, 1
	# Desaloca a heap
	add t0, zero, a0
	addi a7, zero, 9
	ecall
	
	# Printa \n que ficou faltando
	addi a7, zero, 4
	la a0, str_nl
	ecall
	
	# Finaliza
	addi a7, zero, 4
    la a0, str_goodbye
    ecall

    addi a7, zero, 10
    ecall

print_choice:
	# Funcao printa o nome da jogada
	# a0: jogada escolhida

	# Guardando o valor de s0 na stack
	addi sp, sp, -4
	sw s0, 0(sp)
	
	# Carregando os valores de comparacao
	lw t1, 0(s1)
	lw t2, 4(s1)
	lw t3, 8(s1)
	
	# Copiando o valor do argumento para s0
	add s0, zero, a0
	
	bne s0, t1, case1
    addi a7, zero, 4            # Escolheu pedra
    la a0, str_rock
    ecall

case1:

    bne s0, t2, case2
    addi a7, zero, 4            # Escolheu papel
    la a0, str_paper
    ecall

case2: 

    bne s0, t3, case3
    addi a7, zero, 4            # Escolheu tesoura
    la a0, str_scisor
    ecall

case3:
	# Desempilhando o valor de s0
	lw s0, 0(sp)
	addi sp, sp, 4
	
	jr ra
	
pc_choice:
	# Calculo da escolha do computador
	# Retorno em a1
	
	addi a7, zero, 30           # Obtem o tempo em milisegundos -> retorno em a1
    ecall                       # sera usado como seed
    addi a7, zero, 40           # Setando a seed
    ecall

    addi a0, zero, 0
    # Limite superior dos numeros aleatorios
    addi a1, zero, 3
    addi a7, zero, 42
    ecall
    # Copia o numero aleatorio para a1
    add a1, zero, a0

    # Adequa o numero aleatorio para o padrao determinado
    addi a1, a1, 1

	# Printa str_msg1
    addi a7, zero, 4
    la a0, str_msg1
    ecall
    
    jr ra
    
save_choice:
	
	# Guardando o valor de s0 na stack
	addi sp, sp, -4
	sw s0, 0(sp)
	
	# Escolha do pc copiado para s0
	add s0, zero, a0
	
	la t0, list_address
	# t1 agora possui o endereco do lista na heap
	lw t1, 0(t0)
	
	addi a7, zero, 9
	addi a0, zero, 8
	ecall
	
	# Verifica se ainda nao foi guardado nada
	bnez t1, default
	sw a0, 0(t0)
	sw s0, 0(a0)
	
	# Desempilhar s0
	lw s0, 0(sp)
	addi sp, sp, 4
	jr ra 
	
default:
	# Ja tinha algo salvo na heap
	# A lista encadeada e descrita assim:	list_address -> (4 bytes)Val01 (4 bytes)End01 -> (4 bytes)Val02 (4 bytes)End02 -> ... 
	
	# Acesso do endereco do proximo elemento 
	lw t0 4(t1)
	bnez t0, increase
	
	# Como em 4(t1) ha apenas 0, salvamos o endereco do espaco alocado nesta posicao
	sw a0, 4(t1)
	
	# Salvamos a escolha do pc nos primeiros 4 bytes do espaco alocado na heap. Os outros 4 guardarao o endereco do proximo elemento alocado
	sw s0, 0(a0)
	
	# Desempilhar s0
	lw s0, 0(sp)
	addi sp, sp, 4
	jr ra
	
	# Incremento do t1
increase:
	add t1, zero, t0
	j default
	
compareResults:
	# a0: escolha do usuario -> s0
	# a1: escolha do pc -> s1
	
	addi sp, sp, -12
	sw s0, 0(sp)
	sw s1, 4(sp)
	sw s2, 8(sp)
	
	add s0, zero, a0
	add s1, zero, a1
	
	# Carregando valores de comparacao
	la s2, comp_array
	lw t1, 0(s2)
    lw t2, 4(s2)
    lw t3, 8(s2)
    
    add t4, zero, a0
    add t5, zero, a1

    bne s0, s1, notEqual
    addi a7, zero, 4            # Escolhas iguais
    la a0, str_msg5
    ecall
    
    j desempilhar1
    
notEqual:

    bne s0, t1, UserNOTRock
    bne s1, t2, User_wins         # User: Pedra; PC: Tesoura

    j User_loses                 # User: Pedra; PC: Papel

UserNOTRock:

    bne s0, t2, UserScisor
    bne s1, t1, User_loses        # User: Papel; PC: Tesoura

    j User_wins                  # User: Papel; PC: Pedra

UserScisor:

    bne s1, t1, User_wins         # User: Tesoura; Pc: papel    

    j User_loses                 # User: Tesoura; PC: pedra

User_wins:

    addi a7, zero, 4
    la a0, str_msg3
    ecall
    j desempilhar1

User_loses:

    addi a7, zero, 4
    la a0, str_msg4
    ecall
    j desempilhar1

desempilhar1:
	
	lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    addi sp, sp, 12
    jr ra
    
print_history:
	
	# Printa o historico de escolhas do pc
	# Retorna em a0 a quantidade de elementos alocados
	
	addi a7, zero, 4
    la a0, str_msg6
    ecall
	
	addi sp, sp, -4
	sw s0, 0(sp)
	
	addi t2, zero, 0
	
	# Carrega o endereco do endereco da lista em s0
	la s0, list_address
	# Carrega o endereco da lista em s0
	lw s0, 0(s0)
	
loop2:
	# Carrega o valor em t0
	lw t0, 0(s0)
	
	addi a7, zero, 1
	add a0, zero, t0
	ecall
	
	addi a7, zero, 4
    la a0, str_space           # Espaco
    ecall
    
    # Contador
    addi t2, t2, 1
    # Carrega em s0 o endereco do proximo elemnto
    lw s0, 4(s0)
    
    # Verifica se chegou no fim da lista
    bnez s0, loop2
    
    # Desempilha s0
    sw s0, 0(sp)
    addi sp, sp, 4
    
    add a0, zero, t2
    
	jr ra


