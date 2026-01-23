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
               WHEN "LOVE" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-LOVE-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-LOVE-FG(THM-IDX)
               WHEN "SCARLE" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-LOVE-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-LOVE-FG(THM-IDX)
               WHEN "RED" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-LOVE-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-LOVE-FG(THM-IDX)
               WHEN "GOLD" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-GOLD-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-GOLD-FG(THM-IDX)
               WHEN "YELLOW" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-GOLD-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-GOLD-FG(THM-IDX)
               WHEN "ROSE" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-ROSE-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-ROSE-FG(THM-IDX)
               WHEN "PINE" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-PINE-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-PINE-FG(THM-IDX)
               WHEN "GREEN" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-PINE-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-PINE-FG(THM-IDX)
               WHEN "FOAM" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-FOAM-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-FOAM-FG(THM-IDX)
               WHEN "BLUE" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-FOAM-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-FOAM-FG(THM-IDX)
               WHEN "IRIS" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     WS-THEMES-IRIS-BG(THM-IDX)
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     WS-THEMES-IRIS-FG(THM-IDX)
               WHEN "TRANSP" SET WS-MOD-COLOR-BG(MOD-IDX) TO
                     "00000000"
                   SET WS-MOD-COLOR-FG(MOD-IDX) TO
                     "00000000"
               WHEN OTHER
                  CONTINUE
           END-EVALUATE
