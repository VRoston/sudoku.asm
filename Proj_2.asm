TITLE NOME:VICTOR DE MELO ROSTON | RA:22006737


.MODEL SMALL
EXIT_DOS MACRO
    MOV AH, 4CH         ; encerra o programa
    INT 21H
ENDM

PULA_LINHA MACRO
    MOV AH, 02H         ; pula uma linha na impressao
    MOV DL, 10
    INT 21H
ENDM

ESPACO MACRO 
    MOV AH, 02
    MOV DL, 32
    INT 21H    
ENDM

IMPRIME_MSG MACRO
    MOV AH, 09H         ; mostra na tela o que estivel em DL
    INT 21H
ENDM

ENTRADA_CARACTERE MACRO
    MOV AH, 01H         ; recebe um caractere do teclado
    INT 21H
ENDM

LIMPA_TELA MACRO
 ; limpa a tela
    MOV AH, 00       ; tipo de video
    MOV AL, 03h      ; tipo de texto 80x25
    INT 10H          ; executa a entrada de video

 ; formata o modo de video
    MOV AH, 09       ; escrever um caractere e atributo para a posicao do cursos
    MOV AL, 20H      ; o caractere a mostrar
    MOV BH, 00       ; numero da pagina
    MOV BL, 070H     ; atribuicao de cor
    MOV CX, 800H     ; numero de vezes a escrever o caractere
    INT 10H          ; executa a entrada de video
ENDM

PUSHREGISTRADOR  MACRO 
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    PUSH SI   
ENDM 

POPREGISTRADOR  MACRO
    POP SI
    POP DX
    POP CX
    POP BX
    POP AX 
ENDM

LIMPA_REGISTRADOR MACRO
    XOR AX, AX
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX
    XOR SI, SI
ENDM

