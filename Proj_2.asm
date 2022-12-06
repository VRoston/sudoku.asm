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

.DATA
; mensagens
    MSG1 DB 10, 13, '              PLAY SUDOKU', '$'
    MSG2 DB 10, 13, '  ===[APERTE UMA TECLA PARA JOGAR]===', '$'

; matrizes
    LINHA EQU 9
    COLUNA EQU 9

    ofmx dw ?
    ofmy dw ?
    ofmw dw ?

    ;MATRIZ1 DB LINHA DUP (COLUNA DUP (?))
    JOGO_FACIL DB '4','2','7',  '5', ? ,'8',  '9', ? ,'3'
               DB  ? , ? ,'5',   ? ,'4', ? ,   ? , ? ,'7'
               DB '6','8', ? ,   ? , ? , ? ,   ? , ? ,'7'
               
               DB '7','6', ? ,   ? ,'1', ? ,   ? ,'3', ?
               DB '1', ? ,'2',   ? , ? ,'5',   ? , ? ,'9'
               DB  ? ,'9','8',   ? , ? ,'4',   ? ,'6', ?
               
               DB '3', ? , ? ,  '8','5','1',   ? , ? , ?
               DB '8','7','1',   ? , ? ,'6',   ? , ? , ?
               DB '2', ? ,'6',  '4', ? ,'3',   ? , ? ,'1'


.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    CALL PRIMEIRA_PAGINA        ; tela de apresentação (Título piscando)
    LIMPA_TELA
    

    LEA BX, JOGO_FACIL
    CALL imp_matriz

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

le_matriz proc near
    PUSHREGISTRADOR 
    mov cX,linha
outerl:
    mov di,coluna
    xor si,si
innerl:
    mov ah,01
    int 21H
    and al,0fh
    mov [bx][si], al
    inc si
    dec di
    jnz innerl
    PULA_LINHA
    add bx,coluna
    loop outerl
    POPREGISTRADOR

    RET
le_matriz ENDP


imp_matriz proc
    PUSHREGISTRADOR


    mov ah,02
    mov cX,linha


outer:
    mov di,coluna
    xor si,si
inner:
    mov dl, [bx][si]
    or dl,30h
    int 21H
    inc si
    dec di
    jnz inner
    PULA_LINHA
    add bx,coluna
    loop outer
    POPREGISTRADOR
    RET
imp_matriz ENDP
END MAIN