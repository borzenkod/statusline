       IDENTIFICATION DIVISION.
       PROGRAM-ID. OUTPUT_FMT.
       DATA DIVISION.
       LINKAGE SECTION.
      * TYPE:
      * 0: i3
      * 1: term
      * <other>: term
       77 L-TYPE  PIC IS 9.
       77 L-TEXT  PROCEDURE-POINTER.
       77 L-COLOR PIC IS X(6).
      * PART:
      * 1: Header
      * 2: BodyStart
      * 3: Body
      * 4: BodyEnd
       01 L-PART  PIC IS 9.
       PROCEDURE DIVISION USING L-TYPE L-TEXT L-COLOR L-PART.
           EVALUATE L-PART
             WHEN 1 PERFORM Header
             WHEN 2 PERFORM BodyStart
             WHEN 3 PERFORM Body
             WHEN 4 PERFORM BodyEnd
             WHEN OTHER CONTINUE
           END-EVALUATE
           GOBACK.

       Header.
           IF L-TYPE = 0
             DISPLAY "{ " QUOTE "version" QUOTE ": 1 }"
             DISPLAY "["
           END-IF
           EXIT PARAGRAPH.
       BodyStart.
           IF L-TYPE = 0
             DISPLAY "["
           END-IF
           EXIT PARAGRAPH.
       Body.
           EVALUATE L-TYPE
               WHEN 0     PERFORM i3
               WHEN 1     PERFORM term
               WHEN OTHER PERFORM term
           END-EVALUATE
           EXIT PARAGRAPH.
       BodyEnd.
           EVALUATE L-TYPE
             WHEN 0 DISPLAY "],"
             WHEN 1 DISPLAY " "
           END-EVALUATE
           EXIT PARAGRAPH.

       i3.
           DISPLAY "{"
           DISPLAY QUOTE "full_text" QUOTE ": " QUOTE WITH NO ADVANCING
           CALL L-TEXT.
           DISPLAY QUOTE ","
           DISPLAY QUOTE "color" QUOTE ": " QUOTE "#" L-COLOR QUOTE
           DISPLAY "},"
           EXIT PARAGRAPH.
        term.
           CALL L-TEXT.
           DISPLAY " " WITH NO ADVANCING
           EXIT PARAGRAPH.

