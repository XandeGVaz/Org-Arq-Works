.data
.align 0
    str_Inicio:     .asciz "Bem vindo ao pedra, papel, tesoura contra o computador!\n" 
    str_pAgain:     .asciz "Deseja jogar novamente? 1 - sim; 2 - nao\n"
    str_choice:     .asciz "Escolha sua jogada: 1 - pedra; 2 - papel; 3 - tesoura.\n"
    str_warning:    .asciz "Escolha invalida. Tente novamente.\n"
    str_goodbye:    .asciz "Ate mais!\n"
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

.text
.align 2
.globl main

main:

    addi a7, zero, 4
    la a0, str_Inicio
    ecall


    add s3, zero, sp           # Keep track of Stack end

    addi s4, zero, 1           # Reserving some register for compares
    addi s5, zero, 2
    addi s6, zero, 3

loopInput:

    addi t1, zero, 0           # Flag
    addi a7, zero, 4
    la a0, str_choice
    ecall

    addi a7, zero, 5
    ecall

    add s1, zero, a0
    bgt s1, s6, invalidChoice
    blt s1, s4, invalidChoice
	j validChoice

invalidChoice:

    addi a7, zero, 4            # Invalid choice
    la a0, str_warning
    ecall
    j loopInput

validChoice:                    # Valid number choice

    addi a7, zero, 4
    la a0, str_msg2
    ecall

    add t2, zero, s1

pcChoice:                       # Also use this piece of code
                                # for pc choice
    bne t2, s4, not1
    addi a7, zero, 4            # Chose Rock
    la a0, str_rock
    ecall

not1:

    bne t2, s5, not2
    addi a7, zero, 4            # Chose Paper
    la a0, str_paper
    ecall

not2: 

    bne t2, s6, not3
    addi a7, zero, 4            # Chose Scisor
    la a0, str_scisor
    ecall

not3:

    beq t1, s4, saveChoice
    addi a7, zero, 30           # Obtain time in miliseconds -> ret(a1)
    ecall                       # (will be used as seed for pseudorandom number)
    addi a7, zero, 40           # Setting the seed
    ecall

    addi a0, zero, 0
    addi a1, zero, 2            # Upper bound for random number
    addi a7, zero, 42
    ecall
    add s2, zero, a0           # Copy generated number

    addi s2, s2, 1
    add t2, zero, s2           # Adequate generated number for tests
    addi t1, zero, 1            # Flag

    addi a7, zero, 4
    la a0, str_msg1
    ecall
    j pcChoice

saveChoice:

    addi sp, sp, -4             # Alocate size for one integer
    sw s2, 0(sp)

compareResults:

    bne s1, s2, notEqual
    addi a7, zero, 4            # Equal choices
    la a0, str_msg5
    ecall
    j end

notEqual:

    bne s1, s4, UserNOTRock
    bne s2, s5, User_wins         # User: Rock; PC: Scisor

    j User_loses                 # User: Rock; PC: Paper

UserNOTRock:

    bne s1, s5, UserScisor
    bne s2, s4, User_loses        # User: Paper; PC: Scisor

    j User_wins                  # User: Paper; PC: Rock

UserScisor:

    bne s2, s4, User_wins         # User: Scisor; Pc: paper     

    j User_loses                 # User: Scisor; PC: Rock

User_wins:

    addi a7, zero, 4
    la a0, str_msg3
    ecall
    j end

User_loses:

    addi a7, zero, 4
    la a0, str_msg4
    ecall
    j end

end:

    addi a7, zero, 4
    la a0, str_pAgain
    ecall

    addi a7, zero, 5
    ecall

    add t0, zero, a0

    bgt t0, s6, invalidChoice2
    blt t0, s4, invalidChoice2
    j validChoice2
    
invalidChoice2:

    addi a7, zero, 4            # Invalid choice
    la a0, str_warning
    ecall
    j end

validChoice2:

    bne t0, s4, finalize
    j loopInput

finalize:

    addi t0, zero, 1            # Counter
    addi sp, sp, -4             # Guarantee that there is a zero on the bottom of the stack

    addi a7, zero, 4
    la a0, str_msg6
    ecall

printArray:

    slli t1, t0, 2
    not t1, t1
    addi t1, t1, 1

    add t1, t1, s3
    lw t1, 0(t1)

    beqz t1, goodBye

    addi a7, zero, 1
    add a0, zero, t1
    ecall

    addi a7, zero, 4
    la a0, str_space           # Space
    ecall
    
    addi t0, t0, 1

    j printArray

goodBye:
	addi a7, zero, 4
	la a0, str_nl
	ecall

    addi a7, zero, 4
    la a0, str_goodbye
    ecall

    addi a7, zero, 10
    ecall

