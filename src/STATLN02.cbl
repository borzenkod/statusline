       IDENTIFICATION DIVISION.
       PROGRAM-ID. STATLN02.
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY "COPYBOOKS/LIBC.CPY".
       01 WS-SOCKET-PATH               PICTURE IS X(80)
                               VALUE Z"/run/user/1000/statusline.sock".
       01 WS-TMP                       USAGE IS BINARY-LONG.
       01 WS-RET                       USAGE IS BINARY-LONG.
       01 WS-RET2                      USAGE IS BINARY-LONG.
       01 WS-SERVER-FD                 USAGE IS BINARY-LONG.
       01 WS-CLIENTS                   OCCURS 7 TIMES INDEXED BY WS-ID.
           05 WS-CLIENT-FD             USAGE IS BINARY-LONG
                                       VALUE -1.
           05 WS-BUFFER                PICTURE IS X(73).
       01 WS-PTR                       POINTER.
       01 WS-SOCKADDR-ROOT.
           05 WS-SOCKADDR PICTURE IS X OCCURS LC-SOCKADDR_UN-LEN TIMES.
       PROCEDURE DIVISION.
       MAIN.
           GO TO INITIALIZE-PROGRAM.
       INITIALIZE-PROGRAM.
           PERFORM CREATE-SOCKET.
           PERFORM SET-NON-BLOCKING.
           PERFORM BIND-TO-PATH.
           ALTER MAIN TO LISTEN-LOOP.
           GOBACK.
       CREATE-SOCKET.
           CALL 'socket' USING
             BY VALUE LC-AF_UNIX
             BY VALUE LC-SOCK_STREAM
             BY VALUE 0
             GIVING WS-RET
           END-CALL.
           IF WS-RET IS EQUAL TO -1 THEN
             CALL 'WTO$ERR' USING
               "ERROR WHILE CREATING SOCKET"
             END-CALL
             GO TO ABEND-PROGRAM-ERRNO
           END-IF
           MOVE WS-RET                 TO WS-SERVER-FD.
           EXIT PARAGRAPH.
       SET-NON-BLOCKING.
           CALL 'fcntl' USING
             BY VALUE WS-SERVER-FD
             BY VALUE LC-F_GETFL
             BY VALUE 0
             GIVING WS-RET
           END-CALL.
           IF WS-RET IS EQUAL TO -1 THEN
             CALL 'WTO$ERR' USING
               "ERROR WHILE GETTING SOCKET FLAGS"
             END-CALL
             GO TO ABEND-PROGRAM-ERRNO
           END-IF.
           MOVE WS-RET                 TO WS-RET2
           CALL 'DCOB$B-OR' USING
             BY VALUE WS-RET2
             BY VALUE LC-O_NONBLOCK
             BY REFERENCE WS-RET
           END-CALL
           MOVE WS-RET                 TO WS-RET2
           CALL 'fcntl' USING
             BY VALUE WS-SERVER-FD
             BY VALUE LC-F_SETFL
             BY VALUE WS-RET2
             GIVING WS-RET
           END-CALL
           IF WS-RET IS EQUAL TO -1 THEN
             CALL 'WTO$ERR' USING
               "ERROR WHILE SETTING SOCKET FLAGS"
             END-CALL
             GO TO ABEND-PROGRAM-ERRNO
           END-IF.
           EXIT PARAGRAPH.
       BIND-TO-PATH.
           CALL 'DCOB$MEMSET' USING
             BY REFERENCE WS-SOCKADDR-ROOT
             BY VALUE 0
             BY VALUE LC-SOCKADDR_UN-SFSZ
           END-CALL
           CALL 'DCOB$MEMCPY' USING
             BY REFERENCE WS-SOCKADDR(LC-SOCKADDR_UN-SFOF)
             BY REFERENCE LC-AF_UNIX
             BY VALUE LC-SOCKADDR_UN-SFSZ
           END-CALL
           CALL 'DCOB$STRNCPY' USING
             BY REFERENCE WS-SOCKADDR(LC-SOCKADDR_UN-PTOF)
             BY REFERENCE WS-SOCKET-PATH
             BY VALUE 80
           END-CALL
           CALL 'unlink' USING
             BY REFERENCE WS-SOCKET-PATH
           END-CALL
           CALL 'bind' USING
             BY VALUE WS-SERVER-FD
             ADDRESS OF WS-SOCKADDR-ROOT
             BY VALUE LC-SOCKADDR_UN-LEN
             GIVING WS-RET
           END-CALL
           IF WS-RET IS EQUAL TO -1 THEN
             CALL 'close' USING
               BY VALUE WS-SERVER-FD
             END-CALL
             CALL 'WTO$ERR' USING
               "ERROR WHILE BINDING SOCKET"
             END-CALL
             GO TO ABEND-PROGRAM-ERRNO
           END-IF
           CALL 'listen' USING
             BY VALUE WS-SERVER-FD
             BY VALUE 5
             GIVING WS-RET
           END-CALL
           IF WS-RET IS EQUAL TO -1 THEN
             CALL 'close' USING
               BY VALUE WS-SERVER-FD
             END-CALL
             CALL 'WTO$ERR' USING
               "ERROR WHILE STARTING LISTENING"
             END-CALL
             GO TO ABEND-PROGRAM-ERRNO
           END-IF
           CALL 'WTO$INFO' USING
             "STARTED A LISTENING SOCKET"
           END-CALL
           EXIT PARAGRAPH.
       LISTEN-LOOP.
           PERFORM LISTEN-LOOP-TRY-ACCEPT
           PERFORM "HANDLE-CLIENT"
             VARYING WS-ID FROM 1 BY 1
             UNTIL WS-ID > 7
           GOBACK.
       LISTEN-LOOP-TRY-ACCEPT.
           CALL 'accept' USING
             BY VALUE WS-SERVER-FD
             0
             0
             GIVING WS-RET2
           END-CALL
           IF WS-RET2 IS EQUAL TO -1 THEN
             CALL 'DCOB$GET-ERRNO' GIVING WS-RET END-CALL
             IF WS-RET IS EQUAL TO LC-EAGAIN OR
                WS-RET IS EQUAL TO LC-EWOULDBLOCK THEN
                EXIT PARAGRAPH
             END-IF
             CALL 'WTO$ERR' USING
               "ERROR WHILE ACCEPTING CLIENT"
             END-CALL
             PERFORM ERRNO-WTO-NOTIFY
           ELSE
             PERFORM
               VARYING WS-ID FROM 1 BY 1
               UNTIL WS-ID > 7 OR
                     WS-CLIENT-FD(WS-ID) = -1
               COMPUTE WS-RET = WS-RET * 1.0
               END-COMPUTE
             END-PERFORM
             IF WS-CLIENT-FD(WS-ID) NOT = -1 THEN
               CALL 'close' USING
                 WS-RET2
               END-CALL
               EXIT PARAGRAPH
             END-IF
             MOVE WS-SERVER-FD         TO WS-TMP
             MOVE WS-RET2              TO WS-SERVER-FD
             PERFORM SET-NON-BLOCKING
             MOVE WS-SERVER-FD         TO WS-CLIENT-FD(WS-ID)
             MOVE WS-TMP               TO WS-SERVER-FD
             MOVE SPACES               TO WS-BUFFER(WS-ID)
           END-IF.
       ABEND-PROGRAM-ERRNO.
           PERFORM ERRNO-WTO-NOTIFY.
           ALTER MAIN TO ABEND-MAIN.
       ABEND-MAIN.
           GOBACK.
       ERRNO-WTO-NOTIFY.
           CALL 'DCOB$STR-ERROR' GIVING WS-PTR END-CALL
           CALL 'WTO$ERR' USING BY VALUE WS-PTR END-CALL.
           EXIT PARAGRAPH.
       HANDLE-CLIENT SECTION.
           IF WS-CLIENT-FD(WS-ID) = -1 THEN
             EXIT SECTION
           END-IF.
           CALL 'read' USING
             BY VALUE WS-CLIENT-FD(WS-ID)
             BY REFERENCE WS-BUFFER(WS-ID)
             BY VALUE 72
             GIVING WS-RET
           END-CALL
           EVALUATE TRUE
               WHEN WS-RET > 0
                 GO TO PROCESS-INPUT-CARD
               WHEN WS-RET = 0
                 GO TO HANDLE-CLIENT-ABEND
               WHEN OTHER
                 CALL 'WTO$ERR' USING
                   "ERROR WHILE PROCESSING CLIENT"
                 END-CALL
                 PERFORM ERRNO-WTO-NOTIFY
                 GO TO HANDLE-CLIENT-ABEND
           END-EVALUATE
           EXIT SECTION.
       PROCESS-INPUT-CARD.
           CALL 'STATLN03' USING WS-BUFFER(WS-ID)
           END-CALL
           EXIT SECTION.
       HANDLE-CLIENT-ABEND.
           CALL 'close' USING
             BY VALUE WS-CLIENT-FD(WS-ID)
           END-CALL
           MOVE -1                     TO WS-CLIENT-FD(WS-ID)
           SET WS-ID TO 10
           EXIT SECTION.
