       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-BODY                      PIC IS X(42).
       PROCEDURE DIVISION.
           MOVE "./BAT"                TO WS-BODY
           INSPECT WS-BODY
                   REPLACING TRAILING SPACES BY X'00'
           MOVE "C"                    TO WS-BODY(42:1)
           CALL 'DBATTHOOK' USING WS-BODY
           END-CALL
           GOBACK.
