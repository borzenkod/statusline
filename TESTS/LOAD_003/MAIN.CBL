       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 L-BODY              EXTERNAL PIC IS X(42).
       01 WS-DATA                      PIC IS X(128).
       PROCEDURE DIVISION.
           MOVE "15M"                  TO L-BODY
           CALL 'MOD_LOAD_INIT' USING WS-DATA
           END-CALL
           CALL 'MOD_LOAD' USING WS-DATA
           END-CALL
           GOBACK.
