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
    MSG9  DB 10, 13, '    IV - VOCE TERA DIREITO A 4 ERROS NO JOGO, SENDO NO 4 ERRO FIM DE JOGO', '$'
    MSG10 DB 10, 13, '    V  - PARA FINALIZAR O JOGO DIGITE 0 NA LINHA E NA COLUNA', '$'
    MSG11 DB 10, 13, ' ERROS :', '$'
    MSG12 DB         '/3 :', '$'
    MSG13 DB 10, 13, ' ENTRE COM A COLUNA:', '$'
    MSG14 DB 10, 13, ' ENTRE COM A LINHA:', '$'
    MSG15 DB 10, 13, ' INSIRA O NUMERO:', '$'
    MSG16 DB 10, 13, ' VOCE ERROU', '$'
    MSG17 DB 10, 13,10,13, '    1-FACIL', '$'
    MSG18 DB 10, 13,10,13, '    2-MEDIO', '$'
    MSG19 DB 10, 13,10,13, '    3-DIFICIL', '$'

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
    JOGO_MEDIO DB 1,1,1,  5,?,8,  9,?,3
               DB ?,?,5,  ?,4,?,  ?,?,7
               DB 6,8,?,  ?,?,?,  ?,?,7
               
               DB 7,6,?,  ?,1,?,  ?,3,?
               DB 1,?,2,  ?,?,5,  ?,?,9
               DB ?,9,8,  ?,?,4,  ?,6,?
               
               DB 3,?,?,  8,5,1,  ?,?,?
               DB 8,7,1,  ?,?,6,  ?,?,?
               DB 2,?,6,  4,?,3,  ?,?,1

 ; matriz resposta do jogo medio
    JOGO_MEDIO_RESPOSTA DB 4,2,7,  5,?,8,  9,?,3
                        DB ?,?,5,  ?,4,?,  ?,?,7
                        DB 6,8,?,  ?,?,?,  ?,?,7
               
                        DB 7,6,?,  ?,1,?,  ?,3,?
                        DB 1,?,2,  ?,?,5,  ?,?,9
                        DB ?,9,8,  ?,?,4,  ?,6,?
               
                        DB 3,?,?,  8,5,1,  ?,?,?
                        DB 8,7,1,  ?,?,6,  ?,?,?
                        DB 2,?,6,  4,?,3,  ?,?,1

 ; matriz do jogo dificil
    JOGO_DIFICIL DB 2,2,2,  5,?,8,  9,?,3
                 DB ?,?,5,  ?,4,?,  ?,?,7
                 DB 6,8,?,  ?,?,?,  ?,?,7
               
                 DB 7,6,?,  ?,1,?,  ?,3,?
                 DB 1,?,2,  ?,?,5,  ?,?,9
                 DB ?,9,8,  ?,?,4,  ?,6,?
               
                 DB 3,?,?,  8,5,1,  ?,?,?
                 DB 8,7,1,  ?,?,6,  ?,?,?
                 DB 2,?,6,  4,?,3,  ?,?,1
                 
 ; matriz resposta do jogo dificil
    JOGO_DIFICIL_RESPOSTA DB 4,2,7,  5,?,8,  9,?,3
                          DB ?,?,5,  ?,4,?,  ?,?,7
                          DB 6,8,?,  ?,?,?,  ?,?,7
               
                          DB 7,6,?,  ?,1,?,  ?,3,?
                          DB 1,?,2,  ?,?,5,  ?,?,9
                          DB ?,9,8,  ?,?,4,  ?,6,?
               
                          DB 3,?,?,  8,5,1,  ?,?,?
                          DB 8,7,1,  ?,?,6,  ?,?,?
                          DB 2,?,6,  4,?,3,  ?,?,1



.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    MOV ERRADO, 0

    CALL PRIMEIRA_PAGINA        ; tela de apresentação (Título piscando)
    LIMPA_TELA
    
    CALL MENU_PRINCIPAL         ; menu principal
        JG JOGO_HARD
        JE JOGO_MEDIUM
        JL JOGO_EASY

    

JOGO_EASY:
    LIMPA_TELA
    LEA BX, JOGO_FACIL
    CALL CONTADOR_ERROS
    CALL IMP_MATRIZ
    CALL LE_RESPOSTA_USUARIO
    CALL CONTINUA_OU_NAO
        JL JOGO_EASY
        JMP ENCERRA_PROGRAMA

JOGO_MEDIUM:
    LIMPA_TELA
    LEA BX, JOGO_MEDIO
    CALL CONTADOR_ERROS
    CALL IMP_MATRIZ
    CALL LE_RESPOSTA_USUARIO
    CALL CONTINUA_OU_NAO
        JL JOGO_MEDIUM
        JMP ENCERRA_PROGRAMA

JOGO_HARD:
    LIMPA_TELA
    LEA BX, JOGO_DIFICIL
    CALL CONTADOR_ERROS
    CALL IMP_MATRIZ
    CALL LE_RESPOSTA_USUARIO
    CALL CONTINUA_OU_NAO
        JL JOGO_HARD
        JMP ENCERRA_PROGRAMA


    
ENCERRA_PROGRAMA:
    ;CALL FIM_PROGRAMA
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
    LEA DX, MSG4
    IMPRIME_MSG
    ;LEA DX, MSG5
    ;IMPRIME_MSG
    LEA DX, MSG6
    IMPRIME_MSG
    LEA DX, MSG7
    IMPRIME_MSG
    ;LEA DX, MSG8
    ;IMPRIME_MSG
    LEA DX, MSG9
    IMPRIME_MSG
    LEA DX, MSG10
    IMPRIME_MSG
    PULA_LINHA
    LEA DX, MSG17
    IMPRIME_MSG
    LEA DX, MSG18
    IMPRIME_MSG
    LEA DX, MSG19
    IMPRIME_MSG

    ENTRADA_CARACTERE
    SUB AL,30H
    CMP AL, 2

    RET
MENU_PRINCIPAL ENDP

; entrada das posicoes da matriz e o numero a ser inserido
LE_RESPOSTA_USUARIO PROC
    PUSHREGISTRADOR
    LIMPA_REGISTRADOR

 ; entrada do caractere da coluna
    LEA DX, MSG13
    IMPRIME_MSG
    ENTRADA_CARACTERE
    SUB AL,30H

    MOV CX, 9
    MUL CX
    XOR AH,AH

    MOV BX,AX 
    SUB BX,9

 ; entrada do caractere da linha
    LEA DX, MSG14
    IMPRIME_MSG
    ENTRADA_CARACTERE
    SUB AL,31H              

    XOR AH,AH
    MOV SI,AX

 ; recebe o numero que vai para a matriz caso correto
    LEA DX, MSG15
    IMPRIME_MSG
    ENTRADA_CARACTERE
    SUB AL, 30H

 ; comparar o numero da entrada com a matriz resposta
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

    POPREGISTRADOR

    RET
LE_RESPOSTA_USUARIO ENDP

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
    PULA_LINHA

    POPREGISTRADOR
    RET
CONTADOR_ERROS ENDP

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
CONTINUA_OU_NAO PROC
    PUSHREGISTRADOR

    MOV DL, ERRADO
    CMP DL, 3

    POPREGISTRADOR
    RET
CONTINUA_OU_NAO ENDP

; limpa a tela e imprime a menssagem de despedida
FIM_PROGRAMA PROC
    LIMPA_TELA
    RET
FIM_PROGRAMA ENDP
END MAIN