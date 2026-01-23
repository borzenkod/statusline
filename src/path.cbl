       IDENTIFICATION DIVISION.
       PROGRAM-ID. DPATHHOOK.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 TMP                          PIC IS 9 VALUE IS 0.
       01  FILE-INFO.
           05 FILE-SIZE-IN-BYTES  PIC 9(18)  COMP.
           05 MOD-DD              PIC 9(2)   COMP.
           05 MOD-MO              PIC 9(2)   COMP.
           05 MOD-YYYY            PIC 9(4)   COMP.
           05 MOD-HH              PIC 9(2)   COMP.
           05 MOD-MM              PIC 9(2)   COMP.
           05 MOD-SS              PIC 9(2)   COMP.
           05 FILLER              PIC 9(2)   COMP.

       LINKAGE SECTION.
       01 L-BODY                       PIC X(42).
       PROCEDURE DIVISION USING L-BODY.
           CALL 'CBL_CHECK_FILE_EXIST' USING
                   L-BODY
                   FILE-INFO
                   RETURNING TMP
           END-CALL
           IF TMP = 0
             DISPLAY "DOES EXISTS" WITH NO ADVANCING END-DISPLAY
           ELSE
             DISPLAY "NOT EXISTS " WITH NO ADVANCING END-DISPLAY
           END-IF
           GOBACK.

