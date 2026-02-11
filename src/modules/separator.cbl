       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_SEPARATOR.
       DATA DIVISION.
       LINKAGE SECTION.
       01 L-BODY-DATA.
         05 L-CHARACTER                PICTURE IS X.
       PROCEDURE DIVISION USING BY REFERENCE L-BODY-DATA.
           DISPLAY "SHOULD NOT HAPPEN" WITH NO ADVANCING END-DISPLAY
           GOBACK.
       END PROGRAM MOD_SEPARATOR.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_SEPARATOR_L.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/OUTPUT.CPY".
       LINKAGE SECTION.
       01 L-BODY-DATA.
         05 FILLER                     PICTURE IS X(16).
         05 L-CHARACTER                PICTURE IS X(4).
         05 L-SIZE                     USAGE IS BINARY-LONG.
         05 L-DIRECTION                PROGRAM-POINTER.
       PROCEDURE DIVISION USING BY REFERENCE L-BODY-DATA.
           SET L-COLOR-FG              TO L-COLOR-BG
           IF L-COLOR-BG-LAST NOT = ZEROS
             SET L-COLOR-BG            TO L-COLOR-BG-LAST
           END-IF
           SET L-PART                  TO 5
           CALL 'OUTPUT_FMT'           END-CALL
           DISPLAY L-CHARACTER(1:L-SIZE)
             WITH NO ADVANCING
           END-DISPLAY
           SET L-PART                  TO 6
           CALL 'OUTPUT_FMT'           END-CALL
           SET L-PART                  TO 3
           GOBACK.
       END PROGRAM MOD_SEPARATOR_L.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_SEPARATOR_R.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/OUTPUT.CPY".
       LINKAGE SECTION.
       01 L-BODY-DATA.
         05 FILLER                     PICTURE IS X(16).
         05 L-CHARACTER                PICTURE IS X(4).
         05 L-SIZE                     USAGE IS BINARY-LONG.
         05 L-DIRECTION                PROGRAM-POINTER.
       PROCEDURE DIVISION USING BY REFERENCE L-BODY-DATA.
           SET L-COLOR-FG              TO L-COLOR-BG-LAST
           SET L-PART                  TO 5
           CALL 'OUTPUT_FMT'           END-CALL
           DISPLAY L-CHARACTER
             WITH NO ADVANCING
           END-DISPLAY
           SET L-PART                  TO 6
           CALL 'OUTPUT_FMT'           END-CALL
           SET L-PART                  TO 3
           GOBACK.
       END PROGRAM MOD_SEPARATOR_R.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_SEPARATOR_INIT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 L-BODY              EXTERNAL PICTURE IS X(42).
       01 WS-ENCODING-MAP.
           05 WS-LEFT-BR               PICTURE IS X(4).
           05 WS-LEFT-BR-SIZE          PICTURE IS 9 COMP-3.
           05 WS-RIGHT-BR              PICTURE IS X(4).
           05 WS-RIGHT-BR-SIZE         PICTURE IS 9 COMP-3.
           05 WS-BAR                   PICTURE IS X(4).
           05 WS-BAR-SIZE              PICTURE IS 9 COMP-3.
       LINKAGE SECTION.
       01 L-DATA.
         05 L-POINTER                  PICTURE IS X(16).
         05 L-CHARACTER                PICTURE IS X(4).
         05 L-SIZE                     USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY REFERENCE L-DATA.
           EVALUATE L-BODY (42:1)
             WHEN X'41' WHEN X'C1' SET WS-LEFT-BR       TO X'3C' & X'40'
                                   SET WS-LEFT-BR-SIZE  TO 1
                                   SET WS-RIGHT-BR      TO X'3E' & X'40'
                                   SET WS-RIGHT-BR-SIZE TO 1
                                   SET WS-BAR           TO X'7C' & X'40'
                                   SET WS-BAR-SIZE      TO 1
             WHEN X'45' WHEN X'C5' SET WS-LEFT-BR       TO X'4B' & X'40'
                                   SET WS-LEFT-BR-SIZE  TO 1
                                   SET WS-RIGHT-BR      TO X'6E' & X'40'
                                   SET WS-RIGHT-BR-SIZE TO 1
                                   SET WS-BAR           TO X'7A' & X'40'
                                   SET WS-BAR-SIZE      TO 1
             WHEN X'55' WHEN X'E4' SET WS-LEFT-BR       TO ""
                                   SET WS-LEFT-BR-SIZE  TO 3
                                   SET WS-RIGHT-BR      TO ""
                                   SET WS-RIGHT-BR-SIZE TO 3
                                   SET WS-BAR           TO X'7C' & X'40'
                                   SET WS-BAR-SIZE      TO 1
             WHEN OTHER            SET WS-LEFT-BR       TO X'4B' & X'40'
                                   SET WS-LEFT-BR-SIZE  TO 1
                                   SET WS-RIGHT-BR      TO X'6E' & X'40'
                                   SET WS-RIGHT-BR-SIZE TO 1
                                   SET WS-BAR           TO X'7A' & X'40'
                                   SET WS-BAR-SIZE      TO 1
           END-EVALUATE
           EVALUATE L-BODY(1:1)
             WHEN "<" SET L-CHARACTER  TO WS-LEFT-BR
                      SET L-SIZE       TO WS-LEFT-BR-SIZE
                      SET L-POINTER    TO "MOD_SEPARATOR_L"
             WHEN ">" SET L-CHARACTER  TO WS-RIGHT-BR
                      SET L-SIZE       TO WS-RIGHT-BR-SIZE
                      SET L-POINTER    TO "MOD_SEPARATOR_R"
             WHEN "|" SET L-CHARACTER  TO WS-BAR
                      SET L-SIZE       TO WS-BAR
                      SET L-POINTER    TO "MOD_SEPARATOR_L"
             WHEN OTHER SET L-CHARACTER TO WS-BAR
                      SET L-SIZE       TO WS-BAR
                      SET L-POINTER    TO "MOD_SEPARATOR_L"
           END-EVALUATE
           SET RETURN-CODE             TO 4
           GOBACK.
       END PROGRAM MOD_SEPARATOR_INIT.
