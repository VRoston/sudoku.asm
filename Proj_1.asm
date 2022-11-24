TITLE NOME:VICTOR DE MELO ROSTON | RA:22006737

.MODEL SMALL

.DATA
; definindo as menssagens que vao aparecer no programa
    MSG1 db  10, 13,  'Digite o 1o numero: ','$'
    MSG2 db  10, 13,  'Digite o 2o numero: ','$'
    MSG3 db  10, 13,  ' RESULTADO: ','$'
    MSG4 db  10, 13,  'CONTAS ARITIMETICAS','$'
    MSG5 db  10, 13,  ' ESCOLHA A OPERACAO A SER REALIZADA:','$'
    MSG6 db  10, 13,  '  1-SOMA','$'
    MSG7 db  10, 13,  '  2-SUBTRACAO','$'
    MSG8 db  10, 13,  '  3-MULTIPLICACAO','$'
    MSG9 db  10, 13,  '  4-DIVISAO','$'
    MSG10 db  10, 13, '   >>>','$'
    MSG11 db  10, 13, ' CARACTER INVALIDO, TENTE NOVAMENTE:','$'
    msg12 db  10, 13, ' [APERTE QUALQUER TECLA]','$'
    MSG13 db  10, 13, ' [DIGITE DE 1 A 4 PARA ESCOLHER, OU 9 PARA FECHAR]','$'
    MSG14 db  10, 13, '  9-FINALIZAR PROGRAMA','$'
    MSG15 db          '  ///O PROGRAMA FOI ENCERRADO, OBRIGADO POR USAR\\\','$'
    MSG16 db  10, 13, ' GOSTARIA DE CONTINUAR?','$'
    MSG17 db  10, 13, ' SIM - APERTE 1','$'
    MSG18 db  10, 13, ' NAO - APERTE QUALQUER TECLA','$'
    MSG19 db  10, 13, 10, 13,  '         CALCULADORA BASICA','$'
    MSG20 db  10, 13, ' QUOCIENTE: ','$'
    MSG21 db  10, 13, ' RESTO: ','$'
    MSG22 db  10, 13, ' IMPOSSIVEL DIVIDIR POR 0','$'
    MSG23 db  10, 13, '   ===PROGRAMA FEITO POR VICTOR DE MELO ROSTON===','$'
    MSG24 db          '  ADICAO','$'
    MSG25 db          '  SUBTRACAO','$'
    MSG26 db          '  MULTIPLICACAO','$'
    MSG27 db          '  DIVISAO','$'
    PULA_LINHA db 10, 13, '$'
    SINAL_NEGATIVO db '-', '$'
    
; definindo as variaveis que vao auxiliar no programa
    NUM1 DB ?
    NUM2 DB ?
    RESULTADO DB ?              ; existem dois resultados devido a necessidade da divisao de usar um
    RESULTADO2 DB ?             ;  para quociente e outro para o resto

.CODE
MAIN PROC
    MOV AX,@DATA        
    MOV DS,AX                   ; inicializa o data
    MOV ES,AX

    CALL PRIMEIRA_PAGINA        ; faz a chamada da tela inicial do programa que apenas exibira o
                                ;  titulo do programa piscando, conteudo que aparecera apenas ao inicializar o programa

REINICIA_PROGRAMA:
    CALL COR_DE_FUNDO           ; apaga tudo da tela e muda a cor de fundo

    CALL SUMARIO                ; imprime as opcoes de operacoes possiveis no programa

