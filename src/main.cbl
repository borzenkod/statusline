       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CONFIG-FILE          ASSIGN TO WS-CONFIG-PATH
                                       FILE STATUS IS WS-CONFIG-STATUS
                                       ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD CONFIG-FILE.
       01 CONFIG-RECORD                PICTURE IS X(100).
       WORKING-STORAGE SECTION.
       01 WS-CONFIG-STATUS             PIC IS XX.
         88 WS-FILE-OK                 VALUE 00.
         88 WS-FILE-EOF                VALUE 10.
         88 WS-FILE-NOT-FOUND          VALUE 35.
       01 WS-CONFIG-PATH               PIC IS X(256).
       01 WS-CONFIG-LINE.
         05 WS-CONFIG-TYPE             PIC IS X(8).
           88 WS-TYPE-GENERAL          VALUE "GENERAL ".
           88 WS-TYPE-MODULE           VALUE "MODULE  ".
           88 WS-TYPE-COMMENT          VALUE "********".
         05 FILLER                     PIC IS X.
         05 WS-CONFIG-NAME             PIC IS X(12).
         05 FILLER                     PIC IS X.
         05 WS-CONFIG-COLOR            PIC IS X(6).
         05 FILLER                     PIC IS X.
         05 WS-CONFIG-BODY             PIC IS X(71).
      /
       01 WS-GENERAL-CONFIG.
         05 WS-TIME-FORMAT             PIC IS X(3).
         05 WS-UPDATE-INTERVAL         PIC IS 9(3).
       01 WS-MODULE-TABLE.
         05 WS-MODULE OCCURS 10 TIMES INDEXED BY MOD-IDX.
           10 WS-MOD-POINTER           PROCEDURE-POINTER.
           10 WS-MOD-BODY              PIC IS X(71).
           10 WS-MOD-COLOR             PIC IS X(6).
       01 WS-MODULES-LOADED            PIC IS 99.
      /
       01  WS-ENV-VARS.
         05  WS-HOME-DIR               PIC X(256).
         05  WS-XDG-CONFIG-HOME        PIC X(256).
         05  WS-STATUSLINE-CONFIG      PIC X(256).

       01 WS-CALLBACK                  PROCEDURE-POINTER.
       01 WS-TYPE                      PIC IS 9 VALUE IS 9.
       PROCEDURE DIVISION.
       Initialize-Program.
           CALL 'AUTO-DETECT' USING BY REFERENCE WS-TYPE END-CALL.
       Initialize-Config.
           MOVE "24H" TO WS-TIME-FORMAT
           MOVE 1 TO WS-UPDATE-INTERVAL.
       Find-Config-File.
           ACCEPT WS-HOME-DIR FROM ENVIRONMENT "HOME"
           ACCEPT WS-XDG-CONFIG-HOME FROM ENVIRONMENT "XDG_CONFIG_HOME"
           ACCEPT WS-STATUSLINE-CONFIG
             FROM ENVIRONMENT "STATUSLINE_CONFIG"
           SET WS-CONFIG-PATH          TO "./STATUSLINE-COB.CFG"
           COPY "src/check.cpy".
           IF WS-XDG-CONFIG-HOME NOT = SPACES
               STRING FUNCTION TRIM(WS-XDG-CONFIG-HOME)
                      "/STATUSLINE-COB/CONFIG.CFG"
                      DELIMITED BY SIZE
                      INTO WS-CONFIG-PATH
               END-STRING
           END-IF
           COPY "src/check.cpy".
           IF WS-HOME-DIR NOT = SPACES
               STRING FUNCTION TRIM(WS-HOME-DIR)
                      ".config/STATUSLINE-COB/CONFIG.CFG"
                      DELIMITED BY SIZE
                      INTO WS-CONFIG-PATH
               END-STRING
           END-IF
           COPY "src/check.cpy".
           IF WS-HOME-DIR NOT = SPACES
               STRING FUNCTION TRIM(WS-HOME-DIR)
                      ".STATUSLINE-COB.CFG"
                      DELIMITED BY SIZE
                      INTO WS-CONFIG-PATH
               END-STRING
           END-IF
           COPY "src/check.cpy".
           SET WS-CONFIG-PATH        TO "/etc/STATUSLINE/STATUSLINE.CFG"
           COPY "src/check.cpy".
           SET WS-CONFIG-PATH        TO "/etc/STATUSLINE-COB.CFG"
           COPY "src/check.cpy".
           SET MOD-IDX TO 1
           SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DBATTHOOK'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR(MOD-IDX)   TO "ff0f0f"
           SET MOD-IDX TO 2
           SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DMEMHOOK'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR(MOD-IDX)   TO "ffffff"
           SET MOD-IDX TO 3
           SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DLOADHOOK'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR(MOD-IDX)   TO "ff0fff"
           SET MOD-IDX TO 4
           SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DDATEHOOK'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR(MOD-IDX)   TO "ffffff"
           SET MOD-IDX TO 5
           SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DTIMEHOOK'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR(MOD-IDX)   TO "ffff0f".
           SET WS-MODULES-LOADED       TO 5
           GO TO Main.
       Find-Config-File-End.
           OPEN INPUT CONFIG-FILE
           IF NOT WS-FILE-OK
             DISPLAY "ERROR : CANNOT OPEN CONFIG FILE"
             DISPLAY "FILE  : " FUNCTION TRIM(WS-CONFIG-PATH)
             DISPLAY "STATUS: " WS-CONFIG-STATUS
           END-IF.
       Read-Config.
           SET MOD-IDX TO 0.
           PERFORM UNTIL WS-FILE-EOF
             READ CONFIG-FILE INTO WS-CONFIG-LINE
               AT END SET WS-FILE-EOF TO TRUE
               NOT AT END PERFORM Process-Config-Line
             END-READ
           END-PERFORM.
       Main.
           CALL 'OUTPUT_FMT' USING WS-TYPE 0 0 0 1
           PERFORM LoopInner UNTIL 1<0
           STOP RUN.
       LoopInner.
           CALL 'OUTPUT_FMT' USING WS-TYPE 0 0 0 2
           PERFORM VARYING MOD-IDX FROM 1 BY 1
               UNTIL MOD-IDX > WS-MODULES-LOADED
               CALL 'OUTPUT_FMT' USING WS-TYPE WS-MOD-POINTER(MOD-IDX)
               WS-MOD-COLOR(MOD-IDX) WS-MOD-BODY(MOD-IDX) 3
           END-PERFORM

           CALL 'OUTPUT_FMT' USING WS-TYPE 0 0 0 4
           CONTINUE AFTER WS-UPDATE-INTERVAL SECONDS
           EXIT PARAGRAPH.
       Process-Config-Line.
           IF WS-TYPE-COMMENT OR WS-CONFIG-LINE = SPACES
             EXIT PARAGRAPH
           END-IF
           EVALUATE TRUE
             WHEN WS-TYPE-GENERAL UNSTRING WS-CONFIG-BODY
                 DELIMITED BY ALL SPACES
                 INTO WS-TIME-FORMAT WS-UPDATE-INTERVAL
               END-UNSTRING
             WHEN WS-TYPE-MODULE PERFORM Process-Module
             WHEN OTHER DISPLAY "WARNING: UNKNOWN MODULE TYPE: "
                                WS-CONFIG-TYPE
           END-EVALUATE
           EXIT PARAGRAPH.
       Process-Module.
           COMPUTE WS-MODULES-LOADED = WS-MODULES-LOADED + 1
           COMPUTE MOD-IDX           = MOD-IDX + 1
           EVALUATE WS-CONFIG-NAME
             WHEN "BATTERY"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DBATTHOOK'
             WHEN "MEMORY"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DMEMHOOK'
             WHEN "LOAD"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DLOADHOOK'
             WHEN "DATE"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DDATEHOOK'
             WHEN "TIME"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DTIMEHOOK'
             WHEN OTHER
               DISPLAY "MODULE: " QUOTE WS-CONFIG-NAME QUOTE
                       "NOT FOUND"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DTIMEHOOK'
               CONTINUE
           END-EVALUATE
           SET WS-MOD-COLOR(MOD-IDX) TO WS-CONFIG-COLOR.
           SET WS-MOD-BODY(MOD-IDX)  TO WS-CONFIG-BODY.
           EXIT PARAGRAPH.
