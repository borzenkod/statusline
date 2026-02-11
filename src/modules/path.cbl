       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_PATH.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 FILE-INFO.
          05 FILLER              PIC 9(18)  COMP.
          05 FILLER              PIC 9(2)   COMP.
          05 FILLER              PIC 9(2)   COMP.
          05 FILLER              PIC 9(4)   COMP.
          05 FILLER              PIC 9(2)   COMP.
          05 FILLER              PIC 9(2)   COMP.
          05 FILLER              PIC 9(2)   COMP.
          05 FILLER              PIC 9(2)   COMP.
       LINKAGE SECTION.
       01 L-DATA.
         05 L-TRIES                    USAGE   IS BINARY-LONG.
         05 L-MAX-TRIES                USAGE   IS BINARY-LONG.
         05 L-BODY                     PICTURE IS X(42).
         05 L-FILE-INFO.
           10 FILE-SIZE-IN-BYTES  PIC 9(18)  COMP.
           10 MOD-DD              PIC 9(2)   COMP.
           10 MOD-MO              PIC 9(2)   COMP.
           10 MOD-YYYY            PIC 9(4)   COMP.
           10 MOD-HH              PIC 9(2)   COMP.
           10 MOD-MM              PIC 9(2)   COMP.
           10 MOD-SS              PIC 9(2)   COMP.
           10 FILLER              PIC 9(2)   COMP.
         05 TMP                   PIC IS 9 VALUE IS 0.
       PROCEDURE DIVISION USING L-DATA.
           IF L-TRIES IS GREATER OR EQUAL TO L-MAX-TRIES THEN
             SET L-TRIES               TO 1
             CALL 'CBL_CHECK_FILE_EXIST' USING
               L-BODY
               FILE-INFO
               RETURNING TMP
             END-CALL
             SET L-FILE-INFO           TO FILE-INFO
           ELSE
             ADD 1                     TO L-TRIES
             END-ADD
           END-IF
           IF TMP = 0
             DISPLAY "DOES EXISTS" WITH NO ADVANCING END-DISPLAY
           ELSE
             DISPLAY "NOT EXISTS " WITH NO ADVANCING END-DISPLAY
           END-IF
           GOBACK.
       END PROGRAM MOD_PATH.
       IDENTIFICATION DIVISION. 
       PROGRAM-ID. MOD_PATH_INIT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 L-BODY              EXTERNAL PICTURE IS X(42).
       LINKAGE SECTION. 
       01 L-DATA.
         05 L-TRIES                    USAGE   IS BINARY-LONG.
         05 L-MAX-TRIES                USAGE   IS BINARY-LONG.
         05 L-BODY-DATA                PICTURE IS X(42).
         05  FILE-INFO.
           10 FILE-SIZE-IN-BYTES  PIC 9(18)  COMP.
           10 MOD-DD              PIC 9(2)   COMP.
           10 MOD-MO              PIC 9(2)   COMP.
           10 MOD-YYYY            PIC 9(4)   COMP.
           10 MOD-HH              PIC 9(2)   COMP.
           10 MOD-MM              PIC 9(2)   COMP.
           10 MOD-SS              PIC 9(2)   COMP.
           10 FILLER              PIC 9(2)   COMP.
         05 TMP                   PIC IS 9.
       PROCEDURE DIVISION USING L-DATA.
           SET L-TRIES                 TO 15
           SET L-MAX-TRIES             TO 15
           SET RETURN-CODE             TO 2
           SET L-BODY-DATA             TO L-BODY
           SET TMP                     TO 0
           GOBACK.
       END PROGRAM MOD_PATH_INIT.
