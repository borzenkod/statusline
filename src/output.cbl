       IDENTIFICATION DIVISION.
       PROGRAM-ID. OUTPUT_FMT RECURSIVE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TMP                          PIC IS 999.
       01 HEX                          PIC IS XX.
       01 WS-IDX                       PIC IS 9.
       01 CURRENT                      PIC IS X.
       01 CURRENT-DEC                  PIC IS 99.

       COPY "src/output.cpy".
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
             "}"
             DISPLAY "["
           END-IF
           EXIT PARAGRAPH.
       BodyStart.
           IF L-TYPE = 0
             DISPLAY "["
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
           CALL L-TEXT USING L-BODY.
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
             WHEN 0 DISPLAY "],"
             WHEN 1 DISPLAY " "
           END-EVALUATE
           EXIT PARAGRAPH.
       i3Header.
           DISPLAY "{"
           DISPLAY QUOTE "full_text" QUOTE ": " QUOTE WITH NO ADVANCING
           EXIT PARAGRAPH.
       i3Footer.
           DISPLAY QUOTE ","
           DISPLAY QUOTE "color" QUOTE ": " QUOTE "#" COLOR-HEX-FG QUOTE
           DISPLAY ","
           DISPLAY QUOTE "background" QUOTE ": " QUOTE "#" COLOR-HEX-BG 
           QUOTE ","
           DISPLAY QUOTE "separator" QUOTE ": " "false,"
           DISPLAY QUOTE "separator_block_width" QUOTE ": " "0,"
           DISPLAY "},"
           EXIT PARAGRAPH.
       termHeader.
           DISPLAY X'1B' "[38;2;" WITH NO ADVANCING
           MOVE FG-R TO HEX
           PERFORM Hex2TMP
           DISPLAY TMP ";" WITH NO ADVANCING
           MOVE FG-G TO HEX
           PERFORM Hex2TMP
           DISPLAY TMP ";" WITH NO ADVANCING
           MOVE FG-B TO HEX
           PERFORM Hex2TMP
           DISPLAY TMP "m" WITH NO ADVANCING
           DISPLAY X'1B' "[48;2;" WITH NO ADVANCING
           MOVE BG-R TO HEX
           PERFORM Hex2TMP
           DISPLAY TMP ";" WITH NO ADVANCING
           MOVE BG-G TO HEX
           PERFORM Hex2TMP
           DISPLAY TMP ";" WITH NO ADVANCING
           MOVE BG-B TO HEX
           PERFORM Hex2TMP
           DISPLAY TMP "m" WITH NO ADVANCING
           EXIT PARAGRAPH.
       termFooter.
           DISPLAY X'1B' "[0m" WITH NO ADVANCING
           EXIT PARAGRAPH.
       Hex2TMP.
           MOVE 0 TO TMP
           PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 2
             MOVE HEX(WS-IDX:1) TO CURRENT
             MOVE FUNCTION UPPER-CASE(HEX) TO HEX
             IF CURRENT >= '0' AND CURRENT <= '9'
               COMPUTE CURRENT-DEC = FUNCTION ORD(CURRENT) - FUNCTION
               ORD("0")
             ELSE
               COMPUTE CURRENT-DEC = 
               FUNCTION ORD(CURRENT) - FUNCTION ORD("A") + 10
             END-IF
             COMPUTE TMP = TMP * 16 + CURRENT-DEC
           END-PERFORM
           EXIT PARAGRAPH.
