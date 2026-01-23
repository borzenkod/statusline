       IDENTIFICATION DIVISION.
       PROGRAM-ID. DLOADHOOK.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 LOAD.
           05 LOAD1  USAGE COMP-2.
           05 LOAD5  USAGE COMP-2.
           05 LOAD15 USAGE COMP-2.
       01 DIS PIC IS 99.99.
       LINKAGE SECTION.
       01 L-BODY                  PIC X(42).
       PROCEDURE DIVISION USING L-BODY.
           CALL
               'getloadavg' USING
               BY REFERENCE LOAD BY VALUE 3
           END-CALL
           EVALUATE L-BODY
               WHEN "1M"  MOVE LOAD1    TO DIS
               WHEN "5M"  MOVE LOAD5    TO DIS
               WHEN "15M" MOVE LOAD15   TO DIS
               WHEN OTHER MOVE 0        TO DIS
           END-EVALUATE
           DISPLAY DIS WITH NO ADVANCING
           END-DISPLAY
           GOBACK.
