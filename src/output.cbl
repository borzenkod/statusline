       IDENTIFICATION DIVISION.
       PROGRAM-ID. OUTPUT_FMT RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/OUTPUT.CPY".
       PROCEDURE DIVISION.
           EVALUATE L-PART
             WHEN 1 PERFORM Header
             WHEN 2 PERFORM BodyStart
             WHEN 3 PERFORM Body
             WHEN 4 PERFORM BodyEnd
             WHEN 5 PERFORM BodyHeader
             WHEN 6 PERFORM BodyFooter
             WHEN OTHER CONTINUE
           END-EVALUATE
           GOBACK.
       Header.
           IF L-TYPE = 0
             DISPLAY "{ "
               QUOTE "version" QUOTE ": 1, "
               QUOTE "click_events" QUOTE ": true "
             "}["
           END-DISPLAY
           END-IF
           EXIT PARAGRAPH.
       BodyStart.
           IF L-TYPE = 0
             DISPLAY "[" END-DISPLAY
           END-IF
           EXIT PARAGRAPH.
       BodyHeader.
           EVALUATE L-TYPE
               WHEN 0     PERFORM i3Header
               WHEN 1     PERFORM termHeader
               WHEN OTHER PERFORM termHeader
           END-EVALUATE
           EXIT PARAGRAPH.
       Body.
           PERFORM BodyHeader
           CALL L-TEXT USING L-BODY
           END-CALL
           PERFORM BodyFooter
           SET COLOR-HEX-BG-LAST       TO COLOR-HEX-BG
           SET COLOR-HEX-FG-LAST       TO COLOR-HEX-FG
           EXIT PARAGRAPH.
       BodyFooter.
           EVALUATE L-TYPE
               WHEN 0     PERFORM i3Footer
               WHEN 1     PERFORM termFooter
               WHEN OTHER PERFORM termFooter
           END-EVALUATE
           EXIT PARAGRAPH.
       BodyEnd.
           EVALUATE L-TYPE
             WHEN 0 DISPLAY "]," END-DISPLAY
             WHEN 1 DISPLAY " " END-DISPLAY
           END-EVALUATE
           EXIT PARAGRAPH.
       i3Header.
           DISPLAY "{"
             QUOTE "full_text" QUOTE ": " QUOTE
             WITH NO ADVANCING
           END-DISPLAY
           EXIT PARAGRAPH.
       i3Footer.
           DISPLAY QUOTE ","
            QUOTE "color" QUOTE ": " QUOTE "#" COLOR-HEX-FG QUOTE
            ","
            QUOTE "background" QUOTE ": " QUOTE "#" COLOR-HEX-BG 
             QUOTE ","
            QUOTE "separator" QUOTE ": " "false,"
            QUOTE "separator_block_width" QUOTE ": " "0,"
            "},"
           END-DISPLAY
           EXIT PARAGRAPH.
       termHeader.
           DISPLAY
             X'1B' "[38;2;" FG-R ";" FG-G ";" FG-B "m"
             X'1B' "[48;2;" BG-R ";" BG-G ";" BG-B "m"
             WITH NO ADVANCING
           END-DISPLAY.
           EXIT PARAGRAPH.
       termFooter.
           DISPLAY X'1B' "[0m" WITH NO ADVANCING
           END-DISPLAY
           EXIT PARAGRAPH.
