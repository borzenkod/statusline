       IDENTIFICATION DIVISION.
       PROGRAM-ID. OUTPUT_FMT.
       DATA DIVISION.
       LINKAGE SECTION.
      * TYPE:
      * 0: i3
      * <other>: term
       77 L-TYPE  PIC IS 9.
       77 L-TEXT  PROCEDURE-POINTER.
       77 L-COLOR PIC IS X(6).
       PROCEDURE DIVISION USING L-TYPE L-TEXT L-COLOR.
           EVALUATE L-TYPE
               WHEN 0
                   PERFORM i3
               WHEN OTHER
                   PERFORM term
           END-EVALUATE
           GOBACK.

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
           EXIT PARAGRAPH.