; inicio da escolha de operacao
CARACTER_INVALIDO:
    MOV AH,01H                      ; entrada de caractere 1 a 4 para escolher qual operacao realizar
    SUB AL,30H                      ; transforma o caractere da entrada da tabela ASCII para numero
    INT 21H

    CMP AL, '1'                     ; caso entrada seja 1, compara AL com 1, caso igual pula para adicao
    JE ADICAO

    CMP AL, '2'                     ; CASO ENTRADA SEJA 2, COMPARA AL COM 2, SE IGUAL PULA PARA SUBTRACAO
    JE SUBTRACAO

    CMP AL, '3'                     ; CASO ENTRADA SEJA 3, COMPARA AL COM 3, SE IGUAL PULA PARA MULTIPLICACAO
    JE MULTIPLICACAO

    CMP AL, '4'                     ; CASO ENTRADA SEJA 4, COMPARA AL COM 4, SE IGUAL PULA PARA DIVISAO
    JE DIVISAO

    CMP AL, '9'                     ; CASO ENTRADA SEJA 9, COMPARA AL COM 9, SE IGUAL TERMINA O PROGRAMA
    JE FIM

    LEA DX, PULA_LINHA              ; vai para a proxima linha
    CALL IMPRIMIR_MSG

    LEA DX, MSG11                   ; imprime MSG11
    CALL IMPRIMIR_MSG

    LEA DX, MSG10                   ; imprime MSG10
    CALL IMPRIMIR_MSG

    JMP CARACTER_INVALIDO           ; caso chegue nessa parte ele volta pois o caractere inserido nao é valido
; fim da escolha de operacao

; inicio ponte de jumps
    REINICIA_PROGRAMA2:             ; devido a uma resticao de tamanho, o umtimo jmp nao alcanca o REINICIA_PROGRAMA, 
        JMP REINICIA_PROGRAMA       ;  entao foi feito uma ponte para reiniciar o programa

    FIM:                            ; ponte para o jump FIM devido a restricao de tamanho do jump
        JMP FIM2
; fim pontes de jumps

; inicio das operacoes

; inicio da soma
ADICAO:
    CALL COR_DE_FUNDO                   ; chama a funcao para limpar tela e mudar de cor

    LEA DX, MSG24                       ; imprime "ADICAO" como titulo da nova tela
    CALL IMPRIMIR_MSG

    CALL INPUT                          ; chama a funcao para entrada de 2 numeros de 0 a 9

    CALL CALCULAR_SOMA                  ; chama a funcao que vai fazer a soma em binarios

    JMP TERMINA_OPERACAO                ; chama a funcao para exibir a resposta na tela e perguntar se quer fazer 
                                        ;  outra conta ou encerrar o programa
; fim da soma

; inicio da subtracao
SUBTRACAO:
    CALL COR_DE_FUNDO                   ; chama a funcao para limpar tela e mudar de cor

    LEA DX, MSG25                       ; imprime "SUBTRACAO" como titulo da nova tela
    CALL IMPRIMIR_MSG

    CALL INPUT                          ; chama a funcao para entrada de 2 numeros de 0 a 9

    CALL TESTE_POSITIVO_NEGATIVO        ; chama a funcao que testa se a resposta sera positivo ou negativo
        JL RESULTADO_NEGATIVO           ; caso resposta negativo, pula para o caso especial de resposta negativo

    CALL SUBTRACAO_RESULTADO_POSITIVO   ; chama a funcao para calcular a subtracao com resposta positivo

    JMP TERMINA_OPERACAO                ; chama a funcao para exibir a resposta na tela e perguntar se quer fazer 
                                        ;  outra conta ou encerrar o programa
 RESULTADO_NEGATIVO:

    CALL SUBTRACAO_RESULTADO_NEGATIVO   ; chama a funcao que fara a subtracao com o maior numero primeiro, e 
                                        ;  imprimira um resultado de negativo antes da resposta

    JMP TERMINA_OPERACAO                ; chama a funcao para exibir a resposta na tela e perguntar se quer fazer 
                                        ;  outra conta ou encerrar o programa
; fim da subtracao

; inicio da multiplicacao
MULTIPLICACAO:
    CALL COR_DE_FUNDO                   ; chama a funcao para limpar tela e mudar de cor

    LEA DX, MSG26                       ; imprime "MULTIPLICACAO" como titulo da nova tela
    CALL IMPRIMIR_MSG

    CALL INPUT                          ; chama a funcao para entrada de 2 numeros de 0 a 9

    CALL CALCULAR_MULTIPLICACAO         ; chama a funcao que ira calcular a multiplicacao em binario usando rotacao e soma
    
    JMP TERMINA_OPERACAO                ; chama a funcao para exibir a resposta na tela e perguntar se quer fazer 
                                        ;  outra conta ou encerrar o programa
