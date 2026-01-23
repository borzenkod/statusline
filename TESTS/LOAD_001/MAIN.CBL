       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-BODY                      PIC IS X(42).
       PROCEDURE DIVISION.
           MOVE "1M"                   TO WS-BODY
           CALL 'DLOADHOOK' USING WS-BODY
           END-CALL
           GOBACK.
