# Alunos(N usp):
# - Vitor Alexandre Garcia Vaz - 14611432
# - Pedro Gasparelo Leme - 14602421
# - Matheus Cavalcanti de Santana - 13217506

	.data
	.align 0
titulo0: .asciz "###		Jogo  Pedra, Papel e Tesoura		  ###\n"
titulo1: .asciz "###			INSIRA A JOGADA			  ###\n"
titulo2: .asciz "###	PEDRA(1) 	PAPEL(2) 	TESOURA(3)        ###\n"
titulo3: .asciz "###			DIGITE (4) PARA SAIR 		  ###\n"

str_pedra: .asciz "Pedra\n"
str_papel: .asciz "Papel\n"
str_tesoura: .asciz "Tesoura\n"

str_escolha_jogador: .asciz "	Jogador escolheu:"
str_escolha_computador: .asciz "	Computador escolheu:"

erro_escolha: .asciz "	Comando de jogada invalido!!!\n	tente novamente\n"
barra_n: .asciz "\n"

ganha_computador: .asciz "### Resultado: computador venceu!\n\n"
ganha_jogador: .asciz "### Resultado: jogador venceu!\n\n"
empate: .asciz "### Resultado: empate!\n\n"

escolhas_computador: .asciz "### Escolhas feitas pelo computador:\n"
escolha: .asciz "Escolha "
dois_pontos: .asciz ": "
sem_jogadas: .asciz "### Não houveram jogadas do computador\n"

	.text
	.align 2
	.globl main
	
	## s1 - escolha do jogador
	## s2 - escolha do computador
	## s3 - endereço do ponteiro para primeiro elemento da lista
	## s4 - número de elementos da lista encadeada
	
main:
	## Printa o menu
	addi a7, zero, 4
	la a0, titulo0
	ecall

	## Criação da lista de jogadas do computador
	jal cria_lista
loop_de_jogo:
	## Entrada de escolha do jogador(usuário) -> se igual a 4 o programa acaba
	jal input_jogador
	jal printa_escolha

	## Escolha randômica da jogada pelo computador
	jal rand_int
	jal printa_escolha

	## Adição da escolha do computador na lista
	mv a0, s2
	mv a1, s3
	jal add_nodo

	## Verificação da rodada (de quem ganhou: computador ou jogador)
	mv a0, s1
	mv a1, s2
	jal verifica_rodada

	j loop_de_jogo					# continua no loop (cada passagem corresponde a uma rodada)
finaliza_programa:
	## Printa a lista de escolhas do computador
	mv a0, s3
	jal print_lista

	## Finaliza programa
	li a7, 10
	ecall


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


#Função que verifica a jogada e informa quem ganhou ou se houve empate
#	Parâmetros:
#		->a0: jogada feita pelo jogador
#		->a1: jogada feita pela máquina
#	Retorna (em a0):
#		->0: compputador venceu
#		->1: jogador venceu
#		->2: houve empate
verifica_rodada:
	# Temporario recebe jogadas possiveis
    addi t1, zero, 1 ### temporario recebe valor 1
	addi t2, zero, 2 ### temporario recebe valor 2
	addi t3, zero, 3 ### temporario recebe valor 3

	# Verifica empate
	beq a0, a1, res_empate

	# Verifica se escolhas estão nas extremidades (caso estejam a0 + a1  = 4) 
	# , sendo 1 e 3 os valores nas pontas
	li t4, 4
	add t5, a0, a1
	beq t5, t4, pontas

# Se não estiver nas pontas (a0 + a1 != 4) vai para verificação dentro
# Sendo que dentro ganha o valor que for maior
dentro:
	blt a0, a1, res_computador
	j res_jogador

# Se a0 e a1 estão nas extremidades (a0 + a1 = 4), ganha a pedra ( valor menor) 
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


#Função responsável por criar a lista encadeada
#		Esta função cria a variável que conterá o endereço para o primeiro elemento da lista e
#	retorna o endereço dessa variável (ponteiro)
#	Parâmetros: não possui
#	Retorno(a0):
#		-> endereço do ponteiro que aponta para o primeiro elemento da lista
cria_lista:
	## Aloca 4 bytes na memória heap para o ponteiro
	li a7, 9
	li a0, 4
	ecall
	sw zero, 0(a0)

	## Salva ponteiro para início da lista em s3
	mv s3, a0

	## Iguala o número de elementos da lista (s4) a 0, pois a lista está ainda vazia
	li s4, 0

	ret									# retorna para a main