; fim da multiplicacao

; inicio da divisao
DIVISAO:
    CALL COR_DE_FUNDO                   ; chama a funcao para limpar tela e mudar de cor

    LEA DX, MSG27                       ; imprime "DIVISAO" como titulo da nova tela
    CALL IMPRIMIR_MSG

    CALL INPUT                          ; chama a funcao para entrada de 2 numeros de 0 a 9

    CALL DIVISAO_COM_ZERO               ; realiza a verificacao de uma possivel entrada de 0 no segndo numero
        JE PULA4                        ; com a comparacao feita, pula caso algum numero da entrada seja 0

    CALL CALCULAR_DIVISAO               ; chama a funcao que vai fazer a divisao usando rotacao e subtracao

    CALL OUTPUT_QUOCIENTE               ; chama a funcao que vai imprimir o resultado do quociente na tela

    CALL OUTPUT_RESTO                   ; chama a funcao que vai imprimir o resultado do resto na tela

    CALL QUER_CONTINUAR                 ; caso queria realizar outra conta o programa pula para o inicio,
        JE REINICIA_PROGRAMA2           ;  caso nao, o programa pula para o fim
    
    JMP FIM

 PULA4:
    LEA DX, MSG22                       ; imprime a menssagem de impossibilidade de dividir por 0
    CALL IMPRIMIR_MSG

    JMP PULA7                           ; ja foi feito a impressao do resultado, entao pula para perguntar se continua o programa
; fim da divisao

; fim das operacoes


; inicio do termino do programa
TERMINA_OPERACAO:
    CALL OUTPUT                         ; chama a funcao para imprimir o resultado em 2 numeros de 2 bits
 PULA7:
    CALL QUER_CONTINUAR                 ; caso queria realizar outra conta o programa pula para o inicio, 
        JE REINICIA_PROGRAMA2           ;  caso nao, o programa pula para o fim

 FIM2:
    CALL ENCERRA_PROGRAMA               ; limpa a tela, muda a cor de fundo, imprime a menssagem de despedida e fecha o programa
; fim do termino do programa

MAIN ENDP


; apaga o conteudo impresso na tela e muda a cor de fundo
COR_DE_FUNDO PROC
 ; limpa a tela
    MOV AH,00       ; tipo de video
    MOV AL,03h      ; tipo de texto 80x25
    INT 10H         ; executa a entrada de video

 ; formata o modo de video
    MOV AH,09       ; escrever um caractere e atributo para a posicao do cursos
    MOV AL,20H      ; o caractere a mostrar
    MOV BH,00       ; numero da pagina
    MOV BL,6FH      ; atribuicao de cor
    MOV CX,800H     ; numero de vezes a escrever o caractere
    INT 10H         ; executa a entrada de video

    RET             ; retorna a funcao com a exibicao de video limpa e com a cor de fundo laranja
COR_DE_FUNDO ENDP

; definindo a primeira tela que apresenta o titulo da calculadora piscando
PRIMEIRA_PAGINA PROC
 ; limpa a tela
    MOV AH,00                   ; tipo de video
    MOV AL,00                   ; tipo de texto 40x25
    INT 10H                     ; executa a entrada de video

 ; formata o modo de video
    MOV AH,09                   ; escrever um caractere e atributo para a posicao do cursos
    MOV AL,20H                  ; o caractere a mostrar
    MOV BH,00                   ; numero da pagina
    MOV BL,9FH                  ; atribuicao de cor
    MOV CX,800H                 ; numero de vezes a escrever o caractere
    INT 10H                     ; executa a entrada de video

    LEA DX, MSG19               ; imprime "CALCULADORA BASICA"
    CALL IMPRIMIR_MSG

    XOR CX, CX
    MOV CX, 16
    PL:
    LEA DX, PULA_LINHA          ; imprime pular linha 15 vezes definido em CX para imprimir MSG12
    CALL IMPRIMIR_MSG
    LOOP PL

    LEA DX, MSG12               ; imprime "[APERTE QUALQUER TECLA]"
    CALL IMPRIMIR_MSG           

    MOV AH, 01H                 ; faz a entrada de um caractere apenas para sair da tela inicial
    INT 21H                     ;  caractere nao ficara salvo e nao tera nenhuma utilidade apos

    RET                         ; retorna a funcao com primeira tela do programa mostrando o titulo 
                                ;  do projeto com as letras piscando
