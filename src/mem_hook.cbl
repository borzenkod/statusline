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
       01 FD-LINE           PIC X(100).
       WORKING-STORAGE SECTION.
       01 end-of-file       PIC X VALUE 'N'.
       01 WS-BIT-SIZE       PIC 99.
       01 WS-LINE           PIC X(100).
       01 WS-RAM-TOTAL      PIC 9(10) USAGE COMP.
       01 WS-RAM-FREE       PIC 9(10) USAGE COMP.
       01 WS-RAM-AVAILABLE  PIC 9(10) USAGE COMP.
       01 TMP               PIC 9(10).

       PROCEDURE DIVISION.
           OPEN INPUT MEM
           PERFORM UNTIL end-of-file = 'Y'
               READ MEM INTO FD-LINE
                   AT END
                       MOVE 'Y' TO end-of-file
                   NOT AT END
                       PERFORM check
               END-READ
           END-PERFORM
           CLOSE MEM
           DISPLAY "T: " WITH NO ADVANCING
           MOVE WS-RAM-TOTAL TO TMP
           PERFORM PrintHuman
           DISPLAY " F: " WITH NO ADVANCING
           MOVE WS-RAM-FREE TO TMP
           PERFORM PrintHuman
           DISPLAY " A: " WITH NO ADVANCING
           MOVE WS-RAM-AVAILABLE TO TMP
           PERFORM PrintHuman
           GOBACK.
       
       check.
           IF FD-LINE(1:10) = "MemTotal:"
               MOVE FD-LINE(10:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               MOVE FUNCTION NUMVAL(WS-LINE) TO WS-RAM-TOTAL
           END-IF

           IF FD-LINE(1:9) = "MemFree:"
               MOVE FD-LINE(9:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               MOVE FUNCTION NUMVAL(WS-LINE) TO WS-RAM-FREE
           END-IF

           IF FD-LINE(1:14) = "MemAvailable:"
               MOVE FD-LINE(14:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               MOVE FUNCTION NUMVAL(WS-LINE) TO WS-RAM-AVAILABLE
           END-IF.
           

       PrintHuman.
           MOVE 1 TO WS-BIT-SIZE
           PERFORM UNTIL TMP < 1024
               COMPUTE TMP = TMP / 1024
               SET WS-BIT-SIZE UP BY 1
           END-PERFORM.

           DISPLAY TMP(8:3) WITH NO ADVANCING
           EVALUATE WS-BIT-SIZE
               WHEN 1 DISPLAY "KiB" WITH NO ADVANCING
               WHEN 2 DISPLAY "MiB" WITH NO ADVANCING
               WHEN 3 DISPLAY "GiB" WITH NO ADVANCING
               WHEN 4 DISPLAY "TiB" WITH NO ADVANCING
               WHEN OTHER DISPLAY "b" WITH NO ADVANCING
           END-EVALUATE.
           
