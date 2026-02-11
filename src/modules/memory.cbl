       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_MEMORY.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MEM ASSIGN TO '/proc/meminfo' ORGANIZATION IS
               LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD MEM.
       01 FD-LINE                      PIC X(100).
       LOCAL-STORAGE SECTION.
       01 WS-EOF                       PIC X VALUE 'N'.
       01 WS-BIT-SIZE                  PIC 99.
       01 WS-LINE                      PIC X(100).
       01 TMP                          PIC 9(10).
       01 WS-PRINT-HUMAN REDEFINES TMP PIC 9(10).
       01 WS-PRINT-HUMAN-TYPE          PIC 9 VALUE 0.
       LINKAGE SECTION.
       01 L-DATA.
         05 L-TRIES                    PICTURE IS 99.
         05 L-MAX-TRIES                PICTURE IS 99.
         05 L-TYPE                     PICTURE IS X.
         05 L-VALUE                    USAGE IS BINARY-LONG.
         05 L-RAM-TOTAL                USAGE IS BINARY-LONG.
         05 L-RAM-FREE                 USAGE IS BINARY-LONG.
         05 L-RAM-AVAILABLE            USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING L-DATA.
           SET WS-EOF                  TO 'N'
           OPEN INPUT MEM
           PERFORM UNTIL WS-EOF = 'Y'
               READ MEM INTO FD-LINE
                   AT END MOVE 'Y' TO WS-EOF
                   NOT AT END PERFORM check
               END-READ
           END-PERFORM
           CLOSE MEM
           EVALUATE L-TYPE
             WHEN "U"
                 COMPUTE TMP = L-RAM-TOTAL - L-RAM-AVAILABLE
                 END-COMPUTE
                 PERFORM PrintHuman
               WHEN "A"
                 MOVE L-RAM-AVAILABLE TO TMP
                 PERFORM PrintHuman
               WHEN "T"
                 MOVE L-RAM-TOTAL TO TMP
                 PERFORM PrintHuman
               WHEN "F"
                 MOVE L-RAM-FREE TO TMP
                 PERFORM PrintHuman
               WHEN OTHER CONTINUE
           END-EVALUATE
           GOBACK.
       check.
           IF FD-LINE(1:10) = "MemTotal:"
               MOVE FD-LINE(10:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               END-UNSTRING
               MOVE FUNCTION NUMVAL(WS-LINE) TO L-RAM-TOTAL
               IF L-TYPE IS EQUAL      TO 'T'
                 SET WS-EOF            TO 'T'
               END-IF
           END-IF
           IF FD-LINE(1:9) = "MemFree:"
               MOVE FD-LINE(9:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               END-UNSTRING
               MOVE FUNCTION NUMVAL(WS-LINE) TO L-RAM-FREE
               IF L-TYPE IS EQUAL      TO 'F'
                 SET WS-EOF            TO 'T'
               END-IF
           END-IF
           IF FD-LINE(1:14) = "MemAvailable:"
               MOVE FD-LINE(14:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               END-UNSTRING
               MOVE FUNCTION NUMVAL(WS-LINE) TO L-RAM-AVAILABLE
               IF L-TYPE IS EQUAL      TO 'A'
                 SET WS-EOF            TO 'A'
               END-IF
           END-IF.
       COPY "COPYBOOKS/PRINT-HUMAN.CPY".
       END PROGRAM MOD_MEMORY.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_MEMORY_INIT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/ABEND.CPY".
       01 L-BODY              EXTERNAL PICTURE IS X(42).
       LINKAGE SECTION.
       01 L-DATA.
         05 L-TRIES                    PICTURE IS 99.
         05 L-MAX-TRIES                PICTURE IS 99.
         05 L-TYPE                     PICTURE IS X.
         05 L-VALUE                    USAGE IS BINARY-LONG.
       PROCEDURE DIVISION        USING BY REFERENCE L-DATA.
           SET L-TRIES                 TO 5
           SET L-MAX-TRIES             TO 5
           EVALUATE L-BODY
             WHEN "USED" SET L-TYPE    TO "U"
             WHEN "AVAILABLE" SET L-TYPE TO "A"
             WHEN "TOTAL" SET L-TYPE   TO "T"
             WHEN "FREE" SET L-TYPE    TO "F"
             WHEN OTHER
               SET L-TYPE              TO SPACES
               SET WS-STAT-ABEND       TO "FMDMEM01"
               CALL "STATABEND" END-CALL
           END-EVALUATE
           SET RETURN-CODE             TO 2
           GOBACK.
       END PROGRAM MOD_MEMORY_INIT.
