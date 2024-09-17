	.data
	.align 0
titulo0: .asciz "###		Jogo `Pedra, Papel e Tesoura		  ###\n"
titulo1: .asciz "###			INSIRA A JOGADA			  ###\n"
titulo2: .asciz "###	PEDRA(1) 	PAPEL(2) 	TESOURA(3)        ###\n"
titulo3: .asciz "###			DIGITE (4) PARA SAIR 		  ###\n"

str_pedra: .asciz "Pedra\n"
str_papel: .asciz "Papel\n"
str_tesoura: .asciz "Tesoura\n"

str_escolha_jogador: .asciz "###	voce escolheu:"
str_escolha_computador: .asciz "###	computador escolheu:"

erro_escolha: .asciz "###	Comando de jogada invalido!!!\n###	tente novamente\n"
barra_n: .asciz "\n"

	.text
	.align 2
	.globl main
	
	## s1 - escolha do jogador
	## s2 - escolha do computador
	
main:	## Printa o menu
	addi a7, zero, 4
	la a0, titulo0
	ecall
	
input_jogador:
	## print possibilidade de escolha
	addi a7, zero, 4
	la a0, titulo1
	ecall
	
	addi a7, zero, 4
	la a0, titulo2
	ecall
	
	addi a7, zero, 4
	la a0, titulo3
	ecall	
	
	addi a7, zero, 5
	ecall
	addi t1, zero, 1 ### temporario recebe valor 1
	addi t2, zero, 2 ### temporario recebe valor 2
	addi t3, zero, 3 ### temporario recebe valor 3
	addi t4, zero, 4 ### temporario recebe valor 4
	
	add s1, zero, a0
	bgt s1, t4, escolha_invalida
	blt s1, t1, escolha_invalida
	beq s1, t4, finaliza_programa
	j escolha_valida
	
escolha_invalida:

    addi a7, zero, 4            
    la a0, erro_escolha
    ecall
    j input_jogador
    
escolha_valida:                    

	addi a7, zero, 4
	la a0, str_escolha_jogador
	ecall
	
	mv a2, s1
	jal ra, printa_escolha
	
rand_int: # forncece numero pseudo-aleatorio para escolha do computador
	
	addi a7, zero, 30           # Obtem clock do processador
	ecall                      
	addi a7, zero, 40           # salva a semente
	ecall

	addi a0, zero, 0
	addi a1, zero, 2            # numero maximo de geracao de inteiros aleatorios
	addi a7, zero, 42
	ecall
	
	add s2, zero, a0           # salva em S2 a escolha do computador

	addi s2, s2, 1		# soma 1 para ficar no intervalo correto
	
	## print de string escolha do computador
	addi a7, zero, 4
	la a0, str_escolha_computador 
	ecall
	
	## printa escolha aleatoria do computador
	mv a2, s2
	jal ra, printa_escolha
	
    j finaliza_programa
 
printa_escolha:  	
	# temporario recebe jogadas possiveis
    addi t1, zero, 1 ### temporario recebe valor 1
	addi t2, zero, 2 ### temporario recebe valor 2
	addi t3, zero, 3 ### temporario recebe valor 3
    
    # Verifica qual foi a jogada feita
    beq a2, t1, printa_pedra
    beq a2, t2, printa_papel
    beq a2, t3, printa_tesoura
    	
printa_pedra:
	addi a7, zero,4
	la a0, str_pedra
	ecall
	jr ra
	
printa_papel:
	addi a7, zero,4
	la a0, str_papel
	ecall
	jr ra
	
printa_tesoura:
	addi a7, zero,4
	la a0, str_tesoura
	ecall
	jr ra

finaliza_programa:

	addi a7, zero, 10
	ecall
	
	