.DATA
 ; mensagens
    MSG1  DB 10, 13, '              PLAY SUDOKU', '$'
    MSG2  DB 10, 13, '  ===[APERTE UMA TECLA PARA JOGAR]===', '$'
    MSG3  DB 10, 13, '  AS REGRAS:', '$'
    MSG4  DB 10, 13, '    I  - O JOGO CONSISTE EM PREENCHER OS ESPACOS ONDE ESTA 0 COM OS NUMEROS DE   1 A 9 CADA LINHA, COLUNA E MATRIZ 3X3 NAO DEVE CONTER OS NUMEROS DE 1 A 9 REPE- TIDOS', '$'
    MSG6  DB 10, 13, '    II - O JOGO POSSUI 3 NIVEIS DE DIFICULDADE: FACIL, MEDIO, DIFICL', '$'
    MSG7  DB 10, 13, '    III- PARA JOGAR DIGITE O NUMERO DA COLUNA E DA LINHA AO QUAL VOCE QUER ATRI- BUIR O VALOR DEPOIS BASTA DIGITAR O VALOR A SER ATRIBUIDO E APERTAR ENTER', '$'
    MSG9  DB 10, 13, '    IV - VOCE TERA DIREITO A 3 ERROS NO JOGO, SENDO NO 3 ERRO FIM DE JOGO', '$'
    MSG10 DB 10, 13, '    V  - A LINHA E A COLUNA COMECAM EM 1 E VAI ATE 9', '$'
    MSG11 DB 10, 13, ' ERROS :', '$'
    MSG12 DB         '/3 :', '$'
    MSG29 DB         '        ACERTOS :', '$'
    MSG31 DB         '/43 :', '$'
    MSG30 DB         '/51 :', '$'
    MSG32 DB         '/53 :', '$'
    MSG13 DB 10, 13, ' ENTRE COM A LINHA:', '$'
    MSG14 DB 10, 13, ' ENTRE COM A COLUNA:', '$'
    MSG15 DB 10, 13, ' INSIRA O NUMERO:', '$'
    MSG16 DB 10, 13, ' VOCE ERROU', '$'
    MSG08 DB 10, 13, ' VOCE ACERTOU', '$'
    MSG17 DB 10, 13,  '    1-FACIL', '$'
    MSG18 DB 10, 13,10,13, '    2-MEDIO', '$'
    MSG19 DB 10, 13,10,13, '    3-DIFICIL', '$'
    MSG26 DB 10, 13,10,13, '    4-FECHAR JOGO', '$'
    MSG20 DB 10, 13, ' ESCOLHA O NIVEL DE DIFICULDADE (DIGITE O NUMERO DE 1 A 3):', '$'
    MSG21 DB 10, 13, ' NIVEL FACIL', '$'
    MSG22 DB 10, 13, ' NIVEL MEDIO', '$'
    MSG23 DB 10, 13, ' NIVEL DIFICIL', '$'
    MSG24 DB 10, 13,10,13,10,13, '               GAME OVER', '$'
    MSG25 DB 10, 13,             '         PARABENS VOCE GANHOU', '$'
    MSG27 DB 10, 13, '                   ===///OBRIGADO POR JOGAR O SUDOKU\\\===', '$'
    MSG28 DB 10, 13, ' PROJETO DESENVOLVIDO POR VICTOR DE MELO ROSTON', '$'

 ; contadores do jogo
    CORRETO DB ?
    ERRADO  DB ?

 ; auxiliar das matrizes
    LINHA EQU 9
    COLUNA EQU 9


 ; matriz do jogo facil
    JOGO_FACIL DB 4,2,7,  5,?,8,  9,?,3
               DB ?,?,5,  ?,4,?,  ?,?,7
               DB 6,8,?,  ?,?,?,  ?,?,7
               
               DB 7,6,?,  ?,1,?,  ?,3,?
               DB 1,?,2,  ?,?,5,  ?,?,9
               DB ?,9,8,  ?,?,4,  ?,6,?
               
               DB 3,?,?,  8,5,1,  ?,?,?
               DB 8,7,1,  ?,?,6,  ?,?,?
               DB 2,?,6,  4,?,3,  ?,?,1

 ; matriz resposta do jogo facil
    JOGO_FACIL_RESPOSTA DB 4,2,7,  5,6,8,  9,1,3
                        DB 9,1,5,  3,4,2,  6,8,7
                        DB 6,8,3,  1,9,7,  2,5,7
               
                        DB 7,6,4,  2,1,9,  5,3,8
                        DB 1,3,2,  6,8,5,  4,7,9
                        DB 5,9,8,  7,3,4,  1,6,2
               
                        DB 3,4,9,  8,5,1,  7,2,6
                        DB 8,7,1,  9,2,6,  3,4,5
                        DB 2,5,6,  4,7,3,  8,9,1

 ; matriz do jogo medio
    JOGO_MEDIO DB 1,3,?,  4,?,?,  ?,?,?
               DB 5,?,?,  ?,6,?,  ?,3,?
               DB ?,?,?,  ?,?,?,  2,?,9
               
               DB 4,?,7,  ?,1,3,  ?,6,?
               DB ?,?,?,  2,?,4,  1,9,?
               DB 9,?,?,  ?,8,?,  ?,?,2
               
               DB 8,?,?,  3,4,?,  9,?,?
               DB 3,?,?,  ?,?,6,  8,?,1
               DB ?,?,?,  ?,?,1,  ?,?,3

 ; matriz resposta do jogo medio
    JOGO_MEDIO_RESPOSTA DB 1,3,2,  4,7,9,  6,8,5
                        DB 5,9,8,  1,6,2,  7,3,4
                        DB 7,6,4,  5,3,8,  2,1,9
               
                        DB 4,2,7,  9,1,3,  5,6,8
                        DB 6,8,3,  2,5,4,  1,9,7
                        DB 9,1,5,  6,8,7,  3,4,2
               
                        DB 8,7,1,  3,4,5,  9,2,6
                        DB 3,4,9,  7,2,6,  8,5,1
                        DB 2,5,6,  8,9,1,  4,7,3

 ; matriz do jogo dificil
    JOGO_DIFICIL  DB ?,8,?,  9,?,3,  ?,?,2
                  DB 3,?,4,  ?,?,?,  ?,5,?
                  DB ?,7,9,  2,5,?,  6,?,?
               
                  DB ?,5,8,  ?,7,?,  1,2,?
                  DB ?,?,?,  1,?,?,  5,?,9
                  DB ?,?,1,  ?,?,?,  7,?,?
               
                  DB ?,?,7,  8,?,?,  ?,6,?
                  DB ?,?,?,  ?,?,6,  ?,9,?
                  DB 9,?,2,  ?,?,?,  ?,?,?
                 
 ; matriz resposta do jogo dificil
    JOGO_DIFICIL_RESPOSTA DB 5,8,6,  9,1,3,  4,7,2
                          DB 3,2,4,  6,8,7,  9,5,1
                          DB 1,7,9,  2,5,4,  6,3,8
               
                          DB 6,5,8,  4,7,9,  1,2,3
                          DB 7,4,3,  1,6,2,  5,8,9
                          DB 2,9,1,  5,3,8,  7,4,6
               
                          DB 4,3,7,  8,9,1,  2,6,5
                          DB 8,1,5,  7,2,6,  3,9,4
                          DB 9,6,2,  3,4,5,  8,1,7



