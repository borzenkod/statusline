
files = "src/main.cbl src/output.cbl src/date.cbl src/date_hook.cbl src/time.cbl src/time_hook.cbl"

say "Compiling COBOL files: " files
"cobc" "-x" files

if rc = 0 then
    say "Compile successful"
else
    say "Compile failed, RC=" rc

exit rc
