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

       PROCEDURE DIVISION.
       Main.
           DISPLAY "{ " QUOTE "version" QUOTE ": 1 }"
           DISPLAY "["
           PERFORM UNTIL 1<0 
               PERFORM LoopInner
           END-PERFORM
           STOP RUN.

       LoopInner.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-FIELDS

           DISPLAY "["
           DISPLAY "{"
           DISPLAY QUOTE "full_text" QUOTE ": " QUOTE WITH NO ADVANCING
           DISPLAY WS-CURRENT-DAY, "/" WITH NO ADVANCING
           DISPLAY WS-CURRENT-MONTH, "/" WITH NO ADVANCING
           DISPLAY WS-CURRENT-YEAR WITH NO ADVANCING
           DISPLAY QUOTE ","
           DISPLAY QUOTE "color" QUOTE ": " QUOTE "#00ff00" QUOTE
           DISPLAY "},"
           DISPLAY "{"
           DISPLAY QUOTE "full_text" QUOTE ": " QUOTE WITH NO ADVANCING
           DISPLAY WS-CURRENT-HOUR, ":" WITH NO ADVANCING
           DISPLAY WS-CURRENT-MINUTE, ":" WITH NO ADVANCING
           DISPLAY WS-CURRENT-SECOND WITH NO ADVANCING
           DISPLAY QUOTE ","
           DISPLAY QUOTE "color" QUOTE ": " QUOTE "#f00f00" QUOTE
           DISPLAY "},"

           DISPLAY "],"
           CONTINUE AFTER 1 SECONDS

           EXIT PARAGRAPH.

