       IDENTIFICATION DIVISION.
       PROGRAM-ID. AUTO-DETECT.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PPID-FD ASSIGN TO PPID-FILE
           ORGANIZATION IS SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD PPID-FD.
       01 FD-LINE      PIC IS X(200).
       WORKING-STORAGE SECTION.
       01 PPID-FILE PIC IS X(50).
       01 PPID      USAGE INDEX.
       01 TMP       PIC IS 9.
       01 PPID-SIZE PIC IS 9.
       01 NAME      PIC IS X(30).
       LINKAGE SECTION.
       01 L-TYPE    PIC IS 9.
       PROCEDURE DIVISION USING L-TYPE.
       Main.
           CALL 'isatty' USING 0 RETURNING TMP
           IF TMP = 1
             MOVE 1 TO L-TYPE
             GOBACK
           END-IF
           CALL 'getppid' RETURNING PPID
           PERFORM ParseParen.
           MOVE 1 TO L-TYPE
           IF NAME(1:5) = "i3bar"
             MOVE 0 TO L-TYPE
           END-IF
           IF NAME(1:7) = "swaybar"
             MOVE 0 TO L-TYPE
           END-IF
           GOBACK.
        ParseParen.
           PERFORM UNTIL PPID = 0
             MOVE FUNCTION MOD(PPID, 10) TO TMP
             COMPUTE PPID = PPID / 10
             STRING PPID-FILE DELIMITED BY SPACE
               TMP DELIMITED BY SIZE
               INTO PPID-FILE
             END-STRING
           END-PERFORM
           MOVE FUNCTION TRIM(FUNCTION REVERSE(PPID-FILE)) TO NAME
           STRING "/proc/" DELIMITED BY SIZE
                  NAME DELIMITED BY SPACE
                  "/stat" DELIMITED BY SIZE
                  INTO PPID-FILE
           END-STRING
           OPEN INPUT PPID-FD
           MOVE 0 TO TMP
           PERFORM UNTIL TMP = 1
             READ PPID-FD
               AT END MOVE 1 TO TMP
               NOT AT END UNSTRING FD-LINE
                   DELIMITED BY SPACE OR "(" OR ")"
                   INTO TMP
                        TMP
                        NAME
                        TMP
                        PPID
                 MOVE 1 TO TMP
             END-READ
           END-PERFORM
           CLOSE PPID-FD.
           IF NAME(1:2) = "sh" PERFORM ParseParen.