.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    CALL PRIMEIRA_PAGINA        ; tela de apresentação (Título piscando)
    
VOLTA_MENU:    
    LIMPA_TELA

    MOV ERRADO, 0
    MOV CORRETO, 0

    CALL MENU_PRINCIPAL         ; menu principal
    CMP AL, 1
        JE JOGO_EASY            ; escolhe a dificuldade do jogo, ou caso aperte qualquer outra tecla
    CMP AL, 2                   ;  o programa pergunta de novo
        JE JOGO_MEDIUM
    CMP AL, 3
        JE JOGO_HARD
    CMP AL, 4
        JE ENCERRA_PROGRAMA2
    JMP VOLTA_MENU


JOGO_EASY:
    LIMPA_TELA
    LEA BX, JOGO_FACIL              ; carrega a matriz do jogo facil
    CALL CONTADOR_ERROS             ; chama a função que imprime os erros
    CALL CONTADOR_ACERTOS_FACIL     ; chama a função que imprime os acertos
    CALL IMP_MATRIZ                 ; chama a função que imprime a matriz de base do jogo que atualiza a cada rodada
    CALL LE_RESPOSTA_USUARIO_FACIL  ; chama a função que le a resposta do usuário
    CALL CONTINUA_OU_NAO_ERRO       ; depois da jogada, se tiver 3 erros ou todas as respostas corretas, a rodada encerra
        JE GAME_OVER2               ; se tiver 3 erros, chama a função que imprime GAME OVER
    CALL VENCEU_FACIL               ; se tiver todas as respostas corretas, chama a função que imprime YOU WIN
        JE YOU_WIN2
    JMP JOGO_EASY                   ; se não tiver 3 erros e nem todas as respostas corretas, volta para o inicio do jogo

JOGO_MEDIUM:
    LIMPA_TELA
    LEA BX, JOGO_MEDIO
    CALL CONTADOR_ERROS
    CALL CONTADOR_ACERTOS_MEDIO
    CALL IMP_MATRIZ
    CALL LE_RESPOSTA_USUARIO_MEDIO
    CALL CONTINUA_OU_NAO_ERRO
        JE GAME_OVER2
    CALL VENCEU_MEDIO
        JE YOU_WIN2
    JMP JOGO_MEDIUM

ENCERRA_PROGRAMA2:                  ; o jump não alcanca, entao fiz uma ponta
    JMP ENCERRA_PROGRAMA

JOGO_HARD:
    LIMPA_TELA

    LEA BX, JOGO_DIFICIL

    CALL CONTADOR_ERROS
    CALL CONTADOR_ACERTOS_DIFICIL
    CALL IMP_MATRIZ

    CALL LE_RESPOSTA_USUARIO_DIFICIL

    CALL CONTINUA_OU_NAO_ERRO
        JE GAME_OVER2

    CALL VENCEU_DIFICIL
        JE YOU_WIN2

    JMP JOGO_HARD


