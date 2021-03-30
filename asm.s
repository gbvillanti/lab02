        PUBLIC  __iar_program_start
        PUBLIC  __vector_table

        SECTION .text:CODE:REORDER(1)
        
        ;; Keep vector table even if it's not referenced
        REQUIRE __vector_table
        
        THUMB
        
__iar_program_start
        
;;A l�gica utilizada: Partindo do princ�pio que a multiplica��o � o inverso da divis�o, um numero multiplicado por outro � o mesmo
;;que soma-lo n vezes. Para determinar n, dividimos o valor por 2 e utilizamos o quociente e caso seja impar utilizamos o resto da
;; divisao para atingir o resultado esperado somando ele a ele mesmo
;;Dividindo o R1 por 2, verificamos se � par, resto zero.
;;Caso seja, as multiplica��es ir�o funcionar de forma que R0 seja multiplicado por 2 e incrementado at� atingir o valor final
;;A quantidade de vezes que isso ir� ocorrer � determinada pelo quociente R3.
;;Multiplicando o R3 por 2 novamente, joga-se em R4 e subtrai de R1 para verificar se h� resto
;;Explicando o passo anterior: caso o quociente multiplcado por 2 nao seja o valor de R1, h� resto que ser� armazenado em R4
;;Se o R1 for impar, ser� adicionado uma vez o valor do R0 para concluir a multiplica��o, estaremos incluindo a soma do resto
main
        MOV R0, #6
        MOV R1, #7
        MOV LR, PC
        CBNZ R1, Mul16b
        
        B fim
        
fim     B fim

Mul16b  LSR R3, R1, #1   ;;verifica se � par e armazena em R3 a quantidade de vezes que ir� multiplicar, ser� o nosso quociente
        LSL R4, R3, #1   ;;multiplicando o quociente por 2, para verificar se haver� resto
        SUBS R4, R1, R4  ;;calcula o resto. Se der zero n�o ser� necess�rio a soma do resto
        ADD R5, R0, R0   ;;faz a primeira soma e armazena no R5
        MOV R6, PC       ;;guarda 
        B mult
        CBNZ R4, somaImp
        MOV PC, LR       ;;coloca no PC o LR, para sair da subrotina

mult    ADD R2, R2, R5   ;;
        SUBS R3, R3, #1  ;;decrementa o multiplicador
        CBZ R3, encerrar ;;encerra o la�o caso o multiplicador chegue a zero

loop    B mult           ;;la�o que realiza as somas

encerrar MOV PC, R6      ;;coloca no PC 

somaImp ADD R2, R2, R0   ;;soma o numero a ele mesmo para finalizar a multiplica��o com o resto
        MOV PC, LR  
        
        
        ;; Forward declaration of sections.
        SECTION CSTACK:DATA:NOROOT(3)
        SECTION .intvec:CODE:NOROOT(2)
        
        DATA

__vector_table
        DCD     sfe(CSTACK)
        DCD     __iar_program_start

        DCD     NMI_Handler
        DCD     HardFault_Handler
        DCD     MemManage_Handler
        DCD     BusFault_Handler
        DCD     UsageFault_Handler
        DCD     0
        DCD     0
        DCD     0
        DCD     0
        DCD     SVC_Handler
        DCD     DebugMon_Handler
        DCD     0
        DCD     PendSV_Handler
        DCD     SysTick_Handler

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Default interrupt handlers.
;;

        PUBWEAK NMI_Handler
        PUBWEAK HardFault_Handler
        PUBWEAK MemManage_Handler
        PUBWEAK BusFault_Handler
        PUBWEAK UsageFault_Handler
        PUBWEAK SVC_Handler
        PUBWEAK DebugMon_Handler
        PUBWEAK PendSV_Handler
        PUBWEAK SysTick_Handler

        SECTION .text:CODE:REORDER:NOROOT(1)
        THUMB

NMI_Handler
HardFault_Handler
MemManage_Handler
BusFault_Handler
UsageFault_Handler
SVC_Handler
DebugMon_Handler
PendSV_Handler
SysTick_Handler
Default_Handler
__default_handler
        CALL_GRAPH_ROOT __default_handler, "interrupt"
        NOCALL __default_handler
        B __default_handler

        END
