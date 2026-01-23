       IDENTIFICATION DIVISION.
       PROGRAM-ID. DSEPHOOK.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-TYPE             EXTERNAL PIC IS 9 VALUE IS 0.
       COPY "COPYBOOKS/OUTPUT.CPY".
       PROCEDURE DIVISION.
           SET L-COLOR-FG              TO L-COLOR-BG
           SET L-COLOR-BG              TO L-COLOR-BG-LAST
           SET L-PART                  TO 6
           CALL 'OUTPUT_FMT'
           END-CALL
           SET L-PART                  TO 5
           CALL 'OUTPUT_FMT'
           END-CALL
           IF L-BODY(1:1) = "<" 
             DISPLAY " "
               WITH NO ADVANCING
             END-DISPLAY
           END-IF
           IF L-BODY(1:1) = ">"
             DISPLAY " "
               WITH NO ADVANCING
             END-DISPLAY
           END-IF
           IF L-BODY(1:1) = "=" 
             DISPLAY " |"
               WITH NO ADVANCING
             END-DISPLAY
           END-IF
           SET L-PART                  TO 6
           CALL 'OUTPUT_FMT'
           END-CALL
           SET L-COLOR-BG              TO L-COLOR-FG
           SET L-PART                  TO 5
           CALL 'OUTPUT_FMT'
           END-CALL
           DISPLAY " " WITH NO ADVANCING
           END-DISPLAY
           SET L-PART                  TO 6
           CALL 'OUTPUT_FMT'
           END-CALL
           SET L-PART                  TO 5
           CALL 'OUTPUT_FMT'
           END-CALL
           SET L-PART                  TO 3
           GOBACK.