PRIMEIRA_PAGINA ENDP

; imprime na tela um sumario das operacoes que podem ser selecionadas
SUMARIO PROC
    LEA DX, MSG5                ;imprime "ESCOLHA A OPERACAO A SER REALIZADA:"
    CALL IMPRIMIR_MSG

    LEA DX, MSG6                ;imprime "1-SOMA"
    CALL IMPRIMIR_MSG

    LEA DX, MSG7                ;imprime "2-SUBTRACAO"
    CALL IMPRIMIR_MSG

    LEA DX, MSG8                ;imprime "3-MULTIPLICACAO"
    CALL IMPRIMIR_MSG

    LEA DX, MSG9                ;imprime "4-DIVISAO"
    CALL IMPRIMIR_MSG

    LEA DX, MSG14               ;imprime "9-FINALIZAR PROGRAMA"
    CALL IMPRIMIR_MSG

    LEA DX, PULA_LINHA          ;passa para a proxima linha
    CALL IMPRIMIR_MSG

    LEA DX, MSG13               ;imprime "[DIGITE DE 1 A 4 PARA ESCOLHER, OU 9 PARA FECHAR]"
    CALL IMPRIMIR_MSG

    LEA DX, MSG10               ;imprime " >>>"
    CALL IMPRIMIR_MSG

    RET                         ; retorna a funcao com as opcoes de conta, ou encerramento do programa impressas na tela
SUMARIO ENDP

; entrada dos numeros para a operacao
INPUT PROC
 NUMERO_INVALIDO:
    LEA DX, MSG1            ; imprime "Digite o 1o numero: "
    CALL IMPRIMIR_MSG

    MOV AH,01H
    INT 21H                 ; faz a entrada do primeiro número da operação
    
    CMP AL, 57              ; como a entrada pode ser qualquer caractere e o programa trabalha
    JG NUMERO_INVALIDO      ;  com entrada de apenas um digito de numero (0 a 9), esse breve sistema 
                            ;  limitara a entrada de caracteres entre 48 (0 na tabela ASCII) a 57 (9 na tabela ASCII),
    CMP AL, 48              ;  fazendo um loop quando a entrada nao for entre 0 a 9
    JL NUMERO_INVALIDO
    
    SUB AL,30H              ; passa o caractere para numero
    MOV NUM1, AL            ; armazena o primeiro numero na variavel NUM1

; mesmos procedimentos, mas para a entrada do segundo numero para a operacao
 NUMERO_INVALIDO2:
    LEA DX, MSG2            ; imprime "Digite o 2o numero: "
    CALL IMPRIMIR_MSG

    MOV AH,01H
    INT 21H

    CMP AL, 57
    JG NUMERO_INVALIDO2

    CMP AL, 48
    JL NUMERO_INVALIDO2

    SUB AL,30H
    MOV NUM2, AL

    RET                     ; o retorno a funcao se dara com a entrada dos dois numeros armazenados nas variaveis NUM1 e NUM2
INPUT ENDP

; conversao do resultado em 2 numeros de 2 bits e imprime na tela
OUTPUT PROC
 ; o ultimo passo da conta, impressao do resultado na tela, que esta armazenado na variavel RESULTADO
    XOR AX, AX          ; zera conteudo de AX
    MOV AL, RESULTADO   ; passa o resultado para AL
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

; imprime o resto da divisao
OUTPUT_RESTO PROC
 ; realiza a mesma funcao do primeiro output, porem com a menssagem de resto antes de exibir a resposta e imprimira a variavel RESULTADO2
    LEA DX, MSG21       ; imprime "RESTO: "
    CALL IMPRIMIR_MSG

    XOR AX, AX          ; zera conteudo de AX                       
    MOV AL, RESULTADO2  ; passa o resultado para AL                 
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
OUTPUT_RESTO ENDP

