       IDENTIFICATION DIVISION.
       PROGRAM-ID. STATLN03.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       LINKAGE SECTION.
       01 L-BODY PICTURE IS X(72).
       01 L-FIRST REDEFINES L-BODY PICTURE IS X.
       PROCEDURE DIVISION USING L-BODY.
           EVALUATE L-FIRST
             WHEN 'i'
               CALL 'MOD_STATUS_CHANGE' USING
                 BY VALUE 1
               END-CALL
             WHEN 'v'
               CALL 'MOD_STATUS_CHANGE' USING
                 BY VALUE 2
               END-CALL
             WHEN 'c'
               CALL 'MOD_STATUS_CHANGE' USING
                 BY VALUE 3
               END-CALL
             WHEN 'r'
               CALL 'MOD_STATUS_CHANGE' USING
                 BY VALUE 4
               END-CALL
             WHEN OTHER
               CALL 'MOD_STATUS_CHANGE' USING
                 BY VALUE 0
               END-CALL
           END-EVALUATE
           GOBACK.
