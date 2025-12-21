       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
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
           CALL 'DMEM'
           CALL 'DLOAD'
           CALL 'DDATE'
           CALL 'DTIME'
           DISPLAY "],"

           CONTINUE AFTER 1 SECONDS

           EXIT PARAGRAPH.
