       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-CURRENT-DATE-FIELDS.
        05  WS-CURRENT-DATE.
           10  WS-CURRENT-YEAR    PIC  9(4).
           10  WS-CURRENT-MONTH   PIC  9(2).
           10  WS-CURRENT-DAY     PIC  9(2).
        05  WS-CURRENT-TIME.
           10  WS-CURRENT-HOUR    PIC  9(2).
           10  WS-CURRENT-MINUTE  PIC  9(2).
           10  WS-CURRENT-SECOND  PIC  9(2).
           10  WS-CURRENT-MS      PIC  9(2).
        05  WS-DIFF-FROM-GMT      PIC S9(4).

       01 WS-POINTER PROGRAM-POINTER.


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
           CALL 'DDATE'
           CALL 'DTIME'
           DISPLAY "],"

           CONTINUE AFTER 1 SECONDS

           EXIT PARAGRAPH.
