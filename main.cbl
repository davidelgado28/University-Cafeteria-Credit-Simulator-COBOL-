IDENTIFICATION DIVISION.
       PROGRAM-ID. REFEITORIO.
       AUTHOR. PROFESSOR-COMPUTACAO.
       DETAIL. SIMULADOR DE CREDITOS DE REFEITORIO UNIVERSITARIO.

       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SPECIAL-NAMES.
           DECIMAL-POINT IS COMMA.

       DATA DIVISION.
       WORKING-STORAGE SECTION.

       01  TABELA-ALUNOS-RAW.
           05 FILLER PIC X(38) VALUE "123456789MARIA SILVA      0150001234".
           05 FILLER PIC X(38) VALUE "987654321JOAO SOUZA      0050504321".
           05 FILLER PIC X(38) VALUE "456789123ANA OLIVEIRA    0300259999".

       01  TABELA-ALUNOS REDEFINES TABELA-ALUNOS-RAW.
           05 REGISTRO-ALUNO OCCURS 3 TIMES.
              10 ALUNO-ID          PIC 9(09).
              10 ALUNO-NOME        PIC X(15).
              10 ALUNO-SALDO       PIC 9(05)V99.
              10 ALUNO-TOKEN       PIC 9(04).

       77  WS-ENTRADA-ID           PIC 9(09) VALUE ZEROS.
       77  WS-ENTRADA-TOKEN        PIC 9(04) VALUE ZEROS.
       77  WS-INDICE               PIC 9(02) VALUE ZEROS.
       77  WS-VALOR-OPERACAO       PIC 9(03)V99 VALUE ZEROS.
       77  WS-SALDO-EDITADO        PIC ZZZ.ZZ9,99.
       77  WS-VALOR-EDITADO        PIC ZZZ.ZZ9,99.

       01  WS-FLAG-AUTENTICADO     PIC X VALUE "N".
           88 AUTENTICADO          VALUE "S".
           88 NAO-AUTENTICADO      VALUE "N".

       01  WS-OPCAO-MENU           PIC 9 VALUE ZERO.
           88 OPCAO-CONSULTAR      VALUE 1.
           88 OPCAO-DEBITO         VALUE 2.
           88 OPCAO-RECARGA        VALUE 3.
           88 OPCAO-LOGOFF         VALUE 4.

       01  WS-FLAG-SISTEMA         PIC X VALUE "A".
           88 SISTEMA-ATIVO        VALUE "A".
           88 SISTEMA-ENCERRADO    VALUE "E".

       PROCEDURE DIVISION.
       0000-PRINCIPAL.
           PERFORM 1000-INICIALIZAR
           PERFORM 2000-FLUXO-SISTEMA UNTIL SISTEMA-ENCERRADO
           DISPLAY " "
           DISPLAY "=== PROGRAMA FINALIZADO COM SUCESSO ==="
           STOP RUN.

       1000-INICIALIZAR.
           SET SISTEMA-ATIVO TO TRUE.

       2000-FLUXO-SISTEMA.
           PERFORM 2100-AUTENTICAR-ALUNO
           IF AUTENTICADO
               PERFORM 3000-MENU-INTERATIVO UNTIL OPCAO-LOGOFF
           END-IF.

       2100-AUTENTICAR-ALUNO.
           SET NAO-AUTENTICADO TO TRUE
           DISPLAY " "
           DISPLAY "========================================"
           DISPLAY "  REFEITORIO UNIVERSITARIO - LOGIN"
           DISPLAY "========================================"
           DISPLAY "Informe o ID do Aluno (9 digitos): " WITH NO ADVANCING
           ACCEPT WS-ENTRADA-ID
           DISPLAY "Informe o Token de Acesso (4 digitos): " WITH NO ADVANCING
           ACCEPT WS-ENTRADA-TOKEN

           PERFORM VARYING WS-INDICE FROM 1 BY 1 UNTIL WS-INDICE > 3 OR AUTENTICADO
               IF ALUNO-ID(WS-INDICE) = WS-ENTRADA-ID AND
                  ALUNO-TOKEN(WS-INDICE) = WS-ENTRADA-TOKEN
                   SET AUTENTICADO TO TRUE
               END-IF
           END-PERFORM

           IF NAO-AUTENTICADO
               DISPLAY " "
               DISPLAY ">>> ERRO: ID ou Token invalido! Tente novamente."
           ELSE
               -- DECREMENTA INDICE PARA MANTER O ALUNO LOCALIZADO
               SUBTRACT 1 FROM WS-INDICE
               DISPLAY " "
               DISPLAY ">>> Bem-vindo(a), " ALUNO-NOME(WS-INDICE) "!"
           END-IF.

       3000-MENU-INTERATIVO.
           DISPLAY " "
           DISPLAY "----------------------------------------"
           DISPLAY "          MENU DE OPCOES"
           DISPLAY "----------------------------------------"
           DISPLAY "1 - Consultar Credito Atual"
           DISPLAY "2 - Debito de Credito (Uso RU)"
           DISPLAY "3 - Recarga de Credito"
           DISPLAY "4 - Finalizar Sessao (Sair)"
           DISPLAY "Escolha uma opcao: " WITH NO ADVANCING
           ACCEPT WS-OPCAO-MENU

           EVALUATE TRUE
               WHEN OPCAO-CONSULTAR
                   PERFORM 3100-CONSULTAR-CREDITO
               WHEN OPCAO-DEBITO
                   PERFORM 3200-DEBITAR-CREDITO
               WHEN OPCAO-RECARGA
                   PERFORM 3300-RECARREGAR-CREDITO
               WHEN OPCAO-LOGOFF
                   DISPLAY " "
                   DISPLAY ">>> Encerrando sessao do usuario..."
               WHEN OTHER
                   DISPLAY " "
                   DISPLAY ">>> Opcao invalida! Tente novamente."
           END-EVALUATE.

       3100-CONSULTAR-CREDITO.
           MOVE ALUNO-SALDO(WS-INDICE) TO WS-SALDO-EDITADO
           DISPLAY " "
           DISPLAY "----------------------------------------"
           DISPLAY "Aluno: " ALUNO-NOME(WS-INDICE)
           DISPLAY "Saldo Atual: R$ " WS-SALDO-EDITADO
           DISPLAY "----------------------------------------".

       3200-DEBITAR-CREDITO.
           DISPLAY " "
           DISPLAY "Informe o valor a debitar: R$ " WITH NO ADVANCING
           ACCEPT WS-VALOR-OPERACAO

           IF WS-VALOR-OPERACAO <= 0
               DISPLAY ">>> ERRO: Valor para debito deve ser maior que zero."
           ELSE IF WS-VALOR-OPERACAO > ALUNO-SALDO(WS-INDICE)
               MOVE ALUNO-SALDO(WS-INDICE) TO WS-SALDO-EDITADO
               DISPLAY " "
               DISPLAY ">>> ERRO: Saldo insuficiente!"
               DISPLAY "    Saldo disponivel: R$ " WS-SALDO-EDITADO
           ELSE
               SUBTRACT WS-VALOR-OPERACAO FROM ALUNO-SALDO(WS-INDICE)
               MOVE ALUNO-SALDO(WS-INDICE) TO WS-SALDO-EDITADO
               MOVE WS-VALOR-OPERACAO     TO WS-VALOR-EDITADO
               DISPLAY " "
               DISPLAY ">>> Debito de R$ " WS-VALOR-EDITADO " realizado!"
               DISPLAY "    Novo Saldo: R$ " WS-SALDO-EDITADO
           END-IF.

       3300-RECARREGAR-CREDITO.
           DISPLAY " "
           DISPLAY "Informe o valor da recarga: R$ " WITH NO ADVANCING
           ACCEPT WS-VALOR-OPERACAO

           IF WS-VALOR-OPERACAO <= 0
               DISPLAY ">>> ERRO: O valor de recarga deve ser maior que zero."
           ELSE
               ADD WS-VALOR-OPERACAO TO ALUNO-SALDO(WS-INDICE)
               MOVE ALUNO-SALDO(WS-INDICE) TO WS-SALDO-EDITADO
               MOVE WS-VALOR-OPERACAO     TO WS-VALOR-EDITADO
               DISPLAY " "
               DISPLAY ">>> Recarga de R$ " WS-VALOR-EDITADO " realizada com sucesso!"
               DISPLAY "    Novo Saldo: R$ " WS-SALDO-EDITADO
           END-IF.
