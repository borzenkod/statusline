       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 L-BODY              EXTERNAL PIC IS X(42).
       01 WS-DATA                      PIC IS X(128).
       PROCEDURE DIVISION.
           MOVE "./BAT"                TO L-BODY
           INSPECT L-BODY
                   REPLACING TRAILING SPACES BY X'00'
           MOVE "C"                    TO L-BODY(42:1)
           CALL 'MOD_BATTERY_INIT' USING WS-DATA
           END-CALL
           CALL 'MOD_BATTERY' USING WS-DATA
           END-CALL
           GOBACK.
