           OPEN INPUT CONFIG-FILE
           IF WS-FILE-OK
               CLOSE CONFIG-FILE
               GO TO Find-Config-File-End
           ELSE
           IF NOT WS-FILE-NOT-FOUND
               DISPLAY "ERROR : CANNOT OPEN CONFIG FILE"
               END-DISPLAY
               DISPLAY "FILE  : " FUNCTION TRIM(WS-CONFIG-PATH)
               END-DISPLAY
               DISPLAY "STATUS: " WS-CONFIG-STATUS
               END-DISPLAY
           END-IF
           END-IF
