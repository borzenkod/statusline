       IDENTIFICATION DIVISION.
       PROGRAM-ID. DSEPHOOK.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-TYPE             EXTERNAL PIC IS 9 VALUE IS 0.
       COPY "src/output.cpy".
       PROCEDURE DIVISION.
           SET L-COLOR-FG              TO L-COLOR-BG
           SET L-COLOR-BG              TO L-COLOR-BG-LAST
           SET L-PART                  TO 6
           CALL 'OUTPUT_FMT'
           SET L-PART                  TO 5
           CALL 'OUTPUT_FMT'
           IF L-BODY(1:1) = "<" DISPLAY " " WITH NO ADVANCING
           END-IF
           IF L-BODY(1:1) = "=" DISPLAY " |" WITH NO ADVANCING
           END-IF
           SET L-PART                  TO 6
           CALL 'OUTPUT_FMT'
           SET L-PART                  TO 5
           CALL 'OUTPUT_FMT'
           SET L-COLOR-BG              TO L-COLOR-FG
           DISPLAY " " WITH NO ADVANCING
           SET L-PART                  TO 6
           CALL 'OUTPUT_FMT'
           SET L-PART                  TO 5
           CALL 'OUTPUT_FMT'
           SET L-PART                  TO 3
           GOBACK.
