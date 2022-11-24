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
    MOV BL, 0F0H     ; atribuicao de cor
    MOV CX, 800H     ; numeNNNNro de vezes a escrever o caractere
    INT 10H          ; executa a entrada de video
ENDM

.DATA
; mensagens
    MSG1 DB 10, 13, '              PLAY SUDOKU', '$'
    MSG2 DB 10, 13, '  ===[APERTE UMA TECLA PARA JOGAR]===', '$'

; matrizes
    MAT DB 9 DUP (?)
        DB 9 DUP (?)
        DB 9 DUP (?)
        DB 9 DUP (?)
        DB 9 DUP (?)
        DB 9 DUP (?)
        DB 9 DUP (?)
        DB 9 DUP (?)
        DB 9 DUP (?)

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX

    CALL PRIMEIRA_PAGINA

    LIMPA_TELA

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


END MAIN