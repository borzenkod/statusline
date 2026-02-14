
nix build nixpkgs#i3status-rust nixpkgs#i3status nixpkgs#sysstat

if [ -d ~/.config/i3status-rust ]; then
  rm -r ~/.config/i3status-rust.cob-bak/
  echo -e "\e[1;31mMOVING ~/.config/i3status-rust/ INTO ~/.config/i3status-rust.cob-bak\e[0m"
  mv ~/.config/i3status-rust{/,.cob-bak/}
fi

mkdir -p ~/.config/i3status-rust

cp -r ./result/share/icons ~/.config/i3status-rust/icons/
cp -r ./result/share/themes ~/.config/i3status-rust/themes/

chmod -R +rw ~/.config/i3status-rust/

export COB_PRE_LOAD=MOD_CIRNO
export COB_LIBRARY_PATH=.

cat <<EOF_COB > ./STATUSLINE-COB.CFG
GENERAL  D. BORZENKO  EBCDIC 001 ROSEPINE                              00000100
MODULE   SEPARATOR    PRIM   <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<00000200
MODULE   SPACE        PRIM                                             00000300
MODULE   TEXT         PRIM                       B:                    00000400
MODULE   SPACE        PRIM                                             00000500
MODULE   BATTERY      PRIM   /sys/class/power_supply/BAT0/uevent      C00000600
MODULE   SPACE        PRIM                                             00000700
MODULE   SEPARATOR    SECOND <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<00000800
MODULE   SPACE        SECOND                                           00000900
MODULE   TEXT         SECOND                     U:                    00001000
MODULE   SPACE        SECOND                                           00001100
MODULE   MEMORY       SECOND USED                                      00001200
MODULE   SPACE        SECOND                                           00001300
MODULE   TEXT         SECOND                     A:                    00001400
MODULE   SPACE        SECOND                                           00001500
MODULE   MEMORY       SECOND AVAILABLE                                 00001600
MODULE   SPACE        SECOND                                           00001700
MODULE   SEPARATOR    TERNRY <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<00001800
MODULE   SPACE        TERNRY                                           00001900
MODULE   LOAD         TERNRY 1M                                        00002000
MODULE   SPACE        TERNRY                                           00002100
MODULE   SEPARATOR    WHITE  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<00002200
MODULE   SPACE        WHITE                                            00002300
MODULE   DATE         WHITE  Y2.1K                                     00002400
MODULE   SPACE        WHITE                                            00002500
MODULE   SEPARATOR    SCARLET==========================================00002600
MODULE   SPACE        WHITE                                            00002700
MODULE   TIME         WHITE  24H                                       00002800
MODULE   SPACE        WHITE                                            00002900
MODULE   SEPARATOR    CIRNO  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<00003000
MODULE   SPACE        CIRNO                                            00003100
MODULE   SYSTEM       CIRNO  ./script.sh 1                             00003200
MODULE   SPACE        CIRNO                                            00003300
MODULE   SEPARATOR    TRANSP >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>00003400
MODULE   SPACE        TRANSP                                           00003500
EOF_COB

cat <<EOF_I3 > /tmp/i3status.conf
general {
        colors = true
        interval = 5
}

order += "ipv6"
order += "wireless _first_"
order += "ethernet _first_"
order += "battery all"
order += "disk /"
order += "load"
order += "memory"
order += "tztime local"

wireless _first_ {
        format_up = "W: (%quality at %essid) %ip"
        format_down = "W: down"
}

ethernet _first_ {
        format_up = "E: %ip (%speed)"
        format_down = "E: down"
}

battery all {
        format = "%status %percentage %remaining"
}

disk "/" {
        format = "%avail"
}

load {
        format = "%1min"
}

memory {
        format = "%used | %available"
        threshold_degraded = "1G"
        format_degraded = "MEMORY < %available"
}

tztime local {
        format = "%Y-%m-%d %H:%M:%S"
}
EOF_I3

cat <<EOF_RUST > /tmp/i3status-rust.conf
icons_format = "{icon}"

[theme]
theme = "solarized-dark"
[theme.overrides]
idle_bg = "#123456"
idle_fg = "#abcdef"

[icons]
icons = "awesome4"
[icons.overrides]
bat = ["|E|", "|_|", "|=|", "|F|"]
bat_charging = "|^| "

[[block]]
block = "cpu"
info_cpu = 20
warning_cpu = 50
critical_cpu = 90

[[block]]
block = "disk_space"
path = "/"
info_type = "available"
alert_unit = "GB"
interval = 5
warning = 20.0
alert = 10.0
format = " $icon root: $available.eng(w:2) "

[[block]]
block = "memory"
interval = 5
format = " $icon $mem_total_used_percents.eng(w:2) "
format_alt = " $icon_swap $swap_used_percents.eng(w:2) "

[[block]]
block = "sound"
[[block.click]]
button = "left"
cmd = "pavucontrol"

[[block]]
block = "time"
interval = 5
format = " $timestamp.datetime(f:'%a %d/%m %R') "
EOF_RUST


./statusline -&
STAT_PID=$!

./result-1/bin/i3status -c /tmp/i3status.conf &
I3STAT=$!

./result/bin/i3status-rs /tmp/i3status-rust.conf &
I3STAT_RUST=$!

./result-2/bin/pidstat -rwdRstuw -p $STAT_PID,$I3STAT,$I3STAT_RUST,SELF 1 60 | grep "^Average: " > test.out

sleep 10

kill -s TERM -- $STAT_PID $I3STAT $I3STAT_RUST
sleep 2
kill -s KILL -- $STAT_PID $I3STAT $I3STAT_RUST

echo -e "\e[1;31mREMOVING TEMPORARY DIRECTORY ~/.config/i3status-rust\e[0m"
rm -rf ~/.config/i3status-rust/
if [ -d ~/.config/i3status-rust.cob-bak ]; then
  echo -e "\e[1;32mRESTORING FROM ~/.config/i3status-rust.cob-bak\e[0m"
  mv ~/.config/i3status-rust{.cob-bak,}
fi