; imprimir o quociente da divisao
OUTPUT_QUOCIENTE PROC
 ; realiza a mesma funcao do primeiro output, porem com a menssagem de quociente antes de exibir a resposta
    LEA DX, MSG20       ; imprime "QUOCIENTE: "
    CALL IMPRIMIR_MSG

    XOR AX, AX          ; zera conteudo de AX
    MOV AL, RESULTADO   ; passa o resultado para AL
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
OUTPUT_QUOCIENTE ENDP

; caso o segundo numero da entrada seja 0, impossivel realizar divisao por zero
DIVISAO_COM_ZERO PROC
    MOV AH, NUM2            ; conteudo de NUM2 sera passado para o registrador
    CMP AH, 0               ;  para fazer comparacao com zero

    RET                     ; a função retornara com a comparação do segundo numero da entrada com zero
DIVISAO_COM_ZERO ENDP

; soma
CALCULAR_SOMA PROC
 ; funcao que ira calcular a soma em binario, usando valores salvo em NUM1 e NUM2
 ; exemplo: 9d(1001b)+8d(1000b)=17d(10001b)
    MOV DL, NUM1        
    ADD DL, NUM2        ; faz a soma dos numeros e armazena na variavel RESULTADO
    MOV RESULTADO, DL

    LEA DX, MSG3        ; imprime "RESULTADO: "
    CALL IMPRIMIR_MSG

    RET                 ; retorna o resultado da soma salva na variavel RESULTADO e imprime na tela MSG3
CALCULAR_SOMA ENDP

; subtracao
TESTE_POSITIVO_NEGATIVO PROC
 ; antes da subtracao e necessario saber se o segundo numero armazenado em NUM2 e maior 
 ;  que NUM1, pois caso afirmativo, resposta sera positivo
    MOV AL, NUM1        ;no caso da subtracao, caso segundo valor maior que o primeiro, resultado sera negativo
    MOV BL, NUM2        ; para isso comparamos num1 e num2, caso positivo ignora o pulo para "resultado_negativo"
    CMP AL, BL          ; e resolve a conta num1-num2, caso contrario, pula para "resultado_negativo" e faz num2-num1
                        ; e adiciona o sinal de negativo antes da resposta final

    RET                 ; retorna a funcao com a comparacao de AL com BL para fazer o jump condicional em seguida
TESTE_POSITIVO_NEGATIVO ENDP

SUBTRACAO_RESULTADO_POSITIVO PROC
 ; funcao que ira calcular a subtracao em binario, usando valores salvo em NUM1 e NUM2 nessa ordem
 ; exemplo: 9d(1001b)-8d(1000b)=1d(0001b)
    MOV DL, NUM1        
    SUB DL, NUM2        ; faz a subtracao dos numero e armazena em "resultado"
    MOV RESULTADO, DL

    LEA DX, MSG3
    MOV AH, 09H         ; imprime "RESULTADO: "
    INT 21H

    RET                 ; retorna a funcao com o resultado da subtracao de resultado positivo salvo na variavel RESULTADO
SUBTRACAO_RESULTADO_POSITIVO ENDP

SUBTRACAO_RESULTADO_NEGATIVO PROC
 ; funcao que ira calcular a subtracao em binario, usando valores salvo em NUM1 e NUM2, porem subtraindo NUM1 de NUM2
 ; exemplo: 8d-9d=-1d  ==  9d(1001b)-8d(1000b)=-1d(0001b) (sinal de menos adicionado manualmente)
    MOV DL, NUM2
    SUB DL, NUM1            ; faz a subtracao invertendo a ordem para deixar o maior valor
                            ;  primeiro e armazena na variavel RESULTADO
    MOV RESULTADO, DL

    LEA DX, MSG3            ; imprime "RESULTADO: "
    CALL IMPRIMIR_MSG

    LEA DX, SINAL_NEGATIVO  ; imprime "-"
    CALL IMPRIMIR_MSG

    RET                     ; retorna a funcao com o resultado da subtracao invertida na 
                            ;  variavel RESULTADO com o sinal de negativo antes de exibir a resposta