GAME_OVER2:
    CALL GAME_OVER
    JMP VOLTA_MENU

YOU_WIN2:
    CALL YOU_WIN
    JMP VOLTA_MENU
    
ENCERRA_PROGRAMA:
    CALL FIM_PROGRAMA               ; chama a função que imprime a mensagem de despedida e sai do programa
    EXIT_DOS
MAIN ENDP

; definindo a primeira tela que apresenta o titulo da calculadora piscando
PRIMEIRA_PAGINA PROC
 ; limpa a tela
    MOV AH, 00                   ; tipo de video
    MOV AL, 00                   ; tipo de texto 40x25
    INT 10H                      ; executa a entrada de video

 ; formata o modo de video
    MOV AH, 09                   ; escrever um caractere e atributo para a posicao do cursos
    MOV AL, 20H                  ; o caractere a mostrar
    MOV BH, 00                   ; numero da pagina
    MOV BL, 8FH                  ; atribuicao de cor
    MOV CX, 800H                 ; numero de vezes a escrever o caractere
    INT 10H                      ; executa a entrada de video

    LEA DX, MSG1                 ; imprime "CALCULADORA BASICA"
    IMPRIME_MSG

    XOR CX, CX                   ; pula linha 15 vezes
    MOV CX, 16
 PL:
    PULA_LINHA
    LOOP PL

    LEA DX, MSG2                 ; imprime "[APERTE QUALQUER TECLA]"
    IMPRIME_MSG           

    ENTRADA_CARACTERE

    RET                           ; retorna a funcao com primeira tela do programa mostrando o titulo 
                                  ;  do projeto com as letras piscando
PRIMEIRA_PAGINA ENDP

; mostra as regras e a opcão de dificuldade do jogo
MENU_PRINCIPAL PROC
    LEA DX, MSG4                    ; imprime todas as menssagens do menu
    IMPRIME_MSG
    LEA DX, MSG6
    IMPRIME_MSG
    LEA DX, MSG7
    IMPRIME_MSG
    LEA DX, MSG9
    IMPRIME_MSG
    LEA DX, MSG10
    IMPRIME_MSG
    PULA_LINHA
    LEA DX, MSG20
    IMPRIME_MSG
    LEA DX, MSG17
    IMPRIME_MSG
    LEA DX, MSG18
    IMPRIME_MSG
    LEA DX, MSG19
    IMPRIME_MSG
    LEA DX, MSG26
    IMPRIME_MSG

    ENTRADA_CARACTERE              ; le o caractere para escolher dificuldade ou sair do programa
    SUB AL,30H


    RET
MENU_PRINCIPAL ENDP

; entrada das posicoes da matriz e o numero a ser inserido
LE_RESPOSTA_USUARIO_FACIL PROC
    PUSHREGISTRADOR
    LIMPA_REGISTRADOR

 ; entrada do caractere da linha
 VOLTA1:
    LEA DX, MSG13
    IMPRIME_MSG
    ENTRADA_CARACTERE
    SUB AL,30H
        CMP AL, 9
        JG VOLTA1
        CMP AL, 0
        JLE VOLTA1


    MOV CX, 9
    MUL CX
    XOR AH,AH

    MOV BX,AX 
    SUB BX,9

 ; entrada do caractere da coluna
 VOLTA2:
    LEA DX, MSG14
    IMPRIME_MSG
    ENTRADA_CARACTERE
    PUSHREGISTRADOR
    SUB AL,30H
        CMP AL, 9
        JG VOLTA2
        CMP AL, 0
        JLE VOLTA2
    POPREGISTRADOR
    SUB AL,31H


    XOR AH,AH
    MOV SI,AX

 ; recebe o numero que vai para a matriz caso correto
 VOLTA4:
    LEA DX, MSG15
    IMPRIME_MSG
    ENTRADA_CARACTERE
    SUB AL, 30H
        CMP AL, 9
        JG VOLTA4
        CMP AL, 0
        JLE VOLTA4

 ; comparar o numero da entrada com a matriz resposta
        CMP AL, JOGO_FACIL[BX][SI]
        JE PULA9

        CMP AL, JOGO_FACIL_RESPOSTA[BX][SI]
        JE ACERTO
 ; contador de erros
    PUSH DX
    XOR DL,DL
    MOV DL, ERRADO
    INC DL
    MOV ERRADO, DL
    POP DX

    JMP SAI
 ; limpa a resposta ja que esta errada
    XOR AX, AX              

 ; passa a resposta para a matriz
