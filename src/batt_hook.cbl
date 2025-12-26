       IDENTIFICATION DIVISION.
       PROGRAM-ID. DBATTHOOK.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BAT ASSIGN TO '/sys/class/power_supply/BAT0/uevent'
           ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD BAT.
       01 FD-LINE           PIC X(100).
       WORKING-STORAGE SECTION.
       01 end-of-file       PIC X VALUE 'N'.
       01 WS-BIT-SIZE       PIC 99.
       01 WS-LINE           PIC X(100).
       01 WS-CAPACITY       PIC 999.
       01 WS-STATUS         PIC 9.
         88 DISCHARDING     VALUE 0.
         88 CHARGING        VALUE 1.
         88 CHARGED         VALUE 2.
       01 TMP               PIC 9(10).

       PROCEDURE DIVISION.
           OPEN INPUT BAT
           PERFORM UNTIL end-of-file = 'Y'
               READ BAT INTO FD-LINE
                   AT END
                       MOVE 'Y' TO end-of-file
                   NOT AT END
                       PERFORM check
               END-READ
           END-PERFORM
           CLOSE BAT
           DISPLAY "B: " WS-CAPACITY " " WITH NO ADVANCING
           GOBACK.

       check.
           IF FD-LINE(1:22) = "POWER_SUPPLY_CAPACITY="
               MOVE FD-LINE(23:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               MOVE FUNCTION NUMVAL(WS-LINE) TO WS-CAPACITY
           END-IF.
