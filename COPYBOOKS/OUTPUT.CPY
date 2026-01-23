       01 L-TYPE              EXTERNAL PIC IS 9.
       01 L-TEXT              EXTERNAL PROCEDURE-POINTER.
       01 L-COLOR-FG          EXTERNAL.
         05 COLOR-HEX-FG               PIC IS X(10).
         05 COLOR-RGB-FG     REDEFINES COLOR-HEX-FG.
           10 FG-R                     PIC IS 9(3).
           10 FG-G                     PIC IS 9(3).
           10 FG-B                     PIC IS 9(3).
           10 FG-T                     PIC IS 9.
       01 L-COLOR-BG          EXTERNAL.
         05 COLOR-HEX-BG               PIC IS X(10).
         05 COLOR-RGB-BG REDEFINES COLOR-HEX-BG.
           10 BG-R                     PIC IS 9(3).
           10 BG-G                     PIC IS 9(3).
           10 BG-B                     PIC IS 9(3).
           10 BG-T                     PIC IS 9.
       01 L-PART              EXTERNAL PIC IS 9.
       01 L-BODY              EXTERNAL PIC IS X(42).
       01 L-COLOR-FG-LAST EXTERNAL.
         05 COLOR-HEX-FG-LAST          PIC IS X(10).
       01 L-COLOR-BG-LAST EXTERNAL.
         05 COLOR-HEX-BG-LAST          PIC IS X(10).