ACERTO:
    ADD AL, 30H
    MOV JOGO_FACIL[BX][SI], AL

 ; contador de acertos
    PUSH DX
    XOR DL,DL
    MOV DL, CORRETO
    INC DL
    MOV CORRETO, DL
    POP DX

    JMP SAI
SAI:
PULA9:
    POPREGISTRADOR

    RET
LE_RESPOSTA_USUARIO_FACIL ENDP

LE_RESPOSTA_USUARIO_MEDIO PROC
    PUSHREGISTRADOR
    LIMPA_REGISTRADOR

 ; entrada do caractere da linha
 VOLTA11:
    LEA DX, MSG13
    IMPRIME_MSG
    ENTRADA_CARACTERE
    SUB AL,30H
        CMP AL, 9
        JG VOLTA11
        CMP AL, 0
        JLE VOLTA11

    MOV CX, 9
    MUL CX
    XOR AH,AH

    MOV BX,AX 
    SUB BX,9

 ; entrada do caractere da coluna
 VOLTA12:
    LEA DX, MSG14
    IMPRIME_MSG
    ENTRADA_CARACTERE
    PUSHREGISTRADOR
    SUB AL,30H
        CMP AL, 9
        JG VOLTA12
        CMP AL, 0
        JLE VOLTA12
    POPREGISTRADOR
    SUB AL,31H

    XOR AH,AH
    MOV SI,AX

 ; recebe o numero que vai para a matriz caso correto
 VOLTA13:
    LEA DX, MSG15
    IMPRIME_MSG
    ENTRADA_CARACTERE
    SUB AL, 30H
        CMP AL, 9
        JG VOLTA13
        CMP AL, 0
        JLE VOLTA13

 ; comparar o numero da entrada com a matriz resposta
    CMP AL, JOGO_MEDIO[BX][SI]
    JE PULA6
    CMP AL, JOGO_MEDIO_RESPOSTA[BX][SI]

    JE ACERTO2
 ; contador de erros
    PUSH DX
    XOR DL,DL
    MOV DL, ERRADO
    INC DL
    MOV ERRADO, DL
    POP DX

    JMP SAI2
    XOR AX, AX

 ; passa a resposta para a matriz
ACERTO2:
    ADD AL, 30H
    MOV JOGO_MEDIO[BX][SI], AL

 ; contador de acertos
    PUSH DX
    XOR DL,DL
    MOV DL, CORRETO
    INC DL
    MOV CORRETO, DL
    POP DX

    JMP SAI2
SAI2:
PULA6:
    POPREGISTRADOR

    RET
LE_RESPOSTA_USUARIO_MEDIO ENDP

