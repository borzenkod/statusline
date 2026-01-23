       IDENTIFICATION DIVISION.
       PROGRAM-ID. getloadavg.
       DATA DIVISION.
       LINKAGE SECTION.
       01 LOAD.
           05 LOAD1  USAGE COMP-2.
           05 LOAD5  USAGE COMP-2.
           05 LOAD15 USAGE COMP-2.
       PROCEDURE DIVISION USING LOAD.
           DISPLAY "CALLED" WITH NO ADVANCING
           END-DISPLAY
           MOVE 12.345                 TO LOAD1
           MOVE 56.785                 TO LOAD5
           MOVE 90.125                 TO LOAD15
           GOBACK.
       END PROGRAM getloadavg.
