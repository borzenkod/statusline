       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-CALLBACK PROCEDURE-POINTER.
       01 WS-TYPE PIC IS 9 VALUE IS 9.
       PROCEDURE DIVISION.
       Main.
           CALL 'AUTO-DETECT' USING BY REFERENCE WS-TYPE END-CALL
           CALL 'OUTPUT_FMT' USING WS-TYPE 0 0 1
           PERFORM LoopInner UNTIL 1<0
           STOP RUN.
       LoopInner.
           CALL 'OUTPUT_FMT' USING WS-TYPE 0 0 2
           SET WS-CALLBACK TO ENTRY 'DBATTHOOK'.
           CALL
               'OUTPUT_FMT' USING
               WS-TYPE WS-CALLBACK "ff0f0f" 3
           END-CALL
           SET WS-CALLBACK TO ENTRY 'DMEMHOOK'.
           CALL
               'OUTPUT_FMT' USING
               WS-TYPE WS-CALLBACK "ffffff" 3
           END-CALL
           SET WS-CALLBACK TO ENTRY 'DLOADHOOK'.
           CALL
               'OUTPUT_FMT' USING
               WS-TYPE WS-CALLBACK "ff0fff" 3
           END-CALL
           SET WS-CALLBACK TO ENTRY 'DDATEHOOK'.
           CALL
               'OUTPUT_FMT' USING
               WS-TYPE WS-CALLBACK "ffffff" 3
           END-CALL
           SET WS-CALLBACK TO ENTRY 'DTIMEHOOK'.
           CALL
               'OUTPUT_FMT' USING
               WS-TYPE WS-CALLBACK "ffff0f" 3
           END-CALL
           CALL 'OUTPUT_FMT' USING WS-TYPE 0 0 4
           CONTINUE AFTER 1 SECONDS
           EXIT PARAGRAPH.
