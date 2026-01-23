       IDENTIFICATION DIVISION.
       PROGRAM-ID. AUTO-DETECT.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT PPID-FD              ASSIGN USING PPID-FILE
                                       ORGANIZATION IS SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
       FD PPID-FD.
       01 FD-LINE                      PICTURE IS X(200).
       WORKING-STORAGE SECTION.
       77 PPID-FILE                    PICTURE IS X(50) VALUE SPACES.
       01 PPID                         USAGE INDEX.
       01 TMP                          PICTURE IS 9.
       01 PPID-SIZE                    PICTURE IS 9.
       01 NAME                         PICTURE IS X(30).
       LINKAGE SECTION.
       01 L-TYPE                       PICTURE IS 9.
       PROCEDURE DIVISION USING L-TYPE.
       Main.
           CALL 'isatty'               USING 0 RETURNING TMP
           END-CALL
           IF TMP = 1
             MOVE 1 TO L-TYPE
             GOBACK
           END-IF
           CALL 'getppid'              RETURNING PPID
           END-CALL
           PERFORM ParseParen.
           SET L-TYPE                  TO 1
           IF NAME(1:5) = "i3bar"
             SET L-TYPE                TO 0
           END-IF
           IF NAME(1:7) = "swaybar"
             SET L-TYPE                TO 0
           END-IF
           GOBACK.
        ParseParen.
           SET PPID-FILE               TO SPACES
           PERFORM UNTIL PPID = 0
             MOVE FUNCTION MOD(PPID, 10) TO TMP
             COMPUTE PPID = PPID / 10
             END-COMPUTE
             STRING PPID-FILE DELIMITED BY SPACE
               TMP
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
                        TMP
                        PPID
                    END-UNSTRING
                 MOVE 1 TO TMP
             END-READ
           END-PERFORM
           CLOSE PPID-FD.
           MOVE 0 to TMP
           INSPECT NAME TALLYING TMP FOR ALL "sh"
           IF TMP NOT = 0
             PERFORM ParseParen
           END-IF.
