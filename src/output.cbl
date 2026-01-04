       IDENTIFICATION DIVISION.
       PROGRAM-ID. OUTPUT_FMT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TMP         PIC IS 999.
       01 HEX         PIC IS XX.
       01 WS-IDX      PIC IS 9.
       01 CURRENT     PIC IS X.
       01 CURRENT-DEC PIC IS 99.
       LINKAGE SECTION.
      * TYPE:
      * 0: i3
      * 1: term
      * <other>: term
       77 L-TYPE      PIC IS 9.
       77 L-TEXT      PROCEDURE-POINTER.
       01 L-COLOR.
         05 COLOR-HEX PIC IS X(6).
         05 COLOR-RGB REDEFINES COLOR-HEX.
           10 R       PIC IS X(2).
           10 G       PIC IS X(2).
           10 B       PIC IS X(2).
      * PART:
      * 1: Header
      * 2: BodyStart
      * 3: Body
      * 4: BodyEnd
       01 L-PART      PIC IS 9.
       01 L-BODY      PIC IS X(71).
       PROCEDURE DIVISION USING L-TYPE L-TEXT L-COLOR L-BODY L-PART.
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
           CALL L-TEXT USING L-BODY.
           DISPLAY QUOTE ","
           DISPLAY QUOTE "color" QUOTE ": " QUOTE "#" COLOR-HEX QUOTE
           DISPLAY "},"
           EXIT PARAGRAPH.
       term.
           DISPLAY X'1B' "[38;2;" WITH NO ADVANCING
           MOVE R TO HEX
           PERFORM Hex2TMP
           DISPLAY TMP ";" WITH NO ADVANCING
           MOVE G TO HEX
           PERFORM Hex2TMP
           DISPLAY TMP ";" WITH NO ADVANCING
           MOVE B TO HEX
           PERFORM Hex2TMP
           DISPLAY TMP "m" WITH NO ADVANCING
           CALL L-TEXT USING L-BODY.
           DISPLAY X'1B' "[0m" WITH NO ADVANCING
           DISPLAY " " WITH NO ADVANCING
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
