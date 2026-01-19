#!/usr/bin/env rexx

args = "-std=ibm"
args = args "-O0"
args = args "-fsign=ebcdic"
args = args "-fdefault-colseq=ebcdic"
args = args "-febcdic-table=ebcdic500_latin1"

files = "src/main.cbl src/output.cbl src/auto-detect.cbl"
files = files "src/time_hook.cbl"
files = files "src/date_hook.cbl"
files = files "src/load_hook.cbl"
files = files "src/mem_hook.cbl"
files = files "src/batt_hook.cbl"
files = files "src/system_hook.cbl"
files = files "src/text.cbl"
files = files "src/separator.cbl"
files = files "src/space.cbl"

command = "cobc" args "-x" files
SAY ' +' command
command

if rc = 0 then
    say "Compile successful"
else
    say "Compile failed, RC=" rc

exit rc