SUBTRACAO_RESULTADO_NEGATIVO ENDP

; multiplicacao
CALCULAR_MULTIPLICACAO PROC
 ; procedimento para calcular a multiplicacao em binário, e armazenar o resultado na variavel RESULTADO
 ; exemplo: 3d(11b)*2d(10b)=6d(110b)
 ; BL = 11b
 ; *
 ; BH = 10b -> CF=0 recebe o numero mais a direita, como 0, nao adiciona o primeiro valor ao resultado em DL,
 ;                                            e rotaciona o primeiro valor a esquerda adicionando 
 ;                                            um zero a sua direita, BL antes 11b / BL depois 110b, 
 ;                                            BH antes = 10b / BH depois = 1b
 ; resultado da primeira operacao = 00
 ; seunda repeticao
 ; BH = 1b -> CF=1       como o CF agora tem 1, BL vai ser somado em DL(resultado), fincando DL antes = 0b/ depois = 110b
 ; esse processo se repete 4 vezes, mas como BH ficou 0b depois da segunda conta, ambas repeticoes nao influenciaram no resultado final
 ; a resposta em DL sera movida para a variavel RESPOSTA

    XOR DX, DX          ; inicializa dx com 0
    MOV CX, 4           ; inicializa cx com 4 para reptir o loop 4 vezes

    MOV BL,NUM1         ; numero que sera adicionado no resultado e rotacionado a esquerda a cada repeticao
    MOV BH,NUM2         ; numero que vai ser a quantidade de vezes que o num1 vai ser adicionado, 
                        ;  sendo esse num2 binario que mandara um valor para a cf, e caso 0 pula 
                        ;  a soma do num1 no resultado e caso 1 adiciona o num1 ao resultado

  VOLTA:
    SHR BH,1            ; movimenta NUM2 p/ CF (caso 1 adciona BL ao resultado e desloca o num1
    JNC PULA            ;  para esquerda para a proxima soma, caso 0 apenas desloca NUM1 p/ esquerda
    ADD DL,BL

  PULA:
    SHL BL,1            ; para a proxima soma e preciso deslocar uma casa a esquerda pois o numero a ser somado
                        ;  tem a adicao de um 0 a sua esquerda exemplo(antes= BL-0001b / depois= BL-0010b) 
    LOOP VOLTA

    MOV RESULTADO,DL    ; passa o resultado final para a variavel RESULTADO

    LEA DX, MSG3        ; imprime "RESULTADO: "
    CALL IMPRIMIR_MSG

    RET                 ; retorna a funcao com a multiplicacao feita e com o resultado salvo na variavel
CALCULAR_MULTIPLICACAO ENDP

; divisao
CALCULAR_DIVISAO PROC
    XOR AX, AX              ; zera os registradores
    XOR BX, BX
    XOR CX, CX
    XOR DX, DX

    MOV AH, NUM2            ; passa para o registrador o conteudo da variavel num2
    MOV CL, 4               ; havera um loop de 4 vezes que usa cx como contador pois
                            ;  a divisao tera no maximo 4 digitos de bits

VOLTA3:
    MOV AL, NUM1            ; o registrador AL (dividendo) recebe num1 toda vez que houver o loop para 
                            ;  fazer um deslocamento a direita com a quantidade que esta em CL 
                            ;  (cada vez que o loop acontece ha um decremento)
    SHR AL, CL              ; move para a carry flag os valores de NUM1 mais a esquerda, decrementando cada loop
                            ;  exemplo AL=9 CX=4(antes= CL - 04  AL - 1001b  CF - 0 / depois= CL - 04  AL - 0000b  CF - 1)
    RCL DL, 1               ; move o valor salvo do CF para DL exemplo(antes= DL - 0001b  CF - 1 / depois DL - 0011b  CF - 0
    CMP AH, DL              ; compara AH (NUM2) com DL (resto), caso o resto seja menor, pula, pois não tem como subtrair o resto, e nao incrementa o quociente
    JG PULA5                ; caso NUM2 for maior que o resto, nao cabe para subtrair o resto, ent pula
    SUB DL, AH              ; caso NUM2 menor que o resto, quer dizer que ele cabe uma vez no resto, ent subtrai o divisor pelo resto
    INC DH                  ; como o divisor cabe no resto, incrementa 1 no quociente
PULA5:
    CMP CL, 1               ; quando CL for 1, nao pode mover DH para a esquerda pois ja terminou a divisao
    JE PULA6                ; pula para o fim (uma vez que CL = 1, nao fara o loop)
    SHL DH, 1               ; caso CL nao seja 1, entao a divisao continua, e o quociente desloca os binarios a esquerda 
                            ; exemplo(antes=0001/depois=0010) para que o proximo quociente seja adicionado a direita
PULA6:
    LOOP VOLTA3             ; repete todo o processo 4 vezes, pois a maior entrada é 9 (1001b) com 4 binarios

    MOV RESULTADO, DH       ; quociente
    MOV RESULTADO2, DL      ; resto

    RET                     ; retorna a funcao com o quociente e o resto armazenados nas variaveis
CALCULAR_DIVISAO ENDP

; fim de programa
ENCERRA_PROGRAMA PROC
    CALL COR_DE_FUNDO   ; limpa a tela e muda a cor de fundo

    LEA DX, PULA_LINHA  ; passa para a linha de baixo
    CALL IMPRIMIR_MSG

    LEA DX, MSG15       ; imprime "///O PROGRAMA FOI ENCERRADO, OBRIGADO POR USAR\\\"
    CALL IMPRIMIR_MSG

    LEA DX, PULA_LINHA
    CALL IMPRIMIR_MSG

    LEA DX, MSG23       ; imprime "===PROGRAMA FEITO POR VICTOR DE MELO ROSTON==="
    CALL IMPRIMIR_MSG

    MOV CX,11           ; inicializa cx com 11
VOLTA1:
    LEA DX, PULA_LINHA
    CALL IMPRIMIR_MSG   ; realiza um loop para pular linha 10 vezes
    LOOP VOLTA1


    MOV AH, 4CH         ; ENCERRA O PROGRAMA!
    INT 21H

    RET                 ; retorna a funcao com o programa encerrado
ENCERRA_PROGRAMA ENDP

; automatizacao do processo para imprimir as menssagens
IMPRIMIR_MSG PROC
    MOV AH,09H      ; codigo para entrada de caractere pelo teclado
    INT 21H         ; realiza a entrada do caractere pelo teclado e armazena no registrador AL

    RET             ; retorna a funcão com a entrada de caractere em AL, e o AH ocupado com conteudo desnecessario
IMPRIMIR_MSG ENDP

; apos uma conta o usuario decide se reinicia o programa ou o encerra
QUER_CONTINUAR PROC
    LEA DX, PULA_LINHA      ; passa para a linha de baixo
    CALL IMPRIMIR_MSG

    LEA DX, MSG16           ; imprime "GOSTARIA DE CONTINUAR?"
    CALL IMPRIMIR_MSG

    LEA DX, MSG17           ; imprime "SIM - APERTE 1"
    CALL IMPRIMIR_MSG

    LEA DX, MSG18           ; imprime "NAO - APERTE QUALQUER TECLA"
    CALL IMPRIMIR_MSG

    LEA DX, MSG10           ; imprime " >>>"
    CALL IMPRIMIR_MSG

    MOV AH, 01              ; entrada de caractere pelo teclado
    INT 21H

    SUB AL, 30H             ; transforma o caractere ASCII da entrada em numero
    MOV BH, 1               ; compara com um, caso seja reinicia o programa, caso 
    CMP AL, BH              ;  seja qualquer outro caractere reinicia o programa

    RET                     ; retorna para a funcao a comparacao de AL e BL para fazer o salto condicional
QUER_CONTINUAR ENDP

END MAIN