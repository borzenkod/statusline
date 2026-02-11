       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_SYSTEM.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/ABEND.CPY".
       COPY "COPYBOOKS/LIBC.CPY".
       01 WS-FD                        USAGE IS BINARY-LONG.
       01 WS-RET                       USAGE IS BINARY-LONG.
       01 WS-RET-2                     USAGE IS BINARY-LONG.
       01 WS-BUFFER                    PICTURE IS X(61).
       LINKAGE SECTION.
       01 L-DATA.
         05 L-BUFFER                   PICTURE IS X(60).
         05 L-FD                       USAGE IS BINARY-LONG.
         05 L-PID                      USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY REFERENCE L-DATA.
           IF L-FD IS EQUAL TO ZERO THEN
             PERFORM DispBuff
           ELSE
             SET WS-BUFFER             TO SPACES
             CALL 'read' USING
               BY VALUE L-FD
               BY REFERENCE WS-BUFFER
               BY VALUE 61
               GIVING WS-RET
             END-CALL
             IF WS-RET IS LESS THAN ZERO THEN
               CALL 'DCOB$GET-ERRNO' GIVING WS-RET-2 END-CALL
               IF WS-RET-2 = LC-EAGAIN THEN PERFORM DispBuff END-IF
               IF WS-RET-2 = LC-EWOULDBLOCK THEN PERFORM DispBuff END-IF
               SET WS-STAT-ABEND         TO "EMDSYS01"
               CALL "STATABEND" END-CALL
             END-IF
             IF WS-RET IS EQUAL TO ZERO THEN
               SET L-FD TO ZERO
               CALL 'waitpid' USING
                 BY VALUE L-PID
                 BY REFERENCE NULL
                 BY VALUE 0
               END-CALL
               PERFORM DispBuff
             ELSE
               SET L-BUFFER              TO WS-BUFFER
               INSPECT L-BUFFER REPLACING ALL X'00' BY SPACES
               INSPECT L-BUFFER REPLACING ALL X'0D' BY SPACES
               PERFORM DispBuff
             END-IF
           END-IF.
       DispBuff.
             DISPLAY
               FUNCTION TRIM(L-BUFFER)
               WITH NO ADVANCING
             END-DISPLAY
             GOBACK.
       END PROGRAM MOD_SYSTEM.
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MOD_SYSTEM_INIT.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/ABEND.CPY".
       COPY "COPYBOOKS/LIBC.CPY".
       01 L-BODY              EXTERNAL PICTURE IS X(42).
       LOCAL-STORAGE SECTION.
       01 LS-PIPEFDS OCCURS 2 TIMES.
         05 LS-PIPEFD                  USAGE IS BINARY-LONG SIGNED.
       01 LS-RET                       USAGE IS BINARY-LONG SIGNED.
       01 LS-FLG                       USAGE IS BINARY-LONG SIGNED.
       01 LS-PID                       USAGE IS BINARY-LONG SIGNED.
       LINKAGE SECTION.
       01 L-DATA.
         05 L-BUFFER                   PICTURE IS X(60).
         05 L-FD                       USAGE IS BINARY-LONG.
         05 L-PID                      USAGE IS BINARY-LONG.
       PROCEDURE DIVISION USING BY REFERENCE L-DATA.
           CALL 'pipe' USING 
             BY REFERENCE LS-PIPEFDS(1)
             GIVING LS-RET
           END-CALL
           IF LS-RET = -1
             SET WS-STAT-ABEND         TO "FMDSYS01"
             CALL "STATABEND" END-CALL
           END-IF
           CALL 'fork'
             GIVING LS-PID
           END-CALL
           IF LS-PID < 0 THEN
             SET WS-STAT-ABEND         TO "FMDSYS02"
             CALL "STATABEND" END-CALL
           END-IF
           EVALUATE LS-PID
               WHEN 0 PERFORM Child
               WHEN OTHER PERFORM Parent
           END-EVALUATE
           SET RETURN-CODE             TO 2.
           GOBACK.
       Child.
           SET LS-RET TO LS-PIPEFD(1)
           CALL 'close' USING 
             BY VALUE LS-RET
           END-CALL
           SET LS-RET TO LS-PIPEFD(2)
           CALL 'dup2' USING 
             BY VALUE LS-RET
             BY VALUE LC-STDOUT_FILENO
           END-CALL
           CALL 'close' USING
             BY VALUE LS-RET
           END-CALL
           CALL 'execl' USING
             BY REFERENCE Z"/bin/sh"
             BY REFERENCE Z"sh"
             BY REFERENCE Z"-c"
             BY REFERENCE L-BODY
             BY VALUE 0
           END-CALL
           STOP RUN RETURNING 4.
       Parent.
           SET LS-RET TO LS-PIPEFD(2)
           CALL 'close' USING 
             BY VALUE LS-RET
           END-CALL
           SET LS-RET TO LS-PIPEFD(1)
           CALL 'fcntl' USING
             BY VALUE LS-RET
             BY VALUE LC-F_GETFL
             BY VALUE 0
             GIVING LS-FLG
           END-CALL
           IF LS-FLG = -1 THEN
             SET WS-STAT-ABEND         TO "FMDSYS03"
             CALL "STATABEND" END-CALL
           END-IF
           CALL 'DCOB$B-OR' USING 
             BY VALUE LS-FLG
             BY VALUE LC-O_NONBLOCK
             BY REFERENCE LS-FLG
           END-CALL
           CALL 'fcntl' USING
             BY VALUE LS-RET
             BY VALUE LC-F_SETFL
             BY VALUE LS-FLG
             GIVING LS-RET
           END-CALL
           IF LS-RET = -1 THEN
             SET WS-STAT-ABEND         TO "FMDSYS04"
             CALL "STATABEND" END-CALL
           END-IF
           SET L-FD                    TO LS-PIPEFD(1)
           SET L-PID                   TO LS-PID
           SET L-BUFFER                TO SPACES
           EXIT PARAGRAPH.
       END PROGRAM MOD_SYSTEM_INIT.
