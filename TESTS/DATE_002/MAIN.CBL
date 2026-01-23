       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OUTP                 ASSIGN TO './OUTPUT.TXT'
                                       ORGANIZATION IS SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD OUTP.
       01 FD-DATA-ALTERNATIVE.
         05 FD-DATA-DAY                PICTURE IS 99.
         05 FD-FILLER-1                PICTURE IS X.
         05 FD-DATA-MONTH              PICTURE IS 99.
         05 FD-FILLER-2                PICTURE IS X.
         05 FD-DATA-CENTURY            PICTURE IS 99.
         05 FD-DATA-YEAR               PICTURE IS 99.
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
       01 WS-BODY                      PIC IS X(42).
       PROCEDURE DIVISION.
           MOVE FUNCTION CURRENT-DATE TO WS-CURRENT-DATE-FIELDS
           MOVE "Y2.1K"               TO WS-BODY
           CALL 'DDATEHOOK' USING WS-BODY
           END-CALL
           OPEN OUTPUT OUTP
           MOVE WS-CURRENT-DAY         TO FD-DATA-DAY
           MOVE WS-CURRENT-MONTH       TO FD-DATA-MONTH
           MOVE WS-CURRENT-YEAR        TO FD-DATA-YEAR
           MOVE '20'                   TO FD-DATA-CENTURY
           MOVE '/'                    TO FD-FILLER-1
           MOVE '/'                    TO FD-FILLER-2
           WRITE FD-DATA-ALTERNATIVE
           END-WRITE
           CLOSE OUTP
           GOBACK.