LE_RESPOSTA_USUARIO_DIFICIL PROC
    PUSHREGISTRADOR
    LIMPA_REGISTRADOR

 ; entrada do caractere da linha
 VOLTA21:
    LEA DX, MSG13
    IMPRIME_MSG
    ENTRADA_CARACTERE
    SUB AL,30H
        CMP AL, 9
        JG VOLTA21
        CMP AL, 0
        JLE VOLTA21

    MOV CX, 9
    MUL CX
    XOR AH,AH

    MOV BX,AX 
    SUB BX,9

 ; entrada do caractere da coluna
 VOLTA22:
    LEA DX, MSG14
    IMPRIME_MSG
    ENTRADA_CARACTERE
    PUSHREGISTRADOR
    SUB AL,30H
        CMP AL, 9
        JG VOLTA22
        CMP AL, 0
        JLE VOLTA22
    POPREGISTRADOR
    SUB AL,31H

    XOR AH,AH
    MOV SI,AX

 ; recebe o numero que vai para a matriz caso correto
 VOLTA23:
    LEA DX, MSG15
    IMPRIME_MSG
    ENTRADA_CARACTERE
    SUB AL, 30H
        CMP AL, 9
        JG VOLTA23
        CMP AL, 0
        JLE VOLTA23

 ; comparar o numero da entrada com a matriz resposta
    CMP AL, JOGO_FACIL[BX][SI]
    JE PULA8

    CMP AL, JOGO_DIFICIL_RESPOSTA[BX][SI]

    JE ACERTO3
 ; contador de erros
    PUSH DX
    XOR DL,DL
    MOV DL, ERRADO
    INC DL
    MOV ERRADO, DL
    POP DX

    JMP PULA8
    XOR AX, AX

 ; passa a resposta para a matriz
 ACERTO3:
    ADD AL, 30H
    MOV JOGO_DIFICIL[BX][SI], AL

 ; contador de acertos
    PUSH DX
    XOR DL,DL
    MOV DL, CORRETO
    INC DL
    MOV CORRETO, DL
    POP DX

 PULA8:
    POPREGISTRADOR

    RET
LE_RESPOSTA_USUARIO_DIFICIL ENDP

; contador de erros
CONTADOR_ERROS PROC
    PUSHREGISTRADOR
    LIMPA_REGISTRADOR
    LEA DX, MSG11
    IMPRIME_MSG
    MOV DL, ERRADO
    ADD DL, 30H
    MOV AH, 02
    INT 21H
    LEA DX, MSG12
    IMPRIME_MSG

    POPREGISTRADOR
    RET
CONTADOR_ERROS ENDP

; contador de acertos
CONTADOR_ACERTOS_FACIL PROC
    PUSHREGISTRADOR
    LIMPA_REGISTRADOR
    LEA DX, MSG29
    IMPRIME_MSG
    CALL OUTPUT
    LEA DX, MSG31
    IMPRIME_MSG
    PULA_LINHA

    POPREGISTRADOR
    RET
CONTADOR_ACERTOS_FACIL ENDP

CONTADOR_ACERTOS_MEDIO PROC
    PUSHREGISTRADOR
    LIMPA_REGISTRADOR
    LEA DX, MSG29
    IMPRIME_MSG
    MOV DL, CORRETO
    CALL OUTPUT
    LEA DX, MSG30
    IMPRIME_MSG
    PULA_LINHA

    POPREGISTRADOR
    RET
CONTADOR_ACERTOS_MEDIO ENDP

CONTADOR_ACERTOS_DIFICIL PROC
    PUSHREGISTRADOR
    LIMPA_REGISTRADOR
    LEA DX, MSG29
    IMPRIME_MSG
    MOV DL, CORRETO
    CALL OUTPUT
    LEA DX, MSG32
    IMPRIME_MSG
    PULA_LINHA

    POPREGISTRADOR
    RET
CONTADOR_ACERTOS_DIFICIL ENDP

; imprime uma mensagem na tela
IMP_MATRIZ PROC
    PUSHREGISTRADOR

    MOV AH,02
    MOV CX,LINHA
    

 OUTER:
    PUSH AX
    PUSH DX
    ESPACO
    POP DX
    POP AX

    MOV DI,COLUNA
    XOR SI,SI
 INNER:
    MOV DL, [BX][SI]
    OR DL,30H
    INT 21H
    INC SI
    DEC DI

    PUSH AX
    PUSH DX
    ESPACO
    POP DX
    POP AX

    JNZ INNER
    PULA_LINHA
    ADD BX,COLUNA
    LOOP OUTER
    POPREGISTRADOR
    RET
IMP_MATRIZ ENDP

