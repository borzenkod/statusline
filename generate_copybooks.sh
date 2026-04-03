#!/bin/sh

temp_header=$(mktemp)
temp_output=$(mktemp)

cat <<EOF1 > $temp_header
#include <stdio.h>
#include <sys/stat.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <sys/wait.h>
#include <syslog.h>
#include <signal.h>
#include <fcntl.h>
#include <syslog.h>
#include <unistd.h>
#include <errno.h>
#define WNOSAYORI WNOHANG
EOF1

names=$(gcc -E -dM -x c "$temp_header"  \
  | grep -E '^\s*#define\s*(W|O_|SIG|LOG_|F_|STD|E|AF_|SOCK_)[A-Za-z0-9_]*[^()]\s.*$' \
  | awk '{ print "fprintf(f, \"012345 77 LC-" $2 " USAGE BINARY-LONG VALUE IS %i.\\n\", ",$2 ");" }')

cat <<EOF2 >> $temp_header

int
main (int argc, char **argv)
{
  struct sockaddr_un addr;
  FILE *f;
  if (argc < 2)
    return -1;
  f = fopen(argv[1], "w");
  if (f == NULL)
    return -2;
EOF2

echo $names >> $temp_header

cat << EOF3 >> $temp_header
  fprintf(f, "012345 01 LC-SOCKADDR_UN-LEN CONSTANT AS %i.\n", sizeof(struct sockaddr_un));
  fprintf(f, "012345 77 LC-SOCKADDR_UN-SFSZ USAGE BINARY-LONG VALUE IS %i.\n", sizeof(addr.sun_family));
  fprintf(f, "012345 77 LC-SOCKADDR_UN-SFOF USAGE BINARY-LONG VALUE IS %i.\n", (void*)&addr.sun_family - (void*)&addr + 1);
  fprintf(f, "012345 77 LC-SOCKADDR_UN-PTSZ USAGE BINARY-LONG VALUE IS %i.\n", sizeof(addr.sun_path));
  fprintf(f, "012345 77 LC-SOCKADDR_UN-PTOF USAGE BINARY-LONG VALUE IS %i.\n", (void*)&addr.sun_path - (void*)&addr + 1);

  fclose(f);
  return (0);
}
EOF3

gcc -x c "$temp_header" -o $temp_output -w
chmod +x $temp_output
$temp_output COPYBOOKS/LIBC.CPY
