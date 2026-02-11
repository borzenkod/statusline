       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/OUTPUT.CPY".
       PROCEDURE DIVISION.
           SET L-TYPE                  TO 0
           SET L-TEXT                  TO SPACES
           SET L-COLOR-FG              TO '12345678'
           SET L-COLOR-BG              TO 'ABCDEF12'
           SET L-PART                  TO 6
           SET L-BODY                  TO SPACES
           CALL 'OUTPUT_FMT'
           END-CALL
           GOBACK.