; realiza uma verificacao se o jogo acabou ou nao
CONTINUA_OU_NAO_ERRO PROC
    PUSHREGISTRADOR

    MOV DL, ERRADO
    CMP DL, 3

    POPREGISTRADOR
    RET
CONTINUA_OU_NAO_ERRO ENDP

; realiza uma verificacao se o jogo acabou ou nao
VENCEU_FACIL PROC
    PUSHREGISTRADOR

    MOV DL, CORRETO         ; limite de acertos do jogo
    CMP DL, 43

    POPREGISTRADOR
    RET
VENCEU_FACIL ENDP

VENCEU_MEDIO PROC
    PUSHREGISTRADOR

    MOV DL, CORRETO
    CMP DL, 51

    POPREGISTRADOR
    RET
VENCEU_MEDIO ENDP

VENCEU_DIFICIL PROC
    PUSHREGISTRADOR

    MOV DL, CORRETO
    CMP DL, 52

    POPREGISTRADOR
    RET
VENCEU_DIFICIL ENDP

; menssagem que perdeu
GAME_OVER PROC
 ; limpa a tela
    MOV AH, 00                   ; tipo de video
    MOV AL, 00                   ; tipo de texto 40x25
    INT 10H                      ; executa a entrada de video

 ; formata o modo de video
    MOV AH, 09                   ; escrever um caractere e atributo para a posicao do cursos
    MOV AL, 20H                  ; o caractere a mostrar
    MOV BH, 00                   ; numero da pagina
    MOV BL, 84H                  ; atribuicao de cor
    MOV CX, 800H                 ; numero de vezes a escrever o caractere
    INT 10H                      ; executa a entrada de video

    LEA DX, MSG24
    IMPRIME_MSG

    ENTRADA_CARACTERE

    RET
GAME_OVER ENDP

; menssagem que venceu
YOU_WIN PROC
     ; limpa a tela
    MOV AH, 00                   ; tipo de video
    MOV AL, 00                   ; tipo de texto 40x25
    INT 10H                      ; executa a entrada de video

 ; formata o modo de video
    MOV AH, 09                   ; escrever um caractere e atributo para a posicao do cursos
    MOV AL, 20H                  ; o caractere a mostrar
    MOV BH, 00                   ; numero da pagina
    MOV BL, 82H                  ; atribuicao de cor
    MOV CX, 800H                 ; numero de vezes a escrever o caractere
    INT 10H                      ; executa a entrada de video

    LEA DX, MSG25
    IMPRIME_MSG

    ENTRADA_CARACTERE

    RET
YOU_WIN ENDP

; conversao do resultado em 2 numeros de 2 bits e imprime na tela
OUTPUT PROC
 ; o ultimo passo da conta, impressao do resultado na tela, que esta armazenado na variavel RESULTADO
    XOR AX, AX          ; zera conteudo de AX
    MOV AL, CORRETO   ; passa o resultado para AL
    MOV BL, 10          ; atribui 10 para BL                        
    DIV BL              ; divide o AL por 10 - (AL)/10 - agora o resultado da divisao esta em AL        
                        ;  e o resto da divisao esta em AH          
    MOV BX,AX           ; passa esse resultado para BX              

    MOV DL, BL          
    ADD DL, 30H         ; imprime o que estava em AL na casa da dezena   
    MOV AH, 02H
    INT 21H
    
    MOV DL, BH
    ADD DL, 30H         ; imprime o que estava em AH na casa da unidade  
    MOV AH, 02H
    INT 21H

    RET                 ; retorna a funcao com o resultado da operacao impresso na tela usando saida de 2 bits
OUTPUT ENDP

; limpa a tela e imprime a menssagem de despedida
FIM_PROGRAMA PROC
    LIMPA_TELA

    LEA DX, MSG27
    IMPRIME_MSG

    MOV CX, 18
VOLTA3:
    PULA_LINHA
    LOOP VOLTA3

    LEA DX, MSG28
    IMPRIME_MSG

    RET
FIM_PROGRAMA ENDP
END MAIN