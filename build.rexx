#!/usr/bin/env regina

files = "src/main.cbl src/output.cbl src/auto-detect.cbl"
files = files "src/time_hook.cbl"
files = files "src/date_hook.cbl"
files = files "src/load_hook.cbl"
files = files "src/mem_hook.cbl"
files = files "src/batt_hook.cbl"
files = files "src/system_hook.cbl"

say "Compiling COBOL files: " files
"cobc" "-x" files ""

if rc = 0 then
    say "Compile successful"
else
    say "Compile failed, RC=" rc

exit rc
