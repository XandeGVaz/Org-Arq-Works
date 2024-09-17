	.data
	.align 0
titulo0: .asciz "###		Jogo `Pedra, Papel e Tesoura		  ###\n"
titulo1: .asciz "###			INSIRA A JOGADA			  ###\n"
titulo2: .asciz "###	PEDRA(1) 	PAPEL(2) 	TESOURA(3)        ###\n"
titulo3: .asciz "###			DIGITE (4) PARA SAIR 		  ###\n"

str_pedra: .asciz "Pedra\n"
str_papel: .asciz "Papel\n"
str_tesoura: .asciz "Tesoura\n"

str_escolha_jogador: .asciz "### Voce escolheu:"
str_escolha_computador: .asciz "###	Computador escolheu:"

erro_escolha: .asciz "###	Comando de jogada invalido!!!\n###	tente novamente\n"
barra_n: .asciz "\n"

ganha_computador: .asciz "### Resultado: computador venceu!\n"
ganha_jogador: .asciz "### Resultado: jogador venceu!\n"
empate: .asciz "### Resultado: empate!\n" 

.text
.align 2
.globl main
	
	## s1 - escolha do jogador
	## s2 - escolha do computador
	## s3 - flag que indica se o programa deve ser finalizado
	
main:	## Printa o menu
	addi a7, zero, 4
	la a0, titulo0
	ecall
	li s3, 0
loop_de_jogo:
	li t1, 1
	beq s3, t1, finaliza_programa
	jal input_jogador
	jal printa_escolha
	jal rand_int
	jal printa_escolha
	mv a0, s1
	mv a1, s2
	jal verifica_jogada
	j loop_de_jogo

#Função de input de jogada do usuário
#	Função que imprime as possíveis jogadas na tela, lê jogada do usuário e verifica se ela é
#	válida:
#		->Se sim, imprime a jogada feita e a salva no registrador s1
#			- e se a entrada feita for 4, o programa é finalizado antes do retorno
#		->Se não, continua printando possíveis escolhas 
#	Parâmetros: não possui
#	Retorno:
#		-> a0: escolha feita
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

	## leitura de escolha
	addi a7, zero, 5
	ecall

	## registramento de possibilidades
	addi t1, zero, 1 ### temporario recebe valor 1
	addi t2, zero, 2 ### temporario recebe valor 2
	addi t3, zero, 3 ### temporario recebe valor 3
	addi t4, zero, 4 ### temporario recebe valor 4
	
	add a1, zero, a0
	bgt a1, t4, escolha_invalida
	blt a1, t1, escolha_invalida
	beq a1, t4, finaliza_programa
	j escolha_valida
	
escolha_invalida:
    addi a7, zero, 4            
    la a0, erro_escolha			# print de erro na entrada dada pelo usuário
    ecall
    j input_jogador				# usuário tem que dar outra entrada
    
escolha_valida:

	## Começo de print da escolha do jogador
	addi a7, zero, 4
	la a0, str_escolha_jogador
	ecall

	## Salvamento e retorno de escolha válida do jogador
	mv s1, a1	
	mv a0, a1	

	ret							# retorna para loop de game



#Função forncece numero pseudo-aleatorio para escolha do computador e a retorna
#	Parâmetros: não possui
#	Retorno:
#		->a0: escolha feita aleatoriamente pelo computador
rand_int:
	
	addi a7, zero, 30           # Obtem clock do processador
	ecall                      
	addi a7, zero, 40           # salva a semente
	ecall

	addi a0, zero, 0
	addi a1, zero, 2            # numero maximo de geracao de inteiros aleatorios
	addi a7, zero, 42
	ecall
	
	add s2, zero, a0           # salva em S2 a escolha do computador

	addi s2, s2, 1			   # soma 1 para ficar no intervalo correto
	
	## Começo de print de string escolha do computador
	addi a7, zero, 4
	la a0, str_escolha_computador 
	ecall
	
	mv a0, s2					# retorna escolha feita pelo computador
	ret
 

#Função que recebe escolha em a0 e printa objeto (pedra, papel..._) correspondente
#	Parâmetros:
#		->a0: escolha feita anteriormente que deve ser printada
#	Retorno: não possui
printa_escolha:  	
	# Temporario recebe jogadas possiveis
    addi t1, zero, 1 ### temporario recebe valor 1
	addi t2, zero, 2 ### temporario recebe valor 2
	addi t3, zero, 3 ### temporario recebe valor 3
    
    ## Verifica qual foi a jogada feita
    beq a0, t1, printa_pedra
    beq a0, t2, printa_papel
    beq a0, t3, printa_tesoura
    	
printa_pedra:
	addi a7, zero,4
	la a0, str_pedra
	ecall
	ret
	
printa_papel:
	addi a7, zero,4
	la a0, str_papel
	ecall
	ret
	
printa_tesoura:
	addi a7, zero,4
	la a0, str_tesoura
	ecall
	ret



verifica_jogada:
	# Temporario recebe jogadas possiveis
    addi t1, zero, 1 ### temporario recebe valor 1
	addi t2, zero, 2 ### temporario recebe valor 2
	addi t3, zero, 3 ### temporario recebe valor 3

	# Verifica empate
	beq a0, a1, res_empate

	# Se a0 não estiver nas extremidades, verifica dentro
	beq a0, t1, cont1
	beq a0, t3, cont1

# Se não estiver nas pontas vai para verificação dentro
# Dentro ganha o valor que for maior
dentro:
	blt a0, a1, res_computador
	j res_jogador

# Passo de transição para saber se os valores estão de fato nas extremidades
cont1:
	beq a1, t1, pontas
	beq a1, t3, pontas
	j dentro

# Se a0 e a1 estão nas extremidades, ganha a pedra ( valor menor) 
pontas:
	blt a0, a1, res_jogador
	j res_computador

res_empate:
	# Printa empate
	la a0, empate
	li a7, 4
	ecall

	# Retorna 2 para resultado de empate
	li a0,2
	ret						#Retorna para loop de jogo

res_jogador:
	# Printa que jogador ganhou
	la a0, ganha_jogador
	li a7, 4
	ecall

	# Retorna 1 para resultado de vitória do jogador
	li a0,1
	ret						#Retorna para loop de jogo

res_computador:
	# Printa que computador ganhou
	la a0, ganha_computador
	li a7, 4
	ecall

	# Retorna 0 para resultado de vitória para computadpr
	li a0,1
	ret						#Retorna para loop de jogo


finaliza_programa:
	addi a7, zero, 10
	ecall
	
	
