       IDENTIFICATION DIVISION.
       PROGRAM-ID. DMEMHOOK.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT MEM ASSIGN TO '/proc/meminfo' ORGANIZATION IS
               LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD MEM.
       01 FD-LINE                      PIC X(100).
       WORKING-STORAGE SECTION.
       01 MEM-end-of-file     EXTERNAL PIC X VALUE 'N'.
       01 WS-BIT-SIZE                  PIC 99.
       01 WS-LINE                      PIC X(100).
       01 WS-RAM-TOTAL                 PIC 9(10) USAGE COMP.
       01 WS-RAM-FREE                  PIC 9(10) USAGE COMP.
       01 WS-RAM-AVAILABLE             PIC 9(10) USAGE COMP.
       01 WS-RAM-USED                  PIC 9(10) USAGE COMP.
       01 TMP                          PIC 9(10).
       01 WS-PRINT-HUMAN REDEFINES TMP PIC 9(10).
       01 WS-PRINT-HUMAN-TYPE          PIC 9 VALUE 0.
       LINKAGE SECTION.
       01 L-BODY                       PIC X(41).
       PROCEDURE DIVISION USING L-BODY.
           OPEN INPUT MEM
           PERFORM UNTIL MEM-end-of-file = 'Y'
               READ MEM INTO FD-LINE
                   AT END MOVE 'Y' TO MEM-end-of-file
                   NOT AT END PERFORM check
               END-READ
           END-PERFORM
           CLOSE MEM
           EVALUATE L-BODY
             WHEN "USED"
                 COMPUTE WS-RAM-USED = WS-RAM-TOTAL - WS-RAM-AVAILABLE
                 END-COMPUTE
                 MOVE WS-RAM-USED TO TMP
                 PERFORM PrintHuman
               WHEN "AVAILABLE"
                 MOVE WS-RAM-AVAILABLE TO TMP
                 PERFORM PrintHuman
               WHEN "TOTAL"
                 MOVE WS-RAM-TOTAL TO TMP
                 PERFORM PrintHuman
               WHEN "FREE"
                 MOVE WS-RAM-FREE TO TMP
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
               MOVE FUNCTION NUMVAL(WS-LINE) TO WS-RAM-TOTAL
           END-IF
           IF FD-LINE(1:9) = "MemFree:"
               MOVE FD-LINE(9:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               END-UNSTRING
               MOVE FUNCTION NUMVAL(WS-LINE) TO WS-RAM-FREE
           END-IF
           IF FD-LINE(1:14) = "MemAvailable:"
               MOVE FD-LINE(14:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               END-UNSTRING
               MOVE FUNCTION NUMVAL(WS-LINE) TO WS-RAM-AVAILABLE
           END-IF.
       COPY "COPYBOOKS/PRINT-HUMAN.CPY".
