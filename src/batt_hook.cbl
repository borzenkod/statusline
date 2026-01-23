       IDENTIFICATION DIVISION.
       PROGRAM-ID. DBATTHOOK.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BAT                  ASSIGN USING BAT-FILE
                                       ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD BAT.
       01 FD-LINE                      PIC X(100).
       WORKING-STORAGE SECTION.
       01 BAT-end-of-file     EXTERNAL PIC X VALUE 'N'.
       01 BAT-FILE                     PIC X(40).
       01 WS-BIT-SIZE                  PIC 99.
       01 WS-LINE                      PIC X(100).
       01 WS-CAPACITY                  PIC 999.
       01 WS-STATUS                    PIC 9.
         88 DISCHARGING                VALUE 0.
         88 CHARGING                   VALUE 1.
         88 CHARGED                    VALUE 2.
       01 TMP                          PIC 9(10).
       LINKAGE SECTION.
       01 L-BODY                  PIC X(42).
       PROCEDURE DIVISION USING L-BODY.
           IF BAT-end-of-file NOT = "y"
             UNSTRING L-BODY DELIMITED BY X'00' INTO BAT-FILE
             END-UNSTRING
             OPEN INPUT BAT
             PERFORM UNTIL BAT-end-of-file = 'Y'
                 READ BAT INTO FD-LINE
                     AT END MOVE 'Y' TO BAT-end-of-file
                     NOT AT END PERFORM check
                 END-READ
             END-PERFORM
             CLOSE BAT
           END-IF
           EVALUATE L-BODY(42:1)
             WHEN "C" DISPLAY WS-CAPACITY WITH NO ADVANCING
               END-DISPLAY
               WHEN OTHER CONTINUE
           END-EVALUATE
           GOBACK.
       check.
           IF FD-LINE(1:22) = "POWER_SUPPLY_CAPACITY="
               MOVE FD-LINE(23:) TO WS-LINE
               MOVE FUNCTION Trim(WS-LINE) TO WS-LINE
               UNSTRING WS-LINE DELIMITED BY SPACES INTO WS-LINE
               END-UNSTRING
               MOVE FUNCTION NUMVAL(WS-LINE) TO WS-CAPACITY
           END-IF.
