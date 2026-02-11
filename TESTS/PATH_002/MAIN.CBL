       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 L-BODY              EXTERNAL PIC IS X(42).
       01 WS-DATA.
         05 L-TRIES                    USAGE   IS BINARY-LONG.
         05 L-MAX-TRIES                USAGE   IS BINARY-LONG.
         05 L-BODY-DATA                PICTURE IS X(42).
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
       PROCEDURE DIVISION.
           MOVE "/proc/meminfo"           TO L-BODY
           CALL 'MOD_PATH_INIT' USING BY REFERENCE WS-DATA
           END-CALL
           CALL 'MOD_PATH' USING BY REFERENCE WS-DATA
           END-CALL
           GOBACK.