#Função responsável pela adição de nodos à lista
#	Se a lista estiver vazia, essa função conecta o ponteiro de início ao nodo adicionado
#	Parâmentos:
#		->a0: valor a ser adicionado na lista( nesta aplicação é a última jogada do computador)
#		->a1: endereço do ponteiro que aponta para o início da lista
#	Retorno(a0):
#		-> endereço para nodo adicionado (o qual possui o valor informado)
add_nodo:
	mv a3, a0 							# move escolha feita para a3, pois a0 será usado na alocação

	## Aloca 8 bytes na memória heap para um nó (elemento) da lista (valor da jogada + ponteiro para próximo elemento)
	li a7, 9
	li a0, 8
	ecall

	## Armazena última escolha feita pelo jogador no nodo criado
	sw a3, 0(a0)
	sw zero, 4(a0)						# endereço para próximo elemento ainda não existe


	## Verifica se a lista está vazia
	lw t1, 0(a1)						# t1 = ponteiro_lista
	beq t1, zero, lista_vazia

	## a4 recebe endereço do primeiro nó da lista e funcionará como cursor na lista (ele irá percorrê-la)
	lw a4, 0(a1)						# a4 = ponteiro_lista (&elemento1)
	addi t1, a4, 4						# pula 4 bytes (t1 = &elemento1.prox)
	lw a4, 0(t1)						# a4 = elemento1.prox (&elementon) (recebe endereço do pŕoximo elemento)

lista_preenchida:
	beq a4, zero, final_encontrado
	addi t1, a4, 4						# pula 4 bytes (t1 = &elementon.prox)
	lw a4, 0(t1)						# a4 = elementon.prox (&elementon++) (recebe endereço do pŕoximo elemento)
	j lista_preenchida

final_encontrado:
	## Ponteiro de próximo elemento (do último nodo) adquire endereço nodo adicionado
	sw a0, 0(t1)
	addi s4, s4, 1						# incrementa número de elementos da lista
	ret

lista_vazia:
	## Ponteiro de início de lista adquire endereço do primeiro nodo
	sw a0, 0(a1)
	addi s4, s4, 1						# incrementa o número de elementos da lista
	ret

#Função responsável por printar os elementos de uma lista
#	Parâmetros:
#		->a0: endereço do ponteiro que aponta para início da lista
print_lista:
	li a4, 1							# índice i

	## Verifica se lista não está vazia antes da impressão
	lw t1, 0(a0)
	beq t1, zero, sem_print

	## Carrega endereço do primeiro elemento da lista
	lw a1, 0(a0)

	## Começo de print das escolhas
	la a0, escolhas_computador
	li a7, 4
	ecall

print_lista_loop:
	## Verifica se cursor a1já chegou no final da lista 
	beq a1, zero, print_lista_fim

	## Imprime strings pŕevias ao elemento que será impresso
	la a0, escolha
	li a7, 4
	ecall

	mv a0, a4	
	li a7, 1
	ecall

	la a0, dois_pontos
	li a7, 4
	ecall

	## Carregamento do valor da lista (que corresponde a uma escolha)
	lw a0, 0(a1)

	## Print das escolha correspondente ao valor do nodo apontado pelo cursor a1
	addi sp, sp, -4							# aloca espaço na pilha
	sw ra, 0(sp)							# armazena endereço de retorno
	jal printa_escolha						# printa a escolha 
	lw ra, 0(sp)							# recebe endereço de retorno
	addi sp, sp, 4							# desaloca espaço na pilha

	## Cursor vai para o pŕoximo nodo
	addi t4, a1, 4							# pula 4 bytes
	lw a1, 0(t4)							# a1 = elementon.prox (&elementon++)

	addi a4, a4, 1							# incrementa índice
	j print_lista_loop

print_lista_fim:
	ret

sem_print:
	## Imprime que não houveram jogadas do computador
	la a0, sem_jogadas
	li a7, 4
	ecall

	ret



	
