       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 L-BODY              EXTERNAL PIC IS X(42).
       01 WS-DATA                      PIC IS X(128).
       PROCEDURE DIVISION.
           MOVE "/does/not/exist/"     TO L-BODY
           CALL 'MOD_PATH_INIT' USING WS-DATA
           END-CALL
           CALL 'MOD_PATH' USING WS-DATA
           END-CALL
           GOBACK.
