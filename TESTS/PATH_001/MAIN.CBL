       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-BODY                      PIC IS X(42).
       PROCEDURE DIVISION.
           MOVE "/does/not/exist/"     TO WS-BODY
           CALL 'DPATHHOOK' USING WS-BODY
           END-CALL
           GOBACK.
