       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       SOURCE-COMPUTER. teto WITH DEBUGGING MODE.
       OBJECT-COMPUTER. you PROGRAM COLLATING SEQUENCE IS THEBEST.
       SPECIAL-NAMES.
           ALPHABET THEBEST IS EBCDIC
           CRT STATUS IS WS-CRT-STATUS.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CONFIG-FILE          ASSIGN USING WS-CONFIG-PATH
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
         05 WS-CONFIG-CONTROL          PIC IS X.
         05 WS-CONFIG-NAME             PIC IS X(12).
         05 FILLER                     PIC IS X.
         05 WS-CONFIG-COLOR            PIC IS X(6).
         05 FILLER                     PIC IS X.
         05 WS-CONFIG-BODY             PIC IS X(42).
      /
       01 WS-GENERAL-CONFIG.
         05 WS-UPDATE-INTERVAL         PIC IS 9(3).
         05 WS-THEME-NAME              PIC IS X(8).
         05 WS-THEME-TYPE              PIC IS X(4).
       01 WS-MODULE-TABLE.
         05 WS-MODULE  OCCURS 25 TIMES INDEXED BY MOD-IDX.
           10 WS-MOD-POINTER           PROCEDURE-POINTER.
           10 WS-MOD-BODY              PIC IS X(71).
           10 WS-MOD-COLOR-BG          PIC IS X(8).
           10 WS-MOD-COLOR-FG          PIC IS X(8).
       01 WS-MODULES-LOADED            PIC IS 99 VALUE 00.
      /
       01  WS-ENV-VARS.
         05  WS-HOME-DIR               PIC X(256).
         05  WS-XDG-CONFIG-HOME        PIC X(256).
         05  WS-STATUSLINE-CONFIG      PIC X(256).

       01 WS-CALLBACK                  PROCEDURE-POINTER.
       01 WS-CLICK-EVENTS              PIC IS X(1024).
       01 WS-CRT-STATUS                PIC IS 9999.
           88 WS-CRT-NO-INPUT          VALUE IS 8000.
       01 WS-TALLY                     USAGE IS BINARY-LONG.
       01 WS-TYPE             EXTERNAL PIC IS 9 VALUE IS 0.
       01 BAT-end-of-file     EXTERNAL PIC X VALUE 'N'.
       01 MEM-end-of-file     EXTERNAL PIC X VALUE 'N'.

       COPY "src/output.cpy".
       COPY "src/themes.cpy".
       PROCEDURE DIVISION.
       Initialize-Program.
           CALL 'AUTO-DETECT' USING BY REFERENCE WS-TYPE END-CALL.
       Initialize-Config.
           SET WS-UPDATE-INTERVAL      TO 5
           SET WS-THEME-NAME           TO "ROSEPINE"
           SET WS-THEME-TYPE           TO "BLCK".
       Initialize-Themes.
           COPY "src/themes-init.cpy"..
       Find-Config-File.
           ACCEPT WS-HOME-DIR          FROM ENVIRONMENT"HOME"
           ACCEPT WS-XDG-CONFIG-HOME   FROM ENVIRONMENT"XDG_CONFIG_HOME"
           ACCEPT WS-STATUSLINE-CONFIG
             FROM ENVIRONMENT "STATUSLINE_CONFIG"
           IF WS-STATUSLINE-CONFIG NOT = SPACES
             SET WS-CONFIG-PATH        TO WS-STATUSLINE-CONFIG
             COPY "src/check.cpy".
           END-IF
           SET WS-CONFIG-PATH          TO SPACES
           SET WS-CONFIG-PATH          TO "./STATUSLINE-COB.CFG"
           COPY "src/check.cpy".
           IF WS-XDG-CONFIG-HOME NOT = SPACES
             SET WS-CONFIG-PATH          TO SPACES
               STRING FUNCTION TRIM(WS-XDG-CONFIG-HOME)
                      "/STATUSLINE-COB/CONFIG.CFG"
                      DELIMITED BY SIZE
                      INTO WS-CONFIG-PATH
               END-STRING
             COPY "src/check.cpy".
           END-IF
           IF WS-HOME-DIR NOT = SPACES
             SET WS-CONFIG-PATH          TO SPACES
               STRING FUNCTION TRIM(WS-HOME-DIR)
                      "/.config/STATUSLINE-COB/CONFIG.CFG"
                      DELIMITED BY SIZE
                      INTO WS-CONFIG-PATH
               END-STRING
             COPY "src/check.cpy".
           END-IF
           IF WS-HOME-DIR NOT = SPACES
             SET WS-CONFIG-PATH          TO SPACES
               STRING FUNCTION TRIM(WS-HOME-DIR)
                      "/.STATUSLINE-COB.CFG"
                      DELIMITED BY SIZE
                      INTO WS-CONFIG-PATH
               END-STRING
             COPY "src/check.cpy".
           END-IF
           SET WS-CONFIG-PATH        TO "/etc/STATUSLINE/STATUSLINE.CFG"
           COPY "src/check.cpy".
           SET WS-CONFIG-PATH        TO "/etc/STATUSLINE-COB.CFG"
           COPY "src/check.cpy".
           ACCEPT WS-STATUSLINE-CONFIG
             FROM ENVIRONMENT "STATUSLINE_CONFIG_END"
           IF WS-STATUSLINE-CONFIG NOT = SPACES
             SET WS-CONFIG-PATH        TO WS-STATUSLINE-CONFIG
             COPY "src/check.cpy".
           END-IF.
       Default-Config.
           COPY "src/default.cpy".
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
           SET L-TYPE                  TO WS-TYPE
           SET L-TEXT                  TO NULL
           SET L-COLOR-BG              TO '000000FF'
           SET L-COLOR-FG              TO '000000FF'
           SET L-PART                  TO 1
           SET L-BODY                  TO SPACES
           CALL 'OUTPUT_FMT'
           PERFORM LoopInner UNTIL 1<0
           STOP RUN.
       LoopInner.
           MOVE 'N' TO BAT-end-of-file
           MOVE 'N' TO MEM-end-of-file
           SET L-PART                  TO 2
           CALL 'OUTPUT_FMT'
           SET L-PART                  TO 3
           SET L-COLOR-BG              TO '00000000'
           SET L-COLOR-FG              TO '00000000'
           SET L-COLOR-BG-LAST         TO '00000000'
           SET L-COLOR-FG-LAST         TO '00000000'
           PERFORM VARYING MOD-IDX FROM 1 BY 1
               UNTIL MOD-IDX > WS-MODULES-LOADED
               SET L-TEXT                  TO WS-MOD-POINTER(MOD-IDX)
               SET L-COLOR-BG              TO WS-MOD-COLOR-BG(MOD-IDX)
               SET L-COLOR-FG              TO WS-MOD-COLOR-FG(MOD-IDX)
               SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
               CALL 'OUTPUT_FMT'
           END-PERFORM

           IF WS-CRT-NO-INPUT
             ACCEPT WS-CLICK-EVENTS
           END-IF

           SET L-PART                  TO 4
           CALL 'OUTPUT_FMT'
           CALL 'C$SLEEP' USING WS-UPDATE-INTERVAL
           EXIT PARAGRAPH.
       Process-Config-Line.
           IF WS-TYPE-COMMENT OR WS-CONFIG-LINE = SPACES OR
             WS-CONFIG-CONTROL = '*'
             EXIT PARAGRAPH
           END-IF
           EVALUATE TRUE
             WHEN WS-TYPE-GENERAL UNSTRING WS-CONFIG-BODY
                 DELIMITED BY ALL SPACES
                 INTO WS-UPDATE-INTERVAL WS-THEME-NAME WS-THEME-TYPE
               END-UNSTRING
               EVALUATE WS-THEME-NAME
                   WHEN "ROSEPINE" SET THM-IDX TO 1
                   WHEN OTHER CONTINUE
               END-EVALUATE
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
             WHEN "SYSTEM"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DSYSHOOK'
             WHEN "SEPARATOR"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DSEPHOOK'
             WHEN "TEXT"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DTEXTHOOK'
             WHEN "SPACE"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DSPACEHOOK'
             WHEN OTHER
               DISPLAY "MODULE: " QUOTE WS-CONFIG-NAME QUOTE
                       "NOT FOUND"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DTIMEHOOK'
               CONTINUE
           END-EVALUATE
           COPY "src/get-theme.cpy".
           SET WS-MOD-BODY(MOD-IDX)  TO WS-CONFIG-BODY.
           EXIT PARAGRAPH.
