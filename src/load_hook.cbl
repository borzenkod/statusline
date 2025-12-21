       IDENTIFICATION DIVISION.
       PROGRAM-ID. DLOADHOOK.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 LOAD.
           05 LOAD1  USAGE COMP-2. 
           05 LOAD5  USAGE COMP-2. 
           05 LOAD15 USAGE COMP-2. 
       PROCEDURE DIVISION.
           CALL
               'getloadavg' USING
               BY REFERENCE LOAD BY VALUE 3
           END-CALL
           DISPLAY LOAD1 " " LOAD5 " " LOAD15 WITH NO ADVANCING

           GOBACK.
           
