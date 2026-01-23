       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/OUTPUT.CPY".
       PROCEDURE DIVISION.
           SET L-TYPE                  TO 0
           SET L-TEXT                  TO ENTRY 'HOOK'
           SET L-COLOR-BG              TO '000000FF'
           SET L-COLOR-FG              TO '000000FF'
           SET L-PART                  TO 3
           SET L-BODY                  TO SPACES
           CALL 'OUTPUT_FMT'
           END-CALL
           GOBACK.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HOOK.
       PROCEDURE DIVISION.
           DISPLAY "DATA" WITH NO ADVANCING
           END-DISPLAY
           GOBACK.
       END PROGRAM HOOK.
