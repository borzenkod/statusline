       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_LOAD.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 DIS PIC IS 99.99.
       LINKAGE SECTION.
       01 L-DATA.
           05 L-LOAD                   COMP-2 OCCURS 3 TIMES.
           05 L-INDEX                  USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING L-DATA.
           CALL
               'getloadavg' USING
               BY REFERENCE L-DATA BY VALUE 3
           END-CALL
           MOVE L-LOAD(L-INDEX)        TO DIS
           DISPLAY DIS WITH NO ADVANCING
           END-DISPLAY
           GOBACK.
       END PROGRAM MOD_LOAD.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_LOAD_INIT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 L-BODY              EXTERNAL PICTURE IS X(42).
       LINKAGE SECTION.
       01 L-DATA.
           05 L-LOAD                   COMP-2 OCCURS 3 TIMES.
           05 L-INDEX                  USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY REFERENCE L-DATA.
           EVALUATE L-BODY
               WHEN "1M"  MOVE 1       TO L-INDEX
               WHEN "5M"  MOVE 2       TO L-INDEX
               WHEN "15M" MOVE 3       TO L-INDEX
               WHEN OTHER MOVE 1       TO L-INDEX
           END-EVALUATE
           SET RETURN-CODE             TO 2
           GOBACK.
       END PROGRAM MOD_LOAD_INIT.
