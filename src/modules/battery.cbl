       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_BATTERY.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT BAT                  ASSIGN USING WS-FILE
                                       ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD BAT.
       01 FD-LINE                      PIC X(100).
       WORKING-STORAGE SECTION.
       01 WS-EOF                       PIC X VALUE 'N'.
       01 WS-FILE                      PIC X(42).
       01 WS-BIT-SIZE                  PIC 99.
       01 WS-LINE                      PIC X(100).
       01 WS-CAPACITY                  PIC 999.
       01 WS-STATUS                    PIC 9.
         88 DISCHARGING                VALUE 0.
         88 CHARGING                   VALUE 1.
         88 CHARGED                    VALUE 2.
       01 TMP                          PIC 9(10).
       LINKAGE SECTION.
       01 L-DATA.
         05 L-TYPE                     PICTURE IS X.
         05 L-PATH                     PICTURE IS X(41).
         05 L-TRIES                    PICTURE IS 9.
         05 L-MAX-TRIES                PICTURE IS 9.
       PROCEDURE DIVISION USING BY REFERENCE L-DATA.
           IF L-TRIES IS GREATER OR EQUAL TO L-MAX-TRIES THEN
             SET WS-EOF                TO 'N'
             SET L-TRIES               TO 1
           ELSE
             ADD 1                     TO L-TRIES
             END-ADD
             SET WS-EOF                TO 'Y'
           END-IF
           IF WS-EOF NOT = "Y"
             MOVE L-PATH               TO WS-FILE
             OPEN INPUT BAT
             PERFORM UNTIL WS-EOF = 'Y'
                 READ BAT INTO FD-LINE
                     AT END MOVE 'Y' TO WS-EOF
                     NOT AT END PERFORM check
                 END-READ
             END-PERFORM
             CLOSE BAT
           END-IF
           EVALUATE L-TYPE
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
       END PROGRAM MOD_BATTERY.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_BATTERY_INIT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/OUTPUT.CPY".
       LINKAGE SECTION.
       01 L-BAT-DATA.
         05 L-DATA-TYPE                PICTURE IS X.
         05 L-DATA-PATH                PICTURE IS X(41).
         05 L-TRIES                    PICTURE IS 9.
         05 L-MAX-TRIES                PICTURE IS 9.
       PROCEDURE DIVISION USING BY REFERENCE L-BAT-DATA.
           DISPLAY L-BAT-DATA END-DISPLAY
           SET L-DATA-TYPE             TO L-BODY(42:1)
           SET L-BODY(42:1)            TO SPACE
           MOVE L-BODY                 TO L-DATA-PATH
           INSPECT L-DATA-PATH
                   REPLACING TRAILING  SPACES BY X'00'
           SET RETURN-CODE             TO 2
           SET L-TRIES                 TO 5
           SET L-MAX-TRIES             TO 5
           GOBACK.
       END PROGRAM MOD_BATTERY_INIT.
