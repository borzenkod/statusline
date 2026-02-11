       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_DATE.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-CURRENT-DATE-FIELDS.
        05  WS-CURRENT-DATE.
           10  FILLER             PIC  9(2).
           10  WS-CURRENT-YEAR    PIC  9(2).
           10  WS-CURRENT-MONTH   PIC  9(2).
           10  WS-CURRENT-DAY     PIC  9(2).
        05  WS-CURRENT-TIME.
           10  WS-CURRENT-HOUR    PIC  9(2).
           10  WS-CURRENT-MINUTE  PIC  9(2).
           10  WS-CURRENT-SECOND  PIC  9(2).
           10  WS-CURRENT-MS      PIC  9(2).
        05  WS-DIFF-FROM-GMT      PIC S9(4).
       LINKAGE SECTION.
       01 L-DATA.
         05 L-DATA-DAY                 PICTURE IS XX.
         05 L-DATA-FILLER-1            PICTURE IS X.
         05 L-DATA-MONTH               PICTURE IS XX.
         05 L-DATA-FILLER-2            PICTURE IS X.
         05 L-DATA-CENTRY              PICTURE IS XX.
         05 L-DATA-YEAR                PICTURE IS XX.
         05 L-TRIES                    PICTURE IS 99.
         05 L-MAX-TRIES                PICTURE IS 99.
       01 L-DATA-PRINTABLE REDEFINES L-DATA PICTURE IS X(10).
       PROCEDURE DIVISION USING BY REFERENCE L-DATA.
           IF L-TRIES IS GREATER OR EQUAL TO L-MAX-TRIES THEN
             MOVE FUNCTION CURRENT-DATE  TO WS-CURRENT-DATE-FIELDS
             SET L-DATA-DAY              TO WS-CURRENT-DAY
             SET L-DATA-MONTH            TO WS-CURRENT-MONTH
             SET L-DATA-YEAR             TO WS-CURRENT-YEAR
             SET L-TRIES                 TO 0
           ELSE
             ADD 1                       TO L-TRIES
             END-ADD
           END-IF
           DISPLAY L-DATA-PRINTABLE WITH NO ADVANCING END-DISPLAY
           GOBACK.
       END PROGRAM MOD_DATE.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_DATE_INIT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 L-BODY              EXTERNAL PIC IS X(42).
       01  WS-CURRENT-DATE-FIELDS.
        05  WS-CURRENT-DATE.
           10  FILLER             PIC  9(2).
           10  WS-CURRENT-YEAR    PIC  9(2).
           10  WS-CURRENT-MONTH   PIC  9(2).
           10  WS-CURRENT-DAY     PIC  9(2).
        05  WS-CURRENT-TIME.
           10  WS-CURRENT-HOUR    PIC  9(2).
           10  WS-CURRENT-MINUTE  PIC  9(2).
           10  WS-CURRENT-SECOND  PIC  9(2).
           10  WS-CURRENT-MS      PIC  9(2).
        05  WS-DIFF-FROM-GMT      PIC S9(4).
       01 WS-STM                  USAGE IS BINARY-LONG.
       LINKAGE SECTION.
       01 L-DATA.
         05 L-DATA-DAY                 PICTURE IS XX.
         05 L-DATA-FILLER-1            PICTURE IS X.
         05 L-DATA-MONTH               PICTURE IS XX.
         05 L-DATA-FILLER-2            PICTURE IS X.
         05 L-DATA-CENTRY              PICTURE IS XX.
         05 L-DATA-YEAR                PICTURE IS XX.
         05 L-TRIES                    PICTURE IS 99.
         05 L-MAX-TRIES                PICTURE IS 99.
       PROCEDURE DIVISION USING BY REFERENCE L-DATA.
           SET L-DATA-FILLER-1         TO '/'
           SET L-DATA-FILLER-2         TO '/'
           SET L-MAX-TRIES             TO 15
           MOVE FUNCTION CURRENT-DATE  TO WS-CURRENT-DATE-FIELDS
           SET L-DATA-DAY              TO WS-CURRENT-DAY
           SET L-DATA-MONTH            TO WS-CURRENT-MONTH
           SET L-DATA-YEAR             TO WS-CURRENT-YEAR
           SET L-TRIES                 TO 15
           COMPUTE
             WS-STM = (L-MAX-TRIES - FUNCTION MOD ((24 * 60 * 60)
                    - (WS-CURRENT-SECOND + (WS-CURRENT-MINUTE * 60)
                    + (WS-CURRENT-HOUR * 60 * 60)) L-MAX-TRIES))
           END-COMPUTE
           SET L-TRIES                 TO WS-STM
           EVALUATE L-BODY
             WHEN "Y1.9K" SET L-DATA-CENTRY TO "18"
             WHEN "Y2K"   SET L-DATA-CENTRY TO "19"
             WHEN "Y2.1K" SET L-DATA-CENTRY TO "20"
             WHEN "Y2.2K" SET L-DATA-CENTRY TO "21"
             WHEN "Y2.3K" SET L-DATA-CENTRY TO "22"
             WHEN OTHER CONTINUE
           END-EVALUATE
           SET RETURN-CODE             TO 2
           GOBACK.
       END PROGRAM MOD_DATE_INIT.
