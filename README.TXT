===============================================================================
             ____ _____  _  _____ _   _ ____  _     ___ _   _ _____ 
            / ___|_   _|/ \|_   _| | | / ___|| |   |_ _| \ | | ____|
            \___ \ | | / _ \ | | | | | \___ \| |    | ||  \| |  _|  
             ___) || |/ ___ \| | | |_| |___) | |___ | || |\  | |___ 
            |____/ |_/_/   \_\_|  \___/|____/|_____|___|_| \_|_____|

===============================================================================

SIMPLE STATUS LINE WRITTEN IN THE BEST PROGRAMMING LANGUAGE EVER

TODO:
- [X] DISPLAY TIME
- [X] DISPLAY LOAD
- [X] DISPLAY MEMORY
- [X] DISPLAY BATTERY
- [ ] DISPLAY NETWORKING

===
=== CONFIGURATION
===

STATUSLINE LOOKS IN THE FOLLOWING PLACES IN THE ORDER OF PREFERENCE:
- ./STATUSLINE-COB.CFG
- $XDG-CONFIG-HOME/STATUSLINE-COB/CONFIG.CFG
- $HOME/.config/STATUSLINE-COB/CONFIG.CFG
- $HOME/.STATUSLINE-COB.CFG
- /etc/STATUSLINE/STATUSLINE.CFG
- /etc/STATUSLINE-COB.CFG

CONFIG FILE IS LINE SQUENTIAL DATA SET WITH RECORDS HEAVING FOLLOWING STRUCTURE:
- FIRST 8 BYTES SPECIFIES THE COMMAND AND CAN BE EITHER
  + `********` FOR A COMMENT. ALL CONTENT FURTHER IS IGNORED
  + `GENERAL ` FOR A GENERAL CONFIGURATION SECTION
  + `MODULE  ` TO ADD MODULE
- SPACE
- NEXT 12 BYTES SPECIFIES THE NAME FOR THE MODULE.
- SPACE
- COLOR 6 BYTES FOR RRGGBB VALUES
- SPACE
- NEXT 71 BYTES SPECIFY USER DEFINED DATA

===
=== MODULES:
===
ARGUMENTS ARE GENERALY A SPACE SEPARATED LIST

- `BATTERY     ` ARGS: 0
- `MEMORY      ` ARGS: 0
- `LOAD        ` ARGS: 0
- `DATE        ` ARGS: 1
  + THE CENTURY SELECTOR, EITHER: "Y2K", "Y2.1K" OR "Y2.2K"
- `TIME        ` ARGS: 0
