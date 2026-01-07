
           OPEN INPUT CONFIG-FILE
           IF WS-FILE-OK
               CLOSE CONFIG-FILE
               GO TO Find-Config-File-End
           ELSE
           IF NOT WS-FILE-NOT-FOUND
               DISPLAY "ERROR : CANNOT OPEN CONFIG FILE"
               DISPLAY "FILE  : " FUNCTION TRIM(WS-CONFIG-PATH)
               DISPLAY "STATUS: " WS-CONFIG-STATUS
           END-IF
           END-IF
