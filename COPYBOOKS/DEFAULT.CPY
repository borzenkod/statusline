           SET MOD-IDX TO 1
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_TEXT'
           SET WS-MOD-BODY(MOD-IDX)    TO "B: "
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           CALL 'MOD_TEXT_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 2
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_SPACE'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_SPACE_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 3
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_BATTERY'
           SET WS-MOD-BODY(MOD-IDX)    TO
           "/sys/class/power_supply/BAT0/uevent      C"
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "000000ff"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_BATTERY_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 4
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_SEPARATOR'
           SET WS-MOD-BODY(MOD-IDX)    TO
           "-                                        A"
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 4
           CALL 'MOD_SEPARATOR_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET WS-MOD-POINTER(MOD-IDX) TO WS-MOD-DATA(MOD-IDX)(1:16)
           SET WS-MOD-POINTER(MOD-IDX) TO WS-MOD-DATA(MOD-IDX)(1:16)
           SET MOD-IDX TO 5
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_TEXT'
           SET WS-MOD-BODY(MOD-IDX)    TO "U: "
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ffffffff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_TEXT_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 6
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_SPACE'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_SPACE_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 7
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_MEMORY'
           SET WS-MOD-BODY(MOD-IDX)    TO "USED"
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ffffffff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_MEMORY_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 8
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_SPACE'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_SPACE_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 9
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_TEXT'
           SET WS-MOD-BODY(MOD-IDX)    TO "A: "
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ffffffff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_TEXT_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 10
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_SPACE'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_SPACE_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 11
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_MEMORY'
           SET WS-MOD-BODY(MOD-IDX)    TO "AVAILABLE"
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ffffffff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_MEMORY_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 12
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_SEPARATOR'
           SET WS-MOD-BODY(MOD-IDX)    TO
           "-                                        A"
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 4
           CALL 'MOD_SEPARATOR_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET WS-MOD-POINTER(MOD-IDX) TO WS-MOD-DATA(MOD-IDX)(1:16)
           SET MOD-IDX TO 13
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_LOAD'
           SET WS-MOD-BODY(MOD-IDX)    TO SPACES
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0fffff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_LOAD_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 14
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_SEPARATOR'
           SET WS-MOD-BODY(MOD-IDX)    TO
           "-                                        A"
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 4
           CALL 'MOD_SEPARATOR_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET WS-MOD-POINTER(MOD-IDX) TO WS-MOD-DATA(MOD-IDX)(1:16)
           SET MOD-IDX TO 15
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_DATE'
           SET WS-MOD-BODY(MOD-IDX)    TO "Y2.1K"
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ffffffff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 2
           CALL 'MOD_DATE_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET MOD-IDX TO 16
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_SEPARATOR'
           SET WS-MOD-BODY(MOD-IDX)    TO
           "-                                        A"
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ff0f0fff"
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 4
           CALL 'MOD_SEPARATOR_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET WS-MOD-POINTER(MOD-IDX) TO WS-MOD-DATA(MOD-IDX)(1:16)
           SET MOD-IDX TO 17
           SET WS-MOD-POINTER(MOD-IDX) TO 'MOD_TIME'
           SET WS-MOD-BODY(MOD-IDX)    TO "24H"
           SET WS-MOD-COLOR-FG(MOD-IDX)   TO "ffff0fff".
           SET WS-MOD-COLOR-BG(MOD-IDX)   TO "00000000"
           SET L-BODY                  TO WS-MOD-BODY(MOD-IDX)
           SET WS-MOD-VERSION(MOD-IDX) TO 1
           CALL 'MOD_TIME_INIT' USING WS-MOD-DATA(MOD-IDX) END-CALL
           SET WS-MODULES-LOADED       TO 17
