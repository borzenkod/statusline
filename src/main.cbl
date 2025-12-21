       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-CALLBACK PROCEDURE-POINTER.
       01 WS-OUTPUT-TYPE PIC IS 9 VALUE IS 0.
       PROCEDURE DIVISION.
       Main.
           DISPLAY "{ " QUOTE "version" QUOTE ": 1 }"
           DISPLAY "["
           PERFORM UNTIL 1<0 
               PERFORM LoopInner
           END-PERFORM
           STOP RUN.

       LoopInner.
           DISPLAY "["
           SET WS-CALLBACK TO ENTRY 'DMEMHOOK'.
           CALL
               'OUTPUT_FMT' USING
               WS-OUTPUT-TYPE WS-CALLBACK "ffffff"
           END-CALL
           SET WS-CALLBACK TO ENTRY 'DLOADHOOK'.
           CALL
               'OUTPUT_FMT' USING
               WS-OUTPUT-TYPE WS-CALLBACK "ff0fff"
           END-CALL
           SET WS-CALLBACK TO ENTRY 'DDATEHOOK'.
           CALL
               'OUTPUT_FMT' USING
               WS-OUTPUT-TYPE WS-CALLBACK "ffffff"
           END-CALL
           SET WS-CALLBACK TO ENTRY 'DTIMEHOOK'.
           CALL
               'OUTPUT_FMT' USING
               WS-OUTPUT-TYPE WS-CALLBACK "ffff0f"
           END-CALL
           DISPLAY "],"

           CONTINUE AFTER 1 SECONDS

           EXIT PARAGRAPH.
