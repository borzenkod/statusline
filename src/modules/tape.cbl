       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_TAPE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/ABEND.CPY".
       01 WS-STATVFS.
         05 WS-F-BSIZE                 USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FRSIZE                USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-BLOCKS                USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-BFREE                 USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-BAVAIL                USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FILES                 USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FFREE                 USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FAVAIL                USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FSIG                  USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FLAG                  USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-NAMEMAX               USAGE IS BINARY-DOUBLE UNSIGNED.
         05 FILLER                     USAGE IS BINARY-LONG UNSIGNED.
         05 FILLER                     OCCURS 5 TIMES.
           10 FILLER                   USAGE IS BINARY-DOUBLE.
       01 TMP                          USAGE IS BINARY-LONG.
       01 WS-PRINT-HUMAN               PIC 9(10).
       01 WS-PRINT-HUMAN-TYPE          PIC 9 VALUE 0.
       01 WS-BIT-SIZE                  PIC 99.
       LINKAGE SECTION.
       01 L-DATA.
         05 L-BODY-DATA                PIC X(42).
         05 L-TRIES                    USAGE IS BINARY-LONG.
         05 L-MAX-TRIES                USAGE IS BINARY-LONG.
         05 L-LAST                     PICTURE IS 9(10).
         05 L-LAST-TYPE                PICTURE IS 9.
         05 L-TYPE                     PICTURE IS X.
       PROCEDURE DIVISION USING L-DATA.
           IF L-TRIES IS GREATER OR EQUAL TO L-MAX-TRIES THEN
             SET L-TRIES               TO 1
             CALL 'statvfs' USING
                          BY REFERENCE L-DATA
                          BY REFERENCE WS-STATVFS
                          GIVING TMP
             END-CALL
             IF TMP NOT = -1
               EVALUATE L-TYPE
                   WHEN "B" MOVE WS-F-BSIZE   TO WS-PRINT-HUMAN
                   WHEN "R" MOVE WS-F-FRSIZE  TO WS-PRINT-HUMAN
                   WHEN "L" MOVE WS-F-BLOCKS  TO WS-PRINT-HUMAN
                            MOVE 9            TO WS-PRINT-HUMAN-TYPE
                   WHEN "H" MOVE WS-F-BFREE   TO WS-PRINT-HUMAN
                            MOVE 9            TO WS-PRINT-HUMAN-TYPE
                   WHEN "A" MOVE WS-F-BAVAIL  TO WS-PRINT-HUMAN
                            MOVE 9            TO WS-PRINT-HUMAN-TYPE
                   WHEN "F" MOVE WS-F-FILES   TO WS-PRINT-HUMAN
                            MOVE 9            TO WS-PRINT-HUMAN-TYPE
                   WHEN "E" MOVE WS-F-FFREE   TO WS-PRINT-HUMAN
                            MOVE 9            TO WS-PRINT-HUMAN-TYPE
                   WHEN "I" MOVE WS-F-FSIG    TO WS-PRINT-HUMAN
                            MOVE 9            TO WS-PRINT-HUMAN-TYPE
                   WHEN "N" MOVE WS-F-NAMEMAX TO WS-PRINT-HUMAN
                            MOVE 9            TO WS-PRINT-HUMAN-TYPE
                   WHEN OTHER SET WS-STAT-ABEND TO "EMDTPE01"
                     CALL "STATABEND" END-CALL
               END-EVALUATE
               SET L-LAST              TO WS-PRINT-HUMAN
               SET L-LAST-TYPE         TO WS-PRINT-HUMAN-TYPE
             ELSE
               DISPLAY
                 "NOT MOUNTED"
                 WITH NO ADVANCING
               END-DISPLAY
               GOBACK
             END-IF
           ELSE
             ADD 1                     TO L-TRIES
             END-ADD
             MOVE L-LAST               TO WS-PRINT-HUMAN
             MOVE L-LAST-TYPE          TO WS-PRINT-HUMAN-TYPE
           END-IF
           PERFORM 'PrintHuman'
           GOBACK.
       COPY "COPYBOOKS/PRINT-HUMAN.CPY".
       END PROGRAM MOD_TAPE.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_TAPE_INIT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 L-BODY              EXTERNAL PICTURE IS X(42).
       LINKAGE SECTION.
       01 L-DATA.
         05 L-BODY-DATA                PIC X(42).
         05 L-TRIES                    USAGE IS BINARY-LONG.
         05 L-MAX-TRIES                USAGE IS BINARY-LONG.
         05 L-LAST                     PICTURE IS 9(10).
         05 L-LAST-TYPE                PICTURE IS 9.
         05 L-TYPE                     PICTURE IS X.
       PROCEDURE DIVISION USING BY REFERENCE L-DATA.
           SET L-BODY-DATA             TO L-BODY
           SET RETURN-CODE             TO 2
           SET L-TRIES                 TO 15
           SET L-MAX-TRIES             TO 15
           SET L-LAST                  TO 0
           SET L-LAST-TYPE             TO 0
           SET L-TYPE                  TO L-BODY(42:1)
           SET L-BODY-DATA(42:1)       TO SPACE
           INSPECT L-BODY-DATA REPLACING TRAILING SPACES BY X'00'
           GOBACK.
       END PROGRAM MOD_TAPE_INIT.
