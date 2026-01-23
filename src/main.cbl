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
       01 WS-CONFIG-STATUS             PIC IS X(2).
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
         05 WS-MODULE  OCCURS 99 TIMES INDEXED BY MOD-IDX.
           10 WS-MOD-POINTER           PROCEDURE-POINTER.
           10 WS-MOD-BODY              PIC IS X(71).
           10 WS-MOD-COLOR-BG          PIC IS X(9).
           10 WS-MOD-COLOR-FG          PIC IS X(9).
       01 WS-MODULES-LOADED            PIC IS 99 VALUE 00.
       01 TMP-PTR                      PROCEDURE-POINTER.
      /
       01  WS-ENV-VARS.
         05  WS-HOME-DIR               PIC X(256).
         05  WS-XDG-CONFIG-HOME        PIC X(256).
         05  WS-STATUSLINE-CONFIG      PIC X(256).
         05  WS-ONE-SHOT               PIC X VALUE 'N'.

       01 WS-CALLBACK                  PROCEDURE-POINTER.
       01 WS-CLICK-EVENTS              PIC IS X(1024).
       01 WS-CRT-STATUS                PIC IS 9999.
           88 WS-CRT-NO-INPUT          VALUE IS 8000.
       01 WS-TALLY                     USAGE IS BINARY-LONG.
       01 WS-TYPE             EXTERNAL PIC IS 9 VALUE IS 0.
       01 BAT-end-of-file     EXTERNAL PIC X VALUE 'N'.
       01 MEM-end-of-file     EXTERNAL PIC X VALUE 'N'.

       01 TMP                          USAGE IS BINARY-LONG.
       01 HEX                          PIC IS XX.
       01 WS-IDX                       PIC IS 9.
       01 CURRENT                      PIC IS X.
       01 CURRENT-DEC                  PIC IS 99.
       01 WS-COLOR-HEX.
         05 WS-COLOR-R-HEX             PIC IS 99.
         05 WS-COLOR-G-HEX             PIC IS 99.
         05 WS-COLOR-B-HEX             PIC IS 99.
       01 WS-COLOR.
         05 WS-COLOR-R                 PIC IS 999.
         05 WS-COLOR-G                 PIC IS 999.
         05 WS-COLOR-B                 PIC IS 999.

       COPY "COPYBOOKS/OUTPUT.CPY".
       COPY "COPYBOOKS/THEMES.CPY".
       PROCEDURE DIVISION.
       Initialize-Program.
           CALL 'AUTO-DETECT' USING BY REFERENCE WS-TYPE END-CALL.
       Initialize-Config.
           SET WS-UPDATE-INTERVAL      TO 5
           SET WS-THEME-NAME           TO "ROSEPINE"
           SET WS-THEME-TYPE           TO "BLCK".
       Initialize-Themes.
           COPY "COPYBOOKS/THEMES-INIT.CPY"..
       Find-Config-File.
           ACCEPT WS-HOME-DIR          FROM ENVIRONMENT"HOME"
           END-ACCEPT
           ACCEPT WS-XDG-CONFIG-HOME   FROM ENVIRONMENT"XDG_CONFIG_HOME"
           END-ACCEPT
           ACCEPT WS-STATUSLINE-CONFIG
             FROM ENVIRONMENT "STATUSLINE_CONFIG"
           END-ACCEPT
           IF WS-STATUSLINE-CONFIG NOT = SPACES
             SET WS-CONFIG-PATH        TO WS-STATUSLINE-CONFIG
             COPY "COPYBOOKS/CHECK.CPY".
           END-IF
           SET WS-CONFIG-PATH          TO SPACES
           SET WS-CONFIG-PATH          TO "./STATUSLINE-COB.CFG"
           COPY "COPYBOOKS/CHECK.CPY".
           IF WS-XDG-CONFIG-HOME NOT = SPACES
             SET WS-CONFIG-PATH          TO SPACES
               STRING FUNCTION TRIM(WS-XDG-CONFIG-HOME)
                      "/STATUSLINE-COB/CONFIG.CFG"
                      DELIMITED BY SIZE
                      INTO WS-CONFIG-PATH
               END-STRING
             COPY "COPYBOOKS/CHECK.CPY".
           END-IF
           IF WS-HOME-DIR NOT = SPACES
             SET WS-CONFIG-PATH          TO SPACES
               STRING FUNCTION TRIM(WS-HOME-DIR)
                      "/.config/STATUSLINE-COB/CONFIG.CFG"
                      DELIMITED BY SIZE
                      INTO WS-CONFIG-PATH
               END-STRING
             COPY "COPYBOOKS/CHECK.CPY".
           END-IF
           IF WS-HOME-DIR NOT = SPACES
             SET WS-CONFIG-PATH          TO SPACES
               STRING FUNCTION TRIM(WS-HOME-DIR)
                      "/.STATUSLINE-COB.CFG"
                      DELIMITED BY SIZE
                      INTO WS-CONFIG-PATH
               END-STRING
             COPY "COPYBOOKS/CHECK.CPY".
           END-IF
           SET WS-CONFIG-PATH        TO "/etc/STATUSLINE/STATUSLINE.CFG"
           COPY "COPYBOOKS/CHECK.CPY".
           SET WS-CONFIG-PATH        TO "/etc/STATUSLINE-COB.CFG"
           COPY "COPYBOOKS/CHECK.CPY".
           ACCEPT WS-STATUSLINE-CONFIG
             FROM ENVIRONMENT "STATUSLINE_CONFIG_END"
           END-ACCEPT
           IF WS-STATUSLINE-CONFIG NOT = SPACES
             SET WS-CONFIG-PATH        TO WS-STATUSLINE-CONFIG
             COPY "COPYBOOKS/CHECK.CPY".
           END-IF.
       Default-Config.
           COPY "COPYBOOKS/DEFAULT.CPY".
           GO TO Main.
       Find-Config-File-End.
           OPEN INPUT CONFIG-FILE
           IF NOT WS-FILE-OK
             DISPLAY "ERROR : CANNOT OPEN CONFIG FILE" END-DISPLAY
             DISPLAY "FILE  : " FUNCTION TRIM(WS-CONFIG-PATH)
             END-DISPLAY
             DISPLAY "STATUS: " WS-CONFIG-STATUS END-DISPLAY
           END-IF.
       Read-Config.
           SET MOD-IDX TO 0.
           PERFORM UNTIL WS-FILE-EOF
             READ CONFIG-FILE INTO WS-CONFIG-LINE
               AT END SET WS-CONFIG-STATUS TO '10'
               NOT AT END PERFORM Process-Config-Line
             END-READ
           END-PERFORM.
       Main.
           ACCEPT WS-ONE-SHOT FROM ENVIRONMENT "STATLINE_ONESHOT"
           END-ACCEPT
           IF WS-ONE-SHOT NOT = "Y"
             SET WS-ONE-SHOT           TO "N"
             SET TMP-PTR TO ENTRY 'SIGUSR1'
             CALL "signal" USING BY VALUE 10 BY VALUE TMP-PTR
             END-CALL
           ELSE
             SET WS-UPDATE-INTERVAL    TO 0
           END-IF
           SET L-TYPE                  TO WS-TYPE
           SET L-TEXT                  TO NULL
           SET L-COLOR-BG              TO '000000FF'
           SET L-COLOR-FG              TO '000000FF'
           SET L-PART                  TO 1
           SET L-BODY                  TO SPACES
           CALL 'OUTPUT_FMT'
           END-CALL
           PERFORM LoopInner UNTIL WS-ONE-SHOT NOT = "N"
           STOP RUN.
       LoopInner.
           MOVE 'N' TO BAT-end-of-file
           MOVE 'N' TO MEM-end-of-file
           SET L-PART                  TO 2
           CALL 'OUTPUT_FMT'
           END-CALL
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
               END-CALL
           END-PERFORM

           IF WS-CRT-NO-INPUT
             ACCEPT WS-CLICK-EVENTS
             END-ACCEPT
           END-IF

           SET L-PART                  TO 4
           CALL 'OUTPUT_FMT'
           END-CALL
           CALL 'sleep' USING BY VALUE WS-UPDATE-INTERVAL
           END-CALL
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
                   WHEN "GRUVBOX " SET THM-IDX TO 2
                   WHEN "SOLARIZE" SET THM-IDX TO 3
                   WHEN OTHER CONTINUE
               END-EVALUATE
             WHEN WS-TYPE-MODULE PERFORM Process-Module
             WHEN OTHER DISPLAY "WARNING: UNKNOWN MODULE TYPE: "
                                WS-CONFIG-TYPE END-DISPLAY
           END-EVALUATE
           EXIT PARAGRAPH.
       Process-Module.
           COMPUTE WS-MODULES-LOADED = WS-MODULES-LOADED + 1
           END-COMPUTE
           COMPUTE MOD-IDX           = MOD-IDX + 1
           END-COMPUTE
           SET WS-MOD-BODY(MOD-IDX)         TO WS-CONFIG-BODY.
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
             WHEN "PATH"
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DPATHHOOK'
             WHEN "TAPE"
               SET HEX                     TO WS-MOD-BODY(MOD-IDX)(42:1)
               SET WS-MOD-BODY(MOD-IDX)(42:1) TO SPACE
               DISPLAY WS-MOD-BODY(MOD-IDX)
               END-DISPLAY
               INSPECT WS-MOD-BODY(MOD-IDX) 
                        REPLACING TRAILING SPACES BY X'00'
               SET WS-MOD-BODY(MOD-IDX)(40:1) TO HEX
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DTAPEHOOK'
             WHEN OTHER
               DISPLAY "MODULE: " QUOTE WS-CONFIG-NAME QUOTE
                       "NOT FOUND" END-DISPLAY
               SET WS-MOD-POINTER(MOD-IDX) TO ENTRY 'DTIMEHOOK'
               CONTINUE
           END-EVALUATE
           COPY "COPYBOOKS/GET-THEME.CPY".
           IF WS-TYPE = 1
             MOVE WS-MOD-COLOR-FG(MOD-IDX)  TO WS-COLOR-HEX
             MOVE WS-COLOR-R-HEX            TO HEX
             PERFORM Hex2TMP
             MOVE TMP                       TO WS-COLOR-R
             MOVE WS-COLOR-G-HEX            TO HEX
             PERFORM Hex2TMP
             MOVE TMP                       TO WS-COLOR-G
             MOVE WS-COLOR-B-HEX            TO HEX
             PERFORM Hex2TMP
             MOVE TMP                       TO WS-COLOR-B
             MOVE WS-COLOR                  TO WS-MOD-COLOR-FG(MOD-IDX)
             MOVE WS-MOD-COLOR-BG(MOD-IDX)  TO WS-COLOR-HEX
             MOVE WS-COLOR-R-HEX            TO HEX
             PERFORM Hex2TMP
             MOVE TMP                       TO WS-COLOR-R
             MOVE WS-COLOR-G-HEX            TO HEX
             PERFORM Hex2TMP
             MOVE TMP                       TO WS-COLOR-G
             MOVE WS-COLOR-B-HEX            TO HEX
             PERFORM Hex2TMP
             MOVE TMP                       TO WS-COLOR-B
             MOVE WS-COLOR                  TO WS-MOD-COLOR-BG(MOD-IDX)
           END-IF
           EXIT PARAGRAPH.
       Hex2TMP.
           MOVE 0 TO TMP
           PERFORM VARYING WS-IDX FROM 1 BY 1 UNTIL WS-IDX > 2
             MOVE HEX(WS-IDX:1) TO CURRENT
             MOVE FUNCTION UPPER-CASE(HEX) TO HEX
             IF CURRENT >= '0' AND CURRENT <= '9'
               COMPUTE
                 CURRENT-DEC = FUNCTION ORD(CURRENT) - FUNCTION ORD("0")
               END-COMPUTE
             ELSE
               COMPUTE CURRENT-DEC = 
                 FUNCTION ORD(CURRENT) - FUNCTION ORD("A") + 10
               END-COMPUTE
             END-IF
             MULTIPLY TMP BY 16 GIVING TMP
             END-MULTIPLY
             ADD CURRENT-DEC TO TMP GIVING TMP
             END-ADD
           END-PERFORM
           EXIT PARAGRAPH.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SIGUSR1.
       PROCEDURE DIVISION.
           GOBACK.
       END PROGRAM SIGUSR1.
