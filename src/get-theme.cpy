
           EVALUATE WS-CONFIG-COLOR
               WHEN "PRIM" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                   WS-THEMES-BG-PRIMARY(THM-IDX)
                 SET WS-MOD-COLOR-FG(MOD-IDX) TO
                   WS-THEMES-FG-PRIMARY(THM-IDX)
               WHEN "SECOND" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                   WS-THEMES-BG-SECONDARY(THM-IDX)
                 SET WS-MOD-COLOR-FG(MOD-IDX) TO
                   WS-THEMES-FG-SECONDARY(THM-IDX)
               WHEN "TERNRY" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                   WS-THEMES-BG-TERNARY(THM-IDX)
                 SET WS-MOD-COLOR-FG(MOD-IDX) TO
                   WS-THEMES-FG-TERNARY(THM-IDX)
               WHEN "BLCK" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                   WS-THEMES-BLACK-BG(THM-IDX)
                 SET WS-MOD-COLOR-FG(MOD-IDX) TO
                   WS-THEMES-BLACK-FG(THM-IDX)
               WHEN "WHITE" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                   WS-THEMES-WHITE-BG(THM-IDX)
                 SET WS-MOD-COLOR-FG(MOD-IDX) TO
                   WS-THEMES-WHITE-FG(THM-IDX)
               WHEN "CIRNO" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                   WS-THEMES-CIRNO-BG(THM-IDX)
                 SET WS-MOD-COLOR-FG(MOD-IDX) TO
                   WS-THEMES-CIRNO-FG(THM-IDX)
               WHEN OTHER
                  CONTINUE
           END-EVALUATE
