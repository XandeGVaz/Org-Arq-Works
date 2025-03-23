

<h1 align="center">Trabalho prático referente à matéria de Organização e Arquitetura de Computadores</h1>
  
### Alunos:
- Vitor Alexandre Garcia Vaz - 14611432
- Matheus Cavalcanti de Santana - 13217506
- Pedro Gasparelo Leme - 14602421

# Objetivo

O objetivo deste trabalho é implementar o jogo "Pedra, Papel, Tesoura", onde o jogador
joga contra o computador. O jogo deve ser implementado em Assembly RISC-V e executado no
simulador RARS.

Neste jogo, o programa escolherá aleatoriamente uma das três possibilidades (Pedra, Papel
ou Tesoura) e deverá comparar com a opção do jogador, lida do teclado. O programa deve então
comparar as escolhas e determinar o vencedor.

# Como instalar o simulador RARS

O simulador RARS (RISC-V Assembler and Runtime Simulator) é necessário para executar o código Assembly RISC-V deste projeto. Siga os passos abaixo para instalá-lo:

### Requisitos
- Java JDK 8 ou superior instalado no sistema.

### Passos de instalação

1. **Baixe o RARS**
   - Acesse o repositório oficial do RARS no GitHub: [https://github.com/TheThirdOne/rars](https://github.com/TheThirdOne/rars).
   - Na seção de [Releases](https://github.com/TheThirdOne/rars/releases), baixe o arquivo `.jar` mais recente.

2. **Verifique a instalação do Java**
   - Certifique-se de que o Java está instalado e configurado corretamente. Execute o comando abaixo no terminal para verificar:
     ```sh
     java -version
     ```
   - Caso o Java não esteja instalado, faça o download e instale o JDK a partir do site oficial: [https://www.oracle.com/java/technologies/javase-downloads.html](https://www.oracle.com/java/technologies/javase-downloads.html).

3. **Execute o RARS**
   - Navegue até o diretório onde o arquivo `.jar` do RARS foi baixado.
   - Execute o seguinte comando no terminal:
     ```sh
     java -jar rars.jar
     ```
   - Isso abrirá a interface gráfica do simulador RARS.

4. **Configuração adicional (opcional)**
   - Para facilitar o uso, você pode criar um atalho ou adicionar o comando ao PATH do sistema.

### Recursos úteis
- Documentação oficial do RARS: [https://github.com/TheThirdOne/rars](https://github.com/TheThirdOne/rars)
- Tutoriais e exemplos de uso podem ser encontrados na seção de Wiki do repositório oficial.

Agora você está pronto para executar o código Assembly RISC-V deste projeto no simulador RARS!
