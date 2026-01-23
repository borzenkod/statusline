       IDENTIFICATION DIVISION.
       PROGRAM-ID. DTAPEHOOK.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-STATVFS.
         05 WS-F-BSIZE            USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FRSIZE           USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-BLOCKS           USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-BFREE            USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-BAVAIL           USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FILES            USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FFREE            USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FAVAIL           USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FSIG             USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-FLAG             USAGE IS BINARY-DOUBLE UNSIGNED.
         05 WS-F-NAMEMAX          USAGE IS BINARY-DOUBLE UNSIGNED.
         05 FILLER                USAGE IS BINARY-LONG UNSIGNED.
         05 FILLER                OCCURS 5.
           10 FILLER              USAGE IS BINARY-DOUBLE.

       01 TMP                     USAGE IS BINARY-LONG.
       01 WS-PRINT-HUMAN               PIC 9(10).
       01 WS-PRINT-HUMAN-TYPE          PIC 9 VALUE 0.
       01 WS-BIT-SIZE                  PIC 99.
       LINKAGE SECTION.
       01 L-BODY                  PIC X(42).
       PROCEDURE DIVISION USING L-BODY.
           CALL 'statvfs' USING
                        BY REFERENCE L-BODY
                        BY REFERENCE WS-STATVFS
                        GIVING TMP
           END-CALL
           IF TMP NOT = -1
             EVALUATE L-BODY(40:1)
                 WHEN "B" MOVE WS-F-BSIZE   TO WS-PRINT-HUMAN
                 WHEN "R" MOVE WS-F-FRSIZE  TO WS-PRINT-HUMAN
                 WHEN "L" MOVE WS-F-BLOCKS  TO WS-PRINT-HUMAN
                          MOVE 9            TO WS-PRINT-HUMAN-TYPE
                 WHEN "H" MOVE WS-F-BFREE   TO WS-PRINT-HUMAN
                          MOVE 9            TO WS-PRINT-HUMAN-TYPE
                 WHEN "A" MOVE WS-F-BAVAIL  TO WS-PRINT-HUMAN
                          MOVE 9            TO WS-PRINT-HUMAN-TYPE
                 WHEN "F" MOVE WS-F-FILES   TO WS-PRINT-HUMAN
                          MOVE 9            TO WS-PRINT-HUMAN-TYPE
                 WHEN "E" MOVE WS-F-FFREE   TO WS-PRINT-HUMAN
                          MOVE 9            TO WS-PRINT-HUMAN-TYPE
                 WHEN "I" MOVE WS-F-FSIG    TO WS-PRINT-HUMAN
                          MOVE 9            TO WS-PRINT-HUMAN-TYPE
                 WHEN "N" MOVE WS-F-NAMEMAX TO WS-PRINT-HUMAN
                          MOVE 9            TO WS-PRINT-HUMAN-TYPE
                 WHEN OTHER GOBACK
             END-EVALUATE
             PERFORM 'PrintHuman'
           ELSE
             DISPLAY
               "NOT MOUNTED"
               WITH NO ADVANCING
             END-DISPLAY
           END-IF
           GOBACK.
       COPY "COPYBOOKS/PRINT-HUMAN.CPY".
